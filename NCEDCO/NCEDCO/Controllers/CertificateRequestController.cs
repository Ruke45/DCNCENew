using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using NCEDCO.Models;
using NCEDCO.Models.Business;
using NCEDCO.Models.Business.Template;
using System.IO;

namespace NCEDCO.Controllers
{
    public class CertificateRequestController : Controller
    {
        B_CertificateRequest objCr = new B_CertificateRequest();

        string HSCODEHAS = System.Configuration.ConfigurationManager.AppSettings["HSCODEHAS"];
        string GOLOBALTMP = System.Configuration.ConfigurationManager.AppSettings["GOLOBALTMP"];
        string MASSACTIVE = System.Configuration.ConfigurationManager.AppSettings["MASSACTIVE"];
        string NINDROTMP = System.Configuration.ConfigurationManager.AppSettings["NINDROTMP"];
        string ROWWITHOUTHS = System.Configuration.ConfigurationManager.AppSettings["ROWWITHOUTHS"];
        string ROWWITH_HS = System.Configuration.ConfigurationManager.AppSettings["ROWWITH_HS"];
        string COLUMNWITHOUTHS = System.Configuration.ConfigurationManager.AppSettings["COLUMNWITHOUTHS"];
        string COLUMNWITHOUTHS2 = System.Configuration.ConfigurationManager.AppSettings["COLUMNWITHOUTHS2"];

        public ActionResult Index()
        {
            List<M_CertificateRefferance> ReffList = objCr.getRefferenceCRequest("PC3");
            ViewBag.Bag_RefferenceRequ = new SelectList(ReffList, "RequestId", "Consignee");

            List<M_Customer> ClientList = objCr.getCustomerClients("PC3");
            ViewBag.Bag_ClientsofCustomer = new SelectList(ClientList, "ClientId", "Customer_Name");

            return View();
        }

        [HttpPost]
        public ActionResult Index(M_Cerificate Model)
        {
            B_CertificateRequest objCreq = new B_CertificateRequest();

            string r = "Error";
            Model.Createdby = "ADMIN";
            Model.ParentId = "PC3";
            Model.Status = "P";

            string reff = objCreq.setCertificateRequest(Model);
            if (reff != null)
            {
                var DocumentUpload = Model.Support_Docs;
                if (DocumentUpload != null)
                {
                    string DirectoryPath = "~/Uploads/Web_SDcouments/" +
                                    DateTime.Now.ToString("yyyy") +
                                    "/" + DateTime.Now.ToString("MMM") + "/" + DateTime.Now.ToString("dd") + "/" + reff;
                    if (!Directory.Exists(Server.MapPath(DirectoryPath)))
                    {
                        Directory.CreateDirectory(Server.MapPath(DirectoryPath));
                    }
                    foreach (var Doc in DocumentUpload)
                    {
                        string strFileUpload = "file_" + Doc.SupportingDocument_Id;
                        HttpPostedFileBase file = Request.Files[strFileUpload];

                        if (file != null && file.ContentLength > 0)
                        {
                            var fileName = Path.GetFileName(file.FileName.Replace(" ", "_"));
                            var path = Path.Combine(Server.MapPath(DirectoryPath), fileName);

                            M_SupportDocumentUpload Su = new M_SupportDocumentUpload();
                            Su.RequestRefNo = reff;
                            Su.SignatureRequired = false;
                            Su.SupportingDocumentID = Doc.SupportingDocument_Id;
                            Su.UploadedBy = "Admin";
                            Su.UploadedPath = DirectoryPath + "/" + fileName;
                            Su.DocumentName = fileName;
                            if (Doc.Signature_Required)
                            {
                                Su.SignatureRequired = true;
                                Su.Remarks = "NCE_Certification";
                            }
                            else { Su.SignatureRequired = false; }
                            objCreq.setSupportingDocumentFRequest(Su);
                            file.SaveAs(path);


                        }
                    }
                }
                CreateSample(Model, reff);
                ViewBag._Result = "Succes";
                r = "Succes";
            }

            var result = new { Msg = r, Cid = Model.Client_Id, RqId = reff };
            return Json(result, JsonRequestBehavior.AllowGet);
        }

        public ActionResult LoadRefferenceCR(string Reff)
        {
            M_Cerificate C = new M_Cerificate();
            C = objCr.getCleintNTemplate(Reff, "PC3");
            C.Support_Docs = objCr.getTemplateSupportingDocs(C.Client_Id, C.TemplateId);
            C.SealRequired = true;
            return PartialView("P_CertificateRequstForm", C);
        }

        public ActionResult LoadRefferenceByReq(string Reff)
        {
            M_Cerificate C = new M_Cerificate();
            C = objCr.getSavedCertificateRequest(Reff);
            C.Support_Docs = objCr.getTemplateSupportingDocs(C.Client_Id, C.TemplateId);
            C.SealRequired = true;
            return PartialView("P_CertificateRequstForm", C);
        }

