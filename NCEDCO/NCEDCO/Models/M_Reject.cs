using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace NCEDCO.Models
{
    public class M_Reject : M_RejectCategory
    {
        string RejectingID;

        public string Rejecting_ID
        {
            get { return RejectingID; }
            set { RejectingID = value; }
        }

        [Display(Name = "Reject Reason")]
        string RejectReasonId;

        public string Reject_ReasonId
        {
            get { return RejectReasonId; }
            set { RejectReasonId = value; }
        }

        string RejectReasonCategory;

        public string Reject_ReasonCategory
        {
            get { return RejectReasonCategory; }
            set { RejectReasonCategory = value; }
        }

        string Email;

        public string Email_
        {
            get { return Email; }
            set { Email = value; }
        }

        string RejectReasonName;

        [Display(Name = "Reject Reason")]
        [Required(ErrorMessage = "Required!")]
        public string Reject_ReasonName
        {
            get { return RejectReasonName; }
            set { RejectReasonName = value; }
        }

        [Display(Name = "Is Active")]
        [Required(ErrorMessage = "Required!")]
        public string IsActive { get; set; }

        [Display(Name = "Created By")]
        [Required(ErrorMessage = "Required!")]
        public string Createdby { get; set; }

        [Display(Name = "Created Date")]
        [Required(ErrorMessage = "Required!")]
        public DateTime CreatedDate { get; set; }

        string Ctype;

        public string Ctype_
        {
            get { return Ctype; }
            set { Ctype = value; }
        }
    }

    public class M_RejectCategory
    {
        public string RejectCategoryId { get; set; }
        public string RejectCategoryName { get; set; }
    }
}