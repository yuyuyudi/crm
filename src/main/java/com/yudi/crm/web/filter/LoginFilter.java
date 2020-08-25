package com.yudi.crm.web.filter;

import com.yudi.crm.settings.domain.User;
import org.springframework.stereotype.Component;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;


public class LoginFilter implements Filter {

    public void init(FilterConfig filterConfig) throws ServletException {

    }

    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain filterChain) throws IOException, ServletException {
        System.out.println("进入到验证有没有登录过的过滤器");

        HttpServletRequest request = (HttpServletRequest)req;
        HttpServletResponse response = (HttpServletResponse)resp;

        String path = request.getServletPath();
        if ("/login.jsp".equals(path) || "/settings/user/login.do".equals(path)){
            filterChain.doFilter(req,resp);
        }else {
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");

//        路径一律使用绝对路径
//        关于转发和重定向
//        转发：使用的是一种特殊的绝对路径的使用方式，这种绝对路径前面不加 /项目名 ，这种路径也称为内部路径
//        重定向：使用的是传统的绝对路径的写法，前面必须加 /项目名
            if (user != null){
                filterChain.doFilter(request,resp);
            }else {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
            }
        }


    }

    public void destroy() {

    }
}
