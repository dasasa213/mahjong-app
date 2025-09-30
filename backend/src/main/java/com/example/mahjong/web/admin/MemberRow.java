package com.example.mahjong.web.admin;

public class MemberRow {
    private final String userId;
    private final String login;
    private final String userType;

    public MemberRow(String userId, String login, String userType) {
        this.userId = userId;
        this.login = login;
        this.userType = userType;
    }
    public String getUserId()   { return userId; }
    public String getLogin()  { return login; }
    public String getUserType(){ return userType; }
}