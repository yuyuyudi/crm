package com.yudi.crm.workbench.dao;


import com.yudi.crm.workbench.domain.Activity;

import java.util.List;
import java.util.Map;

public interface ActivityDao {

    int saveActivity(Activity activity);

    int getTotalByCondition(Map<String, Object> map);

    List<Activity> getActivityByCondition(Map<String, Object> map);

    int deleteActivity(String[] ids);

    Activity getActivityById(String id);

    int updateActivity(Activity activity);

    Activity detail(String id);

    List<Activity> getActivityListByClueId(String clueId);

    List<Activity> getActivityListByNameAndNotByClueId(Map<String, String> map);

    List<Activity> getActivityListByName(String aname);
}
