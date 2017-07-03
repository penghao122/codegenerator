<?xml version="1.0" encoding="UTF-8"?>
<sqlConfig xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:mtr="http://www.duowan.com"
    xsi:schemaLocation="http://www.duowan.com ../../query.xsd">


  	<sql-query name="insert">
           <sql>
		        <![CDATA[
				       INSERT INTO ${tableName} 
				       	(
				        <#list properties as prop>
					   		${prop.orignalFieldName},
					    </#list>
				     	)
				       VALUES
				       (
				       	<#list properties as prop>
					   		:${prop.fieldName},
					    </#list>
				       )
		           ]]>
           </sql>
     </sql-query>
         

     <sql-query name="update">
       <sql>
           <![CDATA[
			   UPDATE ${tableName} 
			   
			   SET
			    <#list properties as prop>
				     <if ${prop.fieldName}??> 
				     	${prop.orignalFieldName}='{${prop.fieldName}}'  ,
					 </if> 		   		
			    </#list>
			   	       	
		        WHERE 1=1  <include '${inject}Condition'/>
                ]]>
         </sql>
     </sql-query>
     
     <sql-query name="delete">
       	 <sql>
	         <![CDATA[
	     			DELETE FROM ${tableName} WHERE 1=1  <include '${inject}Condition'/>
	     	  ]]>
         </sql>
     </sql-query>
     
          
      <sql-query name="get${class}">
       	 <sql>
	         <![CDATA[
	     			SELECT * FROM ${tableName} WHERE 
	     			1=1 <include '${inject}Condition'/> limit {page},{rows}
	     	  ]]>
         </sql>
     </sql-query>
     
     <sql-query name="${inject}Condition">
       	 <sql>
	         <![CDATA[
	         
	            <#list properties as prop>
				     <if ${prop.fieldName}??> 
				   		  AND	${prop.orignalFieldName}='{${prop.fieldName}}'  
					 </if> 		   		
			    </#list>
	    
		    		        
	     	  ]]>
         </sql>
     </sql-query>

      <sql-query name="getCount">
       	 <sql>
	         <![CDATA[
	     			SELECT count(*) FROM ${tableName} ;
	     	  ]]>
         </sql>
     </sql-query>             

</sqlConfig>
