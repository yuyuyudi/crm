package com.yudi.crm.web.filter;

import javax.servlet.*;
import java.io.IOException;

public class EncodingFilter implements Filter {

    public void init(FilterConfig filterConfig) throws ServletException {

    }

    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain filterChain) throws IOException, ServletException {
        System.out.println("进入到过滤字符编码的过滤器");
//        过滤post请求中文参数乱码问题
        req.setCharacterEncoding("UTF-8");

//        过滤响应流响应中文乱码的问题
        resp.setContentType("text/html;charset=utf-8");

//        请求放行
        filterChain.doFilter(req,resp);

    }

    public void destroy() {

    }
}
