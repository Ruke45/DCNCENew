using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using NCEDCO.Models;
using NCEDCO.Models.Business;
using NCEDCO.Models.Templates;
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
            ViewBag.Bag_RefferenceRequ = new SelectList(ReffList, "RequestId", "TemplateName");

            List<M_Customer> ClientList = objCr.getCustomerClients("PC3");
            ViewBag.Bag_ClientsofCustomer = new SelectList(ClientList, "ClientId", "Customer_Name");

            return View();
        }

        [HttpPost]
        public ActionResult Index(M_Cerificate Model)
        {
             string result = "Error";
                 result = "Succes";
                 var DocumentUpload = Model.Support_Docs;
                 foreach (var Doc in DocumentUpload)
                 {
                     string strFileUpload = "file_" + Doc.SupportingDocument_Id; ;
                     HttpPostedFileBase file = Request.Files[strFileUpload];

                     if (file != null && file.ContentLength > 0)
                     {
                         // if you want to save in folder use this
                         var fileName = Path.GetFileName(file.FileName);
                         var path = Path.Combine(Server.MapPath("~/Images/"), fileName);
                         file.SaveAs(path);

                         // if you want to store in Bytes in Database use this
                         byte[] image = new byte[file.ContentLength];
                         file.InputStream.Read(image, 0, image.Length);

                     }
                 }
             return Json(result, JsonRequestBehavior.AllowGet);
        }

        public ActionResult LoadRefferenceCR(string Reff)
        {
            M_Cerificate C = new M_Cerificate();
            C = objCr.getCleintNTemplate(Reff, "PC3");
            C.Support_Docs = objCr.getTemplateSupportingDocs(C.Client_Id, C.TemplateId);
            return PartialView("P_CertificateRequstForm",C);
        }

    }
}
