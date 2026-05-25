package com.example.mahjong.web.service;

import com.example.mahjong.web.model.PairwiseRankDiffCell;
import com.example.mahjong.web.model.PairwiseRankDiffRow;
import com.example.mahjong.web.repository.PairwiseRankStatsRepository;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.DecimalFormat;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Service
public class PairwiseRankStatsService {

    private final PairwiseRankStatsRepository repository;

    public PairwiseRankStatsService(PairwiseRankStatsRepository repository) {
        this.repository = repository;
    }

    public List<String> userNames(long groupId) {
        return repository.findUserNames(groupId);
    }

    public Map<String, Map<String, PairwiseRankDiffCell>> matrix(long groupId, List<String> userNames) {
        Map<String, Map<String, PairwiseRankDiffCell>> matrix = new LinkedHashMap<>();
        for (String rowName : userNames) {
            Map<String, PairwiseRankDiffCell> cols = new LinkedHashMap<>();
            for (String colName : userNames) {
                if (rowName.equals(colName)) {
                    cols.put(colName, new PairwiseRankDiffCell(null, "-", "self"));
                } else {
                    cols.put(colName, new PairwiseRankDiffCell(null, "", "nodata"));
                }
            }
            matrix.put(rowName, cols);
        }

        for (PairwiseRankDiffRow row : repository.findRankDiffRows(groupId)) {
            if (!matrix.containsKey(row.getRowUserName())) {
                continue;
            }
            Map<String, PairwiseRankDiffCell> cols = matrix.get(row.getRowUserName());
            if (!cols.containsKey(row.getColUserName())) {
                continue;
            }
            BigDecimal rounded = row.getRankDiff().setScale(1, RoundingMode.HALF_UP);
            cols.put(row.getColUserName(), new PairwiseRankDiffCell(
                    rounded,
                    formatWithSign(rounded),
                    rounded.signum() >= 0 ? "pos" : "neg"
            ));
        }
        return matrix;
    }

    private String formatWithSign(BigDecimal value) {
        DecimalFormat df = new DecimalFormat("+0.0;-0.0");
        return df.format(value);
    }
}
