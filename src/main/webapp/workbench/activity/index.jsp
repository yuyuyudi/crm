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

        $(".time").datetimepicker({
            minView: "month",
            language:  'zh-CN',
            format: 'yyyy-mm-dd',
            autoclose: true,
            todayBtn: true,
            pickerPosition: "bottom-left"
        });

	//	为创建按钮绑定事件
		$("#addBtn").click(function () {
		/*
		* 操作模态窗口：
		* 调用modal方法，为该方法传递参数，show：打开模态窗口，hide：关闭模态窗口*/
		//走后台，取用户数据
            $.ajax({

                url : "workbench/activity/getUserList.do",
                type : "get",
                dataType : "json",
                success : function (data) {
                    /*
                        data
                    */
                    var html = "<option></option>";

                    $.each(data,function (i,n) {
						html += "<option value='" + n.id + "'>" + n.name + "</option>"
                    })

					$("#create-owner").html(html);

                //    将当前用户设为下拉框的默认选项
					var id = "${user.id}";
                    $("#create-owner").val(id);
                //    展现模态窗口
                    $("#createActivityModal").modal("show");
                }
            })

        })


	//	为保存按钮绑定事件
		$("#saveBtn").click(function () {

			$.ajax({
				url : "workbench/activity/save.do",
				data : {

                    "owner":$.trim($("#create-owner").val()),
                    "name":$.trim($("#create-name").val()),
                    "startDate":$.trim($("#create-startDate").val()),
                    "endDate":$.trim($("#create-endDate").val()),
                    "cost":$.trim($("#create-cost").val()),
                    "description":$.trim($("#create-description").val())

                },
				type : "post",
				dataType : "json",
				success:function (data) {
					if (data.success){
                        //添加成功后刷新市场活动列表
						/*
						* currentPage:操作后停留在当前页
						* rowsPerPage：操作后维持在以及和设置好的每页展示记录数
						* */
                        /*
                        pageList($("#activityPage").bs_pagination('getOption','currentPage')
								,$("#activityPage").bs_pagination('getOption','rowsPerPage'));
						*/
                        pageList(1
                            ,$("#activityPage").bs_pagination('getOption','rowsPerPage'));

					//    清空模态窗口文本
					// 	  $("#activityAddForm").reset();此方法不存在是一个坑，jQuery没有该方法，但是原生js对象有，所以我们需要转换对象
					//    jQuery转换为dom对象:jquery对象[下标]
					//	  dom对象转换为jQuery对象：$(dom)
                        $("#activityAddForm")[0].reset();
					//    关闭模态窗口
						$("#createActivityModal").modal("hide");
					} else {
					    alert("添加失败")
					}
                }

			})
        })

		pageList(1,2);

		$("#saveBtn").click(function () {
			pageList(1,2)
        })

        //	为查询按钮绑定事件
		$("#searchBtn").click(function () {
		    //点击搜索框时把文本保存下来
			$("#hidden-name").val($.trim($("#search-name").val()));
            $("#hidden-owner").val($.trim($("#search-owner").val()));
            $("#hidden-startDate").val($.trim($("#search-startDate").val()));
            $("#hidden-endDate").val($.trim($("#search-endDate").val()));
			pageList(1,2)
        })

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
		$("#activityBody").on("click",$("input[name=xz]"),function () {
            $("#qx").prop("checked",$("input[name=xz]").length == $("input[name=xz]:checked").length);
        })

	//	为删除按钮绑定事件
		$("#deleteBtn").click(function () {

		//	找到所有勾了的复选框
			var $xz = $("input[name=xz]:checked");
			if ($xz.length == 0){
			    alert("请选择要删除的记录")
			}else {
                if (confirm("确定删除所选中的记录吗？")){
                    // url:"workbench/activity/delete.do?id=xxx&id=xxx"
                    //	拼接参数
                    var param = "";

                    for (var i = 0; i < $xz.length; i++){
                        param += "id=" + $.trim($($xz[i]).val());
                        //    如果不是最后一个元素，需要追加一个&
                        if (i < $xz.length - 1){
                            param += "&";
                        }
                    }
                    $.ajax({
                        url : "workbench/activity/delete.do",
                        data : param,
                        type : "post",
                        dataType : "json",
                        success:function (data) {
                            /*
                            * data
                            * {"success":true/false}
                            * */
                            if (data.success){
                                //    删除成功后
                                pageList(1,$("#activityPage").bs_pagination('getOption','rowsPerPage'));
                            }else {
                                alert("删除失败")
                            }

                        }
                    })
				}


			}
        })

	//	为修改按钮绑定事件
		$("#editBtn").click(function () {
			var $xz = $("input[name=xz]:checked");
			if ($xz.length == 0){
			    alert("请选择需要修改的记录");
			} else if ($xz.length > 1){
			    alert("只能选择一条记录进行修改");
			} else {
			    var id = $xz.val();
                $.ajax({
                    url : "workbench/activity/getUserListAndActivity.do",
                    data : {
						"id" : id
                    },
                    type : "get",
                    dataType : "json",
                    success:function (data) {
						/*
						* data
						* 	用户列表，市场活动单条记录
						* {"uList":[{用户},{}],"a":{市场活动}}
						* */
						//处理所有者的下拉框
						var html = "<option></option>";

						$.each(data.uList,function (i,n) {
							html += "<option value='"+ n.id +"'>"+ n.name +"</option>"
                        })

						$("#edit-owner").html(html);

					//	处理单条activity
					//	id在隐藏域
                        $("#edit-id").val(data.a.id);
						$("#edit-name").val(data.a.name);
                        $("#edit-owner").val(data.a.owner);
                        $("#edit-startDate").val(data.a.startDate);
                        $("#edit-endDate").val(data.a.endDate);
                        $("#edit-cost").val(data.a.cost);
                        $("#edit-description").val(data.a.description);

					//	打开模态窗口
						$("#editActivityModal").modal("show");

                    }
                })
			}
        })
	//	为更新按钮绑定事件
		$("#updateBtn").click(function () {
            $.ajax({
                url : "workbench/activity/update.do",
                data : {

                    "id":$.trim($("#edit-id").val()),
                    "owner":$.trim($("#edit-owner").val()),
                    "name":$.trim($("#edit-name").val()),
                    "startDate":$.trim($("#edit-startDate").val()),
                    "endDate":$.trim($("#edit-endDate").val()),
                    "cost":$.trim($("#edit-cost").val()),
                    "description":$.trim($("#edit-description").val())

                },
                type : "post",
                dataType : "json",
                success:function (data) {
                    if (data.success){
                        pageList($("#activityPage").bs_pagination('getOption','currentPage')
                                ,$("#activityPage").bs_pagination('getOption','rowsPerPage'));
                        //    关闭模态窗口
                        $("#editActivityModal").modal("hide");
                    } else {
                        alert("更新失败");
                    }
                }

            })
        })

	});
	/*发出ajax请求，从后台获取最新的市场活动，展示到列表中
	* 1.点击左侧菜单栏
	* 2.添加修改删除
	* 3.查询
	* 4.分页组件
	* 以上制定了六个pageList的入口*/
	function pageList(pageNo,pageSize) {

	    //将全选的复选框取消
		$("#qz").prop("checked",false);
	    //查询前将隐藏域中的信息取出来，保存在搜索框中
        $("#search-name").val($.trim($("#hidden-name").val()));
        $("#search-owner").val($.trim($("#hidden-owner").val()));
        $("#search-startDate").val($.trim($("#hidden-startDate").val()));
        $("#search-endDate").val($.trim($("#hidden-endDate").val()));

        $.ajax({
            url : "workbench/activity/pageList.do",
            data : {
				"pageNo" : pageNo,
				"pageSize" : pageSize,
				"name" : $.trim($("#search-name").val()),
				"owner" : $.trim($("#search-owner").val()),
                "startDate" : $.trim($("#search-startDate").val()),
                "endDate" : $.trim($("#search-endDate").val())

            },
            type : "get",
            dataType : "json",
            success:function (data) {
				/*
				* data
				* 	[{市场活动1}，{2}，{3}]
				* 	分页插件需要的，查询出来的总记录数
				* 	{"total":100}
				* 	{"total":100,"dataList":[{市场活动1}，{2}，{3}]}*/
				var html = "";
				$.each(data.dataList,function (i,n) {
                	html += '<tr class="active">';
                    html += '<td><input type="checkbox" name="xz" value="'+ n.id + '"/></td>';
                    html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/activity/detail.do?id='+ n.id +'\';">' + n.name + '</a></td>';
                    html += '<td>' + n.owner + '</td>';
                    html += '<td>' + n.startDate + '</td>';
                    html += '<td>' + n.endDate + '</td>';
                    html += '</tr>';
                })

				$("#activityBody").html(html);
			//计算总页数
				var totalPages = data.total%pageSize == 0 ? data.total/pageSize : parseInt(data.total/pageSize) + 1;
			//	结合分页插件

				$("#activityPage").bs_pagination({
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

	<input type="hidden" id="hidden-name"/>
	<input type="hidden" id="hidden-owner"/>
	<input type="hidden" id="hidden-startDate"/>
	<input type="hidden" id="hidden-endDate"/>

	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form id="activityAddForm" class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-Owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner">

								</select>
							</div>
                            <label for="create-Name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-name">
                            </div>
						</div>
						
						<div class="form-group">
							<label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-startDate" readonly>
							</div>
							<label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-endDate" readonly>
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<%--
						data-dismiss="modal"表示关闭模态窗口
					--%>
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改市场活动的模态窗口 -->
	<div class="modal fade" id="editActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form">

						<input type="hidden" id="edit-id"/>
					
						<div class="form-group">
							<label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-owner">

								</select>
							</div>
                            <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-name">
                            </div>
						</div>

						<div class="form-group">
							<label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-startDate">
							</div>
							<label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-endDate">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<%--关于文本域：
									1.标签对形式呈现，正常情况下，标签对要紧紧的挨着
									2.textarea虽然是标签对呈现，但是也属于表单元素范畴
										所有对文本域的取值和赋值要使用val()方法
								--%>
								<textarea class="form-control" rows="3" id="edit-description"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="updateBtn">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>市场活动列表</h3>
			</div>
		</div>
	</div>
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="search-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="search-owner">
				    </div>
				  </div>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">开始日期</div>
					  <input class="form-control" type="text" id="search-startDate" />
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
					  <input class="form-control" type="text" id="search-endDate">
				    </div>
				  </div>
				  
				  <button type="button" id="searchBtn" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="addBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="qx" /></td>
							<td>名称</td>
                            <td>所有者</td>
							<td>开始日期</td>
							<td>结束日期</td>
						</tr>
					</thead>
					<tbody id="activityBody">
<%--						<tr class="active">
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/activity/detail.jsp';">发传单</a></td>
                            <td>zhangsan</td>
							<td>2020-10-10</td>
							<td>2020-10-20</td>
						</tr>
                        <tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/activity/detail.jsp';">发传单</a></td>
                            <td>zhangsan</td>
                            <td>2020-10-10</td>
                            <td>2020-10-20</td>
                        </tr>--%>
					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 30px;">
				<div id="activityPage"></div>
			</div>
			
		</div>
		
	</div>
</body>
</html>