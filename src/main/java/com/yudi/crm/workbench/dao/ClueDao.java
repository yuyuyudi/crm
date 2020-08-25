package com.yudi.crm.workbench.dao;


import com.yudi.crm.workbench.domain.Clue;

import java.util.List;
import java.util.Map;

public interface ClueDao {


    int saveClue(Clue clue);

    Clue getClueById(String id);

    Clue getById(String clueId);

    int delete(String clueId);

    int getTotalByCondition(Map<String, Object> map);

    List<Clue> getListByCondition(Map<String, Object> map);

    int update(Clue clue);

    int deleteActivity(String[] ids);
}
