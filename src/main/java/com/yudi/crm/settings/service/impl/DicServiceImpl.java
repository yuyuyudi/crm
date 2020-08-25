package com.yudi.crm.settings.service.impl;

import com.yudi.crm.settings.dao.DicTypeDao;
import com.yudi.crm.settings.dao.DicValueDao;
import com.yudi.crm.settings.domain.DicType;
import com.yudi.crm.settings.domain.DicValue;
import com.yudi.crm.settings.service.DicService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service("DicService")
public class DicServiceImpl implements DicService {
    @Resource
    private DicTypeDao dicTypeDao;

    @Resource
    private DicValueDao dicValueDao;

    public Map<String, List<DicValue>> getAll() {
        Map<String, List<DicValue>> map = new HashMap<String, List<DicValue>>();
//        将字典类型取出
        List<DicType> dicTypes = dicTypeDao.getTypeList();
//        将字典类型遍历
        for (DicType dicType : dicTypes){
//        取得每种类型的字典编码
        String code = dicType.getCode();
//        根据每一个字典类型来取得字典值列表
        List<DicValue> dicValues = dicValueDao.getListByCode(code);
        map.put(code + "List",dicValues);
        }
        return map;
    }
}
