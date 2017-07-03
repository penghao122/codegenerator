package ${pck}.dao.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.jdbc.core.BeanPropertyRowMapper;

import com.duowan.common.util.NamedQueryUtil;
import com.duowan.dimension.common.dao.BaseSpringJdbcDao;
import com.duowan.dimension.dao.${class}Dao;
import com.duowan.dimension.model.${class};

public class ${class}DaoImpl extends BaseSpringJdbcDao<${class}> implements ${class}Dao {

	public static final String SQL_FILE="query/query-${inject}-mysql.xml";
	
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public List<${class}> get${class}List(int page, int rows) {
		NamedQueryUtil util = new NamedQueryUtil(SQL_FILE);
		Map model  = new HashMap();
		model.put("page", page);
		model.put("rows", rows);
		String sql =util.loadFreeMarkSql("get${class}",model);
		return getSimpleJdbcTemplate().query(sql, new BeanPropertyRowMapper<${class}>(${class}.class));
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	public void delete(${class} obj) {
		
		NamedQueryUtil util = new NamedQueryUtil(SQL_FILE);
		Map model  = new HashMap();
		<#list properties as prop>
		model.put("${prop.fieldName}", obj.get${prop.fieldName?cap_first}());
		</#list>
		String sql =util.loadFreeMarkSql("delete",model);
		this.getSimpleJdbcTemplate().update(sql);
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public void update(${class} obj) {
		NamedQueryUtil util = new NamedQueryUtil(SQL_FILE);
		Map model  = new HashMap();
		<#list properties as prop>
		model.put("${prop.fieldName}", obj.get${prop.fieldName?cap_first}());
		</#list>
		String sql =util.loadFreeMarkSql("update",model);
		this.getJdbcTemplate().update(sql);
		
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public void insert(${class} obj) {
		NamedQueryUtil util = new NamedQueryUtil(SQL_FILE);
		Map model  = new HashMap();
		<#list properties as prop>
		model.put("${prop.fieldName}", obj.get${prop.fieldName?cap_first}());
		</#list>
		String sql =util.loadFreeMarkSql("insert",model);
		this.getJdbcTemplate().update(sql);
		
	}
				
	public int getCount() {

		NamedQueryUtil util = new NamedQueryUtil(SQL_FILE);
		String sql =util.loadSql("getCount");
		return getSimpleJdbcTemplate().queryForInt(sql);
	}
}