package com.yudi.crm.workbench.service;

import com.yudi.crm.vo.PaginationVo;
import com.yudi.crm.workbench.domain.Tran;
import com.yudi.crm.workbench.domain.TranHistory;

import java.util.List;
import java.util.Map;

public interface TranService {
    boolean save(Tran t, String customerName);

    Tran detail(String id);

    List<TranHistory> getHistoryListByTranId(String tranId);

    boolean changeStage(Tran t);

    Map<String, Object> getCharts();

    PaginationVo<Tran> pageList(Map<String, Object> map);
}
