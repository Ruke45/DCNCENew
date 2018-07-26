using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;

namespace NCEDCO.Models.Utility
{
    public class ExportSector
    {
        string Connection_ = ConfigurationManager.ConnectionStrings["NCEDCOConnectionString"].ToString();
        public List<M_ExportSector> getAllExportSector(string status)
        {
            try
            {

                List<M_ExportSector> Requests = new List<M_ExportSector>();
                using (DBLinqDataContext datacontext = new DBLinqDataContext())
                {
                    datacontext.Connection.ConnectionString = Connection_;
                    System.Data.Linq.ISingleResult<_getAllExportSectorResult> lst = datacontext._getAllExportSector(status);
                    foreach (_getAllExportSectorResult result in lst)
                    {
                        M_ExportSector req = new M_ExportSector();
                        req.ExportSectorId = Convert.ToInt32(result.ExportId);
                        req.ExportSectorName= result.ExportSector;
                        Requests.Add(req);
                    }
                }

                return Requests;
            }
            catch (Exception ex)
            {
                ErrorLog.LogError(ex);
                return null;
            }


        }
    }
}