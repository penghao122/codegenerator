package ${pck}.service.impl;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.duowan.dimension.dao.${class}Dao;
import com.duowan.dimension.model.${class};
import com.duowan.dimension.service.${class}Service;

@Service("${inject}Service")
@Transactional
public class ${class}ServiceImpl implements ${class}Service {

	private ${class}Dao ${inject}Dao;
	

	public void set${class}Dao(${class}Dao ${inject}Dao) {
		this.${inject}Dao = ${inject}Dao;
	}

	public List<${class}> get${class}List(int page, int rows) {
		
		return ${inject}Dao.get${class}List(page,rows);
	}

	public void delete(${class} advert) {
		
		${inject}Dao.delete(advert);
	}

	public void update(${class} advert) {
		
		${inject}Dao.update(advert);
	}

	public void insert(${class} advert) {
		${inject}Dao.insert(advert);
		
	}

	public int getCount() {
		
		return ${inject}Dao.getCount();
	}
}
