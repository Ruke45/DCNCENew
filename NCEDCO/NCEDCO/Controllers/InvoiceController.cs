using NCEDCO.Models;
using NCEDCO.Models.Business;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace NCEDCO.Controllers
{
    public class InvoiceController : Controller
    {
        //
        // GET: /Invoice/
        B_Customer CustomerOBj = new B_Customer();
        B_Invoice objInv = new B_Invoice();
        B_SupportDocApprove objSDApp = new B_SupportDocApprove();

        public ActionResult Index()
        {
            List<M_CustomerParent> par = CustomerOBj.getAllParents();
            ViewBag.ParentsIDs = new SelectList(par, "Parent_Id", "Customer_Name"); 

            return View();
        }

        public ActionResult getAllPendingInvoice(DateTime S, DateTime E, string P)
        {
            return PartialView("P_InvoiceCustomers"
                , objInv.getAllInvoice(S.ToString("yyyyMMdd"), E.ToString("yyyyMMdd"), "A", P));
        }

        public ActionResult Genarate_SetValueToHeader(DateTime S, DateTime E,string C)
        {
            /*Start get data for Calculate And Insert to invoice Header for get Invoice No*/
            String Start = S.ToString("yyyyMMdd");
            String End = E.ToString("yyyyMMdd");
            /*end make date for corrct format*/

            String Certi_Status = "A";//Certificate Status
            String SDoc_Status = "A";
            String AttachSheetId = System.Configuration.ConfigurationManager.AppSettings["AttachedSheetId"];

            String CertificateRateId = System.Configuration.ConfigurationManager.AppSettings["CertificateRateId"];//get Certificate Rate Id from Web Config
            String SupDocCertificateRateId = System.Configuration.ConfigurationManager.AppSettings["SupDocCertificateRateId"];//get Certificate Rate Id from Web Config

            String InvoiceRateId = System.Configuration.ConfigurationManager.AppSettings["InvoiceRateId"];//get Invoice Rate Id
            String OtherRateId = System.Configuration.ConfigurationManager.AppSettings["OtherRateId"];//get Other Rate Id
            String SupDocOtherRateId = System.Configuration.ConfigurationManager.AppSettings["SupdocOtherRateId"];//get Supprting Document Id for Other Rate
            String SupsDocInvoiceRateId = System.Configuration.ConfigurationManager.AppSettings["SupdocInvoiceRateId"];//get Supporting Document id For Invoice Rate

            String VATCode = System.Configuration.ConfigurationManager.AppSettings["VatCode"];

            M_InvoiceData Invo_data = new M_InvoiceData();
            Invo_data.CustomerId = C;
            Invo_data.Start = Start;
            Invo_data.End = End;
            Invo_data.InvoiceRateId = InvoiceRateId;
            Invo_data.OtherRateId = OtherRateId;
            Invo_data.SupDocInvoiceRateId = SupsDocInvoiceRateId;
            Invo_data.SupDocOtherRateId = SupDocOtherRateId;
            Invo_data.AttachSheetId = AttachSheetId;
            Invo_data.SupportingDocStatus = SDoc_Status;

            decimal Cost_Certificate = 0;
            decimal Cost_SupprotDoc = 0;
            decimal BeforTax_Total = 0;
            /*start get Certificate Data*/
            decimal TaxCount = 0;
            decimal AfterTax_Total = 0;
            string Is_SVat = string.Empty;

            int checkTaxInvoice = 0;

            foreach (var requst in objInv.getInvoiceDetail_Certs(Certi_Status, Start, End, C, CertificateRateId))
            {
                Cost_Certificate += requst.Rate_; // Calculate Certificate cost befor tax
                Is_SVat = requst.Is_SVAT;
            }
            /*start get Suporting Document Data*/
            foreach (var supporting in objSDApp.getSuuportingDocumentApproval(Invo_data))
            {
                Cost_SupprotDoc += supporting.Rate_;
            }

            BeforTax_Total = Cost_Certificate + Cost_SupprotDoc;//get gross total=Total Certificate value+total Supproting Document Value



            if (Is_SVat.Equals("Y"))
            {
                foreach (var money in objInv.getTaxDetails("Y", "Y"))
                {

                    decimal presentage = money.RateValue;
                    TaxCount = presentage * BeforTax_Total / 100;
                    BeforTax_Total += TaxCount;
                    checkTaxInvoice = 1;

                }
            }
            else
            {
                foreach (var money in objInv.getTaxDetails("Y", VATCode))
                {

                    decimal presentage = money.RateValue;
                    TaxCount = presentage * BeforTax_Total / 100;
                    BeforTax_Total += TaxCount;
                    checkTaxInvoice = 1;

                }
            }

            /*end get Suporting Document Data*/

            return View();
        }
    }
}
