using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using NCEDCO.Models;
using NCEDCO.Models.Business;
using System.IO;

namespace NCEDCO.Controllers
{
    public class CertificateRequestController : Controller
    {
        //
        // GET: /CertificateRequest/
        B_CertificateRequest objCr = new B_CertificateRequest();
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

            string result = "Error";
            Model.Createdby = "ADMIN";
            Model.ParentId = "PC3";
            Model.Status = "P";

            string reff = objCreq.setCertificateRequest(Model);

            string DirectoryPath = "~/Uploads/Web_SDcouments/" + 
                                    DateTime.Now.ToString("yyyy") +
                                    "/" + DateTime.Now.ToString("MM") + "/" + DateTime.Now.ToString("dd") + "/" + reff;
            if (reff != null)
            {
                var DocumentUpload = Model.Support_Docs;
                if (DocumentUpload != null)
                {
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
                            result = "Succes";
                            ViewBag._Result = "Succes";
                        }
                    }
                }
            }
             
                 
             return Json(result, JsonRequestBehavior.AllowGet);
        }

        public ActionResult LoadRefferenceCR(string Reff)
        {
            M_Cerificate C = new M_Cerificate();
            C = objCr.getCleintNTemplate(Reff, "PC3");
            C.Support_Docs = objCr.getTemplateSupportingDocs(C.Client_Id, C.TemplateId);
            C.SealRequired = true;
            return PartialView("P_CertificateRequstForm",C);
        }

        public ActionResult LoadRefferenceByReq(string Reff)
        {
            M_Cerificate C = new M_Cerificate();
            C = objCr.getSavedCertificateRequest(Reff);
            C.Support_Docs = objCr.getTemplateSupportingDocs(C.Client_Id, C.TemplateId);
            C.SealRequired = true;
            return PartialView("P_CertificateRequstForm", C);
        }

    }
}
