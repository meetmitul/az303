using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Serialization;
using Microsoft.AspNetCore;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;

namespace aspnet_core_dotnet_core
{
    public class Program
    {
        public static void Main(string[] args)
        {
            //System.Data.DataSet ds = new System.Data.DataSet();
            //ds.Tables.Add("Table1");
            //ds.Tables["Table1"].Columns.Add("Name");
            //ds.Tables["Table1"].Rows.Add("Mitul");
            //ds.Tables["Table1"].Rows.Add("Patel");
            //ds.AcceptChanges();
            ////make change
            //ds.Tables["Table1"].Rows[1][0] = "NewPatel";
            //MemoryStream s = new MemoryStream();
            //ds.WriteXml(s,XmlWriteMode.IgnoreSchema);
            //byte[] byteArray = s.ToArray();
            //MemoryStream newstream = new MemoryStream(byteArray);
            //XmlSerializer serialiser = new XmlSerializer(typeof(DataSet));
            //Object newDS = (DataSet)serialiser.Deserialize(newstream);

            CreateWebHostBuilder(args).Build().Run();
        }

        public static IWebHostBuilder CreateWebHostBuilder(string[] args) =>
            WebHost.CreateDefaultBuilder(args)
                .UseStartup<Startup>();
    }
}
