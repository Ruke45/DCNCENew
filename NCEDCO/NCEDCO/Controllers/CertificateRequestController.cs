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
            M_Cerificate C = new M_Cerificate();
            C.Support_Docs = objCr.getTemplateSupportingDocs("CC1", "template-2");
            return View(C);
        }

        [HttpPost]
        public ActionResult Index(M_Cerificate Model)
        {
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
            return View();
        }

    }
}
