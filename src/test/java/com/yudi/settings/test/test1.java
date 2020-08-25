package com.yudi.settings.test;
import com.yudi.crm.utils.DateTimeUtil;
public class test1 {
    public static void main(String[] args) {
        String expireTime = "2019-09-09 09:09:09";
        String curretTime = DateTimeUtil.getSysTime();
        int count = expireTime.compareTo(curretTime);
        System.out.println(count);
    }
}
