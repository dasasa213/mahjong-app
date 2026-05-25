package com.example.mahjong.web.user;

import com.example.mahjong.web.service.PairwiseRankStatsService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequestMapping("/user/pairwise-rank")
public class PairwiseRankStatsController {

    private final PairwiseRankStatsService service;

    public PairwiseRankStatsController(PairwiseRankStatsService service) {
        this.service = service;
    }

    @GetMapping
    public String page(HttpSession session, Model model) {
        Object gid = session.getAttribute("groupId");
        if (gid == null) {
            return "redirect:/main/login-in";
        }
        long groupId = (gid instanceof Number) ? ((Number) gid).longValue() : Long.parseLong(String.valueOf(gid));

        List<String> userNames = service.userNames(groupId);
        model.addAttribute("userNames", userNames);
        model.addAttribute("matrix", service.matrix(groupId, userNames));
        model.addAttribute("active", "pairwise-rank");

        return "user/pairwise-rank";
    }
}
