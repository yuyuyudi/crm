package com.yudi.crm.workbench.service;


import com.yudi.crm.vo.PaginationVo;
import com.yudi.crm.workbench.domain.Activity;
import com.yudi.crm.workbench.domain.ActivityRemark;

import java.util.List;
import java.util.Map;

public interface ActivityService {

    boolean saveActivity(Activity activity);

    PaginationVo<Activity> pageList(Map<String, Object> map);

    boolean deleteActivity(String[] ids);

    Map<String, Object> getUserListAndActivity(String id);

    boolean updateActivity(Activity activity);

    Activity detail(String id);

    List<ActivityRemark> getRemarkListByAid(String activityId);

    boolean deleteRemark(String id);

    boolean saveRemark(ActivityRemark activityRemark);

    boolean updateRemark(ActivityRemark activityRemark);

    List<Activity> getActivityListByClueId(String clueId);

    List<Activity> getActivityListByNameAndNotByClueId(Map<String, String> map);

    List<Activity> getActivityListByName(String aname);
}
