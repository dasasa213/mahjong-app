"""Run with: python3 -m unittest discover -s backend/src/test/python -v

Execute the repository's actual SQL against isolated SQLite fixtures (CTEs and
window functions). No live database is accessed. This checks aggregation logic;
it does not replace a Java 21/Maven build or a MySQL 8 integration test.
"""
from pathlib import Path
import re
import sqlite3
import unittest


REPOSITORY = (Path(__file__).resolve().parents[2] /
              'main/java/com/example/mahjong/web/repository/OverallStatsRepository.java')
SQL = re.search(r'String sql = """(.*?)""";', REPOSITORY.read_text(), re.S).group(1)


class OverallPeriodsTest(unittest.TestCase):
    def setUp(self):
        self.db = sqlite3.connect(':memory:')
        self.addCleanup(self.db.close)
        self.db.row_factory = sqlite3.Row
        self.db.executescript('''
            CREATE TABLE daa_user_knr (id INTEGER PRIMARY KEY, name TEXT, groupid INTEGER, type TEXT);
            CREATE TABLE daa_gamerecords (id TEXT PRIMARY KEY, gamedate TEXT, gameno INTEGER, rate INTEGER, groupid INTEGER);
            CREATE TABLE daa_point (point_id INTEGER PRIMARY KEY, game_id TEXT, row_no INTEGER, name TEXT, point NUMERIC,
                UNIQUE(game_id, row_no, name));
            CREATE TABLE daa_ranking (ranking_id INTEGER PRIMARY KEY, game_id TEXT, row_no INTEGER, name TEXT, rank_no INTEGER,
                UNIQUE(game_id, row_no, name));
            CREATE TABLE daa_game_counter (user_id INTEGER, game_date TEXT, hand_count INTEGER, win_count INTEGER,
                call_count INTEGER, riichi_count INTEGER, deal_in_count INTEGER);
            INSERT INTO daa_user_knr VALUES (1, 'Alice', 1, '2'), (2, 'Bob', 1, '2'),
                (3, 'NoGames', 1, '2'), (4, 'Other', 2, '2'), (5, 'Admin', 1, '1');
        ''')

    def game(self, key, date='2026-09-01', gameno=1, rate=50, group=1):
        self.db.execute('INSERT INTO daa_gamerecords VALUES (?, ?, ?, ?, ?)',
                        (key, date, gameno, rate, group))

    def hand(self, game, row, name='Alice', point=10, rank=1):
        self.db.execute('INSERT INTO daa_point (game_id,row_no,name,point) VALUES (?,?,?,?)',
                        (game, row, name, point))
        self.db.execute('INSERT INTO daa_ranking (game_id,row_no,name,rank_no) VALUES (?,?,?,?)',
                        (game, row, name, rank))

    def stats(self, period='all', year=2026, group=1):
        yearly, recent = int(period == 'year'), int(period == 'recent100')
        start, end = f'{year}-01-01', f'{year + 1}-01-01'
        args = (group, yearly, start, end, recent, group, recent, yearly, start, end, group)
        return {r['user_name']: dict(r) for r in self.db.execute(SQL, args)}

    def test_recent_100_is_per_player_and_uses_same_hands_for_all_metrics(self):
        self.game('new', rate=20)
        for row in range(1, 106):
            self.hand('new', row, point=1000 if row <= 5 else 10, rank=4 if row <= 5 else 1)
        # Bob's games are older than every one of Alice's latest 100 games.
        self.game('old', '2025-01-01', rate=30)
        for row in range(1, 4):
            self.hand('old', row, 'Bob', -10, 3)
        recent = self.stats('recent100')
        self.assertEqual(recent['Alice']['hanshan_count'], 100)
        self.assertEqual(recent['Alice']['total_point'], 1000)
        self.assertEqual(recent['Alice']['total_amount'], 20000)
        self.assertEqual(recent['Alice']['avg_rank'], 1)
        self.assertEqual(recent['Alice']['rate1'], 100)
        self.assertEqual(recent['Alice']['rate4'], 0)
        self.assertEqual(recent['Bob']['hanshan_count'], 3)
        self.assertEqual(recent['Bob']['total_amount'], -900)
        self.assertEqual(recent['Bob']['avg_rank'], 3)
        all_time = self.stats()
        self.assertEqual(all_time['Alice']['hanshan_count'], 105)
        self.assertEqual(all_time['Alice']['total_point'], 6000)
        self.assertEqual(all_time['Alice']['recent100_avg_rank'], 1)

    def test_year_includes_january_first_and_december_last_only(self):
        for key, date, point in [('before', '2025-12-31', 1000), ('first', '2026-01-01', 10),
                                 ('last', '2026-12-31', 20), ('after', '2027-01-01', 2000)]:
            self.game(key, date)
            self.hand(key, 1, point=point)
        result = self.stats('year')['Alice']
        self.assertEqual(result['total_point'], 30)
        self.assertEqual(result['hanshan_count'], 2)
        self.assertEqual(result['participate_days'], 2)
        self.assertEqual(self.stats('year', 2027)['Alice']['total_point'], 2000)

    def test_latest_order_is_game_date_then_game_number_then_hand_number(self):
        self.game('latest', '2026-06-02', 1)
        for row in range(1, 100):
            self.hand('latest', row)
        self.game('earlier', '2026-06-01', 2)
        self.hand('earlier', 1, point=888)
        self.hand('earlier', 2, point=77, rank=2)
        # Insert these later: insertion order must not replace played order.
        self.game('same-day', '2026-06-01', 1)
        self.hand('same-day', 99, point=999)
        self.game('old', '2026-05-31', 99)
        self.hand('old', 100, point=9999)
        result = self.stats('recent100')['Alice']
        self.assertEqual(result['total_point'], 990 + 77)
        self.assertAlmostEqual(result['avg_rank'], 1.01)
        self.assertEqual(result['participate_days'], 2)

    def test_recent_count_boundaries(self):
        self.game('g')
        for row in range(1, 102):
            self.hand('g', row)
            if row in (99, 100, 101):
                with self.subTest(recorded=row):
                    self.assertEqual(self.stats('recent100')['Alice']['hanshan_count'], min(row, 100))

    def test_group_isolation_applies_before_recent_limit(self):
        self.game('ours', '2026-01-01')
        self.hand('ours', 1, point=12)
        self.game('foreign', '2026-09-01', group=2)
        for row in range(1, 102):
            self.hand('foreign', row, point=999)
        for period in ('all', 'year', 'recent100'):
            with self.subTest(period=period):
                result = self.stats(period)
                self.assertEqual(list(result), ['Alice', 'Bob', 'NoGames'])
                self.assertEqual(result['Alice']['total_point'], 12)
                self.assertEqual(result['Alice']['hanshan_count'], 1)

    def test_participation_counts_distinct_play_dates(self):
        for key, date, no in [('a', '2026-01-01', 1), ('b', '2026-01-01', 2), ('c', '2026-01-02', 1)]:
            self.game(key, date, no)
            self.hand(key, 1)
            self.hand(key, 2)
        self.assertEqual(self.stats()['Alice']['participate_days'], 2)
        self.assertEqual(self.stats()['Alice']['hanshan_count'], 6)

    def test_year_counters_are_weighted_and_recent_counters_are_unavailable(self):
        self.db.executemany('INSERT INTO daa_game_counter VALUES (?,?,?,?,?,?,?)', [
            (1, '2025-12-31', 100, 100, 100, 100, 100),
            (1, '2026-01-01', 10, 1, 2, 3, 4),
            (1, '2026-12-31', 30, 9, 10, 9, 4),
            (1, '2027-01-01', 200, 200, 200, 200, 200),
            (4, '2026-01-01', 900, 900, 900, 900, 900),
        ])
        result = self.stats('year')['Alice']
        self.assertEqual(result['hand_count'], 40)
        self.assertEqual(result['win_rate'], 25)
        self.assertEqual(result['call_rate'], 30)
        self.assertEqual(result['riichi_rate'], 30)
        self.assertEqual(result['deal_in_rate'], 20)
        self.assertEqual(self.stats()['Alice']['hand_count'], 340)
        self.assertEqual(self.stats('recent100')['Alice']['hand_count'], 0)

    def test_empty_period_and_zero_counters_do_not_drop_players_or_divide_by_zero(self):
        self.db.execute("INSERT INTO daa_game_counter VALUES (1,'2026-01-01',0,0,0,0,0)")
        for period in ('all', 'year', 'recent100'):
            with self.subTest(period=period):
                result = self.stats(period)
                self.assertEqual(list(result), ['Alice', 'Bob', 'NoGames'])
                for player in result.values():
                    for field in ('hanshan_count', 'participate_days', 'total_point', 'win_rate', 'avg_rank'):
                        self.assertEqual(player[field], 0)


if __name__ == '__main__':
    unittest.main()
