using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using NCEDCO.Models;
using NCEDCO.Models.Business;
using NCEDCO.Models.Business.Template;
using NCEDCO.Models.Business.Signature;
using System.IO;
using NCEDCO.Filters;
using NCEDCO.Models.Utility;
using System.Transactions;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Net;
using Newtonsoft.Json;
using System.Web.Script.Serialization;


namespace NCEDCO.Controllers
{
    public class CertificateRequestController : Controller
    {
        B_CertificateRequest objCr = new B_CertificateRequest();
        B_CertificateApprove objAprv = new B_CertificateApprove();
        B_SupportDocApprove objSDAprv = new B_SupportDocApprove();
        B_CertificateDownload objDown = new B_CertificateDownload();
        M_Cerificate CRHeader = new M_Cerificate();
        _USession _session = new _USession();

        List<M_SupportDocumentUpload> SupList = new List<M_SupportDocumentUpload>();

        string HSCODEHAS = System.Configuration.ConfigurationManager.AppSettings["HSCODEHAS"];
        string GOLOBALTMP = System.Configuration.ConfigurationManager.AppSettings["GOLOBALTMP"];
        string MASSACTIVE = System.Configuration.ConfigurationManager.AppSettings["MASSACTIVE"];
        string NINDROTMP = System.Configuration.ConfigurationManager.AppSettings["NINDROTMP"];
        string ROWWITHOUTHS = System.Configuration.ConfigurationManager.AppSettings["ROWWITHOUTHS"];
        string ROWWITH_HS = System.Configuration.ConfigurationManager.AppSettings["ROWWITH_HS"];
        string COLUMNWITHOUTHS = System.Configuration.ConfigurationManager.AppSettings["COLUMNWITHOUTHS"];
        string COLUMNWITHOUTHS2 = System.Configuration.ConfigurationManager.AppSettings["COLUMNWITHOUTHS2"];

        string CertificateLOGO = System.Configuration.ConfigurationManager.AppSettings["CertificateLOGO"];
        string CertificateSEAL = System.Configuration.ConfigurationManager.AppSettings["CertificateSEAL"];

        /* ------- Certificate Request Methods -------*/

        [UserFilter(Function_Id = "F_CERT_REQUST")]
        public ActionResult Index()
        {
            List<M_CertificateRefferance> ReffList = objCr.getRefferenceCRequest(_session.Customer_ID);
            ViewBag.Bag_RefferenceRequ = new SelectList(ReffList, "RequestId", "Consignee");

            List<M_Customer> ClientList = objCr.getCustomerClients(_session.Customer_ID);
            ViewBag.Bag_ClientsofCustomer = new SelectList(ClientList, "ClientId", "Customer_Name");

            return View();
        }

