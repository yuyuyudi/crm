package com.yudi.crm.workbench.service;

import com.yudi.crm.vo.PaginationVo;
import com.yudi.crm.workbench.domain.Clue;
import com.yudi.crm.workbench.domain.ClueRemark;
import com.yudi.crm.workbench.domain.Tran;

import java.util.List;
import java.util.Map;

public interface ClueService {
    boolean saveClue(Clue clue);

    Clue getClueById(String id);

    boolean unbund(String id);

    boolean bund(String cid, String[] aid);


    boolean convert(String clueId, Tran t, String createBy);

    boolean delete(String[] ids);

    PaginationVo<Clue> pageList(Map<String, Object> map);

    List<ClueRemark> getClueRemarkByClueId(String clueId);

    Map<String, Object> getClueAndUserList(String id);

    boolean update(Clue clue);

    boolean saveRemark(ClueRemark clueRemark);
}
