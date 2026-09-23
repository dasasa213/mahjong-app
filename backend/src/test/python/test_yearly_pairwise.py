"""Independent fixtures for year discovery, paired half-games and graph order."""
from pathlib import Path
import re
import unittest
import test_overall_periods as fixtures

ROOT = Path(__file__).resolve().parents[2] / 'main/java/com/example/mahjong/web/repository'

def query(file, marker):
    source = (ROOT / file).read_text().split(marker, 1)[1]
    return re.search(r'"""(.*?)"""', source, re.S).group(1)

class YearlyPairwiseTest(unittest.TestCase):
    def setUp(self):
        self.f = fixtures.OverallPeriodsTest()
        self.f.setUp()
        self.addCleanup(self.f.doCleanups)
        self.db = self.f.db
        self.db.create_function('YEAR', 1, lambda date: int(date[:4]))

    def pairs(self, year=None):
        sql = query('PairwiseRankStatsRepository.java', 'Integer year)')
        y = year or 2000
        return {(r['row_user_name'], r['col_user_name']): dict(r) for r in self.db.execute(
            sql, (1, 1, 1, int(year is not None), f'{y}-01-01', f'{y+1}-01-01'))}

    def test_only_same_half_games_are_compared(self):
        self.f.game('g')
        self.f.hand('g', 1, 'Alice', rank=1)
        self.f.hand('g', 1, 'Bob', rank=4)
        self.f.hand('g', 2, 'Alice', rank=4)
        self.f.hand('g', 2, 'Bob', rank=1)
        self.f.hand('g', 3, 'Alice', rank=1)  # Bob did not play this half-game.
        cell = self.pairs()[('Alice', 'Bob')]
        self.assertEqual(cell['game_count'], 2)
        self.assertEqual(cell['rank_diff'], 0)

    def test_year_boundaries_group_and_direction(self):
        for key, date, group, rank in [('a','2025-12-31',1,1), ('b','2026-01-01',1,4),
                                      ('c','2026-12-31',1,4), ('d','2027-01-01',1,1),
                                      ('e','2026-06-01',2,1)]:
            self.f.game(key, date, group=group)
            self.f.hand(key, 1, 'Alice', rank=rank)
            self.f.hand(key, 1, 'Bob', rank=5-rank)
        self.assertEqual(self.pairs(2025)[('Alice','Bob')]['rank_diff'], -3)
        self.assertEqual(self.pairs(2026)[('Alice','Bob')]['rank_diff'], 3)
        self.assertEqual(self.pairs(2026)[('Bob','Alice')]['rank_diff'], -3)
        self.assertEqual(self.pairs(2026)[('Alice','Bob')]['game_count'], 2)
        self.assertEqual(self.pairs(2024), {})

    def test_years_come_from_group_data_without_filling_gaps(self):
        for key,date,group in [('a','2023-01-01',1),('b','2025-02-01',1),('c','2025-03-01',1),('d','2026-01-01',2)]:
            self.f.game(key, date, group=group)
        for file in ['OverallStatsRepository.java','PairwiseRankStatsRepository.java']:
            sql=query(file,'findYears(')
            self.assertEqual([r[0] for r in self.db.execute(sql,(1,))], [2025,2023])
            self.assertEqual(list(self.db.execute(sql,(99,))), [])

    def test_rank_history_uses_played_order_and_selected_player(self):
        for key,date,no in [('b','2026-01-02',1),('a','2026-01-01',2),('c','2026-01-01',1)]:
            self.f.game(key,date,no)
        self.f.hand('b',1,rank=4)
        self.f.hand('a',2,rank=3)
        self.f.hand('a',1,rank=2)
        self.f.hand('c',1,rank=1)
        self.f.hand('b',1,'Bob',rank=1)
        sql=query('OverallChartRepository.java','loadRankHistory(')
        self.assertEqual([r['rank_no'] for r in self.db.execute(sql,(1,'Alice'))], [1,2,3,4])
        self.assertEqual(list(self.db.execute(sql,(2,'Alice'))), [])
