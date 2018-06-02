using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;
using System.Net;
using System.Text;
using System.Runtime.Serialization;
using System.Runtime.Serialization.Json;


namespace DBRefactoringW
{
    public partial class WebForm1 : System.Web.UI.Page
    {
        private string tablename;
        private int colCnt;
        private List<string> colNsmeList;
        DataTable dsNewAddCol = new DataTable();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                tablename = "社員";
                SqlConnection con
                    = new SqlConnection();
                con.ConnectionString = "Data Source=DESKTOP-3G3RB41\\SQLEXPRESS;Initial Catalog=testDB;Integrated Security=True"; //接続情報を入れる
                con.Open();

                //クエリーの生成
                SqlCommand sqlCom = new SqlCommand();

                //クエリー送信先及びトランザクションの指定
                sqlCom.Connection = con;
                //sqlCom.Transaction = this.sqlTran;

                //クエリー文の指定
                sqlCom.CommandText = "SELECT * FROM " + tablename + ";";

                //データテーブルを作成するためのアダプタ
                SqlDataAdapter sqlAda = new SqlDataAdapter();
                sqlAda.SelectCommand = sqlCom;

                DataTable dsgrid = new DataTable();
                dsgrid.Columns.Add("Column", typeof(string));
                dsgrid.Columns.Add("テーブル間距離", typeof(string));
                //dsにテーブルデータを代入
                DataTable ds = new DataTable();
                sqlAda.Fill(ds);
                colCnt = ds.Columns.Count;
                colNsmeList = new List<string>();
                List<String> colnameList = new List<string>();
                DataTable dsgridbetCol = new DataTable();
                foreach (DataColumn clm in ds.Columns)
                {
                    dsgridbetCol.Columns.Add(clm.ColumnName, typeof(string));
                    //columnList.Add(clm.ColumnName);
                    var sim = getSimilarity(tablename, clm.ColumnName);
                    //var sim = "0";
                    string[] row = new string[] { clm.ColumnName, sim };
                    dsgrid.Rows.Add(row);
                    colNsmeList.Add(clm.ColumnName);

                    colnameList.Add(clm.ColumnName);
                }
                //dsgrid.Rows[10]["word2vec距離"] = "0.1";

                columnlist1.DataSource = dsgrid;
                columnlist1.DataBind();

                columnlist2.DataSource = dsgrid;
                columnlist2.DataBind();

                //DataTable dsNewAddCol = new DataTable();
                dsNewAddCol = dsgrid;
                grNewAddCol.DataSource = dsNewAddCol;
                grNewAddCol.DataBind();

                grdivideCol.DataSource = dsgrid;
                grdivideCol.DataBind();

                grRenameCol.DataSource = dsgrid;
                grRenameCol.DataBind();

                txtDiv.Text = "投稿者ID";
                foreach (DataColumn clm in ds.Columns)
                {
                    List<string> row = new List<string>();
                    foreach (string colname in colnameList)
                    {
                        if (colname == clm.ColumnName)
                        {
                            row.Add("1.0");
                            continue;
                        }
                        //string sim = "0";
                        var sim = getSimilarity(colname, clm.ColumnName);
                        //var sim = "0";
                        row.Add(sim);

                    }
                    var str = row.ToArray();
                    dsgridbetCol.Rows.Add(str);
                }
                grColumnRel.DataSource = dsgridbetCol;
                grColumnRel.DataBind();
            }
        }

        static String ENDPOINT = "https://api.apitore.com/api/8/word2vec-neologd-jawiki/similarity";
        static String ACCESS_TOKEN = "b15f2e8b-8986-46cb-8c73-36e76a483c51";

        public string getSimilarity(string word1, string word2)
        {
            String url = ENDPOINT + "?access_token=" + ACCESS_TOKEN + "&word1=" + word1 + "&word2=" + word2;
            //params.put("word1", "ポメラニアン");
            //params.put("word2", "ゴールデンレトリバー");
            //String url = UrlFormatter.format(ENDPOINT, params);

            // HTTPアクセス
            var req = WebRequest.Create(url);
            req.Headers.Add("Accept-Language:ja,en-us;q=0.7,en;q=0.3");
            var res = req.GetResponse();

            Encoding enc = Encoding.GetEncoding("UTF-8");
            //Stream st = res.GetResponseStream();

            //StreamReader sr = new StreamReader(st, enc);
            //string xml = sr.ReadToEnd();

            // レスポンス(JSON)をオブジェクトに変換
            ServiceResult info;
            using (res)
            {
                using (var resStream = res.GetResponseStream())
                {
                    var serializer = new DataContractJsonSerializer(typeof(ServiceResult));
                    info = (ServiceResult)serializer.ReadObject(resStream);
                }
            }

            Decimal tmpDecimal = Decimal.Parse(info.similarity);
            tmpDecimal = Math.Round(tmpDecimal, 2, MidpointRounding.AwayFromZero);
            return tmpDecimal.ToString();
        }

        [DataContract]
        public class ServiceResult
        {

            [DataMember]
            public string log { get; set; }
            [DataMember]
            public string startTime { get; set; }
            [DataMember]
            public string endTime { get; set; }
            [DataMember]
            public string processTime { get; set; }
            [DataMember]
            public string word1 { get; set; }
            [DataMember]
            public string word2 { get; set; }
            [DataMember]
            public string similarity { get; set; }
        }
    }
}