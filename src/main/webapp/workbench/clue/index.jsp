<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
            pickerPosition: "top-left"
        });
	//	打开添加操作的模态窗口
		$("#addBtn").click(function () {
            $.ajax({
                url : "workbench/clue/getUserList.do",
                type : "get",
                dataType : "json",
                success:function (data) {
					/*
					* data
					* [{用户1},{2},{3}]*/
					var html="";

					$.each(data,function (i,n) {
						html += "<option value='"+ n.id +"'>"+ n.name +"</option>"
                    })

					$("#create-owner").html(html);

                    var id = "${user.id}";
					$("#create-owner").val(id);

				//	处理完下拉框的数据，打开模态窗口
					$("#createClueModal").modal("show");
                }
            })
        })

	//	为保存按钮绑定事件，执行线索的添加事件
		$("#saveBtn").click(function () {
            $.ajax({
                url : "workbench/clue/save.do",
                data : {
                    "fullname" : $.trim($("#create-fullname").val()),
                    "appellation" : $.trim($("#create-appellation").val()),
                    "owner" : $.trim($("#create-owner").val()),
                    "company" : $.trim($("#create-company").val()),
                    "job" : $.trim($("#create-job").val()),
                    "email" : $.trim($("#create-email").val()),
                    "phone" : $.trim($("#create-phone").val()),
                    "website" : $.trim($("#create-website").val()),
                    "mphone" : $.trim($("#create-mphone").val()),
                    "state" : $.trim($("#create-state").val()),
                    "source" : $.trim($("#create-source").val()),
                    "description" : $.trim($("#create-description").val()),
                    "contactSummary" : $.trim($("#create-contactSummary").val()),
                    "nextContactTime" : $.trim($("#create-nextContactTime").val()),
                    "address" : $.trim($("#create-address").val())
                },
                type : "post",
                dataType : "json",
                success:function (data) {
					if (data.success){
					//    刷新列表
                        pageList(1
                            ,$("#cluePage").bs_pagination('getOption','rowsPerPage'));
					//	关闭模态窗口
                        $("#addClueForm")[0].reset();
						$("#createClueModal").modal("hide");
					} else {
					    alert("添加线索失败")
					}
                }
            })

        })

        pageList(1,2);

        $("#saveBtn").click(function () {

            pageList(1,2);
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
                    url : "workbench/clue/getClueAndUserList.do",
                    data : {
                        "id" : id
                    },
                    type : "post",
                    dataType : "json",
                    success:function (data) {

                        //处理所有者的下拉框
                        var html = "<option></option>";

                        $.each(data.uList,function (i,n) {
                            html += "<option value='"+ n.id +"'>"+ n.name +"</option>"
                        })

                        $("#edit-owner").html(html);
                        //	id在隐藏域
                        $("#edit-id").val(data.c.id);
                        $("#edit-fullname").val(data.c.fullname);
                        $("#edit-appellation").val(data.c.appellation);
                        $("#edit-owner").val(data.c.owner);
                        $("#edit-company").val(data.c.company);
                        $("#edit-job").val(data.c.job);
                        $("#edit-email").val(data.c.email);
                        $("#edit-phone").val(data.c.phone);
                        $("#edit-website").val(data.c.website);
                        $("#edit-mphone").val(data.c.mphone);
                        $("#edit-state").val(data.c.state);
                        $("#edit-source").val(data.c.source);
                        $("#edit-description").val(data.c.description);
                        $("#edit-contactSummary").val(data.c.contactSummary);
                        $("#edit-nextContactTime").val(data.c.nextContactTime);
                        $("#edit-address").val(data.c.address);
                        $("#editClueModal").modal("show");
                    }
                })

			}
        })
	//	未修改页面的更新按钮绑定事件
		$("#updateBtn").click(function () {
            $.ajax({
                url : "workbench/clue/update.do",
                data : {
                    "id" : $.trim($("#edit-id").val()),
                    "fullname" : $.trim($("#edit-fullname").val()),
                    "appellation" : $.trim($("#edit-appellation").val()),
                    "owner" : $.trim($("#edit-owner").val()),
                    "company" : $.trim($("#edit-company").val()),
                    "job" : $.trim($("#edit-job").val()),
                    "email" : $.trim($("#edit-email").val()),
                    "phone" : $.trim($("#edit-phone").val()),
                    "website" : $.trim($("#edit-website").val()),
                    "mphone" : $.trim($("#edit-mphone").val()),
                    "state" : $.trim($("#edit-state").val()),
                    "source" : $.trim($("#edit-source").val()),
                    "description" : $.trim($("#edit-description").val()),
                    "contactSummary" : $.trim($("#edit-contactSummary").val()),
                    "nextContactTime" : $.trim($("#edit-nextContactTime").val()),
                    "address" : $.trim($("#edit-address").val())
                },
                type : "post",
                dataType : "json",
                success:function (data) {
                    if (data.success){

                        pageList($("#cluePage").bs_pagination('getOption','currentPage')
                            ,$("#cluePage").bs_pagination('getOption','rowsPerPage'));
                        //    关闭模态窗口
                        $("#editClueModal").modal("hide");
                    } else {
                        alert("更新失败");
                    }
                }
            })
        })
	//为查询按钮绑定事件
		$("#searchBtn").click(function () {
		//	将值赋值给隐藏文本域
			$("#hidden-fullname").val($.trim($("#search-fullname").val()));
            $("#hidden-company").val($.trim($("#search-company").val()));
            $("#hidden-mphone").val($.trim($("#search-mphone").val()));
            $("#hidden-source").val($.trim($("#search-source").val()));
            $("#hidden-owner").val($.trim($("#search-owner").val()));
            $("#hidden-phone").val($.trim($("#search-phone").val()));
            $("#hidden-state").val($.trim($("#search-state").val()));


            pageList(1,2);

        })

        //	为全选的复选框绑定事件，触发全选操作
        $("#qx").click(function () {
            $("input[name=xz]").prop("checked",this.checked)
        })
		//点击别的地方时取消全选
        $("#clueBody").on("click",$("input[name=xz]"),function () {
            $("#qx").prop("checked",$("input[name=xz]").length == $("input[name=xz]:checked").length);
        })
	//	为删除按钮绑定事件
		$("#deleteBtn").click(function () {
		//	找到所有被勾选的复选框
			var $xz = $("input[name=xz]:checked");
			if ($xz.length == 0){
			    alert("请选择要删除的对象");
			} else {
			    if (confirm("确定要删除所选记录吗")) {
                    // url:"workbench/clue/delete.do?id=xxx&id=xxx"
                    //	拼接参数
					var param = "";
					for (var i = 0; i < $xz.length; i++){
					    param += "id=" + $.trim($($xz[i]).val());
					    if (i < $xz.length - 1) {
					        param += "&";
						}
					}

				}
                $.ajax({
                    url : "workbench/clue/delete.do",
                    data : param,
                    type : "post",
                    dataType : "json",
                    success:function (data) {
						if (data.success){

                            pageList(1
                                ,$("#cluePage").bs_pagination('getOption','rowsPerPage'));
						} else {
						    alert("删除失败");
						}
                    }
                })
			}
        })

	});

	function pageList(pageNo,pageSize) {
	//	将全选的复选框取消
		$("#qx").prop("checked",false);
		//查询前将隐藏域中的信息取出来，保存在搜索框中
        $("#search-fullname").val($.trim($("#hidden-fullname").val()));
        $("#search-company").val($.trim($("#hidden-company").val()));
        $("#search-mphone").val($.trim($("#hidden-mphone").val()));
        $("#search-source").val($.trim($("#hidden-source").val()));
        $("#search-owner").val($.trim($("#hidden-owner").val()));
        $("#search-phone").val($.trim($("#hidden-phone").val()));
        $("#search-state").val($.trim($("#hidden-state").val()));

        $.ajax({
            url : "workbench/clue/pageList.do",
            data : {
                "pageNo" : pageNo,
                "pageSize" : pageSize,
                "fullname" : $.trim($("#search-fullname").val()),
                "company" : $.trim($("#search-company").val()),
                "mphone" : $.trim($("#search-mphone").val()),
                "source" : $.trim($("#search-source").val()),
                "owner" : $.trim($("#search-owner").val()),
                "phone" : $.trim($("#search-phone").val()),
                "state" : $.trim($("#search-state").val())
            },
            type : "get",
            dataType : "json",
            success:function (data) {
                /*
                * data
                * 	[{clue1}，{2}，{3}]
                * 	分页插件需要的，查询出来的总记录数
                * 	{"total":100}
                * 	{"total":100,"dataList":[{市场活动1}，{2}，{3}]}*/
                var html = "";
                $.each(data.dataList,function (i,n) {
                	html += '<tr class="active">';
                    html += '<td><input type="checkbox" name="xz" value="'+ n.id +'"/></td>';
                    html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/clue/detail.do?id='+ n.id +'\';">'+ n.fullname +'</a></td>';
                    html += '<td>'+ n.company +'</td>';
                    html += '<td>'+ n.mphone +'</td>';
                    html += '<td>'+ n.phone +'</td>';
                    html += '<td>'+ n.source +'</td>';
                    html += '<td>'+ n.owner +'</td>';
                    html += '<td>'+ n.state +'</td>';
                    html += '</tr>';
                })
				$("#clueBody").html(html);
            //    计算总页数
                var totalPages = data.total%pageSize == 0 ? data.total/pageSize : parseInt(data.total/pageSize) + 1;
            //    结合分页插件
                $("#cluePage").bs_pagination({
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
	<input type="hidden" id="hidden-fullname"/>
	<input type="hidden" id="hidden-company"/>
	<input type="hidden" id="hidden-mphone"/>
	<input type="hidden" id="hidden-source"/>
	<input type="hidden" id="hidden-owner"/>
	<input type="hidden" id="hidden-phone"/>
	<input type="hidden" id="hidden-state"/>

	<!-- 创建线索的模态窗口 -->
	<div class="modal fade" id="createClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">创建线索</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form" id="addClueForm">
					
						<div class="form-group">
							<label for="create-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner">
								  <option>zhangsan</option>
								  <option>lisi</option>
								  <option>wangwu</option>
								</select>
							</div>
							<label for="create-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-company">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-appellation">
								  <option></option>
									<c:forEach items="${appellationList}" var="a">
										<option value="${a.value}">${a.text}</option>
									</c:forEach>
								</select>
							</div>
							<label for="create-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-fullname">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-job">
							</div>
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
							<label for="create-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-website">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-mphone">
							</div>
							<label for="create-status" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-state">
								  <option></option>
									<c:forEach items="${clueStateList}" var="c">
										<option value="${c.value}">${c.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-source">
								  <option></option>
									<c:forEach items="${sourceList}" var="s">
										<option value="${s.value}">${s.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						

						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">线索描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control time" id="create-nextContactTime">
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>
						
						<div style="position: relative;top: 20px;">
							<div class="form-group">
                                <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address"></textarea>
                                </div>
							</div>
						</div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改线索的模态窗口 -->
	<div class="modal fade" id="editClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">修改线索</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">

						<input type="hidden" id="edit-id"/>
					
						<div class="form-group">
							<label for="edit-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-owner">
								  <option>zhangsan</option>
								  <option>lisi</option>
								  <option>wangwu</option>
								</select>
							</div>
							<label for="edit-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-company" value="测试">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-appellation">
								  <option></option>
									<c:forEach items="${appellationList}" var="a">
										<option value="${a.value}">${a.text}</option>
									</c:forEach>
								</select>
							</div>
							<label for="edit-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-fullname" value="李四">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job" value="CTO">
							</div>
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email" value="lisi@xxx.com">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone" value="010-84846003">
							</div>
							<label for="edit-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-website" value="http://www.bjpowernode.com">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone" value="12345678901">
							</div>
							<label for="edit-status" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-state">
								  <option></option>
									<c:forEach items="${clueStateList}" var="c">
										<option value="${c.value}">${c.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-source">
								  <option></option>
									<c:forEach items="${sourceList}" var="s">
										<option value="${s.value}">${s.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description">这是一条线索的描述信息</textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="edit-contactSummary">这个线索即将被转换</textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control time" id="edit-nextContactTime" value="2017-05-01">
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address">北京大兴区大族企业湾</textarea>
                                </div>
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
				<h3>线索列表</h3>
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
				      <input class="form-control" type="text" id="search-fullname">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司</div>
				      <input class="form-control" type="text" id="search-company">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司座机</div>
				      <input class="form-control" type="text" id="search-mphone">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索来源</div>
					  <select class="form-control"  id="search-source">
					  	  <option></option>
						  <c:forEach items="${sourceList}" var="s">
							  <option value="${s.value}">${s.text}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="search-owner">
				    </div>
				  </div>
				  
				  
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">手机</div>
				      <input class="form-control" type="text" id="search-phone">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索状态</div>
					  <select class="form-control" id="search-state">
					  	<option></option>
						  <c:forEach items="${clueStateList}" var="c">
							  <option value="${c.value}">${c.text}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>

				  <button type="button" class="btn btn-default" id="searchBtn">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="addBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 50px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="qx"/></td>
							<td>名称</td>
							<td>公司</td>
							<td>公司座机</td>
							<td>手机</td>
							<td>线索来源</td>
							<td>所有者</td>
							<td>线索状态</td>
						</tr>
					</thead>
					<tbody id="clueBody">
	<%--					<tr>
							<td><input type="checkbox" name="xz" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/clue/detail.do?id=6e65a622c4894b79ab3d401e3e8c1c31';">马云先生</a></td>
							<td>动力节点</td>
							<td>010-84846003</td>
							<td>12345678901</td>
							<td>广告</td>
							<td>zhangsan</td>
							<td>已联系</td>
						</tr>
                        <tr class="active">
                            <td><input type="checkbox" name="xz"/></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">李四先生</a></td>
                            <td>动力节点</td>
                            <td>010-84846003</td>
                            <td>12345678901</td>
                            <td>广告</td>
                            <td>zhangsan</td>
                            <td>已联系</td>
                        </tr>--%>
					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 30px;">
				<div id="cluePage">

				</div>
			</div>
			
		</div>
		
	</div>
</body>
</html>