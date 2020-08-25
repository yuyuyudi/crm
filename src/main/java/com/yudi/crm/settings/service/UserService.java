package com.yudi.crm.settings.service;

import com.yudi.crm.exception.LoginException;
import com.yudi.crm.settings.domain.User;

import java.util.List;

public interface UserService {
    User login(String loginAct, String loginPwd, String ip) throws LoginException;

    List<User> getUserList();
}
