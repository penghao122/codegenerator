<%@ WebHandler Language="C#" Class="GetClassJsonByPid" %>

using System;
using System.Web;
using System.Data;

public class GetClassJsonByPid : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string sJsonTree = string.Empty;
        int parentId = -1;
        string pid = context.Request.QueryString["pid"];
        if (!string.IsNullOrEmpty(pid))
            Int32.TryParse(pid, out parentId);
        if (parentId>=0)
            sJsonTree = getJsonTree(parentId);
        context.Response.Write(sJsonTree);
    }
	
    public string getJsonTree(int pid)
    { 
        string resultStr = "";
        resultStr += "[";
        string sqlexe = @"select * From proclass where pid=" + pid.ToString() + " order by [Order] ASC";
        DataTable dt =OleDbHelper.dataTable(sqlexe);
        foreach (DataRow dr in dt.Rows)
	    {
            string id = dr["id"].ToString();
            string state = "open";
            if (bChild(id))
                state = "closed";
            resultStr += "{";
            resultStr += string.Format("\"id\": \"{0}\", \"text\": \"{1}\", \"iconCls\": \"\", \"state\": \"" + state + "\"", dr["id"].ToString(), dr["Name"].ToString());
            resultStr += "},";
        }
        resultStr = resultStr.Substring(0, resultStr.Length - 1);                   
        resultStr += "]";
        return resultStr;
    }
    public Boolean bChild(string pid)
    {
        string sqlexe = @"select * From proclass where pid=" + pid.ToString() + " order by [Order] ASC";
        DataTable dt = OleDbHelper.dataTable(sqlexe);
        return dt.Rows.Count > 0;
    }
	
    public bool IsReusable {
        get {
            return false;
        }
    }

}