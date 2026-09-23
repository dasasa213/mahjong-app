// Run: node --test e2e/overall-chart.test.cjs
// Execute the JSP's actual browser script with a fake DOM/Chart and API responses.
const {test} = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const vm = require('node:vm');
const jsp = fs.readFileSync(path.join(__dirname, '../backend/src/main/webapp/WEB-INF/views/user/overall-chart.jsp'), 'utf8');
const script = jsp.match(/<script>\s*([\s\S]*?)<\/script>/)[1]
  .replace(/<c:url value="[^"]*"\s*\/>/g, '/user/overall/chart/data');
const flush = () => new Promise(resolve => setImmediate(resolve));
function setup(fetch) {
  const nodes = {};
  for (const id of ['userSelect','metricSelect','reloadBtn','overallChart','rankHint']) {
    nodes[id] = {value: id === 'metricSelect' ? 'avgRank' : 'Alice', events: {}, hidden: true,
      addEventListener(event, callback) {this.events[event] = callback;}, getContext() {return {};}};
  }
  const configs = [], errors = [];
  function Chart(ctx, config) {configs.push(config); this.destroy = () => {};}
  vm.runInNewContext(script, {document: {getElementById: id => nodes[id]}, URLSearchParams,
    fetch, Chart, showAppMessage: message => errors.push(message)});
  return {nodes, configs, errors};
}
function data(count, metric = 'avgRank') {
  const movingAverages = {};
  for (const window of [25,50,100]) movingAverages[window] = Array.from({length: count}, (_,i) => i+1 < window ? null : 2.5);
  return {metric, labels: Array.from({length: count}, (_,i) => String(i+1)), series: Array(count).fill(2.5), movingAverages};
}
const response = value => ({ok: true, json: async () => value});
for (const [count, expected] of [[0,0],[24,0],[25,1],[49,1],[50,2],[99,2],[100,3]]) {
  test(`only available windows are drawn after ${count} games`, async () => {
    const app = setup(async () => response(data(count)));
    await flush();
    assert.equal(app.errors.length, 0);
    const cfg = app.configs[0];
    assert.equal(cfg.data.datasets.length, expected);
    assert.equal(cfg.data.datasets.some(ds => ds.label === '累積：平均順位'), false);
    assert.equal(cfg.options.scales.y.min, 1.5);
    assert.equal(cfg.options.scales.y.max, 3.5);
    for (const ds of cfg.data.datasets) {
      const window = Number(ds.label.match(/\d+/)[0]);
      assert.equal(ds.data.slice(0,window-1).every(x => x === null), true);
      assert.equal(ds.spanGaps, false);
    }
    assert.equal(app.nodes.rankHint.hidden, false);
  });
}
test('point chart keeps only its cumulative series', async () => {
  const app = setup(async () => response(data(100,'point')));
  await flush();
  assert.equal(app.configs[0].data.datasets.length, 1);
  assert.equal(app.nodes.rankHint.hidden, true);
});
test('a slower previous player request cannot overwrite the newly selected player', async () => {
  const pending = [];
  const app = setup(() => new Promise(resolve => pending.push(resolve)));
  app.nodes.userSelect.value = 'Bob';
  const latest = app.nodes.userSelect.events.change();
  pending[1](response(data(25)));
  await latest;
  pending[0](response(data(100)));
  await flush();
  assert.equal(app.configs.length, 1);
  assert.equal(app.configs[0].data.labels.length, 25);
  assert.equal(app.nodes.reloadBtn.disabled, false);
});
