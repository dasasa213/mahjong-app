package com.example.mahjong.web.user;

import com.example.mahjong.web.service.PairwiseRankStatsService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
@RequestMapping("/user/pairwise-rank")
public class PairwiseRankStatsController {

    private final PairwiseRankStatsService service;

    public PairwiseRankStatsController(PairwiseRankStatsService service) {
        this.service = service;
    }

    @GetMapping
    public String page(HttpSession session, Model model,
                       @RequestParam(name = "year", required = false) Integer requestedYear) {
        Object gid = session.getAttribute("groupId");
        if (gid == null) {
            return "redirect:/main/login-in";
        }
        long groupId = (gid instanceof Number) ? ((Number) gid).longValue() : Long.parseLong(String.valueOf(gid));

        List<Integer> years = service.years(groupId);
        Integer selectedYear = requestedYear != null && years.contains(requestedYear) ? requestedYear : null;
        model.addAttribute("years", years);
        model.addAttribute("selectedYear", selectedYear);
        List<String> userNames = service.userNames(groupId);
        model.addAttribute("userNames", userNames);
        model.addAttribute("matrix", service.matrix(groupId, userNames, selectedYear));
        model.addAttribute("active", "pairwise-rank");

        return "user/pairwise-rank";
    }
}
