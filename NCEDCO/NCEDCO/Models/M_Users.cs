using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace NCEDCO.Models
{
    public class M_Users
    {
        [Required(ErrorMessage = "User Id")]
        [Display(Name = "User ID")]
        [RegularExpression(@"^[0-9a-zA-Z''-'\s]{1,40}$", ErrorMessage = "Special Characters Are Not  Allowed.")]
        public string UserId { get; set; }

        [Required(ErrorMessage = "User Name")]
        [Display(Name = "User Name")]
        [RegularExpression(@"^[0-9a-zA-Z''-'\s]{1,40}$", ErrorMessage = "Special Characters Are Not  Allowed.")]
        public string UserName { get; set; }

        [Required(ErrorMessage = "E-Mail")]
        [Display(Name = "Email")]
        [DataType(DataType.EmailAddress)]
        [EmailAddress(ErrorMessage = "Invalid Email Address")]
        public string Email { get; set; }

        [Required(ErrorMessage = "Required!")]
        [Display(Name = "Mobile")]
        [DataType(DataType.PhoneNumber)]
        [Phone(ErrorMessage = "Invalid Mobile Number")]
        public string ContactPersonMobile { get; set; }

        private string Password { get; set; }
        [Display(Name = "Password")]
        [Required(ErrorMessage = "Required!")]
        [DataType(DataType.Password)]
        [StringLength(20, MinimumLength = 6, ErrorMessage = "field must be atleast 6 characters")]
        public string Password_
        {
            get { return Password; }
            set { Password = value; }
        }
        [Display(Name = "Confirm Password")]
        [Required(ErrorMessage = "Required!")]
        [DataType(DataType.Password)]
        [Compare("Admin_Password")]
        [StringLength(20, MinimumLength = 6, ErrorMessage = "field must be atleast 6 characters")]
        public string ConfirmPassword { get; set; }
    }
}