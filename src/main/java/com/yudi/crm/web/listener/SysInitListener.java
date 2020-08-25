package com.yudi.crm.web.listener;

import com.yudi.crm.settings.domain.DicValue;
import com.yudi.crm.settings.service.DicService;
import com.yudi.crm.settings.service.impl.DicServiceImpl;
import org.springframework.stereotype.Component;
import org.springframework.web.context.support.WebApplicationContextUtils;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.util.*;

@Component
//初始化数据字典
public class SysInitListener implements ServletContextListener {
    public SysInitListener() {}
    //    监听上下文域对象，当服务器启动时上下文域对象创建
//    对象创建完成后，马上执行该方法
    public void contextInitialized(ServletContextEvent servletContextEvent) {

//        空指针异常是因为自己的监听器在容器的监听器之前被创建了
        DicService dicService = WebApplicationContextUtils.getWebApplicationContext(servletContextEvent.getServletContext()).getBean(DicServiceImpl.class);
        System.out.println("缓存数据字典开始=====================");
        ServletContext application = servletContextEvent.getServletContext();
//        取数据字典，分门别类保存数据字典
        Map<String, List<DicValue>> map = dicService.getAll();
//        将map中的键值对解析为上下文域对象中的键值对
        Set<String> set = map.keySet();
        for (String key:set){
            application.setAttribute(key,map.get(key));
        }
        application.setAttribute("dic",map);
        System.out.println("缓存数据字典结束=====================");

        System.out.println("解析属性文件Stage2Possibility.properties============");
//        解析该文件，属性文件键值对转换为java键值对map
        ResourceBundle rb = ResourceBundle.getBundle("Stage2Possibility");
        Enumeration<String> e = rb.getKeys();
        Map<String,String> pMap = new HashMap<String, String>();
        while (e.hasMoreElements()){
//            阶段
            String key = e.nextElement();
//            可能性
            String value = rb.getString(key);
            pMap.put(key,value);
        }
//        保存在服务器缓存中
        application.setAttribute("pMap",pMap);
    }

    public void contextDestroyed(ServletContextEvent servletContextEvent) {

    }
}
