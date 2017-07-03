package ${pck}.action;

import java.io.UnsupportedEncodingException;
import java.util.List;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;
import java.sql.SQLException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.util.StringUtils;
import com.duowan.dimension.model.${class};
import com.duowan.dimension.service.${class}Service;
import com.duowan.dimension.util.DateJsonValueProcessor;

@Controller
public class ${class}Action extends BaseAction{

	@Autowired
	private ${class}Service ${inject}Service;
	
	@RequestMapping
	public String ${inject}DimisionList() {
		String target = "dim/${inject}DimisionList";
		return target;
	}
	
	
	
	@RequestMapping
    @ResponseBody
	public String ${inject}DimisionGrid(int page, int rows) throws UnsupportedEncodingException{
		String gridData = getJsonGrid(page,rows);
		return gridData;
	}
	
	public String getJsonGrid(int page, int rows) throws UnsupportedEncodingException
	 { 	
		  
	    	List<${class}> ${inject}List = null;
	    	${inject}List = ${inject}Service.get${class}List( (page-1)*rows,  rows);
	        JSONObject jdata = new JSONObject();
	        JsonConfig jsonConfig = new JsonConfig();  
	        jsonConfig.registerJsonValueProcessor(java.util.Date.class, new DateJsonValueProcessor()); 
	        if(${inject}List!=null){
	        	jdata.put("total",${inject}Service.getCount());
	        	jdata.put("rows",JSONArray.fromObject(${inject}List, jsonConfig));
	        }else{
	        	jdata.put("total",0);
	        	jdata.put("rows","[{}]");
	        }
	        return jdata.toString();
	 }
	 
	 
	@RequestMapping
	@ResponseBody
	public String ${inject}Batch(String inserted, String updated,
			String deleted) throws Exception {

		JSONObject json = new JSONObject();
		try {
			if (StringUtils.hasText(inserted)) {
				processInser${class}(inserted);
			}
			if (StringUtils.hasText(updated)) {
				processUpdate${class}(updated);
			}
			if (StringUtils.hasText(deleted)) {
				processDelete${class}(deleted);
			}
			json.put("status", true);
		} catch (Exception e) {
			json.put("status", false);
			json.put("message", e.getMessage());
			return json.toString();
		}
		return json.toString();
	}
	
	
	@SuppressWarnings({ "unchecked", "deprecation" })
	private void processDelete${class}(String json) throws SQLException {
		JSONArray objArray = JSONArray.fromObject(json);
		List<${class}> ${inject}List = JSONArray.toList(objArray,${class}.class);
		for (${class} ${inject} : ${inject}List) {
			${inject}Service.delete(${inject});
		}

	}

	@SuppressWarnings({ "unchecked", "deprecation" })
	private void processUpdate${class}(String json) {
		JSONArray objArray = JSONArray.fromObject(json);
		List<${class}>  ${inject}List = JSONArray.toList(objArray,${class}.class);
		for (${class} ${inject} : ${inject}List) {
			${inject}Service.update(${inject});
		}

	}

	@SuppressWarnings({ "unchecked", "deprecation" })
	private void processInser${class}(String json) throws SQLException,
			UnsupportedEncodingException {
		JSONArray objArray = JSONArray.fromObject(json);
		List<${class}>  ${inject}List = JSONArray.toList(objArray,${class}.class);
		for (${class} ${inject} : ${inject}List) {
			${inject}Service.insert(${inject});
		}

	}
	 
}
