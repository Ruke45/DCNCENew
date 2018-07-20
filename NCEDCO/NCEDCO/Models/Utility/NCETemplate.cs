using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;

namespace NCEDCO.Models.Utility
{
    public class NCETemplate
    {
        string Connection_ = ConfigurationManager.ConnectionStrings["NCEDCOConnectionString"].ToString();
        public List<M_NCETemplate> getTemplateData(string TempID, String IsActive, string ViewAdminOnly)
        {
            try
            {

                List<M_NCETemplate> listTemplate = new List<M_NCETemplate>();
                using (DBLinqDataContext datacontext = new DBLinqDataContext())
                {
                    datacontext.Connection.ConnectionString = Connection_;
                    System.Data.Linq.ISingleResult<DCISgetTemplateHeaderResult> lst = datacontext.DCISgetTemplateHeader(TempID, IsActive,ViewAdminOnly);

                    foreach (DCISgetTemplateHeaderResult result in lst)
                    {
                        M_NCETemplate th = new M_NCETemplate();
                        th.Template_Id = result.TemplateId;
                        th.Template_Name = result.TemplateName;
                        th.Description_ = result.Description;
                        th.Img_Url = result.ImgUrl;
                        th.Is_Active = result.IsActive;

                        listTemplate.Add(th);

                    }
                }

                return listTemplate;
            }
            catch (Exception ex)
            {
                ErrorLog.LogError(ex);
                return null;
            }


        }

        public M_NCETemplate getTemplateData(string TempID, String IsActive)
        {
            try
            {
                M_NCETemplate th = new M_NCETemplate();
                using (DBLinqDataContext datacontext = new DBLinqDataContext())
                {
                    datacontext.Connection.ConnectionString = Connection_;
                    System.Data.Linq.ISingleResult<DCISgetTemplateHeaderResult> lst = datacontext.DCISgetTemplateHeader(TempID, IsActive,"%");

                    foreach (DCISgetTemplateHeaderResult result in lst)
                    {
                        
                        th.Template_Id = result.TemplateId;
                        th.Template_Name = result.TemplateName;
                        th.Description_ = result.Description;
                        th.Img_Url = result.ImgUrl;
                        th.Is_Active = result.IsActive;

                    }
                }

                return th;
            }
            catch (Exception ex)
            {
                ErrorLog.LogError(ex);
                return null;
            }


        }
    }
}