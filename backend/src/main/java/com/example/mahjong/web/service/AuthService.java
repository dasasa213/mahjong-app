package com.example.mahjong.web.service;


import com.example.mahjong.web.dao.UserDao;
import com.example.mahjong.web.model.User;
import org.springframework.stereotype.Service;

@Service
public class AuthService {
    private final UserDao dao;
    public AuthService(UserDao dao){ this.dao = dao; }

    public Result login(String name, String password){
        User u = dao.findByName(name);
        if (u != null && password.equals(u.getPassword())) {
            return new Result(true, u.getId(), u.getName(), u.getType());
        }
        return new Result(false, null, null, null);
    }

    public record Result(boolean ok, String userId, String userName, String type){}
}
