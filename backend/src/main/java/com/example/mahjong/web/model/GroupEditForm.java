package com.example.mahjong.web.model;

public class GroupEditForm {
    private String currentName; // 表示専用
    private String newName;     // 入力値（10文字以内）

    public String getCurrentName() {
        return currentName;
    }

    public void setCurrentName(String currentName) {
        this.currentName = currentName;
    }

    public String getNewName() {
        return newName;
    }

    public void setNewName(String newName) {
        this.newName = newName;
    }
}
