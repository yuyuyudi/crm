package com.yudi.crm.settings.dao;

import com.yudi.crm.settings.domain.DicValue;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface DicValueDao {
    List<DicValue> getListByCode(String code);
}
