package ${pck}.service;

import java.util.List;

import com.duowan.dimension.model.${class};

public interface ${class}Service {

	void batchInser${class}(final BufferedReader reader,final String parentId)throws Exception;

	List<${class}> get${class}List(int page, int rows);

	void delete(${class} obj);

	void update(${class} obj);

	void insert(${class} obj);
	
	int getCount();
	
	List<${class}> get${class}TopList();
}
