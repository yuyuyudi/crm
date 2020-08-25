package com.yudi.crm.workbench.dao;

import com.yudi.crm.workbench.domain.ClueRemark;

import java.util.List;

public interface ClueRemarkDao {

    List<ClueRemark> getListByClueId(String clueId);

    int delete(ClueRemark clueRemark);

    int getCountByAids(String[] ids);

    int deleteByAids(String[] ids);

    int save(ClueRemark clueRemark);
}
