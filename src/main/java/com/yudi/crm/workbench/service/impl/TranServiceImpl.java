package com.yudi.crm.workbench.service.impl;

import com.yudi.crm.utils.DateTimeUtil;
import com.yudi.crm.utils.UUIDUtil;
import com.yudi.crm.vo.PaginationVo;
import com.yudi.crm.workbench.dao.CustomerDao;
import com.yudi.crm.workbench.dao.TranDao;
import com.yudi.crm.workbench.dao.TranHistoryDao;
import com.yudi.crm.workbench.domain.Customer;
import com.yudi.crm.workbench.domain.Tran;
import com.yudi.crm.workbench.domain.TranHistory;
import com.yudi.crm.workbench.service.TranService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service("TranService")
public class TranServiceImpl implements TranService {
    @Resource
    private TranDao tranDao;

    @Resource
    private TranHistoryDao tranHistoryDao;

    @Resource
    private CustomerDao customerDao;

    public boolean save(Tran t, String customerName) {
        boolean flag = true;
        /*
        * 交易添加业务
        * 在做添加之前，参数页面少了一项信息，customerId
        * 先处理客户的需求
        *  1.判断customerName，在客户表精确查询，如果在客户表中，则直接取id
        *   没有则创建一个客户，将新建的客户id取出
        *  2.执行添加交易操作
        *  3.创建一条交易历史
        * */
//        1.
        Customer customer = customerDao.getByName(customerName);
        if (customer == null){
//            创建客户
            customer = new Customer();
            customer.setId(UUIDUtil.getUUID());
            customer.setName(customerName);
            customer.setCreateBy(t.getCreateBy());
            customer.setCreateTime(DateTimeUtil.getSysTime());
            customer.setContactSummary(t.getContactSummary());
            customer.setNextContactTime(t.getNextContactTime());
            customer.setOwner(t.getOwner());
//            添加客户
            int count1 = customerDao.save(customer);
            if (count1 != 1){
                flag = false;
            }
        }
//        此时客户已经有了
        String customerId = customer.getId();
        t.setCustomerId(customerId);

//        添加交易
        int count2 = tranDao.save(t);
        if (count2 != 1){
            flag = false;
        }
//        添加交易历史
        TranHistory tranHistory = new TranHistory();
        tranHistory.setId(UUIDUtil.getUUID());
        tranHistory.setTranId(t.getId());
        tranHistory.setExpectedDate(t.getExpectedDate());
        tranHistory.setStage(t.getStage());
        tranHistory.setCreateBy(t.getCreateBy());
        tranHistory.setCreateTime(t.getCreateTime());
        tranHistory.setMoney(t.getMoney());

        int count3 = tranHistoryDao.save(tranHistory);
        if (count3 != 1){
            flag = false;
        }
        return flag;
    }

    public Tran detail(String id) {
        Tran t = tranDao.detail(id);
        return t;
    }

    public List<TranHistory> getHistoryListByTranId(String tranId) {
        List<TranHistory> tranHistoryList = tranHistoryDao.getHistoryListByTranId(tranId);
        return tranHistoryList;
    }

    public boolean changeStage(Tran t) {
        boolean flag = true;
        int count1 = tranDao.changeStage(t);
        if (count1 != 1){
            flag = false;
        }
//        交易阶段改变后生成一段交易历史
        TranHistory tranHistory = new TranHistory();
        tranHistory.setId(UUIDUtil.getUUID());
        tranHistory.setCreateBy(t.getEditBy());
        tranHistory.setCreateTime(DateTimeUtil.getSysTime());
        tranHistory.setExpectedDate(t.getExpectedDate());
        tranHistory.setMoney(t.getMoney());
        tranHistory.setTranId(t.getId());
        tranHistory.setStage(t.getStage());
        int count2 = tranHistoryDao.save(tranHistory);
        if (count2 != 1){
            flag = false;
        }
        return flag;
    }

    public Map<String, Object> getCharts() {
        Map<String, Object> map = new HashMap<String, Object>();
//        取得total
        int total = tranDao.getTotal();
//        取得dataList
        List<Map<String,Object>> dataList = tranDao.getCharts();
        map.put("total",total);
        map.put("dataList",dataList);
        return map;
    }

    public PaginationVo<Tran> pageList(Map<String, Object> map) {
        PaginationVo<Tran> paginationVo = new PaginationVo<Tran>();
        List<Tran> tranList = tranDao.pageListByCondition(map);
        int total = tranDao.getTotalByCondition(map);
        paginationVo.setTotal(total);
        paginationVo.setDataList(tranList);
        return paginationVo;
    }
}
