<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
String basePath = request.getScheme() + "://" +
request.getServerName() + ":" + request.getServerPort() +
request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
    <link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css"/>
    <script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination/en.js"></script>
<script type="text/javascript">

	$(function(){
		pageList(1,2);
        //	为全选的复选框绑定事件，触发全选操作
        $("#qx").click(function () {
            $("input[name=xz]").prop("checked",this.checked)
        })

        /*	以下方法错误，动态生成的不能用普通的绑定事件的形式进行操作
            $("input[name=xz]").click(function () {
                alert(123)
            })*/
        //动态的要用on
        // 	$(需要绑定元素的有效外层元素).on(绑定事件的方式，需要绑定的元素的jQuery对象，回调函数)
        $("#transactionBody").on("click",$("input[name=xz]"),function () {
            $("#qx").prop("checked",$("input[name=xz]").length == $("input[name=xz]:checked").length);
        })
	});

	function pageList(pageNo,pageSize) {
        //将全选的复选框取消
        $("#qz").prop("checked",false);
        //查询前将隐藏域中的信息取出来，保存在搜索框中
        $("#search-name").val($.trim($("#hidden-name").val()));
        $("#search-owner").val($.trim($("#hidden-owner").val()));
        $("#search-customerName").val($.trim($("#hidden-customerName").val()));
        $("#search-stage").val($.trim($("#hidden-stage").val()));
        $("#search-type").val($.trim($("#hidden-type").val()));
        $("#search-source").val($.trim($("#hidden-source").val()));
        $("#search-contractName").val($.trim($("#hidden-contractName").val()));

        $.ajax({
            url : "workbench/transaction/pageList.do",
            data : {
                "pageNo" : pageNo,
                "pageSize" : pageSize,
				"hidden-id" : $.trim($("#search-").val()),
				"hidden-owner" : $.trim($("#search-owner").val()),
				"hidden-name" : $.trim($("#search-name").val()),
				"hidden-customerName" : $.trim($("#search-customerName").val()),
				"hidden-stage" : $.trim($("#search-stage").val()),
				"hidden-type" : $.trim($("#search-type").val()),
				"hidden-source" : $.trim($("#search-source").val()),
				"hidden-contractName" : $.trim($("#search-contractName").val())
            },
            type : "get",
            dataType : "json",
            success:function (data) {
                /*
                * data
                * 	[{交易}，{2}，{3}]
                * 	分页插件需要的，查询出来的总记录数
                * 	{"total":100}
                * 	{"total":100,"dataList":[{市场活动1}，{2}，{3}]}*/
                var html = "";
                $.each(data.dataList,function (i,n) {
                    html += '<tr class="active">';
                    html += '<td><input type="checkbox" name="xz"/></td>';
                    html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/transaction/detail.do?id='+ n.id +'\';">'+ n.name +'</a></td>';
                    html += '<td>'+ n.customerName +'</td>';
                    html += '<td>'+ n.stage +'</td>';
                    html += '<td>'+ n.type +'</td>';
                    html += '<td>'+ n.owner +'</td>';
                    html += '<td>'+ n.source +'</td>';
                    html += '<td>'+ n.contactsName +'</td>';
                    html += '</tr>';
                })
                $("#transactionBody").html(html);
                //计算总页数
                var totalPages = data.total%pageSize == 0 ? data.total/pageSize : parseInt(data.total/pageSize) + 1;
                //	结合分页插件

                $("#tranPage").bs_pagination({
                    currentPage : pageNo,//页码
                    rowsPerPage : pageSize,//每一显示的记录条数
                    maxRowsPerPage : 20,//每一页最多显示的记录条数
                    totalPages : totalPages,//总页数
                    totalRows : data.total,//总记录数

                    visiblePageLinks : 3,//显示几个卡片

                    showGoToPage : true,
                    showRowsPerPage : true,
                    showRowsInfo : true,
                    showRowsDefaultInfo : true,
                    onChangePage : function (event, data) {
                        pageList(data.currentPage,data.rowsPerPage);
                    }
                })
            }
        })
    }
	
</script>
</head>
<body>

	<input type="hidden" id="hidden-id"/>
	<input type="hidden" id="hidden-owner"/>
	<input type="hidden" id="hidden-name"/>
	<input type="hidden" id="hidden-customerName"/>
	<input type="hidden" id="hidden-stage"/>
	<input type="hidden" id="hidden-type"/>
	<input type="hidden" id="hidden-source"/>
	<input type="hidden" id="hidden-contractName"/>

	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>交易列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">客户名称</div>
				      <input class="form-control" type="text">
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">阶段</div>
					  <select class="form-control">
					  	<option></option>
						  <c:forEach items="${stageList}" var="s">
							  <option value="${s.value}">${s.text}</option>
						  </c:forEach>

					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">类型</div>
					  <select class="form-control">
					  	<option></option>
						  <c:forEach items="${transactionTypeList}" var="t">
							  <option value="${t.value}">${t.text}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">来源</div>
				      <select class="form-control" id="create-clueSource">
						  <option></option>
						  <c:forEach items="${sourceList}" var="s">
							  <option value="${s.value}">${s.text}</option>
						  </c:forEach>
						</select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">联系人名称</div>
				      <input class="form-control" type="text">
				    </div>
				  </div>
				  
				  <button type="submit" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" onclick="window.location.href='workbench/transaction/add.do';"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" onclick="window.location.href='edit.html';"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="qx"/></td>
							<td>名称</td>
							<td>客户名称</td>
							<td>阶段</td>
							<td>类型</td>
							<td>所有者</td>
							<td>来源</td>
							<td>联系人名称</td>
						</tr>
					</thead>
					<tbody id="transactionBody">
<%--						<tr>
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/transaction/detail.do?id=b6827dc7e0ef48d3a0963a52d8d34434';">交易123</a></td>
							<td>阿里巴巴</td>
							<td>谈判/复审</td>
							<td>新业务</td>
							<td>zhangsan</td>
							<td>广告</td>
							<td>李四</td>
						</tr>
                        <tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">交易01</a></td>
                            <td>阿里巴巴</td>
                            <td>谈判/复审</td>
                            <td>新业务</td>
                            <td>zhangsan</td>
                            <td>广告</td>
                            <td>李四</td>
                        </tr>--%>
					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 20px;">
				<div id="tranPage">
					<%--<button type="button" class="btn btn-default" style="cursor: default;">共<b>50</b>条记录</button>--%>
				</div>
<%--				<div class="btn-group" style="position: relative;top: -34px; left: 110px;">
					<button type="button" class="btn btn-default" style="cursor: default;">显示</button>
					<div class="btn-group">
						<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
							10
							<span class="caret"></span>
						</button>
						<ul class="dropdown-menu" role="menu">
							<li><a href="#">20</a></li>
							<li><a href="#">30</a></li>
						</ul>
					</div>
					<button type="button" class="btn btn-default" style="cursor: default;">条/页</button>
				</div>
				<div style="position: relative;top: -88px; left: 285px;">
					<nav>
						<ul class="pagination">
							<li class="disabled"><a href="#">首页</a></li>
							<li class="disabled"><a href="#">上一页</a></li>
							<li class="active"><a href="#">1</a></li>
							<li><a href="#">2</a></li>
							<li><a href="#">3</a></li>
							<li><a href="#">4</a></li>
							<li><a href="#">5</a></li>
							<li><a href="#">下一页</a></li>
							<li class="disabled"><a href="#">末页</a></li>
						</ul>
					</nav>
				</div>--%>
			</div>
			
		</div>
		
	</div>
</body>
</html>