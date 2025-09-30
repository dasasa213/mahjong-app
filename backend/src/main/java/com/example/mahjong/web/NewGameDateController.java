// src/main/java/com/example/mahjong/web/game/NewGameDateController.java
package com.example.mahjong.web;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import jakarta.servlet.http.HttpSession;

import java.time.LocalDate;

@Controller
@RequestMapping("/user/newgame/date")
public class NewGameDateController {
    @GetMapping
    public String page(Model model){
        model.addAttribute("today", LocalDate.now());
        model.addAttribute("active", "newgame");
        return "user/newgame-date";
    }
    @PostMapping
    public String submit(@RequestParam("gamedate") LocalDate gamedate,
                         HttpSession session){
        session.setAttribute("newGameDate", gamedate);
        return "redirect:/user/newgame/players";
    }
}
