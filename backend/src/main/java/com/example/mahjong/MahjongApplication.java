package com.example.mahjong; // ← Controller（com.example.mahjong.web...）の親パッケージに置く

import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.web.servlet.error.ErrorMvcAutoConfiguration;


@SpringBootApplication(exclude = { ErrorMvcAutoConfiguration.class })
public class MahjongApplication {
    public static void main(String[] args) {
        org.springframework.boot.SpringApplication.run(MahjongApplication.class, args);
    }
}