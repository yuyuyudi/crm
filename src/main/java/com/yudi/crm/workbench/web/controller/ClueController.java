package com.yudi.crm.workbench.web.controller;

import com.yudi.crm.settings.domain.User;
import com.yudi.crm.settings.service.UserService;
import com.yudi.crm.utils.DateTimeUtil;
import com.yudi.crm.utils.PrintJson;
import com.yudi.crm.utils.UUIDUtil;
import com.yudi.crm.vo.PaginationVo;
import com.yudi.crm.workbench.domain.Activity;
import com.yudi.crm.workbench.domain.Clue;
import com.yudi.crm.workbench.domain.ClueRemark;
import com.yudi.crm.workbench.domain.Tran;
import com.yudi.crm.workbench.service.ActivityService;
import com.yudi.crm.workbench.service.ClueService;
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
public class ClueController {
    @Resource
    private ClueService clueService;

    @Resource
    private UserService userService;

    @Resource
    private ActivityService activityService;

    @RequestMapping("/workbench/clue/getUserList.do")
    public void getUserList(HttpServletResponse response){
        System.out.println("获取用户信息");
        List<User> userList = userService.getUserList();
        PrintJson.printJsonObj(response,userList);
    }

    @RequestMapping("/workbench/clue/save.do")
    public void saveClue(HttpServletRequest request, HttpServletResponse response, Clue clue){
        String id = UUIDUtil.getUUID();
        String createTime = DateTimeUtil.getSysTime();
        String createBy = ((User)request.getSession().getAttribute("user")).getName();

        clue.setId(id);
        clue.setCreateBy(createBy);
        clue.setCreateTime(createTime);

        boolean flag = clueService.saveClue(clue);
        PrintJson.printJsonFlag(response,flag);
    }

    @RequestMapping("/workbench/clue/detail.do")
    public void detailClue(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        Clue clue = clueService.getClueById(id);
        request.setAttribute("c",clue);
        request.getRequestDispatcher("/workbench/clue/detail.jsp").forward(request,response);
    }

    @RequestMapping("/workbench/clue/getActivityListByClueId.do")
    public void getActivityListByClueId(HttpServletRequest request, HttpServletResponse response){
        System.out.println("根据线索查询关联的市场活动列表");
        String clueId = request.getParameter("clueId");
        List<Activity> activityList = activityService.getActivityListByClueId(clueId);
        PrintJson.printJsonObj(response,activityList);
    }

    @RequestMapping("/workbench/clue/unbund.do")
    public void deleteClue(HttpServletRequest request, HttpServletResponse response){
        String id = request.getParameter("id");
        boolean flag = clueService.unbund(id);
        PrintJson.printJsonFlag(response,flag);
    }

    @RequestMapping("/workbench/clue/getActivityListByNameAndNotByClueId.do")
    public void getActivityListByNameAndNotByClueId(HttpServletRequest request, HttpServletResponse response){
        System.out.println("查询市场关联活动列表");
        String aname = request.getParameter("aname");
        String clueId = request.getParameter("clueId");
        Map<String,String> map = new HashMap<String, String>();
        map.put("aname",aname);
        map.put("clueId",clueId);
        List<Activity> activityList = activityService.getActivityListByNameAndNotByClueId(map);
        PrintJson.printJsonObj(response,activityList);
    }

    @RequestMapping("/workbench/clue/bund.do")
    public void bund(HttpServletRequest request, HttpServletResponse response){
        System.out.println("执行关联市场活动的操作");
        String cid = request.getParameter("cid");
        String[] aid = request.getParameterValues("aid");
        boolean flag = clueService.bund(cid,aid);
        PrintJson.printJsonFlag(response,flag);
    }

    @RequestMapping("/workbench/clue/getActivityListByName.do")
    public void getActivityListByName(HttpServletRequest request, HttpServletResponse response){
        System.out.println("根据名称模糊查询市场活动");
        String aname = request.getParameter("aname");
       List<Activity> activityList = activityService.getActivityListByName(aname);
        PrintJson.printJsonObj(response,activityList);
    }