        public void CreateSample(M_Cerificate Model, string Reff)
        {
            bool Created = false;
            string Template = Model.TemplateId;

            string LogoPath = Server.MapPath("~/Images/NCELOGO.PNG"); // NCE Certificate logo Image path
            string DirectoryPath = "~/Temp/" + DateTime.Now.ToString("yyyy")
                                    + "/Web_Certificates/" + DateTime.Now.ToString("MMM") + "/" + DateTime.Now.ToString("dd") + "/" + Reff;

            //HeaderR.Customer_Telephone = usrSessiong.Telephone_;
            //HeaderR.CustomerName1 = usrSessiong.Customer_Name;

            //DirectoryPath which will save the NOT singed PDF File as NOT_Signed.pdf in the given Path
            if (!Directory.Exists(Server.MapPath(DirectoryPath)))
            {
                Directory.CreateDirectory(Server.MapPath(DirectoryPath));
            }

            /**PDF Cerator 
             * Parameters
             * M_Certificate
             * Document Save Path
             * 
            */
            if (Template.Equals(ROWWITH_HS))
            {
                RowWithHSTemplate Certificate =
                new RowWithHSTemplate(Reff, Model, LogoPath,
                Server.MapPath(DirectoryPath + "/" + Reff + "_Sample.pdf"), "", "");

                Created = Certificate.CreateCertificate("");
            }
            else if (Template.Equals(ROWWITHOUTHS))
            {
                RowWithoutHSTemplate Certificate =
                new RowWithoutHSTemplate(Reff, Model, LogoPath,
                Server.MapPath(DirectoryPath + "/" + Reff + "_Sample.pdf"), "", "");

                Created = Certificate.CreateCertificate("");
            }
            else if (Template.Equals(GOLOBALTMP))
            {
                OrientGlobalCertificateTemplate Certificate =
                new OrientGlobalCertificateTemplate(Reff, Model, LogoPath,
                Server.MapPath(DirectoryPath + "/" + Reff + "_Sample.pdf"), "", "");

                Created = Certificate.CreateCertificate("");
            }
            else if (Template.Equals(MASSACTIVE))
            {
                MassActiveCertificateTemplate Certificate =
                new MassActiveCertificateTemplate(Reff, Model, LogoPath,
                Server.MapPath(DirectoryPath + "/" + Reff + "_Sample.pdf"), "", "");

                Created = Certificate.CreateCertificate("");
            }
            else if (Template.Equals(NINDROTMP))
            {
                NidroCertificateTemplate Certificate =
                new NidroCertificateTemplate(Reff, Model, LogoPath,
                Server.MapPath(DirectoryPath + "/" + Reff + "_Sample.pdf"), "", "");

                Created = Certificate.CreateCertificate("");
            }
            else if (Template.Equals(COLUMNWITHOUTHS))
            {
                ColumnWithoutHSTemplate Certificate =
                new ColumnWithoutHSTemplate(Reff, Model, LogoPath,
                Server.MapPath(DirectoryPath + "/" + Reff + "_Sample.pdf"), "", "");

                Created = Certificate.CreateCertificate("");
            }
            else if (Template.Equals(COLUMNWITHOUTHS2))
            {
                ColumnWithoutHSTemplate Certificate =
                new ColumnWithoutHSTemplate(Reff, Model, LogoPath,
                Server.MapPath(DirectoryPath + "/" + Reff + "_Sample.pdf"), "", "");

                Created = Certificate.CreateCertificate("");
            }
            else
            {
                ColumnWithHSTemplate Certificate =
                new ColumnWithHSTemplate(Reff, Model, LogoPath,
                Server.MapPath(DirectoryPath + "/" + Reff + "_Sample.pdf"), "", "");

                Created = Certificate.CreateCertificate("");
            }
            if (Created)
            {
                objCr.setWebBasedCertificateCreation(Reff,
                    DirectoryPath + "/" + Reff + "_Sample_Cert.pdf",
                    Reff + "_Sample_Cert.pdf");
            }
        }

        public ActionResult Upload()
        {
            List<M_Customer> ClientList = objCr.getCustomerClients("PC3");
            ViewBag.Bag_ClientsofCustomer = new SelectList(ClientList, "ClientId", "Customer_Name");

            return View();
        }

        public ActionResult LoadUBTemplate(string Reff)
        {
            M_Cerificate C = new M_Cerificate();
            C = objCr.getCleintNTemplate(Reff, "PC3");
            C.Support_Docs = objCr.getTemplateSupportingDocs(C.Client_Id, C.TemplateId);
            C.SealRequired = true;
            return PartialView("P_UploadBaseCRequest", C);
        }

