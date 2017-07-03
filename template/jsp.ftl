<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<c:set var="ctx" value="{pageContext.request.contextPath}"/>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"></meta>
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0"> 
    <title></title>
    <link href="${ctx}/js/easyui/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="${ctx}/js/easyui/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="${ctx}/js/easyui/jquery-1.4.2.min.js" type="text/javascript"></script>
    <script src="${ctx}/js/easyui/jquery.easyui.min.js" type="text/javascript"></script>
    <script type="text/javascript">

    $(function () {

        grid = $('#grid').datagrid({
            title: '${inject}',
            iconCls: 'icon-save',
            methord: 'get',
            url: '${ctx}/${inject}DimisionGrid.do',
            sortName: 'id',
            sortOrder: 'desc',
            idField: 'id',
            pageSize: 30,
            columns: [[
            			<#list properties as prop>
					   	{ field: '${prop.fieldName}', title: '${prop.fieldName}', width: 50 ,sortable: true ,editor:'text'},
					    </#list>
    					{field:'action',title:'操作',width:70,align:'center',
    						formatter:function(value,row,index){
	    						if (row.editing){
		    						var s = '<a href="#" onclick="saverow('+index+')">保存</a> ';
		    						var c = '<a href="#" onclick="cancelrow('+index+')">取消</a>';
		    						return s+c;
	    						} else {
		    						var e = '<a href="#" onclick="editrow('+index+')">编辑</a> ';
		    						var d = '<a href="#" onclick="deleterow('+index+')">删除</a>';
		    						return e+d;
	    						}
    						}
    					} 
    				]],
    		 toolbar: [ {
             text: '新增',
             iconCls: 'icon-add',
             handler: add
	         }, '-', {
	             text: '批量删除',
	             iconCls: 'icon-remove',
	             handler: del
	         }, '-', {
	             text: '同步保存',
	             iconCls: 'icon-save',
	             handler: saveData
	         }
    	                
    	     ],
    		onBeforeEdit:function(index,row){ 
    				row.editing = true; 
    				$('#grid').datagrid('refreshRow', index); 
    				editcount++; 
    		}, 
    		onAfterEdit:function(index,row){ 
    				row.editing = false; 
    				$('#grid').datagrid('refreshRow', index); 
    				editcount--; 
    		}, 
    		onCancelEdit:function(index,row){ 
    			row.editing = false; 
    			$('#grid').datagrid('refreshRow', index); 
    			editcount--; 
    		}, 
            fit:true,
            pagination: true,
            rownumbers: true,
            fitColumns: true,
            singleSelect: false,
            onHeaderContextMenu: function (e, field) {
                e.preventDefault();
                if (!$('#tmenu').length) {
                    createColumnMenu();
                }
                $('#tmenu').menu('show', {
                    left: e.pageX,
                    top: e.pageY
                });
            }
        }).datagrid('acceptChanges'); 
        $('body').layout();
    });

    function createColumnMenu() {
        var tmenu = $('<div id="tmenu" style="width:100px;"></div>').appendTo('body');
        var fields = grid.datagrid('getColumnFields');
        for (var i = 0; i < fields.length; i++) {
            $('<div iconCls="icon-ok"/>').html(fields[i]).appendTo(tmenu);
        }
        tmenu.menu({
            onClick: function (item) {
                if (item.iconCls == 'icon-ok') {
                    grid.datagrid('hideColumn', item.text);
                    tmenu.menu('setIcon', {
                        target: item.target,
                        iconCls: 'icon-empty'
                    });
                } else {
                    grid.datagrid('showColumn', item.text);
                    tmenu.menu('setIcon', {
                        target: item.target,
                        iconCls: 'icon-ok'
                    });
                }
            }
        });
    }


    var grid;
    function Msgshow(msg) {
        $.messager.show({
            title: '提示',
            msg: msg,
            showType: 'show'
        });
    }
    function Msgslide(msg) {
        $.messager.show({
            title: '提示',
            msg: msg,
            timeout: 3000,
            showType: 'slide'
        });
    }
    function Msgfade(msg) {
        $.messager.show({
            title: '提示',
            msg: msg,
            timeout: 3000,
            showType: 'fade'
        });
    }

    var editcount = 0; 
	var lastIndex;
	
	function editrow(index){
		var node = $('#tree').tree('getSelected');
		if(node!=null){
		}
		$('#grid').datagrid('beginEdit', index);
	}
		
	function deleterow(index){
	
		$.messager.confirm('确认','是否真的删除?',function(r){
		if (r){
			$('#grid').datagrid('deleteRow', index);
		}
		});
	}
	function saverow(index){
		$('#grid').datagrid('endEdit', index);
	}
	function cancelrow(index){
		$('#grid').datagrid('cancelEdit', index);
	}
    
    function add(){
		$('#grid').datagrid('appendRow',{ 
			        product:'',
			        productParent:'',	
			        description:'',
					isLeaf:'',
					isValid:''
		}); 
		var lastIndex = $('#grid').datagrid('getRows').length-1;
		$('#grid').datagrid('beginEdit', lastIndex);
	}
    
    
    //同步数据库保存操作
    function saveData() {
    	
    	   endEdit();
           if ($('#grid').datagrid('getChanges').length) {
               var inserted = $('#grid').datagrid('getChanges', "inserted");
               var deleted =  $('#grid').datagrid('getChanges', "deleted");
               var updated =  $('#grid').datagrid('getChanges', "updated");
               
               var effectRow = new Object();
               if (inserted.length) {
                   effectRow["inserted"] = JSON.stringify(inserted);
               }
               if (deleted.length) {
                   effectRow["deleted"] = JSON.stringify(deleted);
               }
               if (updated.length) {
                   effectRow["updated"] = JSON.stringify(updated);
               }

            
               $.ajax({
            	     type: 'POST',
            	     url: '${ctx}/${inject}Batch.do',
            	     data: effectRow,
            	     asyn: false,
            	     success: function(rsp)
            	     {
	            	    	 eval('rsp=' + rsp);
	                         if(rsp.status){
	                             $.messager.alert("提示", "提交成功！");
	                         
	                             $('#grid').datagrid('acceptChanges');
		                         $('#grid').datagrid('reload');
	                         }else{
	                        	  $.messager.alert("提示", "提交错误了！"+rsp.message);
		                         $('#grid').datagrid('acceptChanges');
		                         $('#grid').datagrid('reload');
	                         }
            	     },
            	     error: function (response) {
            	         var r = jQuery.parseJSON(response.responseText);
            	         $.messager.alert("提示", "操作失败！ " );
            	    }

            	 });
               
           }

    }
    function endEdit(){
        var rows = $('#grid').datagrid('getRows');
        for ( var i = 0; i < rows.length; i++) {
        	$('#grid').datagrid('endEdit', i);
        }
    }
    
	//批量删除
	function del() {
		var rows = $('#grid').datagrid('getSelections');
	    if (rows.length > 0) {
	        $.messager.confirm('提示信息', '您确认要删除吗?', function (data) {
	            if (data) {
	            	for (var i = 0; i < rows.length; i++) {  
                        var rowIndex = $('#grid').datagrid('getRowIndex', rows[i]); 
                        $('#grid').datagrid('deleteRow', rowIndex);  
                    }  
	            }
	        });
	    } else {
	        Msgshow('请先选择要删除的记录。');
	    }
	}
    </script>
</head>
<body class="easyui-layout" style="overflow-y: hidden" scroll="no">
    
    <div region="center" style="width: 500px; height: 300px; padding: 1px;overflow-y: hidden">
        <table id="grid"></table> 
 
    </div>
  
</body>
</html>
