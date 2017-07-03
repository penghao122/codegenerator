package ${pck}.dao; 

import java.util.List;


import com.duowan.dimension.model.${class};

public interface ${class}Dao {

	List<${class}> get${class}List(int page,int rows);
	
	void delete(${class} area);

	void update(${class} area);

	void insert(${class} area);

	int getCount();
}
