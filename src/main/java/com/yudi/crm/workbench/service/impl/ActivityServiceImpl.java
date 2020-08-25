package com.yudi.crm.workbench.service.impl;


import com.yudi.crm.settings.dao.UserDao;
import com.yudi.crm.settings.domain.User;
import com.yudi.crm.vo.PaginationVo;
import com.yudi.crm.workbench.dao.ActivityDao;
import com.yudi.crm.workbench.dao.ActivityRemarkDao;
import com.yudi.crm.workbench.domain.Activity;
import com.yudi.crm.workbench.domain.ActivityRemark;
import com.yudi.crm.workbench.service.ActivityService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


@Service("ActivityService")
@Transactional
public class ActivityServiceImpl implements ActivityService {
    @Resource
    private ActivityDao activityDao;

    @Resource
    private ActivityRemarkDao activityRemarkDao;

    @Resource
    private UserDao userDao;

    public boolean saveActivity(Activity activity) {
        boolean flag = true;
        int count = activityDao.saveActivity(activity);
        if (count != 1){
            flag = false;
        }
        return flag;
    }

    public PaginationVo<Activity> pageList(Map<String, Object> map) {
//        取得total
        int total = activityDao.getTotalByCondition(map);
//        取得pageList
        List<Activity> activityList= activityDao.getActivityByCondition(map);
        PaginationVo<Activity> vo = new PaginationVo<Activity>();
        vo.setTotal(total);
        vo.setDataList(activityList);

        return vo;
    }

    public boolean deleteActivity(String[] ids) {
        Boolean flag = true;
//        查询需要删除的备注的数量
        int count1 = activityRemarkDao.getCountByAids(ids);
//        删除备注返回受到影响的条数
        int count2 = activityRemarkDao.deleteByAids(ids);

        if (count1 != count2){
            flag  = false;
        }
//        删除市场活动
        int count3 = activityDao.deleteActivity(ids);
        if (count3 != ids.length){
            flag = false;
        }
        return flag;
    }

    public Map<String, Object> getUserListAndActivity(String id) {
        Map<String, Object> map = new HashMap<String, Object>();
//        取uList
        List<User> userList = userDao.getUserList();
//        取a
        Activity activity = activityDao.getActivityById(id);

        map.put("uList",userList);
        map.put("a",activity);

        return map;
    }

    public boolean updateActivity(Activity activity) {
        boolean flag = true;
        int count = activityDao.updateActivity(activity);
        if (count != 1){
            flag = false;
        }
        return flag;
    }

    public Activity detail(String id) {
        Activity activity = activityDao.detail(id);
        return activity;
    }

    public List<ActivityRemark> getRemarkListByAid(String activityId) {
        List<ActivityRemark> arList = activityRemarkDao.getRemarkListByAid(activityId);
        return arList;
    }

    public boolean deleteRemark(String id) {
        boolean flag = true;
        int count = activityRemarkDao.deleteRemark(id);
        if (count != 1){
            flag = false;
        }
        return flag;
    }

    public boolean saveRemark(ActivityRemark activityRemark) {
        boolean flag = true;
        int count = activityRemarkDao.saveRemark(activityRemark);
        if (count != 1){
            flag = false;
        }
        return flag;
    }

    public boolean updateRemark(ActivityRemark activityRemark) {
        boolean flag = true;
        int count = activityRemarkDao.updateRemark(activityRemark);
        if (count != 1){
            flag = false;
        }
        return flag;
    }

    public List<Activity> getActivityListByClueId(String clueId) {
        List<Activity> activityList = activityDao.getActivityListByClueId(clueId);
        return activityList;
    }

    public List<Activity> getActivityListByNameAndNotByClueId(Map<String, String> map) {
        List<Activity> activityList = activityDao.getActivityListByNameAndNotByClueId(map);
        return activityList;
    }

    public List<Activity> getActivityListByName(String aname) {
        List<Activity> activityList = activityDao.getActivityListByName(aname);
        return activityList;
    }


}
