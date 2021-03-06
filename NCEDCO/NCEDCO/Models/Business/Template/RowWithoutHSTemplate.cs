﻿using iTextSharp.text;
using iTextSharp.text.pdf;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace NCEDCO.Models.Business.Template
{
    public class RowWithoutHSTemplate : Base_Certificate
    {
        public RowWithoutHSTemplate(M_Cerificate MCertificate, string LOGOpath, string DocPath, string AuthOffer, string Date)
        {
            this.LOGOimgPath = LOGOpath;
            this.Model = MCertificate;
            this.CertificateSavePath = DocPath;
            this.CertificateId = Model.RefferencNo;
            this.AuthoirzedOfficer = AuthOffer;
            this.SignedDate = Date;
        }

        public RowWithoutHSTemplate(string CertificateID, M_Cerificate MCertificate, string LOGOpath, string DocPath, string AuthOffer, string Telephone)
        {
            this.LOGOimgPath = LOGOpath;
            this.Model = MCertificate;
            this.CertificateSavePath = DocPath;
            this.AuthoirzedOfficer = AuthOffer;
            this.AuthTelephone = Telephone;
            this.CertificateId = CertificateID;

        }

        protected override void printListHead()
        {
            //----------------------------------------------------------------------------

            PdfPTable CertItemTbl = new PdfPTable(7);
            CertItemTbl.HorizontalAlignment = 1;
            CertItemTbl.WidthPercentage = 100;
            CertItemTbl.SpacingBefore = 4;
            //CertItemTbl.SpacingAfter = 230;
            CertItemTbl.DefaultCell.Border = Rectangle.BOX;
            CertItemTbl.SetWidths(new int[] { 1, 1, 1, 1, 1, 1, 1 });

            PdfPCell GoodItemHead = new PdfPCell(new Phrase("10. Goods/Item", fontTableHeader));
            GoodItemHead.FixedHeight = 20f;
            GoodItemHead.HorizontalAlignment = PdfPCell.ALIGN_CENTER;
            CertItemTbl.AddCell(GoodItemHead);

            PdfPCell ShipMarkHead = new PdfPCell(new Phrase("11. Shipping Mark", fontTableHeader));
            ShipMarkHead.FixedHeight = 20f;
            ShipMarkHead.HorizontalAlignment = PdfPCell.ALIGN_CENTER;
            CertItemTbl.AddCell(ShipMarkHead);

            PdfPCell PackageHead = new PdfPCell(new Phrase("12. Package Typ/Qty", fontTableHeader));
            PackageHead.FixedHeight = 20f;
            PackageHead.HorizontalAlignment = PdfPCell.ALIGN_CENTER;
            CertItemTbl.AddCell(PackageHead);

            PdfPCell SummaryHead = new PdfPCell(new Phrase("13. Summary Description", fontTableHeader));
            SummaryHead.Colspan = 3;
            SummaryHead.FixedHeight = 20f;
            SummaryHead.HorizontalAlignment = PdfPCell.ALIGN_CENTER;
            CertItemTbl.AddCell(SummaryHead);

            //PdfPCell HSHead = new PdfPCell(new Phrase("14. HS Code", fontTableHeader));
            //HSHead.MinimumHeight = 20f;
            //HSHead.HorizontalAlignment = PdfPCell.ALIGN_CENTER;
            //CertItemTbl.AddCell(HSHead);

            PdfPCell QttHead = new PdfPCell(new Phrase("14. Qty & Units", fontTableHeader));
            QttHead.FixedHeight = 20f;
            QttHead.HorizontalAlignment = PdfPCell.ALIGN_CENTER;
            CertItemTbl.AddCell(QttHead);


            document.Add(CertItemTbl);
            //-----------------------------------------------------------------------------

        }

        protected override void printlistRow()
        {
            //PdfPTable table = new PdfPTable(3);

            PdfPTable CertificateItems = new PdfPTable(2);
            CertificateItems.HorizontalAlignment = 1;
            CertificateItems.WidthPercentage = 100;
            //CertificateItems.SpacingBefore = 4;
            CertificateItems.SpacingAfter = 2;
            CertificateItems.DefaultCell.Border = Rectangle.BOX;
            CertificateItems.SetWidths(new int[] { 5, 2 });


            PdfPCell GoodItemDetails = new PdfPCell(new Phrase(Model.Goods_Item.Replace("<br />", "\r\n"), fontItemDetails));//CertReqDetails[i].GoodItem1
            GoodItemDetails.FixedHeight = 230f;
            GoodItemDetails.Border = Rectangle.LEFT_BORDER;
            GoodItemDetails.HorizontalAlignment = PdfPCell.ALIGN_LEFT;
            CertificateItems.AddCell(GoodItemDetails);

            PdfPCell QuantityDetails = new PdfPCell(new Phrase(Model.QtyNUnit.Replace("<br />", "\r\n"), fontItemDetails));//CertReqDetails[i].GoodItem1
            QuantityDetails.FixedHeight = 230f;
            QuantityDetails.Border = Rectangle.LEFT_BORDER | Rectangle.RIGHT_BORDER;
            QuantityDetails.HorizontalAlignment = PdfPCell.ALIGN_LEFT;
            CertificateItems.AddCell(QuantityDetails);

            document.Add(CertificateItems);
        }
    }
}