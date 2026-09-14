package com.example.mahjong.web;

import com.example.mahjong.web.model.GameCounter;
import com.example.mahjong.web.service.GameCounterService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDate;

@Controller
@RequestMapping("/user/counter")
public class GameCounterController {

    private final GameCounterService service;

    public GameCounterController(GameCounterService service) {
        this.service = service;
    }

    @GetMapping
    public String page(HttpSession session, Model model) {

        long userId = getLoginUserId(session);

        GameCounter counter = service.findToday(userId);

        if (counter == null) {
            counter = new GameCounter();
            counter.setUserId(userId);
            counter.setGameDate(LocalDate.now());
        }

        model.addAttribute("counter", counter);
        model.addAttribute("history", service.findHistory(userId));
        model.addAttribute("active", "counter");

        return "user/counter";
    }

    @PostMapping
    public String save(
            HttpSession session,
            Model model,
            RedirectAttributes redirectAttributes,
            @RequestParam int handCount,
            @RequestParam int winCount,
            @RequestParam int callCount,
            @RequestParam int riichiCount,
            @RequestParam int dealInCount) {

        long userId = getLoginUserId(session);

        GameCounter counter = new GameCounter();

        counter.setGameDate(LocalDate.now());
        counter.setUserId(userId);
        counter.setHandCount(handCount);
        counter.setWinCount(winCount);
        counter.setCallCount(callCount);
        counter.setRiichiCount(riichiCount);
        counter.setDealInCount(dealInCount);

        if (handCount < 0
                || winCount < 0
                || callCount < 0
                || riichiCount < 0
                || dealInCount < 0) {

            model.addAttribute("counter", counter);
            model.addAttribute("active", "counter");
            model.addAttribute("error", "入力値は0以上にしてください。");

            return "user/counter";
        }

        if (winCount > handCount) {
            model.addAttribute("counter", counter);
            model.addAttribute("active", "counter");
            model.addAttribute("error", "和了数は局数以下にしてください。");

            return "user/counter";
        }

        if (callCount > handCount) {
            model.addAttribute("counter", counter);
            model.addAttribute("active", "counter");
            model.addAttribute("error", "副露数は局数以下にしてください。");

            return "user/counter";
        }

        if (riichiCount > handCount) {
            model.addAttribute("counter", counter);
            model.addAttribute("active", "counter");
            model.addAttribute("error", "立直数は局数以下にしてください。");

            return "user/counter";
        }

        if (dealInCount > handCount) {
            model.addAttribute("counter", counter);
            model.addAttribute("active", "counter");
            model.addAttribute("error", "放銃数は局数以下にしてください。");

            return "user/counter";
        }

        service.save(counter);

        redirectAttributes.addFlashAttribute(
                "success",
                "登録しました。"
        );

        return "redirect:/user/counter";
    }

    private long getLoginUserId(HttpSession session) {

        Object value = session.getAttribute("userId");

        if (value instanceof Number) {
            return ((Number) value).longValue();
        }

        return Long.parseLong(String.valueOf(value));
    }

    @PostMapping("/delete")
    public String delete(
            HttpSession session,
            @RequestParam long id,
            RedirectAttributes redirectAttributes) {

        long userId = getLoginUserId(session);

        service.delete(id, userId);

        redirectAttributes.addFlashAttribute(
                "success",
                "削除しました。"
        );

        return "redirect:/user/counter";
    }

    @GetMapping("/edit")
    public String edit(
            HttpSession session,
            @RequestParam long id,
            Model model) {

        long userId = getLoginUserId(session);

        GameCounter counter = service.findById(id, userId);

        if (counter == null) {
            return "redirect:/user/counter";
        }

        model.addAttribute("counter", counter);
        model.addAttribute("active", "counter");

        return "user/counter-edit";
    }

    @PostMapping("/edit")
    public String update(
            HttpSession session,
            Model model,
            @RequestParam long id,
            @RequestParam int handCount,
            @RequestParam int winCount,
            @RequestParam int callCount,
            @RequestParam int riichiCount,
            @RequestParam int dealInCount,
            RedirectAttributes redirectAttributes) {

        long userId = getLoginUserId(session);

        GameCounter counter = service.findById(id, userId);

        if (counter == null) {
            return "redirect:/user/counter";
        }

        counter.setHandCount(handCount);
        counter.setWinCount(winCount);
        counter.setCallCount(callCount);
        counter.setRiichiCount(riichiCount);
        counter.setDealInCount(dealInCount);

        if (handCount < 0
                || winCount < 0
                || callCount < 0
                || riichiCount < 0
                || dealInCount < 0) {

            model.addAttribute("counter", counter);
            model.addAttribute("active", "counter");
            model.addAttribute("error", "入力値は0以上にしてください。");

            return "user/counter-edit";
        }

        if (winCount > handCount) {
            model.addAttribute("counter", counter);
            model.addAttribute("active", "counter");
            model.addAttribute("error", "和了数は局数以下にしてください。");

            return "user/counter-edit";
        }

        if (callCount > handCount) {
            model.addAttribute("counter", counter);
            model.addAttribute("active", "counter");
            model.addAttribute("error", "副露数は局数以下にしてください。");

            return "user/counter-edit";
        }

        if (riichiCount > handCount) {
            model.addAttribute("counter", counter);
            model.addAttribute("active", "counter");
            model.addAttribute("error", "立直数は局数以下にしてください。");

            return "user/counter-edit";
        }

        if (dealInCount > handCount) {
            model.addAttribute("counter", counter);
            model.addAttribute("active", "counter");
            model.addAttribute("error", "放銃数は局数以下にしてください。");

            return "user/counter-edit";
        }

        service.update(counter);

        redirectAttributes.addFlashAttribute(
                "success",
                "更新しました。"
        );

        return "redirect:/user/counter";
    }
}