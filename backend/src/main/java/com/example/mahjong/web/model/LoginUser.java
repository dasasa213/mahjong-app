package com.example.mahjong.web.model;

import java.io.Serializable;

public record LoginUser(
        String id,
        String name,
        String groupId,
        String groupName,
        Integer type
) implements Serializable {}
