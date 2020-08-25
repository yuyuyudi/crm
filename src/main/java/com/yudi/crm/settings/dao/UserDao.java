package com.yudi.crm.settings.dao;

import com.yudi.crm.settings.domain.User;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface UserDao {
    User login(@Param("loginAct") String loginAct, @Param("loginPwd") String loginPwd);

    List<User> getUserList();
}
