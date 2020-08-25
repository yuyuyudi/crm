package com.yudi.crm.settings.service.impl;

import com.yudi.crm.exception.LoginException;
import com.yudi.crm.settings.dao.UserDao;
import com.yudi.crm.settings.domain.User;
import com.yudi.crm.settings.service.UserService;
import com.yudi.crm.utils.DateTimeUtil;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.List;


@Service("UserService")
@Transactional
public class UserServiceImpl implements UserService {
    @Resource
    private UserDao userDao;

    public User login(String loginAct, String loginPwd, String ip) throws LoginException{
        User user =  userDao.login(loginAct,loginPwd);
        if (user == null){
            throw new LoginException("账号或密码错误");
        }
//        程序到此说明密码正确，需要继续向下验证
//        验证失效时间
        String expireTime = user.getExpireTime();
        String currentTime = DateTimeUtil.getSysTime();
        if (expireTime.compareTo(currentTime) < 0){
            throw new LoginException("账号已失效");
        }
//        判断锁定状态
        if ("0".equals(user.getLockState())){
            throw new LoginException("账号已锁定，请联系管理员");
        }
//        判断ip
//        String allowIp = user.getAllowIps();
//        if (!allowIp.contains(ip)){
//            throw new LoginException("ip地址受限，请联系管理员");
//        }
        return user;
    }

    public List<User> getUserList() {
        return userDao.getUserList();
    }
}
