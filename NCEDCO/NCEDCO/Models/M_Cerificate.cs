using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace NCEDCO.Models
{
    public  class M_Cerificate
    {
        [Display(Name = "Consignor/Exporter")]
        [Required(ErrorMessage = "Required!")]
        public string Consignor_Exporter { get; set; }

        [Display(Name = "Select Client")]
        [Required(ErrorMessage = "Required!")]
        public string Client_Id { get; set; }

        [Display(Name = "Consignee")]
        [Required(ErrorMessage = "Required!")]
        public string Consignee { get; set; }

        [Display(Name = "Reff No")]
        [Required(ErrorMessage = "Required!")]
        public string RefferencNo { get; set; }

        [Display(Name = "Invoice No")]
        [Required(ErrorMessage = "Required!")]
        public string InvoiceNo { get; set; }

        [Display(Name = "Invoice Date")]
        [Required(ErrorMessage = "Required!")]
        [DataType(DataType.Date)]
        public string InvoiceDate { get; set; }

        [Display(Name = "Country of Origin")]
        [Required(ErrorMessage = "Required!")]
        public string CountyOfOrigin { get; set; }

        [Display(Name = "Total Invoice Value")]
        //[Required(ErrorMessage = "Required!")]
        public string TotalInvoiceValue { get; set; }

        [Display(Name = "Total Quantity")]
        //[Required(ErrorMessage = "Required!")]
        public string TotalQuantity { get; set; }

        [Display(Name = "Port Of Loading")]
        //[Required(ErrorMessage = "Required!")]
        public string PortOfLoading { get; set; }

        [Display(Name = "Port Of Discharge")]
        //[Required(ErrorMessage = "Required!")]
        public string PortOfDischarge { get; set; }

        [Display(Name = "Place Of Delivery")]
        //[Required(ErrorMessage = "Required!")]
        public string PlaceOfDelivery { get; set; }

        [Display(Name = "Vessel")]
        [Required(ErrorMessage = "Required!")]
        public string Vessel { get; set; }

        [Display(Name = "Other Comments")]
        //[Required(ErrorMessage = "Required!")]
        public string OtherComments { get; set; }

        /**NCE Certificate item Table**/

        [Display(Name = "Goods/Items")]
        //[Required(ErrorMessage = "Required!")]
        public string Goods_Item { get; set; }

        [Display(Name = "Shipping Marks")]
        //[Required(ErrorMessage = "Required!")]
        public string ShippingMarks { get; set; }

        [Display(Name = "Package Type")]
        //[Required(ErrorMessage = "Required!")]
        public string PackageType { get; set; }

        [Display(Name = "Qty & Unit")]
        //[Required(ErrorMessage = "Required!")]
        public string QtyNUnit { get; set; }

        [Display(Name = "Summary Description")]
        //[Required(ErrorMessage = "Required!")]
        public string SummaryDescription { get; set; }

        [Display(Name = "HS Code")]
        public string HSCode { get; set; }

        /**NCE Certificate item Table**/

        [Display(Name = "Remarks")]
        public string Remarks { get; set; }

        [Display(Name = "Certificate Ref ")]
        public string CertificateReff { get; set; }

        [Display(Name = "Certificate Template Name")]
        public string CTemplateName { get; set; }

        [Display(Name = "Certificate Template ID")]
        public string TemplateId { get; set; }

        [Display(Name = "Add as a Reffernece")]
        public bool AddAsReff { get; set; }

        [Display(Name = "Created By")]
        public string Createdby { get; set; }

        [Display(Name = "Status")]
        public string Status { get; set; }

        [Display(Name = "Seal Required")]
        public bool SealRequired { get; set; }

        public string ParentId { get; set; }

        public List<M_SupportDocument> Support_Docs { get; set; }
    }
}