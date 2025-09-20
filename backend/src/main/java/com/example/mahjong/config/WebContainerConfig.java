//package com.example.mahjong.config;
//
//import org.springframework.boot.web.servlet.FilterRegistrationBean;
//import org.springframework.boot.web.servlet.support.ErrorPageFilter;
//import org.springframework.context.annotation.Bean;
//import org.springframework.context.annotation.Configuration;
//
//@Configuration
//public class WebContainerConfig {
//
//    // Boot が自動生成する ErrorPageFilter を受け取り、外部Tomcatでは“フィルタ登録”を無効化する
//    @Bean
//    public FilterRegistrationBean<ErrorPageFilter> disableErrorPageFilter(ErrorPageFilter filter) {
//        FilterRegistrationBean<ErrorPageFilter> reg = new FilterRegistrationBean<>(filter);
//        reg.setEnabled(false);          // これで二重登録を防止
//        return reg;
//    }
//}