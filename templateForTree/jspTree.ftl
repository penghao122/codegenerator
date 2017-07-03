<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<c:set var="ctx" value="{pageContext.request.contextPath}"/>
<% 
	String path = request.getContextPath(); 
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/"; 
	request.setAttribute("basePath", basePath);
%>
<html>
<head>
<!-- jquery easyui tree http://www.jeasyui.com/documentation/tree.php -->
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"></meta>
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
    <link href="${ctx}/js/easyui/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="${ctx}/js/easyui/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="${ctx}/js/easyui/jquery-1.4.2.min.js" type="text/javascript"></script>
    <script src="${ctx}/js/easyui/jquery.easyui.min.js" type="text/javascript"></script>
    <script type="text/javascript">

    $.extend($.fn.datagrid.methods, {
    	addEditor : function(jq, param) {
    		if (param instanceof Array) {
    			$.each(param, function(index, item) {
    				var e = $(jq).datagrid('getColumnOption', item.field);
    				e.editor = item.editor;
    			});
    		} else {
    			var e = $(jq).datagrid('getColumnOption', param.field);
    			e.editor = param.editor;
    		}
    	},
    	removeEditor : function(jq, param) {
    		if (param instanceof Array) {
    			$.each(param, function(index, item) {
    				var e = $(jq).datagrid('getColumnOption', item);
    				e.editor = {};
    			});
    		} else {
    			var e = $(jq).datagrid('getColumnOption', param);
    			e.editor = {};
    		}
    	}
    });  
    
    $(function () {

   	    $('#btn-search,#btn-search-cancel').linkbutton();
   	    fileWin = $('#file-window').window({
   	        closed: true,
   	        modal: true
   	    });
   	    fielForm = fileWin.find('form');
    	    
		 $('#tree').tree({
             url:'${ctx}/${inject}DimisionTree.do',
             method:'get',
             checkbox:false,
             animate: true, 
             onClick:function(node){
            	
            	 query(node.id);
             },
             onBeforeExpand: function (node, param) {
            	 
                $('#tree').tree('options').url = "${ctx}/${inject}DimisionChildrenTree.do?parentId=" + node.id; 
             }
           });

        grid = $('#grid').datagrid({
            title: '${class}',
            iconCls: 'icon-save',
            method:'get',
            url: '${ctx}/${inject}DimisionGrid.do',
            sortName: 'id',
            sortOrder: 'desc',
            idField: 'id',
            pageSize: 30,
            columns: [[
            			<#list properties as prop>
					   	{ field: '${prop.fieldName}', title: '${prop.fieldName}', width: 50 ,sortable: true ,editor:'text'},
					    </#list>
    					{field:'action',title:'����',width:70,align:'center',
    						formatter:function(value,row,index){
	    						if (row.editing){
		    						var s = '<a href="#" onclick="saverow('+index+')">����</a> ';
		    						var c = '<a href="#" onclick="cancelrow('+index+')">ȡ��</a>';
		    						return s+c;
	    						} else {
		    						var e = '<a href="#" onclick="editrow('+index+')">�༭</a> ';
		    						var d = '<a href="#" onclick="deleterow('+index+')">ɾ��</a>';
		    						return e+d;
	    						}
    						}
    					} 
    				]],
	        fit:true,
         	//pagination: true,
            rownumbers: true,
            fitColumns: true,
            singleSelect: false,
            toolbar: [{
                text: '����',
                iconCls: 'icon-add',
                handler: add
            },'-', {
                text: '��������',
                iconCls: 'icon-add',
                handler: batchAdd
            }, '-', {
                text: '����ģ��',
                iconCls: 'icon-edit',
                handler: dowloadTemplate
            }, '-', {
	             text: '����ɾ��',
	             iconCls: 'icon-remove',
	             handler: del
	        }
            , '-', {
                text: 'ͬ������',
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
		} 
		}).datagrid('acceptChanges'); 
        $('body').layout();
    });

    function query(parentId){  
    	 var queryParams = grid.datagrid('options').queryParams;
    	 queryParams.parentId =parentId;
    	 $('#grid').datagrid('reload'); 
    	 $(':input','#parentId').val=parentId;
 
    }  
    
    function batchAdd(){
    	var node = $('#tree').tree('getSelected');
    	
    	if(node==null){
    		 $.messager.alert("��ʾ", "��������,����ѡ����Ӧ������ⲿ��Դ�ĸ�λ�ýڵ�");
    	}else{
    		OpenfileWin();
    	}	    
    	
    }
    
    function batchRootAdd(){
    	$('#tree').tree('reload');
    	query('');
    	OpenfileWin();
    }
    function dowloadTemplate(){
    	window.location='${ctx}/download${class}.do';
    }
    
    
    var tree;
    var grid;
    var editcount = 0; 
	var lastIndex;
	var fileWin;
	var fielForm;
	var  dlg_Edit_form;
	
	
	function editrow(index){
		var node = $('#tree').tree('getSelected');
		$('#grid').datagrid('beginEdit', index);
	}
		
	function deleterow(index){
		$.messager.confirm('ȷ��','�Ƿ����ɾ��?',function(r){
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
		var node = $('#tree').tree('getSelected');
		var pidParent='';
		var text='';
		if(node!=null){
			pidParent = node.id;
		
			text =node.text.substring(node.text.indexOf("-")+1,node.text.length);
			$('#grid').datagrid('appendRow',{ 

				    outerRefParent:pidParent,
				    outerRef:'',	
				    outerRefDesc:text,
					isLeaf:'',
					isRnMonitor:''
				}); 
		}else{
			$('#grid').datagrid('appendRow',{ 
				    outerRefParent:'',
				    outerRef:'',	
				    outerRefDesc:'',
					isLeaf:'',
					isRnMonitor:''
				}); 
		}
		
		var lastIndex = $('#grid').datagrid('getRows').length-1;
		$('#grid').datagrid('beginEdit', lastIndex);
	}
    //ͬ�����ݿⱣ�����
    function saveData() {
    		var node = $('#tree').tree('getSelected');
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
            	     success: function(rsp)
            	     {
            	    	 try{
	            	    	 eval('rsp=' + rsp);
	                         if(rsp.status){
	                             $.messager.alert("��ʾ", "�ύ�ɹ���");
	                          
	                             if(node!=null){
	                          	   $('#tree').tree('reload',node.target);
	                          	   $('#tree').tree("select", node.target);
	                             }else{
	                                 $('#tree').tree('reload');
	                             }
	                             $('#grid').datagrid('acceptChanges');
		                         $('#grid').datagrid('reload');
	                         }else{
	                        	  $.messager.alert("��ʾ", "�ύ�����ˣ�"+rsp.message);
		                         $('#grid').datagrid('acceptChanges');
		                         $('#grid').datagrid('reload');
	                         }
	                   
            	    	 }catch(exception){
                           
                         }
            	     },
            	     error: function (response) {
            	         var r = jQuery.parseJSON(response.responseText);
            	         $.messager.alert("��ʾ", "����ʧ�ܣ� " + r.Message);
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

  //-------------------------------------------tree ����------------------------------------------------------------------

  
   function reloadTree(parentId){
	   $('#tree').tree('options').url = "${ctx}/{inject}DimisionChildrenTree.do?parentId=" + parentId;
	   $('#tree').tree('reload');
    	 query(parentId);
    }
    

  //-------------------------------------------tree ����------------------------------------------------------------------    
    
	function OpenfileWin() {
	    fileWin.window('open');
	    fielForm.form('clear');
	}

 	function fileOK() {
 		var node = $('#tree').tree('getSelected');
	    var file = ($("#fileUpload").val());  
	    if (file == "") {  
	        $.messager.alert('����${class}����', '��ѡ��Ҫ�ϴ����ļ�!');          
	    }  
	    else {  
	        var stuff= (file.substring(file.lastIndexOf(".")+1,file.length)).toLowerCase();;  
	        if (stuff != 'csv') {  
	            $.messager.alert('����${class}����','�ļ����Ͳ���ȷ����ѡ��.csv�ļ�!');   
	        }  
	        else {  
	        	
	        	var node = $('#tree').tree('getSelected');
	        	$('#uploadexcel').form('submit', 
	              {  
	        		onSubmit: function() {  
	                    return true;  
	                }, 
	                error: function(xhr, status, error) {
	                   var err = eval("(" + xhr.responseText + ")");
	               	   $.messager.alert('��ʾ','����${class}����ʧ��,����ϸ������ύ������'+err);
	                }
	                ,
	                success: function(rsp) {  
			       	    	 eval('rsp=' + rsp);
		                     if(rsp.status){
		                      	 $.messager.alert('��ʾ','����${class}����ɹ�'); 
		                      	$('#tree').tree('reload',node.target);
		                      	$('#tree').tree("select", node.target);
		                      	$('#grid').datagrid('reload');
	
		                	 }else{
		                		 $.messager.alert('��ʾ','����${class}����ʧ��:'+rsp.message);  
		                	 }
	                     $(':input','#uploadexcel')
                      	 .not(':button, :submit, :reset, :hidden')
                      	 .val('')
                      	 .removeAttr('checked')
                      	 .removeAttr('selected');
                         $('#file-window').window('close');
	                }
	  
	             }
	        	);   
	              
	        }  
	 }
	 
	}
	function closeFileWindow() {
	    fileWin.window('close');
	}
  
  	//����ɾ��
	function del() {
		var rows = $('#grid').datagrid('getSelections');
	    if (rows.length > 0) {
	        $.messager.confirm('��ʾ��Ϣ', '��ȷ��Ҫɾ����?', function (data) {
	            if (data) {
	            	for (var i = 0; i < rows.length; i++) {  
                        var rowIndex = $('#grid').datagrid('getRowIndex', rows[i]); 
                        $('#grid').datagrid('deleteRow', rowIndex);  
                    }  
	            }
	        });
	    } else {
	        Msgshow('����ѡ��Ҫɾ���ļ�¼��');
	    }
	}
	
	function Msgshow(msg) {
        $.messager.show({
            title: '��ʾ',
            msg: msg,
            showType: 'show'
        });
    }
    function Msgslide(msg) {
        $.messager.show({
            title: '��ʾ',
            msg: msg,
            timeout: 3000,
            showType: 'slide'
        });
    }
    function Msgfade(msg) {
        $.messager.show({
            title: '��ʾ',
            msg: msg,
            timeout: 3000,
            showType: 'fade'
        });
    }
    </script>
</head>
<body class="easyui-layout" style="overflow-y: hidden" scroll="no">
   
          
    <div region="north" split="true" style="overflow: hidden; height: 30px; background: #D2E0F2 repeat-x center 50%;
        line-height: 20px; color: #ff0000;">
      	 Welcome ${class} ����
    </div>
    
    <div region="west" split="true" title="�ⲿ��Դλ��ά����" style="width: 200px;" id="west">
        <p>${class}��ѯ��</p><input type="text" name="pid" onblur="reloadTree(this.value);">
        <ul id="tree"></ul>
    </div>
   
    <div region="center" style="width: 500px; height: 300px; padding: 1px;overflow-y: hidden">
        <table id="grid"></table> 
 
    </div>
   
    
    <div id="file-window" title="ģ�嵼�봰��" style="width: 450px; height: 200px;">
        <div style="padding: 20px 20px 40px 80px;">
            <form id="uploadexcel" method="post" enctype="multipart/form-data"   action="${basePath}/upload${class}.do" >
            <table>
                <tr>
                    <td>${class}ģ�壺</td>
                    <td>
						<input  id="fileUpload" name="fileUpload" type="file"  /> 
						<input type='hidden' id="parentId" name="parentId" value="${parentId}" />
                    </td>
                </tr>
            </table>
            </form>
        </div>
        <div style="text-align: center; padding: 5px;">
            <a href="javascript:void(0)" onclick="fileOK()" id="btn-search" icon="icon-ok">�ϴ�</a>
            <a href="javascript:void(0)" onclick="closeFileWindow()" id="btn-search-cancel" icon="icon-cancel">ȡ��</a>
        </div>
    </div>
</body>
</html>
