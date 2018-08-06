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

        public List<M_CertificateRefferance> getRefferenceCRequest(string PCID)
        {
            try
            {

                List<M_CertificateRefferance> lstSD = new List<M_CertificateRefferance>();
                using (DBLinqDataContext datacontext = new DBLinqDataContext())
                {
                    datacontext.Connection.ConnectionString = Connection_;
                    System.Data.Linq.ISingleResult<getCustomerConsigneesReffResult> lst = datacontext.getCustomerConsigneesReff(PCID);

                    foreach (getCustomerConsigneesReffResult result in lst)
                    {
                        M_CertificateRefferance SD = new M_CertificateRefferance();
                        SD.Consignee = result.Consignee;
                        SD.RequestId = result.RequestId;
                        SD.TemplateName = result.TemplateName;
                        SD.SeqNo = result.SeqNo;
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

        public List<M_Customer> getCustomerClients(string PCID)
        {
            try
            {

                List<M_Customer> lstSD = new List<M_Customer>();
                using (DBLinqDataContext datacontext = new DBLinqDataContext())
                {
                    datacontext.Connection.ConnectionString = Connection_;
                    System.Data.Linq.ISingleResult<getCustomerClientListResult> lst = datacontext.getCustomerClientList(PCID);

                    foreach (getCustomerClientListResult result in lst)
                    {
                        M_Customer SD = new M_Customer();
                        SD.TemplateId = result.TemplateId;
                        SD.Customer_Name = result.CustomerName;
                        SD.ClientId = result.CustomerId;
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

        public M_Cerificate getCleintNTemplate(string CustomerId, string ParentId)
        {
            try
            {

                M_Cerificate Cu = new M_Cerificate();
                using (DBLinqDataContext datacontext = new DBLinqDataContext())
                {
                    datacontext.Connection.ConnectionString = Connection_;
                    var lst = datacontext.getClientTemplateNName(CustomerId,ParentId).SingleOrDefault();
                    if (lst != null)
                    {
                        Cu.Consignor_Exporter = lst.CustomerName;
                        Cu.TemplateId = lst.TemplateId;
                        Cu.Client_Id = lst.CustomerId;
 
                    }
                }

                return Cu;
            }
            catch (Exception ex)
            {
                ErrorLog.LogError(ex);
                return null;
            }


        }
    }
}