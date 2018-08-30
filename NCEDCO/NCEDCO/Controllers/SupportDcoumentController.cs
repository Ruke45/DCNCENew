using NCEDCO.Filters;
using NCEDCO.Models;
using NCEDCO.Models.Business;
using NCEDCO.Models.Business.Signature;
using NCEDCO.Models.Utility;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
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

        [HttpPost]
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

        public ActionResult BulkSign_Model(string IDs)
        {
            ViewBag.A_IDs = IDs;
            return PartialView("P_BulkApprove");
        }

        [HttpPost]
        public JsonResult BulkSign(M_Signatory Model)
        {
            bool r = false;
            _session.C_Password = Model.Password_;
            var strin = Model.RequestID;
            string[] arr = strin.ToString().Split(',');

            for (int a = 0; a < arr.Length; a++)
            {
                M_SupportDocumentUpload SModel = objSDApprv.getSDocbyID(arr[a]);
                _session.C_Password = Model.Password_;
                r = Sign_SDocument(SModel.RequestRefNo, SModel.UploadedPath);
            }
            return Json(r, JsonRequestBehavior.AllowGet);
        }

        //[UserFilter(Function_Id = "F_CERT_APRUV")]
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

        //[UserFilter(Function_Id = "F_CERT_APRUV")]
        public ActionResult RejectSD(string Rid)
        {
            Rejectitem objReject = new Rejectitem();
            string ParentReject_Category = System.Configuration.ConfigurationManager.AppSettings["Certifi_Rject"].ToString();

            List<M_Reject> Rlist = objReject.getReasons(ParentReject_Category);

            ViewBag.Bag_RejectReasons = new SelectList(Rlist, "Reject_ReasonId", "Reject_ReasonName");
            ViewBag.Bag_RejectingID = Rid;

            return PartialView("P_RejectSupportDoc");
        }

        [HttpPost]
        public JsonResult Reject_SDocument(M_Reject Model)
        {
            String result = "Error";
            bool r = false;
            r = objSDApprv.RejectSDocument(Model.Rejecting_ID,
                                       _session.User_Id,
                                       Model.Reject_ReasonId);
            if (r) { result = "Success"; }
            return Json(result, JsonRequestBehavior.AllowGet);
        }

    }
}