    @RequestMapping("/workbench/clue/convert.do")
    public void convert(HttpServletRequest request, HttpServletResponse response) throws IOException {
        System.out.println("执行线索转换的操作");
        String clueId = request.getParameter("clueId");
//        接受是否需要创建的标记
        String flag = request.getParameter("flag");
        String createBy = ((User)request.getSession().getAttribute("user")).getName();
        Tran t = null;
        if ("a".equals(flag)){
            t = new Tran();
//            接受交易表单的参数
            String money = request.getParameter("money");
            String stage = request.getParameter("stage");
            String expectedDate = request.getParameter("expectedDate");
            String activityId = request.getParameter("activityId");
            String name= request.getParameter("name");
            String id = UUIDUtil.getUUID();
            String createTime = DateTimeUtil.getSysTime();

            t.setMoney(money);
            t.setStage(stage);
            t.setExpectedDate(expectedDate);
            t.setActivityId(activityId);
            t.setName(name);
            t.setId(id);
            t.setCreateBy(createBy);
            t.setCreateTime(createTime);
        }
        boolean flag1 = clueService.convert(clueId,t,createBy);

//        重定向
        if (flag1){
            response.sendRedirect(request.getContextPath()+"/workbench/clue/index.jsp");
        }

    }

    @RequestMapping("/workbench/clue/delete.do")
    public void delete(HttpServletRequest request,HttpServletResponse response){
        String ids[] = request.getParameterValues("id");
        boolean flag = clueService.delete(ids);
        PrintJson.printJsonFlag(response,flag);
    }

    @RequestMapping("/workbench/clue/pageList.do")
    public void pageList(HttpServletRequest request,HttpServletResponse response){
        String pageNoStr = request.getParameter("pageNo");
        String pageSizeStr = request.getParameter("pageSize");
        String fullname = request.getParameter("fullname");
        String company = request.getParameter("company");
        String mphone = request.getParameter("mphone");
        String source = request.getParameter("source");
        String owner = request.getParameter("owner");
        String phone = request.getParameter("phone");
        String state = request.getParameter("state");
        // 算出略过的记录数
        int pageNo = Integer.valueOf(pageNoStr);
        int pageSize = Integer.valueOf(pageSizeStr);
        int skipCount = (pageNo - 1) * pageSize;

        Map<String,Object> map = new HashMap<String, Object>();
        map.put("fullname",fullname);
        map.put("company",company);
        map.put("mphone",mphone);
        map.put("source",source);
        map.put("owner",owner );
        map.put("phone",phone );
        map.put("state",state );
        map.put("pageSize",pageSize);
        map.put("skipCount",skipCount);

        PaginationVo<Clue> cluePaginationVo = clueService.pageList(map);
        PrintJson.printJsonObj(response,cluePaginationVo);
    }

    @RequestMapping("/workbench/clue/showRemarkList.do")
    public void showRemarkList(String clueId,HttpServletResponse response){
        List<ClueRemark> clueRemarkList = clueService.getClueRemarkByClueId(clueId);
        PrintJson.printJsonObj(response,clueRemarkList);


    }

    @RequestMapping("/workbench/clue/update.do")
    public void update(Clue clue,HttpServletRequest request,HttpServletResponse response){
        String editTime = DateTimeUtil.getSysTime();
        String editBy = ((User)request.getSession().getAttribute("user")).getName();
        clue.setEditBy(editBy);
        clue.setEditTime(editTime);
        boolean flag = clueService.update(clue);
        PrintJson.printJsonFlag(response,flag);
    }

    @RequestMapping("/workbench/clue/getClueAndUserList.do")
    public void getClueAndUserList(String id,HttpServletResponse response){
        Map<String,Object> map = clueService.getClueAndUserList(id);
        PrintJson.printJsonObj(response,map);
    }

    @RequestMapping("/workbench/clue/saveRemark.do")
    public void saveRemark(ClueRemark clueRemark,HttpServletRequest request,HttpServletResponse response){

        String id = UUIDUtil.getUUID();
        String createTime = DateTimeUtil.getSysTime();
        String createBy = ((User)request.getSession().getAttribute("user")).getName();
        clueRemark.setId(id);
        clueRemark.setCreateBy(createBy);
        clueRemark.setCreateTime(createTime);
        clueRemark.setEditFlag("0");
        boolean flag = clueService.saveRemark(clueRemark);

        Map<String,Object> map = new HashMap<String, Object>();
        map.put("success",flag);
        map.put("cr",clueRemark);

        PrintJson.printJsonObj(response,map);
    }


}
