package com.yudi.crm.settings.dao;

import com.yudi.crm.settings.domain.DicType;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface DicTypeDao {
    List<DicType> getTypeList();
}
