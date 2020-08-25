package com.yudi.crm.workbench.web.controller;

import com.yudi.crm.settings.domain.User;
import com.yudi.crm.settings.service.UserService;
import com.yudi.crm.utils.DateTimeUtil;
import com.yudi.crm.utils.PrintJson;
import com.yudi.crm.utils.UUIDUtil;
import com.yudi.crm.vo.PaginationVo;
import com.yudi.crm.workbench.domain.Tran;
import com.yudi.crm.workbench.domain.TranHistory;
import com.yudi.crm.workbench.service.CustomerService;
import com.yudi.crm.workbench.service.TranService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class TranController {
    @Resource
    private UserService userService;

    @Resource
    private TranService tranService;

    @Resource
    private CustomerService customerService;

    @RequestMapping("/workbench/transaction/add.do")
    public void add(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入到添加交易面");
        List<User> userList = userService.getUserList();
//        传统转发
        request.setAttribute("uList",userList);
        request.getRequestDispatcher("/workbench/transaction/save.jsp").forward(request,response);
    }

    @RequestMapping("/workbench/transaction/getCustomerName.do")
    public void getCustomerName(HttpServletRequest request, HttpServletResponse response){
        System.out.println("取得客户名称列表");
        String name = request.getParameter("name");
        List<String> customerList = customerService.getCustomerName(name);
        PrintJson.printJsonObj(response,customerList);

    }

    @RequestMapping("/workbench/transaction/save.do")
    public void save(HttpServletRequest request, HttpServletResponse response) throws IOException {
        System.out.println("执行添加交易的操作");
        String id = UUIDUtil.getUUID();
        String owner = request.getParameter("owner");
        String money = request.getParameter("money");
        String name = request.getParameter("name");
        String expectedDate = request.getParameter("expectedDate");
        String customerName = request.getParameter("customerName");//只有名称没有id
        String stage = request.getParameter("stage");
        String type = request.getParameter("type");
        String source = request.getParameter("source");
        String activityId = request.getParameter("activityId");
        String contactsId = request.getParameter("contactsId");
        String createTime = DateTimeUtil.getSysTime();
        String createBy = ((User)request.getSession().getAttribute("user")).getName();
        String description = request.getParameter("description");
        String contactSummary = request.getParameter("contactSummary");
        String nextContactTime = request.getParameter("nextContactTime");

        Tran t = new Tran();
        t.setId(id);
        t.setOwner(owner);
        t.setMoney(money);
        t.setName(name);
        t.setExpectedDate(expectedDate);
        t.setStage(stage);
        t.setType(type);
        t.setSource(source);
        t.setActivityId(activityId);
        t.setContactsId(contactsId);
        t.setCreateTime(createTime);
        t.setCreateBy(createBy);
        t.setDescription(description);
        t.setContactSummary(contactSummary);
        t.setNextContactTime(nextContactTime);

        boolean flag = tranService.save(t,customerName);

        if (flag){
//            转发：会保留到原来的路径，可能会重复保存数据，不可取
//            request.getRequestDispatcher("/workbench/transaction/index.jsp").forward(request,response);
//            重定向：如果交易成功，跳转到列表页
            response.sendRedirect(request.getContextPath() + "workbench/transaction/index.jsp");
        }


    }

    @RequestMapping("/workbench/transaction/detail.do")
    public void detail(String id,HttpServletRequest request,HttpServletResponse response) throws ServletException, IOException {
        Tran t =tranService.detail(id);
//        处理可能性
        /*
        * 阶段 可能性之间的关系
        *
        * */
        String stage = t.getStage();
        ServletContext application = request.getServletContext();
        Map<String,String> pMAp = (Map<String, String>) application.getAttribute("pMap");
        String possibility = pMAp.get(stage);
        t.setPossibility(possibility);
        request.setAttribute("t",t);

        request.getRequestDispatcher("/workbench/transaction/detail.jsp").forward(request,response);
    }

    @RequestMapping("/workbench/transaction/getHistoryListByTranId.do")
    public void getHistoryListByTranId(String tranId,HttpServletRequest request,HttpServletResponse response){
        List<TranHistory> tranHistoryList = tranService.getHistoryListByTranId(tranId);
        ServletContext application = request.getServletContext();
        Map<String,String> pMAp = (Map<String, String>) application.getAttribute("pMap");
//        处理可能性
        for (TranHistory tranHistory : tranHistoryList){
//            根据没一条交易历史取出每一个阶段
            String stage = tranHistory.getStage();
            String possibility = pMAp.get(stage);
            tranHistory.setPossibility(possibility);
        }
        PrintJson.printJsonObj(response,tranHistoryList);
    }

    @RequestMapping("/workbench/transaction/changeStage.do")
    public void changeStage(Tran t,HttpServletRequest request,HttpServletResponse response){
//        String id = request.getParameter("id");
//        String stage = request.getParameter("stage");
//        String money = request.getParameter("money");
//        String expectedDate = request.getParameter("expectedDate");
        String editTime = DateTimeUtil.getSysTime();
        String editBy = ((User)request.getSession().getAttribute("user")).getName();

        t.setEditBy(editBy);
        t.setEditTime(editTime);

        boolean flag = tranService.changeStage(t);
        Map<String,String> pMap = (Map<String, String>) request.getServletContext().getAttribute("pMap");
        t.setPossibility(pMap.get(t.getStage()));
        Map<String,Object> map = new HashMap<String, Object>();
        map.put("success",flag);
        map.put("t",t);
        PrintJson.printJsonObj(response,map);

    }

    @RequestMapping("/workbench/transaction/getCharts.do")
    public void getCharts(HttpServletResponse response){
        Map<String,Object> map = tranService.getCharts();
        PrintJson.printJsonObj(response,map);

    }

    @RequestMapping("/workbench/transaction/pageList.do")
    public void pageList(Tran tran,HttpServletRequest request,HttpServletResponse response){
        String pageNoStr = request.getParameter("pageNo");
        String pageSizeStr = request.getParameter("pageSize");
        int pageNo = Integer.valueOf(pageNoStr);
        int pageSize = Integer.valueOf(pageSizeStr);
        Map<String,Object> map = new HashMap<String,Object>();
        //        算出略过的记录数
        int skipCount = (pageNo - 1) * pageSize;
        map.put("t",tran);
        map.put("skipCount",skipCount);
        map.put("pageSize",pageSize);

        PaginationVo<Tran> vo = tranService.pageList(map);
        PrintJson.printJsonObj(response,vo);
    }
}
