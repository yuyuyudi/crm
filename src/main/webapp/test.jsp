<%--
  Created by IntelliJ IDEA.
  User: 玉帝
  Date: 2020/8/18
  Time: 18:06
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
$.ajax({
url : "workbench/activity/save.do",
data : {

},
type : "post",
dataType : "json",
success:function (data) {

}
})


String id = UUIDUtil.getUUID();
String createTime = DateTimeUtil.getSysTime();
String createBy = ((User)request.getSession().getAttribute("user")).getName();

$(".time").datetimepicker({
minView: "month",
language:  'zh-CN',
format: 'yyyy-mm-dd',
autoclose: true,
todayBtn: true,
pickerPosition: "bottom-left"
});

$("#create-customerName").typeahead({
source: function (query, process) {
$.post(
"workbench/transaction/getCustomerName.do",
{ "name" : query },
function (data) {
//alert(data);
process(data);
},
"json"
);
},
delay: 1500
});
</body>
</html>
