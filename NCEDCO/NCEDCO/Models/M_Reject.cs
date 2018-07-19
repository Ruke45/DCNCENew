using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace NCEDCO.Models
{
    public class M_Reject
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
    }
}