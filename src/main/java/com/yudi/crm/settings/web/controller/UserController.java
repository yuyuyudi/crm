package com.yudi.crm.settings.web.controller;

import com.yudi.crm.settings.domain.User;
import com.yudi.crm.settings.service.UserService;
import com.yudi.crm.utils.MD5Util;
import com.yudi.crm.utils.PrintJson;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.Map;


@Controller
public class UserController extends HttpServlet {
    @Resource
    private UserService userService;

    @RequestMapping("/settings/user/login.do")
    public void login(HttpServletRequest request, HttpServletResponse response){
        String loginAct = request.getParameter("loginAct");
        String loginPwd = request.getParameter("loginPwd");

//        将密码明文转换为md5密文
        loginPwd = MD5Util.getMD5(loginPwd);
//        接受ip地址
        String ip = request.getRemoteAddr();

        System.out.println("ip========================" + ip);

        try{
            User user = userService.login(loginAct,loginPwd,ip);

            request.getSession().setAttribute("user", user);
//            程序执行到此处，表示登录成功
            PrintJson.printJsonFlag(response, true);

        }catch (Exception e){
            e.printStackTrace();
//            到此处抛出异常，表示登录失败
            String msg = e.getMessage();
            Map<String,Object> map = new HashMap<String,Object>();
            map.put("success", false);
            map.put("msg", msg);
            PrintJson.printJsonObj(response, map);
        }

    }

}
