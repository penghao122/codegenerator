package ${pck}.model; 

import java.util.Date;

public class ${class} implements java.io.Serializable { 

  <#list properties as prop>
    private ${prop.fieldType} ${prop.fieldName};
  </#list>

  <#list properties as prop>
    public ${prop.fieldType} get${prop.fieldName?cap_first}(){
      return ${prop.fieldName};
    }
    public void set${prop.fieldName?cap_first}(${prop.fieldType} ${prop.fieldName}){
      this.${prop.fieldName} = ${prop.fieldName};
    }
  </#list>

}
