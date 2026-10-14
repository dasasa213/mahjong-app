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
  for (const id of ['userSelect','metricSelect','reloadBtn','overallChart','rankHint','rankScaleSelect','rankScaleControl','chartArea']) {
    nodes[id] = {value: id === 'metricSelect' ? 'avgRank' : id === 'rankScaleSelect' ? 'auto' : 'Alice', events: {}, hidden: true, classList: {toggle() {}},
      addEventListener(event, callback) {this.events[event] = callback;}, getContext() {return {};}};
  }
  const configs = [], errors = [];
  function Chart(ctx, config) {
    configs.push(config); this.data = config.data; this.options = config.options;
    this.hidden = new Set(); this.isDatasetVisible = index => !this.hidden.has(index);
    this.update = () => {}; this.destroy = () => {};
    Chart.current = this;
  }
  Chart.defaults = {plugins: {legend: {onClick(event, item, legend) {
    const hidden = legend.chart.hidden;
    if (hidden.has(item.datasetIndex)) hidden.delete(item.datasetIndex);
    else hidden.add(item.datasetIndex);
  }}}};
  vm.runInNewContext(script, {document: {getElementById: id => nodes[id]}, URLSearchParams,
    fetch, Chart, showAppMessage: message => errors.push(message)});
  return {nodes, configs, errors, Chart};
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
    assert.equal(cfg.options.scales.y.min, count < 25 ? 1.5 : 2.3);
    assert.equal(cfg.options.scales.y.max, count < 25 ? 3.5 : 2.7);
    for (const ds of cfg.data.datasets) {
      const window = Number(ds.label.match(/\d+/)[0]);
      assert.equal(ds.data.slice(0,window-1).every(x => x === null), true);
      assert.equal(ds.spanGaps, false);
      assert.equal(ds.pointRadius, 0);
      assert.equal(ds.pointHoverRadius, 4);
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

test('fixed/auto switch updates axis without fetching again', async () => {
  let requests = 0;
  const app = setup(async () => { requests++; return response(data(100)); });
  await flush();
  app.nodes.rankScaleSelect.value = 'fixed';
  app.nodes.rankScaleSelect.events.change();
  assert.equal(app.configs[0].options.scales.y.min, 1.5);
  assert.equal(app.configs[0].options.scales.y.max, 3.5);
  app.nodes.rankScaleSelect.value = 'auto';
  app.nodes.rankScaleSelect.events.change();
  assert.equal(app.configs[0].options.scales.y.min, 2.3);
  assert.equal(requests, 1);
});
test('auto bounds include extreme ranks and ignore hidden series', async () => {
  const sample = data(100);
  sample.movingAverages[25][99] = 1;
  sample.movingAverages[50][99] = 4;
  const app = setup(async () => response(sample));
  await flush();
  const cfg = app.configs[0];
  assert.equal(cfg.options.scales.y.min, 1);
  assert.equal(cfg.options.scales.y.max, 4);
  const toggle = index => cfg.options.plugins.legend.onClick({}, {datasetIndex:index}, {chart:app.Chart.current});
  toggle(0); toggle(1);
  assert.equal(cfg.options.scales.y.min, 2.3);
  assert.equal(cfg.options.scales.y.max, 2.7);
  toggle(2);
  assert.equal(cfg.options.scales.y.min, 1.5);
  assert.equal(cfg.options.scales.y.max, 3.5);
});
test('a point chart does not use rank scale controls or bounds', async () => {
  const app = setup(async () => response(data(100, 'point')));
  await flush();
  assert.equal(app.nodes.rankScaleControl.hidden, true);
  assert.equal(app.configs[0].options.scales.y.min, undefined);
  assert.equal(app.configs[0].options.scales.y.max, undefined);
});
