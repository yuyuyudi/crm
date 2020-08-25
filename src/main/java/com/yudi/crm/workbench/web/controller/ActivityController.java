package com.yudi.crm.workbench.web.controller;

import com.yudi.crm.settings.domain.User;
import com.yudi.crm.settings.service.UserService;
import com.yudi.crm.utils.DateTimeUtil;
import com.yudi.crm.utils.PrintJson;
import com.yudi.crm.utils.UUIDUtil;
import com.yudi.crm.vo.PaginationVo;
import com.yudi.crm.workbench.domain.Activity;
import com.yudi.crm.workbench.domain.ActivityRemark;
import com.yudi.crm.workbench.service.ActivityService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class ActivityController {
    @Resource
    private UserService userService;

    @Resource
    private ActivityService activityService;

    @RequestMapping("/workbench/activity/getUserList.do")
    public void getUserList(HttpServletResponse response){
        List<User> userList = userService.getUserList();
        PrintJson.printJsonObj(response,userList);
    }

    @RequestMapping("/workbench/activity/save.do")
    public void saveActivity(HttpServletRequest request,HttpServletResponse response){
        System.out.println("执行市场活动添加操作");
        String id = UUIDUtil.getUUID();
        String owner = request.getParameter("owner");
        String name = request.getParameter("name");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String cost = request.getParameter("cost");
        String description = request.getParameter("description");
//        创建人时间
        String createTime = DateTimeUtil.getSysTime();
        String createBy = ((User)request.getSession().getAttribute("user")).getName();

        Activity activity = new Activity();
        activity.setId(id);
        activity.setOwner(owner);
        activity.setName(name);
        activity.setStartDate(startDate);
        activity.setEndDate(endDate);
        activity.setCost(cost);
        activity.setDescription(description);
        activity.setCreateTime(createTime);
        activity.setCreateBy(createBy);

        boolean flag = activityService.saveActivity(activity);
        PrintJson.printJsonFlag(response,flag);

    }

    @RequestMapping("/workbench/activity/pageList.do")
    public void pageList(HttpServletRequest request,HttpServletResponse response){
        System.out.println("活动页面查询");
        String name = request.getParameter("name");
        String owner = request.getParameter("owner");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String pageNoStr = request.getParameter("pageNo");
        int pageNo = Integer.valueOf(pageNoStr);
        String pageSizeStr = request.getParameter("pageSize");
        int pageSize = Integer.valueOf(pageSizeStr);
//        算出略过的记录数
        int skipCount = (pageNo - 1) * pageSize;

        Map<String,Object> map = new HashMap<String,Object>();
        map.put("name", name);
        map.put("owner",owner);
        map.put("startDate",startDate);
        map.put("endDate",endDate);
        map.put("skipCount",skipCount);
        map.put("pageSize",pageSize);

        PaginationVo<Activity> vo = activityService.pageList(map);
        PrintJson.printJsonObj(response,vo);
    }

    @RequestMapping("/workbench/activity/delete.do")
    public void deleteActivity(HttpServletRequest request,HttpServletResponse response){
        System.out.println("市场活动删除操作");
        String ids[] = request.getParameterValues("id");
        boolean flag = activityService.deleteActivity(ids);
        PrintJson.printJsonFlag(response,flag);
    }

    @RequestMapping("/workbench/activity/getUserListAndActivity.do")
    public void getUserListAndActivity(HttpServletRequest request,HttpServletResponse response){
        System.out.println("进入用户查询列表和根据市场活动id查询单条市场活动");
        String id = request.getParameter("id");
        Map<String,Object> map = activityService.getUserListAndActivity(id);
        PrintJson.printJsonObj(response,map);

    }

    @RequestMapping("/workbench/activity/update.do")
    public void updateActivity(HttpServletRequest request,HttpServletResponse response){
        System.out.println("执行市场活动添加操作");
        String id = request.getParameter("id");
        String owner = request.getParameter("owner");
        String name = request.getParameter("name");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String cost = request.getParameter("cost");
        String description = request.getParameter("description");
//        创建人时间
        String editTime = DateTimeUtil.getSysTime();
        String editBy = ((User)request.getSession().getAttribute("user")).getName();

        Activity activity = new Activity();
        activity.setId(id);
        activity.setOwner(owner);
        activity.setName(name);
        activity.setStartDate(startDate);
        activity.setEndDate(endDate);
        activity.setCost(cost);
        activity.setDescription(description);
        activity.setEditTime(editTime);
        activity.setEditBy(editBy);

        boolean flag = activityService.updateActivity(activity);
        PrintJson.printJsonFlag(response,flag);

    }

    @RequestMapping("/workbench/activity/detail.do")
    public void detail(HttpServletRequest request,HttpServletResponse response) throws ServletException, IOException {
        System.out.println("跳转到详细信息页");
        String id = request.getParameter("id");
        Activity activity = activityService.detail(id);
        request.setAttribute("a",activity);
        request.getRequestDispatcher("/workbench/activity/detail.jsp").forward(request,response);
    }

    @RequestMapping("/workbench/activity/getRemarkListByAid.do")
    public void getRemarkListByAid(HttpServletRequest request,HttpServletResponse response){
        System.out.println("根据市场活动id，取得备注信息");
        String activityId = request.getParameter("activityId");
        List<ActivityRemark> arList = activityService.getRemarkListByAid(activityId);
        PrintJson.printJsonObj(response,arList);

    }

    @RequestMapping("/workbench/activity/deleteRemark.do")
    public void deleteRemark(HttpServletRequest request,HttpServletResponse response){
        System.out.println("删除备注");
        String id = request.getParameter("id");
        boolean flag = activityService.deleteRemark(id);
        PrintJson.printJsonFlag(response,flag);
    }

    @RequestMapping("/workbench/activity/saveRemark.do")
    public void saveRemark(HttpServletRequest request,HttpServletResponse response){
        System.out.println("添加备注");
        String noteContent = request.getParameter("noteContent");
        String activityId = request.getParameter("activityId");
        String id = UUIDUtil.getUUID();
        String createTime = DateTimeUtil.getSysTime();
        String createBy = ((User)request.getSession().getAttribute("user")).getName();
        String editFlag = "0";
        ActivityRemark activityRemark = new ActivityRemark();
        activityRemark.setId(id);
        activityRemark.setNoteContent(noteContent);
        activityRemark.setActivityId(activityId);
        activityRemark.setCreateBy(createBy);
        activityRemark.setCreateTime(createTime);
        activityRemark.setEditFlag(editFlag);

        boolean flag = activityService.saveRemark(activityRemark);

        Map<String,Object> map = new HashMap<String, Object>();
        map.put("success",flag);
        map.put("ar",activityRemark);

        PrintJson.printJsonObj(response,map);
    }

    @RequestMapping("/workbench/activity/updateRemark.do")
    public void updateRemark(HttpServletRequest request,HttpServletResponse response){
        System.out.println("更新备注");
        String id = request.getParameter("id");
        String noteContent = request.getParameter("noteContent");
        String editTime = DateTimeUtil.getSysTime();
        String editeBy = ((User)request.getSession().getAttribute("user")).getName();
        String editFlag = "1";
        ActivityRemark activityRemark = new ActivityRemark();
        activityRemark.setId(id);
        activityRemark.setNoteContent(noteContent);
        activityRemark.setEditBy(editeBy);
        activityRemark.setEditTime(editTime);
        activityRemark.setEditFlag(editFlag);
        boolean flag = activityService.updateRemark(activityRemark);
        Map<String,Object> map = new HashMap<String, Object>();
        map.put("success",flag);
        map.put("ar",activityRemark);

        PrintJson.printJsonObj(response,map);
    }

}