        [UserFilter(Function_Id = "F_CERT_REQUST")]
        [HttpPost]
        public ActionResult Index(M_Cerificate Model)
        {
            B_CertificateRequest objCreq = new B_CertificateRequest();

            string r = "Error";
            Model.Createdby = _session.User_Id;
            Model.ParentId = _session.Customer_ID;
            Model.Status = "G";/// need to be change if the save certificate implemented including the CreateSample()

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
                            Su.UploadedBy = _session.User_Id;
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
            C = objCr.getCleintNTemplate(Reff, _session.Customer_ID);
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
                    DirectoryPath + "/" + Reff + "_Sample.pdf",
                    Reff + "_Sample.pdf");
            }
        }

        [UserFilter(Function_Id = "F_CERT_UPLOD")]
        public ActionResult Upload()
        {
            List<M_Customer> ClientList = objCr.getCustomerClients(_session.Customer_ID);
            ViewBag.Bag_ClientsofCustomer = new SelectList(ClientList, "ClientId", "Customer_Name");

            return View();
        }

        public ActionResult LoadUBTemplate(string Reff)
        {
            M_Cerificate C = new M_Cerificate();
            C = objCr.getCleintNTemplate(Reff, _session.Customer_ID);
            C.Support_Docs = objCr.getTemplateSupportingDocs(C.Client_Id, C.TemplateId);
            C.SealRequired = true;
            return PartialView("P_UploadBaseCRequest", C);
        }

        [UserFilter(Function_Id = "F_CERT_UP")]
        [HttpPost]
        public JsonResult Upload(M_Cerificate Model)
        {

            string r = "Error";
            Model.Createdby = _session.User_Id;
            Model.ParentId = _session.Customer_ID;
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
                                Su.UploadedBy = _session.User_Id;
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

        [UserFilter(Function_Id = "F_SUPORT_UPLOD")]
        public ActionResult Supporting()
        {
            B_Settings objSet = new B_Settings();

            List<M_Customer> ClientList = objCr.getCustomerClients(_session.Customer_ID);
            ViewBag.Bag_ClientsofCustomer = new SelectList(ClientList, "ClientId", "Customer_Name");

            List<M_SupportDocument> SupList = objSet.SDocument_getSDcouments("%", "Y");
            ViewBag.Bag_Supportdoc = new SelectList(SupList, "SupportingDocument_Id", "SupportingDocument_Name");

            return View();
        }

        [UserFilter(Function_Id = "F_SUPORT_UPLOD")]
        [HttpPost]
        public JsonResult Supporting(M_SupportDocumentUpload Model)
        {

            string r = "Error";

            string DirectoryPath = "~/Uploads/" + DateTime.Now.ToString("yyyy") 
                                    + "/Upload_ASDcouments/" + DateTime.Now.ToString("MMM") + "/" + DateTime.Now.ToString("dd");

            string SDocument_file = "Document_File";
            HttpPostedFileBase Cfile = Request.Files[SDocument_file];

            Model.UploadedBy = _session.User_Id; // Client's User;
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

        /* ------- Certificate Request Methods -------*/

        /* ------- Certificate Approval Methods -------*/

        [UserFilter(Function_Id = "F_CERT_APRUV")]
        public ActionResult Pending()
        {
            return View(objCr.getAllPendingCertificateRequest("%"));
        }

        [UserFilter(Function_Id = "F_CERT_APRUV")]
        public ActionResult ApproveC(string Req, string Ctyp)
        {
            bool r = false;
            if (_session.C_Password != "")
            {
                if (Ctyp.Equals("W"))
                {
                    CRHeader = objCr.getSavedCertificateRequest(Req);
                    SupList = objCr.getSupportingDOCfRequest(Req);
                    r = CreateCertificate(CRHeader.TemplateId);
                    
                }
                else if (Ctyp.Equals("U"))
                {
                    CRHeader = objCr.getUploadedCertificateRequest(Req);
                    SupList = objCr.getSupportingDOCfRequest(Req);
                    r = Approve_UCertificateRequest(CRHeader.Client_Id,
                                                         CRHeader.RequestReff,
                                                         CRHeader.CertificateUploadPath,
                                                         CRHeader.SealRequired);
                }
                if (r)
                {
                    return RedirectToAction("Pending", "CertificateRequest");
                }
                else
                {
                    return PartialView("P_Error");
                }
                
            }
            ViewBag.A_ID = Req;
            ViewBag.A_Type = Ctyp;
            return PartialView("P_SignatoryPassword");
        }

        private bool Approve_UCertificateRequest(string CustomerID, string RequestID, string CerificatePath, bool SealReqired)
        {
            using (TransactionScope transactionScope = new TransactionScope())
            {
                try
                {

                    B_RecordSequence seqmanager = new B_RecordSequence();
                    string Certificate_No = "CE" + seqmanager.getNextSequence("CertificateSign").ToString();

                    string DirectoryPath = "~/Documents/" + DateTime.Now.ToString("yyyy")
                                            + "/Issued_Certificates/" + DateTime.Now.ToString("MMM") + "/" + DateTime.Now.ToString("dd") + "/"
                                            + Certificate_No;

                    string Tempary_Direct = "~/Temp/" + DateTime.Now.ToString("yyyy")
                                            + "/Issued_Certificates/" + DateTime.Now.ToString("yyyy_MM_dd") + "/"
                                            + Certificate_No;
                    //DirectoryPath which will save the NOT singed PDF File as NOT_Signed.pdf in the given Path
                    if (!Directory.Exists(Server.MapPath(DirectoryPath)))
                    {
                        Directory.CreateDirectory(Server.MapPath(DirectoryPath));
                    }

                    if (!Directory.Exists(Server.MapPath(Tempary_Direct)))
                    {
                        Directory.CreateDirectory(Server.MapPath(Tempary_Direct));
                    }

                    Sign_ SignCertificate = new Sign_();

                    string NotSigned = Server.MapPath(CerificatePath);
                    string CertificateID_Added = Server.MapPath(Tempary_Direct + "/" + "Not_Signed" + "_Certificate.pdf");

                    /* Method Which Create a New Document Withe Printed Certificate ID
                     * Point is the Certificate ID Placement Area Object
                     */
                    System.Drawing.Point Point = new System.Drawing.Point();
                    Point.X = 350;
                    Point.Y = 55;
                    SignCertificate.AddTextToPdf(NotSigned,
                                                 CertificateID_Added,
                                                 Certificate_No,
                                                 Point,
                                                 Server.MapPath(_session.SignatureIMG_Path),
                                                 SealReqired,
                                                 _session.Person_Name);

                    // string NotSigned = Server.MapPath(CerificatePath);
                    string Signed = Server.MapPath(DirectoryPath + "/" + Certificate_No + "_Certificate.pdf");
                    string pathe = Server.MapPath(_session.PFX_path);//From DB
                    //string pathe = Server.MapPath("~/Signature/Samitha/Samitha.pfx");//From DB
                    string SignatureIMG = Server.MapPath(_session.SignatureIMG_Path);// From DB
                    //string SignatureIMG = Server.MapPath("~/Signature/Samitha/Chernenko_Signature.png");// From DB

                    var PFX = new FileStream(pathe, FileMode.OpenOrCreate);

                    //  DCISDBManager.PDFCreator.Signature SignCertificate = new DCISDBManager.PDFCreator.Signature();
                    bool singed = SignCertificate.signCertificate(CertificateID_Added, Signed, PFX, _session.C_Password);
                    if (!singed)
                    {
                        PFX.Close();
                       // lblError.Text = "Wrong password or Corrupted Certificate file.";
                        _session.C_Password = "";
                       // mp2.Show();
                        return false;
                    }


                    M_CertificateApprove Approve = new M_CertificateApprove();
                    Approve.Certificate_Name = Certificate_No + "_Certificate.pdf";
                    Approve.Certificate_Path = DirectoryPath + "/" + Certificate_No + "_Certificate.pdf";
                    //  Approve.Created_By = "SAMITHA";
                    Approve.Created_By = _session.User_Id;
                    Approve.Expiry_Date = DateTime.Today.AddDays(120);
                    Approve.Is_Downloaded = "N";
                    Approve.Is_Valid = "Y";
                    Approve.Request_Id = RequestID;
                    Approve.Certificate_Id = Certificate_No;

                    bool r = objAprv.ApproveUCertificate(Approve);

                    if (!Directory.Exists(Server.MapPath(DirectoryPath + "/Supporting-Doc")))
                    {
                        Directory.CreateDirectory(Server.MapPath(DirectoryPath + "/Supporting-Doc"));
                    }
                    if (!Directory.Exists(Server.MapPath(Tempary_Direct + "/Supporting-Doc")))
                    {
                        Directory.CreateDirectory(Server.MapPath(Tempary_Direct + "/Supporting-Doc"));
                    }


                    for (int i = 0; i < SupList.Count(); i++)
                    {
                        if (SupList[i].Remarks.Equals("NCE_Certification"))
                        {
                            string DocPath = Server.MapPath(DirectoryPath + "/Supporting-Doc/" + SupList[i].DocumentName);
                            string SealedPath = Server.MapPath(Tempary_Direct + "/Supporting-Doc/" + SupList[i].DocumentName);

                            Sign_ SignDoc = new Sign_();

                            SignDoc.AddSealSD(Server.MapPath(SupList[i].UploadedPath), SealedPath, Server.MapPath(_session.SignatureIMG_Path));

                            var PFX2 = new FileStream(pathe, FileMode.OpenOrCreate);

                            bool Sign = SignDoc.signSupportingDoc(Certificate_No,
                                SealedPath,
                                DocPath,
                                PFX2, _session.C_Password);

                            if (!Sign)
                            {
                                PFX.Close();
                                PFX2.Close();
                                _session.C_Password = "";
                                //lblError.Text = "Corrupted Supporting Document file. Signature Placement Failed !";
                                //mp2.Show();
                                return false;
                            }

                            SupList[i].CertifiedDocPathe = DirectoryPath + "/Supporting-Doc/" + SupList[i].DocumentName;
                            SupList[i].Status = "A";
                            SupList[i].ClientId = CustomerID;
                            SupList[i].ApprovedBy = _session.User_Id;
                            SupList[i].ExpiredOn = DateTime.Today.AddDays(Convert.ToInt64(120)).ToString();

                            objSDAprv.setSupportingDocSignRequestINCertRequest(SupList[i]);

                            SupList[i].UploadedPath = DirectoryPath + "/Supporting-Doc/" + SupList[i].DocumentName;

                            objCr.UpdateSupportingDocCertified(SupList[i]);


                        }
                    }
                    transactionScope.Complete();
                    transactionScope.Dispose();

                    return true;
                }

                catch (TransactionAbortedException Ex)
                {
                    transactionScope.Dispose();
                    ErrorLog.LogError(Ex);
                    return false;
                }
                catch (FileNotFoundException Ex)
                {
                    ErrorLog.LogError(Ex);
                    return false;
                }
                catch (FieldAccessException Ex)
                {
                    ErrorLog.LogError(Ex);
                    return false;
                }
                catch (Exception Ex)
                {
                    ErrorLog.LogError(Ex);
                    return false;
                }

            }
        }

        protected bool CreateCertificate(string Template)
        {
            using (TransactionScope transactionScope = new TransactionScope())
            {
                try
                {
                    bool Created = false;
                    B_RecordSequence seqmanager = new B_RecordSequence();
                    string Certificate_No = "CE" + seqmanager.getNextSequence("CertificateSign").ToString();

                    CRHeader.RefferencNo = Certificate_No;

                    string LogoPath = Server.MapPath(CertificateLOGO); // NCE Certificate logo Image path
                    string DirectoryPath = "~/Documents/" + DateTime.Now.ToString("yyyy")
                                            + "/Issued_Certificates/" + DateTime.Now.ToString("MMM") + "/" + DateTime.Now.ToString("dd") + "/"
                                            + Certificate_No;

                    string Tempary_Direct = "~/Temp/" + DateTime.Now.ToString("yyyy")
                                            + "/Issued_Certificates/" + DateTime.Now.ToString("yyyy_MM_dd")
                                            + "/" + Certificate_No;

                    //DirectoryPath which will save the NOT singed PDF File as NOT_Signed.pdf in the given Path
                    if (!Directory.Exists(Server.MapPath(DirectoryPath)))
                    {
                        Directory.CreateDirectory(Server.MapPath(DirectoryPath));
                    }

                    if (!Directory.Exists(Server.MapPath(Tempary_Direct)))
                    {
                        Directory.CreateDirectory(Server.MapPath(Tempary_Direct));
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
                                new RowWithHSTemplate(Certificate_No,
                                                      CRHeader,
                                                      LogoPath,
                                                      Server.MapPath(Tempary_Direct + "/_Not_Signed.pdf"),
                                                      _session.Person_Name, DateTime.Now.ToString("yyyy/MM/dd"));

                        Created = Certificate.CreateCertificate("");
                    }
                    else if (Template.Equals(ROWWITHOUTHS))
                    {
                        RowWithoutHSTemplate Certificate =
                                new RowWithoutHSTemplate(Certificate_No,
                                                         CRHeader,
                                                         LogoPath,
                                                         Server.MapPath(Tempary_Direct + "/_Not_Signed.pdf"),
                                                         _session.Person_Name, DateTime.Now.ToString("yyyy/MM/dd"));

                        Created = Certificate.CreateCertificate("");
                    }
                    else if (Template.Equals(GOLOBALTMP))
                    {
                        OrientGlobalCertificateTemplate Certificate =
                                new OrientGlobalCertificateTemplate(Certificate_No,
                                                      CRHeader,
                                                      LogoPath,
                                                      Server.MapPath(Tempary_Direct + "/_Not_Signed.pdf"),
                                                      _session.Person_Name, DateTime.Now.ToString("yyyy/MM/dd"));

                        Created = Certificate.CreateCertificate("");
                    }
                    else if (Template.Equals(MASSACTIVE))
                    {
                        MassActiveCertificateTemplate Certificate =
                                new MassActiveCertificateTemplate(Certificate_No,
                                                      CRHeader,
                                                      LogoPath,
                                                      Server.MapPath(Tempary_Direct + "/_Not_Signed.pdf"),
                                                      _session.Person_Name, DateTime.Now.ToString("yyyy/MM/dd"));

                        Created = Certificate.CreateCertificate("");
                    }
                    else if (Template.Equals(NINDROTMP))
                    {
                        NidroCertificateTemplate Certificate =
                                new NidroCertificateTemplate(Certificate_No,
                                                      CRHeader,
                                                      LogoPath,
                                                      Server.MapPath(Tempary_Direct + "/_Not_Signed.pdf"),
                                                      _session.Person_Name, DateTime.Now.ToString("yyyy/MM/dd"));

                        Created = Certificate.CreateCertificate("");
                    }
                    else if (Template.Equals(COLUMNWITHOUTHS))
                    {
                       ColumnWithoutHSTemplate Certificate =
                                new ColumnWithoutHSTemplate(Certificate_No,
                                                      CRHeader,
                                                      LogoPath,
                                                      Server.MapPath(Tempary_Direct + "/_Not_Signed.pdf"),
                                                      _session.Person_Name, DateTime.Now.ToString("yyyy/MM/dd"));

                        Created = Certificate.CreateCertificate("");
                    }
                    else if (Template.Equals(COLUMNWITHOUTHS2))
                    {
                        ColumnWithoutHSTemplate Certificate =
                                new ColumnWithoutHSTemplate(Certificate_No,
                                                      CRHeader,
                                                      LogoPath,
                                                      Server.MapPath(Tempary_Direct + "/_Not_Signed.pdf"),
                                                      _session.Person_Name, DateTime.Now.ToString("yyyy/MM/dd"));

                        Created = Certificate.CreateCertificate("");
                    }
                    else
                    {
                        ColumnWithHSTemplate Certificate =
                                new ColumnWithHSTemplate(Certificate_No,
                                                      CRHeader,
                                                      LogoPath,
                                                      Server.MapPath(Tempary_Direct + "/_Not_Signed.pdf"),
                                                      _session.Person_Name, DateTime.Now.ToString("yyyy/MM/dd"));

                        Created = Certificate.CreateCertificate("");
                    }

                    string Sealed = Server.MapPath(Tempary_Direct + "/_Not_Signed.pdf");
                    string NotSigned = Server.MapPath(Tempary_Direct + "/_Not_Signed.pdf"); ;
                    string Signed = Server.MapPath(DirectoryPath + "/" + Certificate_No + "_Certificate.pdf");
                    string pathe = Server.MapPath(_session.PFX_path);//From DB
                    //  string pathe = Server.MapPath("~/Signature/Samitha/Samitha.pfx");//From DB
                    string SignatureIMG = Server.MapPath(_session.SignatureIMG_Path);// From DB
                    //   string SignatureIMG = Server.MapPath("~/Signature/Samitha/sign.JPG");// From DB

                    var PFX = new FileStream(pathe, FileMode.OpenOrCreate);

                    Sign_ SignCertificate = new Sign_();

                    if (Convert.ToBoolean(CRHeader.SealRequired))
                    {
                        SignCertificate.AddSeal(Sealed, Server.MapPath(_session.SignatureIMG_Path));
                        NotSigned = Server.MapPath(Tempary_Direct + "/_Not_Signed_S.pdf");
                    }

                    bool singed = SignCertificate.signCertificate(NotSigned, Signed,
                                                                  PFX, _session.C_Password);
                    if (!singed)
                    {
                        PFX.Close();
                        //mp1.Show();
                        //lblError.Text = "Wrong password or Corrupted Certificate file.";
                        _session.C_Password = "";
                        return false;
                    }

                    M_CertificateApprove Approve = new M_CertificateApprove();
                    Approve.Certificate_Name = Certificate_No + "_Certificate.pdf";
                    Approve.Certificate_Path = DirectoryPath + "/" + Certificate_No + "_Certificate.pdf";
                    // Approve.Created_By = "SAMITHA";
                    Approve.Created_By = _session.User_Id;
                    Approve.Expiry_Date = DateTime.Today.AddDays(120);
                    Approve.Is_Downloaded = "N";
                    Approve.Is_Valid = "Y";
                    Approve.Request_Id = CRHeader.RequestReff;
                    Approve.Certificate_Id = Certificate_No;


                    bool result = objAprv.ApproveCertificate(Approve);

                    if (SupList.Count != 0)
                    {
                        if (!Directory.Exists(Server.MapPath(Tempary_Direct + "/Supporting-Doc")))
                        {
                            Directory.CreateDirectory(Server.MapPath(Tempary_Direct + "/Supporting-Doc"));
                        }

                        if (!Directory.Exists(Server.MapPath(DirectoryPath + "/Supporting-Doc")))
                        {
                            Directory.CreateDirectory(Server.MapPath(DirectoryPath + "/Supporting-Doc"));
                        }
                    }

                    for (int i = 0; i < SupList.Count(); i++)
                    {
                        if (SupList[i].Remarks != null)
                        {
                            if (SupList[i].Remarks.Equals("NCE_Certification"))
                            {
                                string SignedSD = Server.MapPath(DirectoryPath + "/Supporting-Doc/" + SupList[i].DocumentName);
                                string SealedPath = Server.MapPath(Tempary_Direct + "/Supporting-Doc/" + SupList[i].DocumentName);

                                Sign_ SignDoc = new Sign_();

                                SignDoc.AddSealSD(Server.MapPath(SupList[i].UploadedPath), SealedPath, Server.MapPath(_session.SignatureIMG_Path));

                                var PFX2 = new FileStream(pathe, FileMode.OpenOrCreate);

                                bool Sign = SignDoc.signSupportingDoc(Certificate_No,
                                    SealedPath,
                                    SignedSD,
                                    PFX2, _session.C_Password);

                                if (!Sign)
                                {
                                    PFX.Close();
                                    PFX2.Close();
                                    //lblError.Text = "Corrupted Supporting Document file @ " + SupList[i].Request_Ref_No + ":" + SupList[i].Document_Id + ". Signature Placement Failed !";
                                    //mp1.Show();
                                    _session.C_Password = "";
                                    return false;
                                }
                                SupList[i].CertifiedDocPathe = DirectoryPath + "/Supporting-Doc/" + SupList[i].DocumentName;
                                SupList[i].Status = "A";
                                SupList[i].ClientId = CRHeader.Client_Id;
                                SupList[i].ApprovedBy = _session.User_Id;
                                SupList[i].ExpiredOn = DateTime.Today.AddDays(120).ToString();


                                objSDAprv.setSupportingDocSignRequestINCertRequest(SupList[i]);

                                SupList[i].UploadedPath = DirectoryPath + "/Supporting-Doc/" + SupList[i].DocumentName;
                                objCr.UpdateSupportingDocCertified(SupList[i]);


                            }
                        }
                    }

                    transactionScope.Complete();
                    transactionScope.Dispose();
                    return true;

                }
                catch (TransactionAbortedException Ex)
                {
                    transactionScope.Dispose();
                    ErrorLog.LogError(Ex);
                    return false;
                }
                catch (FileNotFoundException Ex)
                {
                    ErrorLog.LogError(Ex);
                    return false;
                }
                catch (FieldAccessException Ex)
                {
                    ErrorLog.LogError(Ex);
                    return false;
                }
                catch (Exception Ex)
                {
                    ErrorLog.LogError(Ex);
                    return false;
                }
            }
        }

        [UserFilter(Function_Id = "F_CERT_APRUV")]
        [HttpPost]
        public JsonResult Approve_Certificate(M_Signatory Model)
        {
            String result = "Error";
            bool r = false;
            _session.C_Password = Model.Password_;
            if (Model.RequestType.Equals("W"))
            {
                CRHeader = objCr.getSavedCertificateRequest(Model.RequestID);
                SupList = objCr.getSupportingDOCfRequest(Model.RequestID);
                r = CreateCertificate(CRHeader.TemplateId);
                
            }
            else if (Model.RequestType.Equals("U"))
            {
                CRHeader = objCr.getUploadedCertificateRequest(Model.RequestID);
                SupList = objCr.getSupportingDOCfRequest(Model.RequestID);
                r = Approve_UCertificateRequest(CRHeader.Client_Id,
                                                     CRHeader.RequestReff,
                                                     CRHeader.CertificateUploadPath,
                                                     CRHeader.SealRequired);
            }
            if (r) { result = "Success"; }
            return Json(result, JsonRequestBehavior.AllowGet);
        }

        [UserFilter(Function_Id = "F_CERT_APRUV")]
        [HttpGet]
        public ActionResult ViewPDF(String ID)
        {
            try
            {
                WebClient user = new WebClient();

                string p = Server.MapPath(ID.ToString());

                Byte[] FileBuffer = user.DownloadData(p);
                if (FileBuffer != null)
                {
                    return File(FileBuffer, "application/pdf");
                }
                else
                {
                    return Content("No file");
                }
            }
            catch (Exception Ex)
            {
                ErrorLog.LogError("Certificate Request View @ CertificateRequest", Ex);
                return Content("Can't Access the Location of the File");
            }
        }

        public ActionResult P_SupportingDoc(string Req)
        {
            return PartialView("P_SupportingDocTbl",objCr.getSupportingDOCfRequest(Req));
        }

        [UserFilter(Function_Id = "F_CERT_APRUV")]
        public ActionResult BulkSign_Model(string IDs)
        {
            ViewBag.A_IDs = IDs;
            return PartialView("P_SignatoryPasswordBulk");
        }

        [UserFilter(Function_Id = "F_CERT_APRUV")]
        [HttpPost]
        public JsonResult BulkSign(M_Signatory Model)
        {
            string result = "Error";
            //var strin = new JavaScriptSerializer().DeserializeObject(Model.RequestID);
            _session.C_Password = Model.Password_;
            var strin = Model.RequestID;
            string[] arr = strin.ToString().Split(',');

            for (int a = 0; a < arr.Length; a++)
            {
                string[] s = arr[a].Split('_');
                if (s[1].Equals("U"))
                {
                    CRHeader = objCr.getUploadedCertificateRequest(s[0]);
                    SupList = objCr.getSupportingDOCfRequest(s[0]);
                    bool r = Approve_UCertificateRequest(CRHeader.Client_Id,
                                                         CRHeader.RequestReff,
                                                         CRHeader.CertificateUploadPath,
                                                         CRHeader.SealRequired);
                    result = r.ToString();
                }
                else if(s[1].Equals("W"))
                {
                    CRHeader = objCr.getSavedCertificateRequest(s[0]);
                    SupList = objCr.getSupportingDOCfRequest(s[0]);
                    bool r = CreateCertificate(CRHeader.TemplateId);
                    result = r.ToString();
                }
            }
            return Json(result, JsonRequestBehavior.AllowGet);
        }

        [UserFilter(Function_Id = "F_CERT_APRUV")]
        public ActionResult RejectC(string Rid, string Ctyp)
        {
            Rejectitem objReject = new Rejectitem();
            string ParentReject_Category = System.Configuration.ConfigurationManager.AppSettings["Certifi_Rject"].ToString();

            List<M_Reject> Rlist = objReject.getReasons(ParentReject_Category);
            
            ViewBag.Bag_RejectReasons = new SelectList(Rlist, "Reject_ReasonId", "Reject_ReasonName");
            ViewBag.Bag_RejectingID = Rid;
            ViewBag.Bag_Ctype = Ctyp;

            return PartialView("P_RejectCertificate");
        }

        [UserFilter(Function_Id = "F_CERT_APRUV")]
        [HttpPost]
        public JsonResult Reject_Certificate(M_Reject Model)
        {
            String result = "Error";
            bool r = false;
            if (Model.Ctype_.Equals("W"))
            {
               r = objAprv.RejectCertificate(Model.Rejecting_ID,
                                          _session.User_Id,
                                          Model.Reject_ReasonId);
            }
            else if (Model.Ctype_.Equals("U"))
            {
               r = objAprv.RejectUBCertificate(Model.Rejecting_ID,
                                            _session.User_Id,
                                            Model.Reject_ReasonId);
            }
            if (r) { result = "Success"; }
            return Json(result, JsonRequestBehavior.AllowGet);
        }

        /* ------- Certificate Approval Methods -------*/

        //public ActionResult ApprovedCertificates()
        //{
        //    return View(objDown.getCertificateDownload("%", "%", "%", "%", "%", "%"));// need to get Session Parent Id
        //}

        [UserFilter(Function_Id = "F_CERT_STTUS")]
        public ActionResult RequestStatus()
        {
            return View();
        }
        public ActionResult getRequestStatus()
        {
            ViewBag.Fdate = DateTime.Now.AddDays(-30).ToString("yyyy/MMM/dd");
            ViewBag.Tdate = DateTime.Now.ToString("yyyy/MMM/dd");
            return PartialView("P_RequestStatus", objCr.getCertificateRequestStatus("%", "%", "%",
                DateTime.Now.AddDays(-30).ToString("yyyyMMdd"), DateTime.Now.ToString("yyyyMMdd"), "%", "%"));
        }

        public ActionResult getRequestStatus_(DateTime fdate, DateTime tdate, string status)
        {
            ViewBag.Fdate = fdate.ToString("yyyy/MMM/dd");
            ViewBag.Tdate = tdate.ToString("yyyy/MMM/dd");
            return PartialView("P_RequestStatus", objCr.getCertificateRequestStatus("%", "%", status,
               fdate.ToString("yyyyMMdd"), tdate.ToString("yyyyMMdd"), "%", "%"));
        }

    }
}
