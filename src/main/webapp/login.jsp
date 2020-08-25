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
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script>
		$(function () {
		    if (window.top != window){
		        window.top.location = window.location;
			}
		    //页面加载完毕后清空用户名文本框
			$("#loginAct").val("");

			//用户文本框自动获取焦点
			$("#loginAct").focus();
			
			//为登录按钮绑定事件
			$("#submitBtn").click(function () {
				login()
            })

			//为当前页面绑定敲键盘事件
			//event这个可以取得我们敲的那个建
			$(window).keydown(function (event) {
			    //回车键码值为13
				if (event.keyCode == 13){
					login()
				}
            })
        })
		
		function login() {
			// 账号密码不能为空
			//将文本中左右空格去掉$.trim()
			var loginAct = $.trim($("#loginAct").val());
			var loginPwd = $.trim($("#loginPwd").val());

			if (loginAct == "" || loginPwd == ""){
			    $("#msg").html("账号密码不能为空");

			//    若账号密码为空，则强制终止
				return false;
			}

			//	去后台验证
			$.ajax({

				url : "settings/user/login.do",
				data : {
					"loginAct" : loginAct,
					"loginPwd" : loginPwd
				},
				type : "post",
				dataType : "json",
				success : function (data) {
					/*
						data
					*/
					if (data.success) {
					    window.location.href = "workbench/index.jsp";
					}else {
					    $("#msg").html(data.msg);
					}
                }
            })

        }
	</script>
</head>
<body>
	<div style="position: absolute; top: 0px; left: 0px; width: 60%;">
		<img src="image/IMG_7114.JPG" style="width: 100%; height: 90%; position: relative; top: 50px;">
	</div>
	<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
		<div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">CRM &nbsp;<span style="font-size: 12px;">&copy;2020&nbsp;玉帝</span></div>
	</div>
	
	<div style="position: absolute; top: 120px; right: 100px;width:450px;height:400px;border:1px solid #D5D5D5">
		<div style="position: absolute; top: 0px; right: 60px;">
			<div class="page-header">
				<h1>登录</h1>
			</div>
			<form action="workbench/index.jsp" class="form-horizontal" role="form">
				<div class="form-group form-group-lg">
					<div style="width: 350px;">
						<input class="form-control" type="text" placeholder="用户名" id="loginAct">
					</div>
					<div style="width: 350px; position: relative;top: 20px;">
						<input class="form-control" type="password" placeholder="密码" id="loginPwd">
					</div>
					<div class="checkbox"  style="position: relative;top: 30px; left: 10px;">
						
							<span id="msg" style="color: #b92c28"></span>
						
					</div>
					<%--按钮在表单中默认为submit，所以按钮一定要设置为button--%>
					<button type="button" id="submitBtn" class="btn btn-primary btn-lg btn-block"  style="width: 350px; position: relative;top: 45px;">登录</button>
				</div>
			</form>
		</div>
	</div>
</body>
</html>