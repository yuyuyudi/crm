package com.yudi.crm.workbench.service.impl;

import com.yudi.crm.settings.dao.UserDao;
import com.yudi.crm.settings.domain.User;
import com.yudi.crm.utils.DateTimeUtil;
import com.yudi.crm.utils.UUIDUtil;
import com.yudi.crm.vo.PaginationVo;
import com.yudi.crm.workbench.dao.*;
import com.yudi.crm.workbench.domain.*;
import com.yudi.crm.workbench.service.ClueService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service("ClueService")
@Transactional
public class ClueServiceImpl implements ClueService {
    @Resource
    private UserDao userDao;
//    线索相关表
    @Resource
    private ClueDao clueDao;
    @Resource
    private ClueActivityRelationDao clueActivityRelationDao;
    @Resource
    private ClueRemarkDao clueRemarkDao;
//    客户相关表
    @Resource
    private CustomerDao customerDao;
    @Resource
    private CustomerRemarkDao customerRemarkDao;
//    联系人相关表
    @Resource
    private ContactsDao contactsDao;
    @Resource
    private ContactsRemarkDao contactsRemarkDao;
    @Resource
    private ContactsActivityRelationDao contactsActivityRelationDao;
//    交易相关表
    @Resource
    private TranDao tranDao;
    @Resource
    private TranHistoryDao tranHistoryDao;

    public boolean saveClue(Clue clue) {
        boolean flag = true;
        int count = clueDao.saveClue(clue);
        if (count != 1){
            flag = false;
        }
        return flag;
    }

    public Clue getClueById(String id) {
        Clue clue = clueDao.getClueById(id);
        return clue;
    }

    public boolean unbund(String id) {
        boolean flag = true;
        int count = clueActivityRelationDao.unbund(id);
        if (count != 1){
            flag = false;
        }
        return flag;
    }

    public boolean bund(String cid, String[] aids) {
        boolean flag = true;
        for (String aid :aids){
//            取得每一个aid和cid关联
            ClueActivityRelation car = new ClueActivityRelation();
            String id = UUIDUtil.getUUID();
            car.setId(id);
            car.setClueId(cid);
            car.setActivityId(aid);
//            添加关联关系表中的记录
            int count = clueActivityRelationDao.bund(car);
            if (count != 1){
                flag = false;
            }
        }
        return flag;
    }

