<%@ WebHandler Language="C#" Class="Handler" %>

using System;
using System.Web;
using System.Text;
using System.Data;
using System.Data.OleDb;
public class Handler : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string sReturnJson = string.Empty;
        string sqlexe = string.Empty;
        string action = ParamsofEasyUI.RequstString("action");
        switch (action)
        {
            case "save":
                sReturnJson = save();
                break;
            case "del":
                sReturnJson = delete();
                break;
            case "list":
            case "query":
                sReturnJson = getData(action);
                break;
            case "get":
            sReturnJson=getSingleData();
                break;
            default:
                break;
        }
        context.Response.Write(sReturnJson);
    }

    private string getSingleData()
    {
        string id = ParamsofEasyUI.RequstString("id");
        string sqlexe = @"select ID,parent,title,addTime from product where id=" + id + "";
        DataTable dt =OleDbHelper.dataTable(sqlexe);
        return Json4EasyUI.onForm(dt);
    }
    private string getData(string action)
    {
        string order = ParamsofEasyUI.order;
        string sort = ParamsofEasyUI.sort;
        int page = ParamsofEasyUI.page;
        int rows = ParamsofEasyUI.rows;
        
        string sWhere = string.Empty;
        string sqlexe = string.Empty;
        if (action.Equals("list"))
        {
            string PID = ParamsofEasyUI.RequstString("PID");
            if (!string.IsNullOrEmpty(PID))
            {
                sWhere = " where [parent]=" + PID;
                page = 1;
            }
        }
        else if (action.Equals("query"))
        {
            string stitle = ParamsofEasyUI.RequstString("title");
            if (!string.IsNullOrEmpty(stitle))
                sWhere = " where title like '%" + stitle + "%'";
        }
        //sqlexe = @"select top 10 ID,title,addTime from (select top 20 * from product " + PID + " order by [addTime] DESC,ID desc) as a";
        sqlexe = @"select ID,title,addTime from product " + sWhere + " order by " + sort + " " + order + ",ID desc";
        DataTable dt = OleDbHelper.dataTable(sqlexe);
        return Json4EasyUI.onDataGrid(dt, page, rows);
    }
    private string delete()
    {
        string sReturnJson = string.Empty;
        string id = ParamsofEasyUI.RequstString("id");
        string sqlexe = string.Format("delete from product where id in ({0})", id);
        if (OleDbHelper.ExecuteUpdate(sqlexe))
            sReturnJson = "{success:true}";
        else
            sReturnJson = "{success:false}";
        return sReturnJson;
    }
    private string save()
    {
        string sReturnJson = string.Empty;
        string id = ParamsofEasyUI.RequstString("id");
        string title = ParamsofEasyUI.RequstForm("title");
        string parent = ParamsofEasyUI.RequstForm("parent");
        int ipar;
        Int32.TryParse(parent, out ipar);
        string sqlexe = string.Empty;
        if (id.Length > 0)
        {
            sqlexe = "update product set title=@title,[parent]=@parent where id=@id";
            OleDbParameter[] param = {
                new OleDbParameter("@title",title),
                new OleDbParameter("@parent",ipar),
                new OleDbParameter("@id",Convert.ToInt32(id))
                };
            if (OleDbHelper.ExecuteNonQuery(sqlexe, param))
                sReturnJson = "{success:true}";
            else
                sReturnJson = "{success:false}";
        }
        else
        {
            sqlexe = string.Format("insert Into product (title,parent,addtime) values ('{0}','{1}','{2}')",
               title,ipar, System.DateTime.Now.ToString());
            if (OleDbHelper.ExecuteUpdate(sqlexe))
                sReturnJson = "{success:true}";
            else
                sReturnJson = "{success:false,msg:'保存信息失败'}";
        }
        return sReturnJson;
    }
    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
}