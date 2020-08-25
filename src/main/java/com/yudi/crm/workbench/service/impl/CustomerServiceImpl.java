package com.yudi.crm.workbench.service.impl;

import com.yudi.crm.workbench.dao.CustomerDao;
import com.yudi.crm.workbench.service.CustomerService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service("CustomerService")
public class CustomerServiceImpl implements CustomerService {
    @Resource
    private CustomerDao customerDao;

    public List<String> getCustomerName(String name) {
        List<String> stringList = customerDao.getCustomerName(name);
        return stringList;
    }
}
