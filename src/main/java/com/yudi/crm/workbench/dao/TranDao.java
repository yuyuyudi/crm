package com.yudi.crm.workbench.dao;

import com.yudi.crm.workbench.domain.Tran;

import java.util.List;
import java.util.Map;

public interface TranDao {

    int save(Tran t);

    Tran detail(String id);

    int changeStage(Tran t);

    int getTotal();

    List<Map<String, Object>> getCharts();

    List<Tran> pageListByCondition(Map<String, Object> map);

    int getTotalByCondition(Map<String, Object> map);
}
