using NCEDCO.Models.Utility;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;

namespace NCEDCO.Models.Business
{
    public class B_CertificateRequest
    {
        string Connection_ = ConfigurationManager.ConnectionStrings["NCEDCOConnectionString"].ToString();

        public List<M_SupportDocument> getTemplateSupportingDocs(string ClientId, string TemplateId)
        {
            try
            {

                List<M_SupportDocument> lstSD = new List<M_SupportDocument>();
                using (DBLinqDataContext datacontext = new DBLinqDataContext())
                {
                    datacontext.Connection.ConnectionString = Connection_;
                    System.Data.Linq.ISingleResult<_getSupportingDOCforRequestResult> lst = datacontext._getSupportingDOCforRequest(ClientId,TemplateId);

                    foreach (_getSupportingDOCforRequestResult result in lst)
                    {
                        M_SupportDocument SD = new M_SupportDocument();
                        SD.SupportingDocument_Id = result.SupportingDocumentId;
                        SD.SupportingDocument_Name = result.SupportingDocumentName;
                        SD.Is_Mandatory = result.IsMandatory;
                        SD.Template_Id = result.TemplateId;
                        lstSD.Add(SD);

                    }
                }

                return lstSD;
            }
            catch (Exception ex)
            {
                ErrorLog.LogError(ex);
                return null;
            }


        }
    }
}