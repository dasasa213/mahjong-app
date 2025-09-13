package com.example.mahjong.web.service;

import com.example.mahjong.web.admin.AdminHomeView;
import com.example.mahjong.web.admin.GroupRow;
import com.example.mahjong.web.admin.MemberRow;
import com.example.mahjong.web.repository.AdminDashboardRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class AdminDashboardService {
    private final AdminDashboardRepository repo;
    public AdminDashboardService(AdminDashboardRepository repo){ this.repo = repo; }

    public AdminHomeView buildViewFor(Long userId){
        var groupOpt = repo.findGroupByUserId(userId);
        if (groupOpt.isEmpty()) {
            return new AdminHomeView(null, null, null, List.of());
        }
        var group = groupOpt.get();
        var members = repo.findMembersByGroupId(group.getGroupId());
        return new AdminHomeView(group.getGroupId(), group.getGroupName(), group.getSakuseiDay(), members);
    }
}