        [HttpPost]
        public JsonResult Upload(M_Cerificate Model)
        {

            string r = "Error";
            Model.Createdby = "ADMIN";
            Model.ParentId = "PC3";
            Model.Status = "P";

            string CertificateFile = "Certificate_File";
            HttpPostedFileBase Cfile = Request.Files[CertificateFile];


            string DirectoryPath = "~/Uploads/" + DateTime.Now.ToString("yyyy")
                                        + "/Upload_Certificates/" + DateTime.Now.ToString("MMM") + "/" + DateTime.Now.ToString("dd") + "/";

            Model.CertificateUploadPath = DirectoryPath;
            string reff = string.Empty;

            if (Cfile != null && Cfile.ContentLength > 0)
            {
                reff = objCr.setUploadBasedCertificateRequest(Model, Cfile.FileName.Replace(" ", "_"));

                if (reff != null)
                {
                    DirectoryPath = DirectoryPath + reff;
                    if (!Directory.Exists(Server.MapPath(DirectoryPath)))
                    {
                        Directory.CreateDirectory(Server.MapPath(DirectoryPath));
                    }
                    var DocumentUpload = Model.Support_Docs;
                    if (DocumentUpload != null)
                    {
                        string UDirectoryPath = "~/Uploads/" + DateTime.Now.ToString("yyyy") + "/Upload_CSDcouments/"
                                                   + DateTime.Now.ToString("MMM") + "/" + DateTime.Now.ToString("dd") + "/" + reff;

                        if (!Directory.Exists(Server.MapPath(UDirectoryPath)))
                        {
                            Directory.CreateDirectory(Server.MapPath(UDirectoryPath));
                        }
                        foreach (var Doc in DocumentUpload)
                        {
                            string strFileUpload = "file_" + Doc.SupportingDocument_Id;
                            HttpPostedFileBase Ufile = Request.Files[strFileUpload];

                            if (Ufile != null && Ufile.ContentLength > 0)
                            {
                                var fileName = Path.GetFileName(Ufile.FileName.Replace(" ", "_"));
                                var path = Path.Combine(Server.MapPath(UDirectoryPath), fileName);

                                M_SupportDocumentUpload Su = new M_SupportDocumentUpload();
                                Su.RequestRefNo = reff;
                                Su.SignatureRequired = false;
                                Su.SupportingDocumentID = Doc.SupportingDocument_Id;
                                Su.UploadedBy = "Admin";
                                Su.UploadedPath = UDirectoryPath + "/" + fileName;
                                Su.DocumentName = fileName;
                                if (Doc.Signature_Required)
                                {
                                    Su.SignatureRequired = true;
                                    Su.Remarks = "NCE_Certification";
                                }
                                else { Su.SignatureRequired = false; }

                                objCr.setSupportingDocumentFRequest(Su);

                                Ufile.SaveAs(path);
                            }
                        }
                    }
                    var CfileName = Path.GetFileName(Cfile.FileName.Replace(" ", "_"));
                    var Cpath = Path.Combine(Server.MapPath(DirectoryPath), CfileName);
                    Cfile.SaveAs(Cpath);
                    r = "Succes";
                }
            }
            var result = new { Msg = r, Cid = Model.Client_Id, RqId = reff};
            return Json(result, JsonRequestBehavior.AllowGet);
        }

        public ActionResult Supporting()
        {
            B_Settings objSet = new B_Settings();

            List<M_Customer> ClientList = objCr.getCustomerClients("PC3");
            ViewBag.Bag_ClientsofCustomer = new SelectList(ClientList, "ClientId", "Customer_Name");

            List<M_SupportDocument> SupList = objSet.SDocument_getSDcouments("%", "Y");
            ViewBag.Bag_Supportdoc = new SelectList(SupList, "SupportingDocument_Id", "SupportingDocument_Name");

            return View();
        }

        [HttpPost]
        public JsonResult Supporting(M_SupportDocumentUpload Model)
        {

            string r = "Error";

            string DirectoryPath = "~/Uploads/" + DateTime.Now.ToString("yyyy") 
                                    + "/Upload_ASDcouments/" + DateTime.Now.ToString("MMM") + "/" + DateTime.Now.ToString("dd");

            string SDocument_file = "Document_File";
            HttpPostedFileBase Cfile = Request.Files[SDocument_file];

            Model.UploadedBy = "ADMIN"; // Client's User;
            Model.Status = "P";
            Model.UploadedPath = DirectoryPath;
            Model.DocumentName = Cfile.FileName.Replace(" ", "_");

            string reff = string.Empty;
            if (Cfile != null && Cfile.ContentLength > 0)
            {
                reff = objCr.setSupportingDocSignRequest(Model);
                if (reff != null)
                {
                    DirectoryPath = DirectoryPath + "/" + reff; 
                    if (!Directory.Exists(Server.MapPath(DirectoryPath)))
                    {
                        Directory.CreateDirectory(Server.MapPath(DirectoryPath));
                    }
                    var CfileName = Path.GetFileName(Cfile.FileName.Replace(" ", "_"));
                    var Cpath = Path.Combine(Server.MapPath(DirectoryPath), CfileName);
                    Cfile.SaveAs(Cpath);
                    r = "Succes";
                }
            }           
            var result = new { Msg = r, RqId = reff };
            return Json(result, JsonRequestBehavior.AllowGet);
        }
    }
}
