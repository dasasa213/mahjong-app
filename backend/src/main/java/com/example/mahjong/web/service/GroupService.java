package com.example.mahjong.web.service;

import com.example.mahjong.web.repository.GroupRepository;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

@Service
public class GroupService {
    private final GroupRepository repo;
    public GroupService(GroupRepository repo){ this.repo = repo; }

    public String currentName(String groupId){
        return repo.findNameById(groupId);
    }

    public boolean changeName(String groupId, String newName){
        if (groupId == null || groupId.isBlank()) return false;
        if (!StringUtils.hasText(newName)) return false;
        if (newName.length() > 10) return false;
        return repo.updateName(groupId, newName) == 1;
    }
}
