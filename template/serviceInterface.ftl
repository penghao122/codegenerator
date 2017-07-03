package ${pck}.service;

import java.util.List;

import com.duowan.dimension.model.${class};

public interface ${class}Service {

	List<${class}> get${class}List(int page, int rows);

	void delete(${class} obj);

	void update(${class} obj);

	void insert(${class} obj);
	
	int getCount();
}
