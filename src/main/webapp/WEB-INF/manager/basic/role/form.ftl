<@ms.html5>
	<@ms.nav title="角色设置" back=true>
		<@ms.saveButton id="save"/>
	</@ms.nav>
	<@ms.panel>
		<@ms.form name="columnForm" isvalidation=true  action="" method="post" >
			<@ms.text name="roleName" label="角色名称:" title="角色名称" value="${roleEntity.roleName?default('')}" width="300"  maxlength="30"  validation={"required":"true", "data-bv-notempty-message":"请填写标题"}/>
			<@ms.formRow label="权限管理:">
				<div>
					<table id="modelList" 
						data-show-export="true"
						data-method="post" 
						data-side-pagination="server">
					</table>
				</div>
			</@ms.formRow>
		</@ms.form>
	</@ms.panel>
</@ms.html5>
<script>
	$(function(){
		//数据初始化
		$("#modelList").bootstrapTable({
			url:"${managerPath}/model/list.do?roleId=${roleEntity.roleId?default('')}",
			contentType : "application/x-www-form-urlencoded",
			queryParamsType : "undefined",
			idField: 'modelId',
            treeShowField: 'modelTitle',
            parentIdField: 'modelModelId',
	    	columns: [
				    	{
				        	field: 'modelTitle',
				        	title: '模块标题',
				        	width: '200'
				    	},{
				        	field: 'attribute',
				        	title: '功能权限',
				        	formatter:function(value,row,index) {
				        		var attribute = "";
				        		for(var i=0;i<row.modelChildList.length;i++){
				        			var modelId = row.modelChildList[i].modelId;
				        			var str = "<input name='attribute' type='checkbox' value='"+modelId+"' data-id='"+row.modelId+"'/>"+row.modelChildList[i].modelTitle;
				        			if(row.modelChildList[i].chick == 1){
				        				str = "<input name='attribute' type='checkbox' checked='checked' value='"+modelId+"' data-id='"+row.modelId+"'/>"+row.modelChildList[i].modelTitle;
				        			}
				        			if(attribute == ""){
				        				attribute = str;
				        			}else{
				        				attribute = attribute+str;
				        			}
				        		}
				        		return attribute;
				        	}
				    	}]
	    })
	})
	//保存操作
	$("#save").click(function(){
		var roleName = $("input[name=roleName]").val();
		var roleId = "${roleEntity.roleId?default('')}";
		var oldRoleName = "${roleEntity.roleName?default('')}";
		var ids=[];
		$("input[name=attribute]").each(function () {
			if($(this).is(':checked')){
				var modelId = $(this).val();
			    var modelModelId = $(this).attr("data-id");
			    ids.push(modelId);
			    if($.inArray(modelModelId, ids) == -1){
			    	ids.push(modelModelId);
			    }
			}
		});
		if(ids.length == 0){
			<@ms.notify msg= '最少选择一个栏目权限' type= "fail" />
			return;
		}
		$.ajax({
		 	type:"post",
		 	url:"${managerPath}/basic/role/saveOrUpdateRole.do",
		 	dataType: "json",
		 	data:{ids:ids,roleName:roleName,roleId:roleId,oldRoleName:oldRoleName},
		 	success:function(data){
		 		if(data.result == false) {
					<@ms.notify msg= '角色名已存在' type= "fail" />
				}else {
					<@ms.notify msg= "操作成功" type= "success" />
					location.href= "${managerPath}/basic/role/index.do";
				}
		 	}
		});
	})
</script>