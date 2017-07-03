package db;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.util.Collection;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;

public class CodeGenerator {

	private final static String DRIVER="com.mysql.jdbc.Driver";
	private final static String URL="jdbc:mysql://113.108.228.101:3306/";
	private final static String MODEL="?useUnicode=true&characterEncoding=UTF-8";
	
	/**
	 * ���빤��ʵ��
	 * 
	 * @param args
	 */
	public static void main(String[] args) {

		String dataBase = "dim"; // ���ݿ���
		String username = "hive"; // ���ݿ��û���
		String password = "123456789"; // ���ݿ�����
		String tableName = "dim_demo"; // ����
		String pck = "com.demo.dimension";// ����
		TemplateGenerate.generateAutoDao(dataBase, username, password, tableName, pck);

	}

	

	/**
	 * ��ȡ������
	 * 
	 * @param dataBase
	 *            ���ݿ���
	 * @param tableName
	 *            ����
	 * @return
	 */
	public static Collection<Map<String, String>> readData(String dataBase,String username, String password, String tableName) {
		Collection<Map<String, String>> properties = new HashSet<Map<String, String>>();
		Connection conn = null;
		ResultSet rs = null;
		try {
			Class.forName(DRIVER);
			conn = DriverManager.getConnection(URL + dataBase+ MODEL,username, password);
			DatabaseMetaData dbmd = conn.getMetaData();
			rs = dbmd.getColumns(null, null, tableName, null);
			while (rs.next()) {
				Map<String, String> map = new HashMap<String, String>();
				map.put("fieldName", genFieldName(rs.getString("COLUMN_NAME")));
				map.put("fieldType", genFieldType(rs.getString("TYPE_NAME")));
				map.put("orignalFieldName", rs.getString("COLUMN_NAME"));
				// map.put("orignalFieldType", rs.getString("TYPE_NAME"));
				properties.add(map);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (conn != null) {
					conn.close();
				}
				if (rs != null) {
					rs.close();
				}
			} catch (Exception e2) {
				e2.printStackTrace();
			}
		}
		return properties;
	}

	/**
	 * ���ݰ�����ȡ��Ӧ��·����
	 * 
	 * @param root
	 *            ��·��
	 * @param pack
	 *            ����
	 * @return
	 */
	public static String genPackStr(String root, String pack) {
		String result = root;
		String[] dirs = pack.split("\\.");
		for (String dir : dirs) {
			result += "/" + dir;
		}
		return result;
	}

	/**
	 * ���ݱ����ȡ����
	 * 
	 * @param tableName
	 *            ����
	 * @return
	 */
	public static String getClassName(String tableName) {
		String result = "";
		String lowerFeild = tableName.toLowerCase();
		String[] fields = lowerFeild.split("_");
		if (fields.length > 1) {
			for (int i = 0; i < fields.length; i++) {
				result += fields[i].substring(0, 1).toUpperCase()+ fields[i].substring(1, fields[i].length());
			}
		}
		return result;
	}

	/**
	 * ���ݱ����ȡ����
	 * 
	 * @param tableName
	 *            ����
	 * @return
	 */
	public static String getInjectClassName(String tableName) {
		String result = "";
		String lowerFeild = tableName.toLowerCase();
		String[] fields = lowerFeild.split("_");
		if (fields.length > 1) {
			for (int i = 0; i < fields.length; i++) {
				if (i == 0) {
					result += fields[i].substring(0, 1).toLowerCase()+ fields[i].substring(1, fields[i].length());
				} else {
					result += fields[i].substring(0, 1).toUpperCase()+ fields[i].substring(1, fields[i].length());
				}
			}
		}
		return result;
	}

	/**
	 * ���ݱ��ֶ�����ȡjava�е��ֶ���
	 * 
	 * @param field
	 *            �ֶ���
	 * @return
	 */
	public static String genFieldName(String field) {
		String result = "";
		String lowerFeild = field.toLowerCase();
		String[] fields = lowerFeild.split("_");
		result += fields[0];
		if (fields.length > 1) {
			for (int i = 1; i < fields.length; i++) {
				result += fields[i].substring(0, 1).toUpperCase()+ fields[i].substring(1, fields[i].length());
			}
		}
		return result;
	}

	/**
	 * ���ݱ��ֶε��������ɶ�Ӧ��java����������
	 * 
	 * @param type
	 *            �ֶ�����
	 * @return
	 */
	public static String genFieldType(String type) {
		String result = "String";
		if (type.toLowerCase().equals("varchar")) {
			result = "String";
		} else if (type.toLowerCase().equals("int")) {
			result = "int";
		} else if (type.toLowerCase().equals("date")) {
			result = "Date";
		}
		return result;
	}

}
