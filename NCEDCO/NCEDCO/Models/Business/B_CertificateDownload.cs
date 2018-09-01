﻿using NCEDCO.Models.Utility;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;

namespace NCEDCO.Models.Business
{
    public class B_CertificateDownload
    {
        string Connection_ = ConfigurationManager.ConnectionStrings["NCEDCOConnectionString"].ToString();

        public List<M_CDownload> getCertificateDownload(string RequestId,
                                                        string CustID,
                                                        string certID, string seal, string invoiceNo,string ParentId)
        {
            try
            {

                List<M_CDownload> lstpackage = new List<M_CDownload>();
                using (DBLinqDataContext datacontext = new DBLinqDataContext())
                {
                    datacontext.Connection.ConnectionString = Connection_;
                    System.Data.Linq.ISingleResult<_getDownloadCertificateResult> lst = datacontext._getDownloadCertificate(RequestId,
                                                                                                                            CustID, 
                                                                                                                            certID, 
                                                                                                                            seal, 
                                                                                                                            invoiceNo,
                                                                                                                            ParentId);
                    foreach (_getDownloadCertificateResult result in lst)
                    {
                        M_CDownload cd = new M_CDownload();
                        if (result.SealRequired == "True"){cd.IsStamped = "Yes";}
                        else{ cd.IsStamped = "No"; }
                        cd.IsDownloaded = result.IsDownloaded;
                        cd.RequestBy = result.CreatedBy;
                        cd.RefNo = result.CertificateId;
                        cd.CertPath = result.CertificatePath;
                        cd.IsDownloaded = result.IsDownloaded;
                        cd.IsPrinted = result.IsDownloaded;
                        cd.RequestID = result.RequestId;
                        cd.ClientName = result.CustomerName;
                        cd.ReqType = result.Ctype;

                        cd.ApproveDate = result.CreatedDate.ToString("dd/MMM/yy");
                        cd.RequestDate = result.RequestDate.ToString("dd/MMM/yy");
                        cd.InvoiceNo = result.InvoiceNo;
                        cd.ApprovedBy = result.created;
                        cd.ParentN = result.ParentName;
                        cd.CertPath = result.CertificatePath;
                        lstpackage.Add(cd);

                    }
                }

                return lstpackage;
            }
            catch (Exception ex)
            {
                ErrorLog.LogError(ex);
                return null;
            }


        }

        public List<M_SupportDocument> getCertificateSupportDocs(string CertificateId)
        {
            try
            {

                List<M_SupportDocument> lstpackage = new List<M_SupportDocument>();
                using (DBLinqDataContext datacontext = new DBLinqDataContext())
                {
                    datacontext.Connection.ConnectionString = Connection_;
                    System.Data.Linq.ISingleResult<_getSignedCertificateSupportDocResult> lst = datacontext._getSignedCertificateSupportDoc(CertificateId);

                    foreach (_getSignedCertificateSupportDocResult result in lst)
                    {
                        M_SupportDocument cd = new M_SupportDocument();
                        cd.Download_Path = result.DPath;
                        cd.Certificate_RequestId = result.RequestRefNo;
                        cd.SupportingDocument_Name = result.Dname;
                        cd.SupportingDocument_Id = result.DId;
                        cd.Status_ = result.IsSigned;
                        lstpackage.Add(cd);

                    }
                }

                return lstpackage;
            }
            catch (Exception ex)
            {
                ErrorLog.LogError(ex);
                return null;
            }


        }
    }
}