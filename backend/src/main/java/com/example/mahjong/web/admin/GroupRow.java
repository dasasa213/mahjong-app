package com.example.mahjong.web.admin;

public class GroupRow {
    private final String groupId;
    private final String groupName;
    private final String sakuseiDay;

    public GroupRow(String groupId, String groupName, String sakuseiDay) {
        this.groupId = groupId;
        this.groupName = groupName;
        this.sakuseiDay = sakuseiDay;
    }
    public String getGroupId()    { return groupId; }
    public String getGroupName()  { return groupName; }
    public String getSakuseiDay() { return sakuseiDay; }
}
