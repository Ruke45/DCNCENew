using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using NCEDCO.Models.Utility;

namespace NCEDCO.Models.Business
{
    public class B_RecordSequence
    {
        string Connection_ = ConfigurationManager.ConnectionStrings["NCEDCOConnectionString"].ToString();
        public Int64 getNextSequence(string SequenceName, DBLinqDataContext dbContext)
        {
            try
            {
                Int64 SeqNo = 0;
                foreach (var p in dbContext.DCISgetSequence(SequenceName).ToList())
                {
                    SeqNo = Int64.Parse(p.SequesnceValue.ToString());
                }

                return SeqNo;
            }
            catch (Exception ex)
            {
                ErrorLog.LogError(ex);
                Console.WriteLine(ex.Message.ToString());
                return 0;
            }


        }

        public Int64 getNextSequence(string SequenceName)
        {
            try
            {
                DBLinqDataContext dbContext = new DBLinqDataContext();
                dbContext.Connection.ConnectionString = Connection_;
                Int64 SeqNo = 0;
                foreach (var p in dbContext.DCISgetSequence(SequenceName).ToList())
                {
                    SeqNo = Int64.Parse(p.SequesnceValue.ToString());
                }

                return SeqNo;
            }
            catch (Exception ex)
            {
                ErrorLog.LogError(ex);
                return 0;
            }


        }
    }
}