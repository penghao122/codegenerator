package db;

import java.io.File;
import java.io.FileWriter;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.util.Collection;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

import org.apache.commons.io.FileUtils;

import freemarker.template.Configuration;
import freemarker.template.DefaultObjectWrapper;
import freemarker.template.Template;

public class TemplateGenerate {

	public static void generateJSP(String dataBase, String username,
			String password, String tableName, String pck) {
		try {

			// ��ȡ����
			Collection<Map<String, String>> properties = CodeGenerator.readData(dataBase,username, password, tableName);

			Configuration cfg = new Configuration();
			cfg.setDirectoryForTemplateLoading(new File("template"));
			cfg.setObjectWrapper(new DefaultObjectWrapper());
			cfg.setEncoding(Locale.CHINA, "GBK");
			cfg.setDefaultEncoding("GBK");
			// ��ȡģ���ļ�
			Template template = cfg.getTemplate("jsp.ftl");

			Map<String, Object> map = new HashMap<String, Object>();
			map.put("class", CodeGenerator.getClassName(tableName));
			map.put("pck", pck);
			map.put("inject", CodeGenerator.getInjectClassName(tableName));
			map.put("properties", properties);
			map.put("ctx", "${ctx}");
			// �������������̨
			Writer out = new OutputStreamWriter(System.out);
			template.process(map, out);
			out.flush();

			// ����������ļ�
			String root = CodeGenerator.genPackStr("src", "dim");
			File fileDir = new File(root);
			// �����ļ��У��������򴴽�
			FileUtils.forceMkdir(fileDir);
			// ָ������������ļ�
			File output = new File(fileDir + "/"+CodeGenerator.getInjectClassName(tableName) + "DimisionList" + ".jsp");
			Writer writer = new FileWriter(output);
			template.process(map, writer);
			writer.close();

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static void generateAutoSQL(String dataBase, String username,
			String password, String tableName, String pck) {
		try {

			// ��ȡ����
			Collection<Map<String, String>> properties = CodeGenerator.readData(dataBase,username, password, tableName);
			Configuration cfg = new Configuration();
			cfg.setDirectoryForTemplateLoading(new File("template"));
			cfg.setObjectWrapper(new DefaultObjectWrapper());
			// ��ȡģ���ļ�
			Template template = cfg.getTemplate("queryForAuto.ftl");

			Map<String, Object> map = new HashMap<String, Object>();
			map.put("class", CodeGenerator.getClassName(tableName));
			map.put("pck", pck);
			map.put("inject", CodeGenerator.getInjectClassName(tableName));
			map.put("properties", properties);
			map.put("tableName", tableName);
			// �������������̨
			Writer out = new OutputStreamWriter(System.out);
			template.process(map, out);
			out.flush();

			// ����������ļ�
			String root = CodeGenerator.genPackStr("src", "query");
			File fileDir = new File(root);
			// �����ļ��У��������򴴽�
			FileUtils.forceMkdir(fileDir);
			// ָ������������ļ�
			File output = new File(fileDir + "/query-"+ CodeGenerator.getInjectClassName(tableName) + "-mysql" + ".xml");
			Writer writer = new FileWriter(output);
			template.process(map, writer);
			writer.close();

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@SuppressWarnings("unused")
	public static void generateSQL(String dataBase, String username,String password, String tableName, String pck) {
		try {

			// ��ȡ����
			Collection<Map<String, String>> properties = CodeGenerator.readData(dataBase,username, password, tableName);

			Configuration cfg = new Configuration();
			cfg.setDirectoryForTemplateLoading(new File("template"));
			cfg.setObjectWrapper(new DefaultObjectWrapper());

			// ��ȡģ���ļ�
			Template template = cfg.getTemplate("query.ftl");

			Map<String, Object> map = new HashMap<String, Object>();
			map.put("class", CodeGenerator.getClassName(tableName));
			map.put("pck", pck);
			map.put("inject", CodeGenerator.getInjectClassName(tableName));
			map.put("properties", properties);
			map.put("tableName", tableName);
			// �������������̨
			Writer out = new OutputStreamWriter(System.out);
			template.process(map, out);
			out.flush();

			// ����������ļ�
			String root = CodeGenerator.genPackStr("src", "query");
			File fileDir = new File(root);
			// �����ļ��У��������򴴽�
			FileUtils.forceMkdir(fileDir);
			// ָ������������ļ�
			File output = new File(fileDir + "/query-"+ CodeGenerator.getInjectClassName(tableName) + "-mysql" + ".xml");
			Writer writer = new FileWriter(output);
			template.process(map, writer);
			writer.close();

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static void generateAction(String dataBase, String username,String password, String tableName, String pck) {
		try {

			Configuration cfg = new Configuration();
			cfg.setDirectoryForTemplateLoading(new File("template"));
			cfg.setObjectWrapper(new DefaultObjectWrapper());

			// ��ȡģ���ļ�
			Template template = cfg.getTemplate("action.ftl");

			Map<String, Object> map = new HashMap<String, Object>();
			map.put("class", CodeGenerator.getClassName(tableName));
			map.put("pck", pck);
			map.put("inject", CodeGenerator.getInjectClassName(tableName));

			// �������������̨
			Writer out = new OutputStreamWriter(System.out);
			template.process(map, out);
			out.flush();

			// ����������ļ�
			String root = CodeGenerator.genPackStr("src", pck + ".action");
			File fileDir = new File(root);
			// �����ļ��У��������򴴽�
			FileUtils.forceMkdir(fileDir);
			// ָ������������ļ�
			File output = new File(fileDir + "/" + CodeGenerator.getClassName(tableName)+ "Action" + ".java");
			Writer writer = new FileWriter(output);
			template.process(map, writer);
			writer.close();

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static void generateSpringConfig(String dataBase, String username,String password, String tableName, String pck) {
		try {

			Configuration cfg = new Configuration();
			cfg.setDirectoryForTemplateLoading(new File("template"));
			cfg.setObjectWrapper(new DefaultObjectWrapper());

			// ��ȡģ���ļ�
			Template template = cfg.getTemplate("spring.ftl");

			Map<String, Object> map = new HashMap<String, Object>();
			map.put("class", CodeGenerator.getClassName(tableName));
			map.put("inject",CodeGenerator.getInjectClassName(tableName));
			map.put("ctx", "${ctx}");

			// �������������̨
			Writer out = new OutputStreamWriter(System.out);
			template.process(map, out);
			out.flush();

			// ����������ļ�
			String root = CodeGenerator.genPackStr("src", "spring");
			File fileDir = new File(root);
			// �����ļ��У��������򴴽�
			FileUtils.forceMkdir(fileDir);
			// ָ������������ļ�
			File output = new File(fileDir + "/"+ "applicationContext-jdbc-dao-" + CodeGenerator.getClassName(tableName)+ ".xml");
			Writer writer = new FileWriter(output);
			template.process(map, writer);
			writer.close();

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static void generateService(String dataBase, String username,String password, String tableName, String pck) {
		try {

			Configuration cfg = new Configuration();
			cfg.setDirectoryForTemplateLoading(new File("template"));
			cfg.setObjectWrapper(new DefaultObjectWrapper());

			// ��ȡģ���ļ�
			Template template = cfg.getTemplate("serviceInterface.ftl");

			Map<String, Object> map = new HashMap<String, Object>();
			map.put("class",CodeGenerator.getClassName(tableName));
			map.put("pck", pck);

			// �������������̨
			Writer out = new OutputStreamWriter(System.out);
			template.process(map, out);
			out.flush();

			// ����������ļ�
			String root = CodeGenerator.genPackStr("src", pck + ".service");
			File fileDir = new File(root);
			// �����ļ��У��������򴴽�
			FileUtils.forceMkdir(fileDir);
			// ָ������������ļ�
			File output = new File(fileDir + "/" + CodeGenerator.getClassName(tableName)+ "Service" + ".java");
			Writer writer = new FileWriter(output);
			template.process(map, writer);
			writer.close();

			// ��ȡģ���ļ�
			Template template2 = cfg.getTemplate("service.ftl");

			Map<String, Object> map2 = new HashMap<String, Object>();
			map2.put("class", CodeGenerator.getClassName(tableName));
			map2.put("pck", pck);
			map2.put("inject", CodeGenerator.getInjectClassName(tableName));

			// �������������̨
			Writer out2 = new OutputStreamWriter(System.out);
			template2.process(map2, out2);
			out2.flush();

			// ����������ļ�
			String root2 = CodeGenerator.genPackStr("src", pck + ".service.impl");
			File fileDir2 = new File(root2);
			// �����ļ��У��������򴴽�
			FileUtils.forceMkdir(fileDir2);
			// ָ������������ļ�
			File output2 = new File(fileDir2 + "/" + CodeGenerator.getClassName(tableName)+ "ServiceImpl" + ".java");
			Writer writer2 = new FileWriter(output2);
			template2.process(map2, writer2);
			writer2.close();

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static void generateModel(String dataBase, String username,String password, String tableName, String pck) {
		try {

			// ��ȡ����
			Collection<Map<String, String>> properties = CodeGenerator.readData(dataBase,username, password, tableName);

			Configuration cfg = new Configuration();
			cfg.setDirectoryForTemplateLoading(new File("template"));
			cfg.setObjectWrapper(new DefaultObjectWrapper());

			// ��ȡģ���ļ�
			Template template = cfg.getTemplate("model.ftl");

			Map<String, Object> map = new HashMap<String, Object>();
			map.put("class", CodeGenerator.getClassName(tableName));
			map.put("pck", pck);
			map.put("properties", properties);

			// �������������̨
			Writer out = new OutputStreamWriter(System.out);
			template.process(map, out);
			out.flush();

			// ����������ļ�
			String root = CodeGenerator.genPackStr("src", pck + ".model");
			File fileDir = new File(root);
			// �����ļ��У��������򴴽�
			FileUtils.forceMkdir(fileDir);
			// ָ������������ļ�
			File output = new File(fileDir + "/" + CodeGenerator.getClassName(tableName)
					+ ".java");
			Writer writer = new FileWriter(output);
			template.process(map, writer);
			writer.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@SuppressWarnings("unused")
	public static void generateDao(String dataBase, String username,String password, String tableName, String pck) {
		try {
			// ��ȡ����
			Collection<Map<String, String>> properties = CodeGenerator.readData(dataBase,username, password, tableName);
			Configuration cfg = new Configuration();
			cfg.setDirectoryForTemplateLoading(new File("template"));
			cfg.setObjectWrapper(new DefaultObjectWrapper());

			// ��ȡģ���ļ�
			Template template = cfg.getTemplate("daoInterface.ftl");

			Map<String, Object> map = new HashMap<String, Object>();
			map.put("class", CodeGenerator.getClassName(tableName));
			map.put("pck", pck);

			// �������������̨
			Writer out = new OutputStreamWriter(System.out);
			template.process(map, out);
			out.flush();

			// ����������ļ�
			String root = CodeGenerator.genPackStr("src", pck + ".dao");
			File fileDir = new File(root);
			// �����ļ��У��������򴴽�
			FileUtils.forceMkdir(fileDir);
			// ָ������������ļ�
			File output = new File(fileDir + "/" + CodeGenerator.getClassName(tableName)+ "Dao" + ".java");
			Writer writer = new FileWriter(output);
			template.process(map, writer);
			writer.close();

			// ��ȡģ���ļ�
			Template template2 = cfg.getTemplate("dao.ftl");

			Map<String, Object> map2 = new HashMap<String, Object>();
			map2.put("class", CodeGenerator.getClassName(tableName));
			map2.put("pck", pck);
			map2.put("inject", CodeGenerator.getInjectClassName(tableName));
			map2.put("properties", properties);
			// �������������̨
			Writer out2 = new OutputStreamWriter(System.out);
			template2.process(map2, out2);
			out2.flush();

			// ����������ļ�
			String root2 = CodeGenerator.genPackStr("src", pck + ".dao.impl");
			File fileDir2 = new File(root2);
			// �����ļ��У��������򴴽�
			FileUtils.forceMkdir(fileDir2);
			// ָ������������ļ�
			File output2 = new File(fileDir2 + "/" + CodeGenerator.getClassName(tableName)
					+ "DaoImpl" + ".java");
			Writer writer2 = new FileWriter(output2);
			template2.process(map2, writer2);
			writer2.close();

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static void generateAutoDao(String dataBase, String username,String password, String tableName, String pck) {
		try {
			// ��ȡ����
			Collection<Map<String, String>> properties = CodeGenerator.readData(dataBase,username, password, tableName);
			Configuration cfg = new Configuration();
			cfg.setDirectoryForTemplateLoading(new File("template"));
			cfg.setObjectWrapper(new DefaultObjectWrapper());

			// ��ȡģ���ļ�
			Template template = cfg.getTemplate("daoInterface.ftl");

			Map<String, Object> map = new HashMap<String, Object>();
			map.put("class",CodeGenerator. getClassName(tableName));
			map.put("pck", pck);

			// �������������̨
			Writer out = new OutputStreamWriter(System.out);
			template.process(map, out);
			out.flush();

			// ����������ļ�
			String root =CodeGenerator. genPackStr("src", pck + ".dao");
			File fileDir = new File(root);
			// �����ļ��У��������򴴽�
			FileUtils.forceMkdir(fileDir);
			// ָ������������ļ�
			File output = new File(fileDir + "/" + CodeGenerator.getClassName(tableName)+ "Dao" + ".java");
			Writer writer = new FileWriter(output);
			template.process(map, writer);
			writer.close();

			// ��ȡģ���ļ�
			Template template2 = cfg.getTemplate("daoForAuto.ftl");

			Map<String, Object> map2 = new HashMap<String, Object>();
			map2.put("class", CodeGenerator.getClassName(tableName));
			map2.put("pck", pck);
			map2.put("inject", CodeGenerator.getInjectClassName(tableName));
			map2.put("properties", properties);
			// �������������̨
			Writer out2 = new OutputStreamWriter(System.out);
			template2.process(map2, out2);
			out2.flush();

			// ����������ļ�
			String root2 = CodeGenerator.genPackStr("src", pck + ".dao.impl");
			File fileDir2 = new File(root2);
			// �����ļ��У��������򴴽�
			FileUtils.forceMkdir(fileDir2);
			// ָ������������ļ�
			File output2 = new File(fileDir2 + "/" + CodeGenerator.getClassName(tableName)+ "DaoImpl" + ".java");
			Writer writer2 = new FileWriter(output2);
			template2.process(map2, writer2);
			writer2.close();

		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
