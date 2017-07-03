<%@ WebHandler Language="C#" Class="TreeHandler" %>

using System;
using System.Web;
using System.Data;
using System.Text;

public class TreeHandler : IHttpHandler {

    protected StringBuilder sb = new StringBuilder();
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        jsonTree("0");        
        context.Response.Write(sb.ToString());
    }
    void jsonTree(string parent)
    {
        sb.Append("[");
        string sqlexe = @"select * From proclass where pid=" + parent + " order by [Order] ASC";
        DataTable dt = OleDbHelper.dataTable(sqlexe);
        foreach (DataRow dr in dt.Rows)
        {
            string id = dr["id"].ToString();
            string state = "open";
            Boolean bc = bChild(id);
            if (bc)
                state = "closed";
            sb.Append("{");
            sb.Append(string.Format("\"id\": \"{0}\", \"text\": \"{1}\", \"iconCls\": \"\", \"state\": \"" + state + "\"", dr["id"].ToString(), dr["Name"].ToString()));
            if (bc)
            {
                sb.Append(",\"children\":");
                jsonTree(id);
            }
            sb.Append("},");
        }
        sb.Remove(sb.ToString().Length - 1, 1);
        sb.Append("]");
    }
    public Boolean bChild(string parent)
    {
        string sqlexe = @"select * From proclass where pid=" + parent + " order by [Order] ASC";
        DataTable dt = OleDbHelper.dataTable(sqlexe);
        return dt.Rows.Count > 0;
    }
    public bool IsReusable {
        get {
            return false;
        }
    }

}