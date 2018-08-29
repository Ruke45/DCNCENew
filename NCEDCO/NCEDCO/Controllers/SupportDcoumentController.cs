using NCEDCO.Models;
using NCEDCO.Models.Business;
using NCEDCO.Models.Business.Signature;
using NCEDCO.Models.Utility;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace NCEDCO.Controllers
{
    public class SupportDcoumentController : Controller
    {
        B_SupportDocApprove objSDApprv = new B_SupportDocApprove();
        _USession _session = new _USession();

        public ActionResult Index()
        {
            return View();
        }

        public ActionResult Pending()
        {
            return View(objSDApprv.getPendingSDRequests("%", "P"));
        }

        private bool Sign_SDocument(string Ref, string UPath)
        {
            bool result = false;
            string DirectoryPath = "~/Documents/" + DateTime.Now.ToString("yyyy")
                                               + "/Issued_SupportingDocs/" + DateTime.Now.ToString("MMM") + "/" + DateTime.Now.ToString("dd") + "/"
                                               + Ref;

            string Tempary_Direct = "~/Temp/" + DateTime.Now.ToString("yyyy")
                                                + "/Issued_SupportingDocs/" + DateTime.Now.ToString("yyyy_MM_dd") + "/"
                                                + Ref;
            if (!Directory.Exists(Server.MapPath(DirectoryPath)))
            {
                Directory.CreateDirectory(Server.MapPath(DirectoryPath));
            }
            if (!Directory.Exists(Server.MapPath(Tempary_Direct)))
            {
                Directory.CreateDirectory(Server.MapPath(Tempary_Direct));
            }

            string Sealed = Server.MapPath(Tempary_Direct + "/" + Ref + "_Seald.pdf");
            string Signed = Server.MapPath(DirectoryPath + "/" + Ref + "_Signed.pdf");
            string pathe = Server.MapPath(_session.PFX_path);

            Sign_ SignDoc = new Sign_();

            SignDoc.AddSealSD(Server.MapPath(UPath), Sealed, Server.MapPath(_session.SignatureIMG_Path));

            var PFX2 = new FileStream(pathe, FileMode.OpenOrCreate);

            bool Sign = SignDoc.signSupportingDoc(Ref,
                Sealed,
                Signed,
                PFX2, _session.C_Password);

            if (Sign)
            {
                M_SupportDocumentUpload Approve = new M_SupportDocumentUpload();
                Approve.DocumentName = Ref + "_Signed.pdf";
                Approve.CertifiedDocPathe = DirectoryPath + "/" + Ref + "_Signed.pdf";
                Approve.ApprovedBy = _session.User_Id;
                Approve.RequestRefNo = Ref;
                Approve.ExpiredOn = DateTime.Today.AddDays(120).ToString();
                //Approve.RequestRefNo = lblApporveRequestID.Text;
                result = objSDApprv.ApproveSupportingDoc(Approve);
               
                
            }
            PFX2.Close();
            return result;
        }

        public ActionResult ApproveSD(string Id)
        {
            ViewBag.SDid = Id;
            return PartialView("P_ApproveSD");
        }

        public ActionResult Approve_Support(M_Signatory Model)
        {
           M_SupportDocumentUpload SModel = objSDApprv.getSDocbyID(Model.RequestID);
           string r = "Error";
           _session.C_Password = Model.Password_;
           if (SModel != null)
           {
              bool rr = Sign_SDocument(SModel.RequestRefNo, SModel.UploadedPath);
              if (rr) { r = "Sucess"; }
           }
            return Json(r, JsonRequestBehavior.AllowGet);
        }
    }
}
