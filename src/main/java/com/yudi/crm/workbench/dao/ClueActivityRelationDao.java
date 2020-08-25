package com.yudi.crm.workbench.dao;


import com.yudi.crm.workbench.domain.ClueActivityRelation;

import java.util.List;

public interface ClueActivityRelationDao {


    int unbund(String id);

    int bund(ClueActivityRelation car);

    List<ClueActivityRelation> getListByClueId(String clueId);

    int delete(ClueActivityRelation clueActivityRelation);

    int getCountByIds(String[] ids);

    int deleteByIds(String[] ids);
}