    public boolean convert(String clueId, Tran t, String createBy) {
        String createTime = DateTimeUtil.getSysTime();
        boolean flag = true;
//        1.通过线索id获取线索对象，线索对象中封装了线索的信息
        Clue clue = clueDao.getById(clueId);
//        2.通过线索信息创建客户信息，如果客户存在则新建客户（根据公司名称精确匹配）
        String company = clue.getCompany();
        Customer customer = customerDao.getByName(company);
        if (customer == null){
//            需要新建客户
            customer = new Customer();
            customer.setId(UUIDUtil.getUUID());
            customer.setAddress(clue.getAddress());
            customer.setWebsite(clue.getWebsite());
            customer.setPhone(clue.getPhone());
            customer.setOwner(clue.getOwner());
            customer.setNextContactTime(clue.getNextContactTime());
            customer.setName(company);
            customer.setDescription(clue.getDescription());
            customer.setCreateBy(createBy);
            customer.setCreateTime(createTime);
            customer.setContactSummary(clue.getContactSummary());
//            添加客户
            int count1 = customerDao.save(customer);
            if (count1 != 1){
                flag = false;
            }
        }
//        经过第二步处理后，客户的信息已经拥有了
//        3.通过线索对象提取联系人信息，保存联系人
        Contacts contacts = new Contacts();
        contacts.setId(UUIDUtil.getUUID());
        contacts.setSource(clue.getSource());
        contacts.setOwner(clue.getOwner());
        contacts.setNextContactTime(clue.getNextContactTime());
        contacts.setJob(clue.getJob());
        contacts.setMphone(clue.getMphone());
        contacts.setFullname(clue.getFullname());
        contacts.setEmail(clue.getEmail());
        contacts.setDescription(clue.getDescription());
        contacts.setCustomerId(customer.getId());
        contacts.setCreateTime(createTime);
        contacts.setCreateBy(createBy);
        contacts.setContactSummary(clue.getContactSummary());
        contacts.setAppellation(clue.getAppellation());
        contacts.setAddress(clue.getAddress());
//        添加联系人
        int count2 = contactsDao.save(contacts);
        if (count2 != 1){
            flag = false;
        }
//经过第三步联系人的信息已经拥有了
//        4.将线索的备注转换到联系人备注和客户备注
//        查询出于该线索关联的备注信息列表
        List<ClueRemark> clueRemarkList = clueRemarkDao.getListByClueId(clueId);
        for (ClueRemark clueRemark : clueRemarkList){
//            取出每一条线索的备注
            String noteContent = clueRemark.getNoteContent();
//            创建客户备注对象，添加客户备注
            CustomerRemark customerRemark = new CustomerRemark();
            customerRemark.setId(UUIDUtil.getUUID());
            customerRemark.setNoteContent(noteContent);
            customerRemark.setCustomerId(customer.getId());
            customerRemark.setCreateTime(createTime);
            customerRemark.setCreateBy(createBy);
            customerRemark.setEditFlag("0");
            int count3 = customerRemarkDao.save(customerRemark);
            if (count3 != 1){
                flag = false;
            }

//            创建联系人备注对象，添加联系人备注
            ContactsRemark contactsRemark = new ContactsRemark();
            contactsRemark.setId(UUIDUtil.getUUID());
            contactsRemark.setNoteContent(noteContent);
            contactsRemark.setContactsId(contacts.getId());
            contactsRemark.setCreateTime(createTime);
            contactsRemark.setCreateBy(createBy);
            contactsRemark.setEditFlag("0");
            int count4 = contactsRemarkDao.save(contactsRemark);
            if (count4 != 1){
                flag = false;
            }
        }
//        5.“线索和市场活动”的关系转换到“联系人和市场活动”的关系
//        查询出于该提案线索关联的市场活动，查询与市场活动的关联关系列表
        List<ClueActivityRelation> clueActivityRelationList = clueActivityRelationDao.getListByClueId(clueId);
        for (ClueActivityRelation clueActivityRelation : clueActivityRelationList){
//            从每一条遍历出来的记录中取出市场活动关联的id
            String activityId = clueActivityRelation.getActivityId();
//            创建联系人与市场活动的关联关系，第三部的联系人与市场活动关联
            ContactsActivityRelation contactsActivityRelation = new ContactsActivityRelation();
            contactsActivityRelation.setId(UUIDUtil.getUUID());
            contactsActivityRelation.setActivityId(activityId);
            contactsActivityRelation.setContactsId(contacts.getId());
//            添加联系人与市场活动的关联关系
            int count5 = contactsActivityRelationDao.save(contactsActivityRelation);
            if (count5 != 1){
                flag = false;
            }
        }
//        6.如果有创建交易需求，创建一条交易
        if (t != null){
            /*
            * t对象在controller已经封装好的信息：
            * id,money,name,expectedDate,stage,activityId,createBy,createName
            *
            * 可以通过第一步生成的clue对象取出一些信息，继续完善交易信息
            */
            t.setSource(clue.getSource());
            t.setOwner(clue.getOwner());
            t.setNextContactTime(clue.getNextContactTime());
            t.setDescription(clue.getDescription());
            t.setContactSummary(clue.getContactSummary());
            t.setCustomerId(customer.getId());
            t.setContactsId(contacts.getId());
//            添加交易
            int count6 = tranDao.save(t);
            if (count6 != 1){
                flag = false;
            }
//        7.如果创建了交易，则创建一条该交易下的交易历史 ：一对多
            TranHistory tranHistory = new TranHistory();
            tranHistory.setId(UUIDUtil.getUUID());
            tranHistory.setTranId(t.getId());
            tranHistory.setCreateBy(createBy);
            tranHistory.setCreateTime(createTime);
            tranHistory.setStage(t.getStage());
            tranHistory.setMoney(t.getMoney());
            tranHistory.setExpectedDate(t.getExpectedDate());
//            添加交易历史
            int count7 = tranHistoryDao.save(tranHistory);
            if (count7 != 1){
                flag = false;
            }
        }

//        8.删除线索备注
        for (ClueRemark clueRemark : clueRemarkList){
            int count8 = clueRemarkDao.delete(clueRemark);
            if (count8 != 1){
                flag = false;
            }
        }
//        9.删除线索和市场活动之间的关联关系
        for (ClueActivityRelation clueActivityRelation : clueActivityRelationList){
            int count9 = clueActivityRelationDao.delete(clueActivityRelation);
            if (count9 != 1){
                flag = false;
            }
        }
//        10.删除线索
        int count10 = clueDao.delete(clueId);
        if (count10 != 1){
            flag = false;
        }
        return flag;
    }

    public boolean delete(String[] ids) {
        Boolean flag = true;
//        查询需要删除的线索备注数量的数量
        int count1 = clueRemarkDao.getCountByAids(ids);
//        删除备注返回受到影响的条数
        int count2 = clueRemarkDao.deleteByAids(ids);

        if (count1 != count2){
            flag  = false;
        }
//        查询需要删除的线索活动关系条数
        int count3 = clueActivityRelationDao.getCountByIds(ids);
//        删除线索活动关系的条数
        int count4 = clueActivityRelationDao.deleteByIds(ids);
        if (count3 != count4){
            flag = false;
        }
//        删除线索
        int count5 = clueDao.deleteActivity(ids);
        if (count5 != ids.length){
            flag = false;
        }
        return flag;
    }

    public PaginationVo<Clue> pageList(Map<String, Object> map) {
        PaginationVo<Clue> vo = new PaginationVo<Clue>();
        int total = clueDao.getTotalByCondition(map);
        List<Clue> clueList = clueDao.getListByCondition(map);
        vo.setTotal(total);
        vo.setDataList(clueList);
        return vo;
    }

    public List<ClueRemark> getClueRemarkByClueId(String clueId) {
        List<ClueRemark> clueList = clueRemarkDao.getListByClueId(clueId);
        return clueList;
    }

    public Map<String, Object> getClueAndUserList(String id) {
        Map<String, Object> map = new HashMap<String, Object>();
        Clue clue = clueDao.getClueById(id);
        List<User> userList = userDao.getUserList();
        map.put("uList",userList);
        map.put("c",clue);
        return map;
    }

    public boolean update(Clue clue) {
        boolean flag = true;
        int count = clueDao.update(clue);
        if (count != 1){
            flag = false;
        }
        return flag;
    }

    public boolean saveRemark(ClueRemark clueRemark) {
        boolean flag = true;
        int count = clueRemarkDao.save(clueRemark);
        if (count != 1){
            flag = false;
        }
        return flag;
    }

}
