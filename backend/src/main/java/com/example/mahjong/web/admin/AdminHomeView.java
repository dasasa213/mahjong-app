package com.example.mahjong.web.admin;

import java.util.List;

public class AdminHomeView {
    private final String groupId;
    private final String groupName;
    private final String sakuseiDay;
    private final List<MemberRow> members;

    public AdminHomeView(String groupId, String groupName, String sakuseiDay, List<MemberRow> members) {
        this.groupId = groupId;
        this.groupName = groupName;
        this.sakuseiDay = sakuseiDay;
        this.members = members;
    }

    public String getGroupId()    { return groupId; }
    public String getGroupName()  { return groupName; }
    public String getSakuseiDay() { return sakuseiDay; }
    public List<MemberRow> getMembers() { return members; }
}