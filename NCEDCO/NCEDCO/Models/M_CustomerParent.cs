using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace NCEDCO.Models
{
    public class M_CustomerParent
    {
        private string RequestId;

        public string Request_Id
        {
            get { return RequestId; }
            set { RequestId = value; }
        }

        [Display(Name = "Customer Name")]
        [Required(ErrorMessage = "Customer Name is Required! ")]
        [RegularExpression(@"^[0-9a-zA-Z''-'\s]{1,40}$", ErrorMessage = "Special Characters Are Not  Allowed.")]
        public string Customer_Name { get; set; }

        [Display(Name = "Telephone")]
        [DataType(DataType.PhoneNumber)]
        [Required(ErrorMessage = "Customer Telephone is Required!")]
        [RegularExpression(@"^[0-9a-zA-Z''-'\s]{1,40}$", ErrorMessage = "Special Characters Are Not  Allowed.")]
        public string Telephone { get; set; }

        [Display(Name = "IsVat")]
        [Required(ErrorMessage = "Required!")]
        public string IsVat { get; set; }

        [Required(ErrorMessage = "E-Mail")]
        [Display(Name = "Email")]
        [DataType(DataType.EmailAddress)]
        [EmailAddress(ErrorMessage = "Invalid Email Address")]
        public string Email { get; set; }

        [Display(Name = "Fax")]
        [DataType(DataType.PhoneNumber)]
        [Phone(ErrorMessage = "Invalid Fax Number")]
        public string Fax { get; set; }

        [Display(Name = "Address 1")]
        [Required(ErrorMessage = "Required!")]
        public string Address1 { get; set; }

        [Display(Name = "Address 2")]
        [Required(ErrorMessage = "Required!")]
        public string Address2 { get; set; }

        [Display(Name = "Address 3")]
        public string Address3 { get; set; }

        [Display(Name = "Status")]
        public string Status { get; set; }

        [Display(Name = "Created Date")]
        public DateTime CreatedDate { get; set; }

        [Display(Name = "Created By")]
        public string CreatedBy { get; set; }

        [Display(Name = "Name")]
        [Required(ErrorMessage = "Contact Person Name is Required! ")]
        [RegularExpression(@"^[0-9a-zA-Z''-'\s]{1,40}$", ErrorMessage = "Special Characters Are Not  Allowed.")]
        public string ContactPersonName { get; set; }

        [Display(Name = "Designation")]
        [Required(ErrorMessage = "Contact Person Designation is Required! ")]
        public string ContactPersonDesignation { get; set; }

        [Required(ErrorMessage = "Required !")]
        [Display(Name = "Direct Phone")]
        [DataType(DataType.PhoneNumber)]
        [Phone(ErrorMessage = "Invalid Phone Number")]
        public string ContactPersonDirectPhone { get; set; }

        [Required(ErrorMessage = "Required!")]
        [Display(Name = "Mobile")]
        [DataType(DataType.PhoneNumber)]
        [Phone(ErrorMessage = "Invalid Mobile Number")]
        public string ContactPersonMobile { get; set; }

        [Required(ErrorMessage = "Required !")]
        [Display(Name = "Email")]
        [DataType(DataType.EmailAddress)]
        [EmailAddress(ErrorMessage = "Invalid Email Address")]
        public string ContactPersonEmail { get; set; }

        [Display(Name = "NCE Member")]
        [Required(ErrorMessage = "Required!")]
        public string IsNCEMember { get; set; }

        [Display(Name = "Paid Type")]
        public string PaidType { get; set; }

        private string AdminUserID { get; set; }

        [Display(Name = "Admin User Name")]
        [Required(ErrorMessage = "Required!")]
        [StringLength(15, MinimumLength = 6, ErrorMessage = "field must be atleast 6 characters")]
        public string Admin_UserId
        {
            get { return AdminUserID; }
            set { AdminUserID = value; }
        }

        [Display(Name = "Admin Name")]
        [Required(ErrorMessage = "Required!")]
        public string Admin_Name { get; set; }

        private string AdminPassword { get; set; }

        [Display(Name = "Admin Password")]
        [Required(ErrorMessage = "Required!")]
        [DataType(DataType.Password)]
        [StringLength(20, MinimumLength = 6, ErrorMessage = "field must be atleast 6 characters")]
        public string Admin_Password
        {
            get { return AdminPassword; }
            set { AdminPassword = value; }
        }

        [Display(Name = "Confirm Password")]
        [Required(ErrorMessage = "Required!")]
        [DataType(DataType.Password)]
        [Compare("Admin_Password")]
        [StringLength(20, MinimumLength = 6, ErrorMessage = "field must be atleast 6 characters")]
        public string ConfirmPassword { get; set; }

    }
}