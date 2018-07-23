USE [master]
GO
/****** Object:  Database [NCEDCO]    Script Date: 7/23/2018 12:34:09 PM ******/
CREATE DATABASE [NCEDCO]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'NCEDCO', FILENAME = N'c:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\NCEDCO.mdf' , SIZE = 3136KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'NCEDCO_log', FILENAME = N'c:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\NCEDCO_log.ldf' , SIZE = 832KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [NCEDCO] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [NCEDCO].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [NCEDCO] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [NCEDCO] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [NCEDCO] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [NCEDCO] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [NCEDCO] SET ARITHABORT OFF 
GO
ALTER DATABASE [NCEDCO] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [NCEDCO] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [NCEDCO] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [NCEDCO] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [NCEDCO] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [NCEDCO] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [NCEDCO] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [NCEDCO] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [NCEDCO] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [NCEDCO] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [NCEDCO] SET  ENABLE_BROKER 
GO
ALTER DATABASE [NCEDCO] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [NCEDCO] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [NCEDCO] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [NCEDCO] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [NCEDCO] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [NCEDCO] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [NCEDCO] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [NCEDCO] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [NCEDCO] SET  MULTI_USER 
GO
ALTER DATABASE [NCEDCO] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [NCEDCO] SET DB_CHAINING OFF 
GO
ALTER DATABASE [NCEDCO] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [NCEDCO] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [NCEDCO]
GO
/****** Object:  StoredProcedure [dbo].[_getAllExportSector]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[_getAllExportSector] 
	(@Status varchar(1))
AS
BEGIN
	SELECT 
	ExportSector,ExportId
	FROM
	tblExportSector
	WHERE
	Status=@Status
END





GO
/****** Object:  StoredProcedure [dbo].[_getRejectReasons]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Proc [dbo].[_getRejectReasons](@RejectReasonCategory varchar(20))
as begin
Select RejectCode, ReasonName
from tblRejectReasons
where Category = @RejectReasonCategory
and IsActive like 'Y'
End
GO
/****** Object:  StoredProcedure [dbo].[_getUserlogin]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create proc [dbo].[_getUserlogin](@UserId varchar(20),@Password nvarchar(50))

as begin

select UserId,UserGroupID,IsActive,Password,PassowordExpiryDate,PersonName, ParentCustomerId
from tblUser 
where UserId = @UserId
and Password = @Password


End








GO
/****** Object:  StoredProcedure [dbo].[_setCutomerClientTemplate]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[_setCutomerClientTemplate]
	-- Add the parameters for the stored procedure here
	(@RequestId varchar(20),@TemplateId varchar(20))
AS
BEGIN
	

    -- Insert statements for procedure here
	UPDATE tblCustomerRequest SET TemplateId=@TemplateId 
	WHERE RequestId=@RequestId
END





GO
/****** Object:  StoredProcedure [dbo].[_setParentChildCustomerRequest]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create PROCEDURE [dbo].[_setParentChildCustomerRequest]
   (@RequestId varchar(20),
	@Name varchar(100),
	@Telephone varchar(20),
	@Email varchar(50),
	@Fax varchar(20),
	@Status varchar(1),
	@Address1 nvarchar(50),
	@Address2 nvarchar(50),
	@Address3 nvarchar(50),
	@CreatedBy varchar(20),
	@isSVat varchar(10), 
	@ContactPersonName varchar(150),
	@ContactPersonDesignation varchar(50),
	@ContactPersonDirectPhoneNumber varchar(20),
	@ContactPersonMobile varchar(20),
	@ContactPersonEmail varchar(50),
	@NCEMember varchar(10),
	@ParentCustomerId varchar(20),
	@ProductDetails text,
	@ExportSector varchar(100))
AS
BEGIN
	INSERT INTO tblCustomerRequest
	(RequestId,
	Name, 
	Telephone, 
	Email, 
	Fax, 
	Address1,
	Address2,
	Address3, 
	Status, 
	CreatedDate, 
	CreatedBy, 
	ContactPersonName,
	ContactPersonDesignation,
	ContactPersonDirectPhoneNumber,
	ContactPersonMobile,
	ContactPersonEmail,
	NCEMember,
	SVat,
	ParentCustomerId,
	ExportSector,
	ProductDetails)
	VALUES
	(
	 @RequestId,
	 @Name,
	 @Telephone,
	 @Email,
	 @Fax,
	 @Address1,
	 @Address2,
	 @Address3,
	 @Status,
	 GETDATE(),
	 @CreatedBy,
	 @ContactPersonName,
	 @ContactPersonDesignation,
	 @ContactPersonDirectPhoneNumber,
	 @ContactPersonMobile,
	 @ContactPersonEmail,
	 @NCEMember,
	 @isSVat,
	 @ParentCustomerId,
	 @ExportSector,
	 @ProductDetails)
END





GO
/****** Object:  StoredProcedure [dbo].[DCISgeMailParameters]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[DCISgeMailParameters]
as
Begin
SELECT ParameterCode,ParameterValue FROM tblParameter WHERE ParameterCode LIKE 'EBCR_EMAIL'
UNION
SELECT ParameterCode,ParameterValue FROM tblParameter WHERE ParameterCode LIKE 'EBCRE_PASS'
UNION
SELECT ParameterCode,ParameterValue FROM tblParameter WHERE ParameterCode LIKE 'EBCRM_SMTP'
UNION
SELECT ParameterCode,ParameterValue FROM tblParameter WHERE ParameterCode LIKE 'EBCRM_SMTP_PORT'
End



GO
/****** Object:  StoredProcedure [dbo].[DCISgetParentCustomerRequestDetails]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[DCISgetParentCustomerRequestDetails](@RequestID varchar(20))
as begin
Select 
RequestId, 
CustomerName, 
Telephone, 
IsSVat, 
Fax, 
Email, 
Address1, 
Address2, 
Address3, 
Status, 
CreatedDate, 
CreatedBy, 
ContactPersonName, 
ContactPersonDesignation, 
ContactPersonDirectPhoneNumber, 
ContactPersonMobile, 
ContactPersonEmail, 
NCEMember, 
PaidType, 
AdminUserId, 
AdminPassword, 
AdminName

from tblCustomerParentRequest
where RequestId like @RequestID

End
GO
/****** Object:  StoredProcedure [dbo].[DCISgetParentCustomerRequestList]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create proc [dbo].[DCISgetParentCustomerRequestList](@Status varchar(5))
as begin
Select 
RequestId, 
CustomerName, 
Telephone, 
IsSVat, 
Fax, 
Email, 
Address1, 
Address2, 
Address3, 
Status, 
CreatedDate, 
CreatedBy, 
ContactPersonName, 
ContactPersonDesignation, 
ContactPersonDirectPhoneNumber, 
ContactPersonMobile, 
ContactPersonEmail, 
NCEMember, 
PaidType, 
AdminUserId, 
AdminPassword, 
AdminName

from tblCustomerParentRequest
where Status like @Status

End
GO
/****** Object:  StoredProcedure [dbo].[DCISgetSequence]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shirandi Ekanayake
-- Create date: 30-05-2016
-- Description:	To Retrieve the Next SequenceNo
-- =============================================

Create PROCEDURE [dbo].[DCISgetSequence](@SequenceName varchar(50)) AS

select SequesnceValue from tblSequence
where SequenceName=@SequenceName;
update tblSequence
set  SequesnceValue=SequesnceValue+1
where SequenceName=@SequenceName;







GO
/****** Object:  StoredProcedure [dbo].[DCISgetTemplateHeader]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE

PROCEDURE[dbo].[DCISgetTemplateHeader]
(

@TemplateId varchar (20),@IsActive varchar (2),@AdminOnlyDisplay varchar(2))
AS

BEGIN

select TemplateId, TemplateName, ImgUrl, CreatedDate, ModifiedDate, IsActive, ModifiedBy, CreatedBy, Description, TemplatePath from tblTemplateHeader
where
TemplateId like @TemplateId and IsActive like @IsActive and AdminOnly like @AdminOnlyDisplay
END

GO
/****** Object:  StoredProcedure [dbo].[DCISsetApprovedPCUser]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [dbo].[DCISsetApprovedPCUser]
(@UserID varchar(20), 
 @PersonName varchar(150), 
 @Password nvarchar(200), 
 @ParentCustomerId varchar(20)
)
as Begin
Insert Into tblUser
(UserID, UserGroupID,PersonName, Password, CreatedBy, CreatedDate, IsActive, ParentCustomerId,PassowordExpiryDate)
values
(@UserID,'CADMIN',@PersonName, @Password, 'ADMIN' , GETDATE(), 'Y', @ParentCustomerId,GETDATE())
End
GO
/****** Object:  StoredProcedure [dbo].[DCISsetApproveParentCustomer]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[DCISsetApproveParentCustomer]
   (@RequestId varchar(20),
    @ParentCustomerID varchar(20),
	@Name varchar(100),
	@Telephone varchar(20),
	@Email varchar(50),
	@Fax varchar(20),
	@Status varchar(1),
	@Address1 nvarchar(50),
	@Address2 nvarchar(50),
	@Address3 nvarchar(50),
	@CreatedBy varchar(20),
	@isSVat varchar(10), 
	@ContactPersonName varchar(150),
	@ContactPersonDesignation varchar(50),
	@ContactPersonDirectPhoneNumber varchar(20),
	@ContactPersonMobile varchar(20),
	@ContactPersonEmail varchar(50),
	@NCEMember varchar(10))

AS
BEGIN
	INSERT INTO tblCustomerParent
	(RequestId,
    ParentCustomerId,
	CustomerName, 
	Telephone, 
	Email, 
	Fax, 
	Address1,
	Address2,
	Address3, 
	Status, 
	CreatedDate, 
	CreatedBy, 
	ContactPersonName,
	ContactPersonDesignation,
	ContactPersonDirectPhoneNumber,
	ContactPersonMobile,
	ContactPersonEmail,
	NCEMember,
	IsSVat)
	VALUES
	(
	 @RequestId,
	 @ParentCustomerID,
	 @Name,
	 @Telephone,
	 @Email,
	 @Fax,
	 @Address1,
	 @Address2,
	 @Address3,
	 @Status,
	 GETDATE(),
	 @CreatedBy,
	 @ContactPersonName,
	 @ContactPersonDesignation,
	 @ContactPersonDirectPhoneNumber,
	 @ContactPersonMobile,
	 @ContactPersonEmail,
	 @NCEMember,
	 @isSVat)
END





GO
/****** Object:  StoredProcedure [dbo].[DCISsetCustomerParentReject]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Proc [dbo].[DCISsetCustomerParentReject](@RequestId varchar(20))
as begin
Update tblCustomerParentRequest
Set Status = 'R'
Where RequestId = @RequestId
End
GO
/****** Object:  StoredProcedure [dbo].[DCISsetCustomerRequest]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create PROCEDURE [dbo].[DCISsetCustomerRequest]
   (@RequestId varchar(20),
	@Name varchar(100),
	@Telephone varchar(20),
	@Email varchar(50),
	@Fax varchar(20),
	@Status varchar(1),
	@Address1 nvarchar(50),
	@Address2 nvarchar(50),
	@Address3 nvarchar(50),
	@CreatedBy varchar(20),
	@isSVat varchar(10), 
	@AdminUserId varchar(20),
	@AdminPassword varchar(200),
	@ContactPersonName varchar(150),
	@ContactPersonDesignation varchar(50),
	@ContactPersonDirectPhoneNumber varchar(20),
	@ContactPersonMobile varchar(20),
	@ContactPersonEmail varchar(50),
	@ExportSector varchar(10),
	@NCEMember varchar(10),
	@AdminName varchar(150))
AS
BEGIN
	INSERT INTO tblCustomerParentRequest
	(RequestId,
	CustomerName, 
	Telephone, 
	Email, 
	Fax, 
	Address1,
	Address2,
	Address3, 
	Status, 
	CreatedDate, 
	CreatedBy, 
    AdminUserId, 
	AdminPassword,
	ContactPersonName,
	ContactPersonDesignation,
	ContactPersonDirectPhoneNumber,
	ContactPersonMobile,
	ContactPersonEmail,
	NCEMember,
	AdminName,
	IsSVat)
	VALUES
	(
	 @RequestId,
	 @Name,
	 @Telephone,
	 @Email,
	 @Fax,
	 @Address1,
	 @Address2,
	 @Address3,
	 @Status,
	 GETDATE(),
	 'SYSTEM',
	 @AdminUserId,
	 @AdminPassword,
	 @ContactPersonName,
	 @ContactPersonDesignation,
	 @ContactPersonDirectPhoneNumber,
	 @ContactPersonMobile,
	 @ContactPersonEmail,
	 @NCEMember,
	 @AdminName,
	 @isSVat)
END





GO
/****** Object:  StoredProcedure [dbo].[DCISsetParentCustomerRequest]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[DCISsetParentCustomerRequest]
   (@RequestId varchar(20),
	@Name varchar(100),
	@Telephone varchar(20),
	@Email varchar(50),
	@Fax varchar(20),
	@Status varchar(1),
	@Address1 nvarchar(50),
	@Address2 nvarchar(50),
	@Address3 nvarchar(50),
	@CreatedBy varchar(20),
	@isSVat varchar(10), 
	@AdminUserId varchar(20),
	@AdminPassword varchar(200),
	@ContactPersonName varchar(150),
	@ContactPersonDesignation varchar(50),
	@ContactPersonDirectPhoneNumber varchar(20),
	@ContactPersonMobile varchar(20),
	@ContactPersonEmail varchar(50),
	@NCEMember varchar(10),
	@AdminName varchar(150))
AS
BEGIN
	INSERT INTO tblCustomerParentRequest
	(RequestId,
	CustomerName, 
	Telephone, 
	Email, 
	Fax, 
	Address1,
	Address2,
	Address3, 
	Status, 
	CreatedDate, 
	CreatedBy, 
    AdminUserId, 
	AdminPassword,
	ContactPersonName,
	ContactPersonDesignation,
	ContactPersonDirectPhoneNumber,
	ContactPersonMobile,
	ContactPersonEmail,
	NCEMember,
	AdminName,
	IsSVat)
	VALUES
	(
	 @RequestId,
	 @Name,
	 @Telephone,
	 @Email,
	 @Fax,
	 @Address1,
	 @Address2,
	 @Address3,
	 @Status,
	 GETDATE(),
	 'SYSTEM',
	 @AdminUserId,
	 @AdminPassword,
	 @ContactPersonName,
	 @ContactPersonDesignation,
	 @ContactPersonDirectPhoneNumber,
	 @ContactPersonMobile,
	 @ContactPersonEmail,
	 @NCEMember,
	 @AdminName,
	 @isSVat)
END





GO
/****** Object:  StoredProcedure [dbo].[DCISsetUpdateParentCustomerReq]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Proc [dbo].[DCISsetUpdateParentCustomerReq] (@Status varchar(1),@RequestID varchar(20))
as begin
Update tblCustomerParentRequest
Set Status = @Status
Where RequestId like @RequestID

End
GO
/****** Object:  Table [dbo].[tblCancelledCertificate]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblCancelledCertificate](
	[DocumentId] [varchar](20) NOT NULL,
	[CustomerId] [varchar](20) NOT NULL,
	[Remark] [varchar](200) NULL,
	[CancelBy] [varchar](20) NOT NULL,
	[CancelDate] [datetime] NOT NULL,
	[DocumentType] [varchar](1) NOT NULL,
 CONSTRAINT [PK_tblCertificateCancelation] PRIMARY KEY CLUSTERED 
(
	[DocumentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblCancelledInvoice]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblCancelledInvoice](
	[InvoiceNo] [varchar](20) NOT NULL,
	[CancelledReasonCode] [varchar](10) NOT NULL,
	[CancelledBy] [varchar](50) NOT NULL,
	[CancelledDate] [datetime] NOT NULL,
 CONSTRAINT [PK_tblCancelledInvoice] PRIMARY KEY CLUSTERED 
(
	[InvoiceNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblCertifcateRequestHeader]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblCertifcateRequestHeader](
	[RequestId] [varchar](20) NOT NULL,
	[TemplateId] [varchar](20) NOT NULL,
	[CustomerId] [varchar](20) NOT NULL,
	[RequestDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [varchar](20) NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedBy] [varchar](20) NOT NULL,
	[Status] [varchar](3) NOT NULL,
	[Consignor] [varchar](500) NULL,
	[Consignee] [varchar](500) NULL,
	[InvoiceNo] [nvarchar](50) NULL,
	[InvoiceDate] [datetime] NULL,
	[CountryCode] [varchar](50) NULL,
	[LoadingPort] [varchar](50) NULL,
	[PortOfDischarge] [varchar](50) NULL,
	[Vessel] [varchar](50) NULL,
	[PlaceOfDelivery] [varchar](50) NULL,
	[TotalInvoiceValue] [varchar](50) NULL,
	[TotalQuantity] [varchar](20) NULL,
	[OtherComments] [varchar](150) NULL,
	[OtherDetails] [varchar](250) NULL,
	[ReasonCode] [varchar](10) NULL,
	[SealRequired] [varchar](5) NULL,
 CONSTRAINT [PK_CertifateRequest] PRIMARY KEY CLUSTERED 
(
	[RequestId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblCertificate]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblCertificate](
	[CertificateId] [varchar](20) NOT NULL,
	[RequestId] [varchar](20) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ExpiryDate] [datetime] NOT NULL,
	[CreatedBy] [varchar](20) NOT NULL,
	[IsDownloaded] [varchar](2) NOT NULL,
	[CertificatePath] [varchar](500) NULL,
	[CertificateName] [varchar](150) NULL,
	[IsValid] [varchar](5) NULL,
	[IsSend] [varchar](5) NULL,
 CONSTRAINT [PK_tblCertificate_1] PRIMARY KEY CLUSTERED 
(
	[CertificateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [Uni_RequestID] UNIQUE NONCLUSTERED 
(
	[RequestId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblCertificateApproval]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblCertificateApproval](
	[RequestId] [varchar](20) NOT NULL,
	[ApprovalSequence] [bigint] IDENTITY(1,1) NOT NULL,
	[ApprovalDate] [datetime] NOT NULL,
	[ApprovedBy] [varchar](20) NULL,
 CONSTRAINT [PK_tblCertificateApproval] PRIMARY KEY CLUSTERED 
(
	[ApprovalSequence] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblCertificateRequestDetails]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblCertificateRequestDetails](
	[SeqNo] [bigint] IDENTITY(1,1) NOT NULL,
	[RequestId] [varchar](20) NOT NULL,
	[GoodItem] [varchar](500) NULL,
	[ShippingMark] [varchar](500) NULL,
	[PackageType] [varchar](500) NULL,
	[SummaryDesc] [varchar](1000) NULL,
	[Quantity] [varchar](500) NULL,
	[HSCode] [varchar](500) NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [varchar](20) NULL,
 CONSTRAINT [PK_tblCertificaterRequestDetails] PRIMARY KEY CLUSTERED 
(
	[SeqNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblCertificateRequestReffrence]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblCertificateRequestReffrence](
	[Consignee] [varchar](250) NULL,
	[CustomerId] [varchar](20) NULL,
	[RequestId] [varchar](20) NULL,
	[SeqNo] [bigint] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_tblCustomerRequestReffrence] PRIMARY KEY CLUSTERED 
(
	[SeqNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblCertificateUnitCharge]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblCertificateUnitCharge](
	[TemplateId] [varchar](20) NOT NULL,
	[UnitChargeValue] [decimal](8, 6) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedBy] [varchar](20) NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[ModifiedBy] [varchar](20) NOT NULL,
 CONSTRAINT [PK_tblCertificateUnitCharge] PRIMARY KEY CLUSTERED 
(
	[TemplateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblContactFormDetails]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblContactFormDetails](
	[seqNo] [bigint] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[Email] [varchar](50) NOT NULL,
	[Phone] [varchar](20) NOT NULL,
	[Detail] [text] NOT NULL,
	[ViewStatus] [varchar](1) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_tblContactFormDetails] PRIMARY KEY CLUSTERED 
(
	[seqNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblCountry]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblCountry](
	[ID] [bigint] NULL,
	[CountryCode] [varchar](10) NOT NULL,
	[CountryName] [varchar](50) NOT NULL,
	[NickName] [varchar](150) NULL,
	[ISO3] [varchar](50) NULL,
	[NumCode] [bigint] NULL,
	[PhoneCode] [varchar](50) NULL,
 CONSTRAINT [PK_tblCountry_1] PRIMARY KEY CLUSTERED 
(
	[CountryCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblCustomer]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblCustomer](
	[CustomerId] [varchar](20) NOT NULL,
	[CustomerName] [varchar](150) NOT NULL,
	[Telephone] [varchar](20) NOT NULL,
	[IsSVat] [varchar](10) NOT NULL,
	[Fax] [varchar](20) NULL,
	[Email] [varchar](50) NOT NULL,
	[Address1] [varchar](150) NOT NULL,
	[Address2] [varchar](150) NOT NULL,
	[Address3] [varchar](150) NOT NULL,
	[Status] [varchar](10) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedBy] [varchar](20) NOT NULL,
	[ContactPersonName] [varchar](150) NULL,
	[ContactPersonDesignation] [varchar](50) NULL,
	[ContactPersonDirectPhoneNumber] [varchar](20) NULL,
	[ContactPersonMobile] [varchar](20) NULL,
	[ContactPersonEmail] [varchar](50) NULL,
	[ProductDetails] [text] NULL,
	[ExportSector] [varchar](200) NULL,
	[NCEMember] [varchar](10) NULL,
	[PaidType] [varchar](10) NULL,
	[ParentCustomerId] [varchar](20) NOT NULL,
	[RequestId] [varchar](20) NULL,
 CONSTRAINT [PK_tblCustomer] PRIMARY KEY CLUSTERED 
(
	[CustomerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblCustomerApplicableRates]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblCustomerApplicableRates](
	[CustomerId] [varchar](20) NOT NULL,
	[RatesId] [varchar](10) NOT NULL,
	[Rates] [decimal](18, 6) NOT NULL,
 CONSTRAINT [PK_tblCustomerApplicableRates] PRIMARY KEY CLUSTERED 
(
	[CustomerId] ASC,
	[RatesId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblCustomerApplicableTax]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblCustomerApplicableTax](
	[CustomerId] [varchar](20) NULL,
	[TaxCode] [varchar](20) NOT NULL,
	[TaxRegistrationNo] [varchar](20) NOT NULL,
	[IsActive] [varchar](1) NULL,
	[ModifiedBy] [varchar](20) NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedBy] [varchar](20) NULL,
	[CreatedDate] [datetime] NULL,
	[RequestId] [varchar](20) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblCustomerEmail]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblCustomerEmail](
	[CustomerId] [varchar](20) NOT NULL,
	[Email] [varchar](150) NOT NULL,
	[UserID] [varchar](20) NOT NULL,
 CONSTRAINT [PK_tblCustomerEmail] PRIMARY KEY CLUSTERED 
(
	[CustomerId] ASC,
	[Email] ASC,
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblCustomerExportSector]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblCustomerExportSector](
	[CustomerExportSectorId] [int] IDENTITY(1,1) NOT NULL,
	[RequestNo] [varchar](20) NULL,
	[ExportSectorId] [varchar](20) NULL,
	[CustomerId] [varchar](20) NULL,
	[Status] [varchar](1) NULL,
 CONSTRAINT [PK_tblCustomerExportSector_1] PRIMARY KEY CLUSTERED 
(
	[CustomerExportSectorId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblCustomerParent]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblCustomerParent](
	[ParentCustomerId] [varchar](20) NOT NULL,
	[CustomerName] [varchar](150) NOT NULL,
	[Telephone] [varchar](20) NOT NULL,
	[IsSVat] [varchar](10) NOT NULL,
	[Fax] [varchar](20) NULL,
	[Email] [varchar](50) NOT NULL,
	[Address1] [varchar](150) NOT NULL,
	[Address2] [varchar](150) NOT NULL,
	[Address3] [varchar](150) NOT NULL,
	[Status] [varchar](10) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedBy] [varchar](20) NOT NULL,
	[ContactPersonName] [varchar](150) NULL,
	[ContactPersonDesignation] [varchar](50) NULL,
	[ContactPersonDirectPhoneNumber] [varchar](20) NULL,
	[ContactPersonMobile] [varchar](20) NULL,
	[ContactPersonEmail] [varchar](50) NULL,
	[NCEMember] [varchar](10) NULL,
	[PaidType] [varchar](10) NULL,
	[RequestId] [varchar](20) NULL,
 CONSTRAINT [PK_tblCustomerParent] PRIMARY KEY CLUSTERED 
(
	[ParentCustomerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblCustomerParentRequest]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblCustomerParentRequest](
	[RequestId] [varchar](20) NOT NULL,
	[CustomerName] [varchar](150) NOT NULL,
	[Telephone] [varchar](20) NOT NULL,
	[IsSVat] [varchar](10) NOT NULL,
	[Fax] [varchar](20) NULL,
	[Email] [varchar](50) NOT NULL,
	[Address1] [varchar](150) NOT NULL,
	[Address2] [varchar](150) NOT NULL,
	[Address3] [varchar](150) NOT NULL,
	[Status] [varchar](10) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedBy] [varchar](20) NOT NULL,
	[ContactPersonName] [varchar](150) NULL,
	[ContactPersonDesignation] [varchar](50) NULL,
	[ContactPersonDirectPhoneNumber] [varchar](20) NULL,
	[ContactPersonMobile] [varchar](20) NULL,
	[ContactPersonEmail] [varchar](50) NULL,
	[NCEMember] [varchar](10) NULL,
	[PaidType] [varchar](10) NULL,
	[AdminUserId] [varchar](20) NOT NULL,
	[AdminPassword] [varchar](200) NOT NULL,
	[AdminName] [varchar](150) NULL,
 CONSTRAINT [PK_tblCustomerParentRequest] PRIMARY KEY CLUSTERED 
(
	[RequestId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblCustomerRegistartionFiles]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblCustomerRegistartionFiles](
	[CustomerId] [varchar](20) NULL,
	[RegistrationLetterPath] [varchar](200) NOT NULL,
	[RequestLetterPath] [varchar](200) NOT NULL,
	[CreatedDate] [date] NOT NULL,
	[RequestId] [varchar](20) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblCustomerRequest]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblCustomerRequest](
	[RequestId] [varchar](20) NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[Telephone] [varchar](20) NOT NULL,
	[Email] [varchar](50) NOT NULL,
	[Fax] [varchar](20) NULL,
	[Address1] [varchar](150) NOT NULL,
	[Address2] [varchar](150) NULL,
	[Address3] [varchar](150) NULL,
	[Status] [varchar](10) NOT NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [varchar](20) NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [varchar](20) NULL,
	[SVat] [varchar](10) NOT NULL,
	[TemplateId] [varchar](20) NULL,
	[RejectReasonCode] [varchar](20) NULL,
	[ContactPersonName] [varchar](150) NULL,
	[ContactPersonDesignation] [varchar](50) NULL,
	[ContactPersonDirectPhoneNumber] [varchar](20) NULL,
	[ContactPersonMobile] [varchar](20) NULL,
	[ContactPersonEmail] [varchar](50) NULL,
	[Productdetails] [text] NULL,
	[ExportSector] [varchar](100) NULL,
	[NCEMember] [varchar](10) NULL,
	[ParentCustomerId] [varchar](20) NOT NULL,
 CONSTRAINT [PK_tblCustomerRequest1] PRIMARY KEY CLUSTERED 
(
	[RequestId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblCustomerTemplate]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblCustomerTemplate](
	[CustomerId] [varchar](20) NOT NULL,
	[TemplateId] [varchar](20) NOT NULL,
	[CreatedBy] [varchar](20) NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_tblCustomerTemplate] PRIMARY KEY CLUSTERED 
(
	[CustomerId] ASC,
	[TemplateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblDocumentType]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblDocumentType](
	[DocumentTypeId] [varchar](10) NOT NULL,
	[DocumentTypeName] [varchar](150) NOT NULL,
	[IsBaseDocument] [varchar](2) NOT NULL,
 CONSTRAINT [PK_tblDocumentType] PRIMARY KEY CLUSTERED 
(
	[DocumentTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblErrorLog]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblErrorLog](
	[UserId] [varchar](50) NOT NULL,
	[ErrorTime] [datetime] NOT NULL,
	[ErrorMessage] [nvarchar](250) NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblExportSector]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblExportSector](
	[ExportId] [varchar](20) NOT NULL,
	[ExportSector] [varchar](100) NOT NULL,
	[Status] [varchar](1) NULL,
 CONSTRAINT [PK_tblExportSector_1] PRIMARY KEY CLUSTERED 
(
	[ExportId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblFunction]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblFunction](
	[FunctionId] [varchar](10) NOT NULL,
	[FunctionName] [varchar](150) NOT NULL,
 CONSTRAINT [PK_tblFunction] PRIMARY KEY CLUSTERED 
(
	[FunctionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblGroupFunction]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblGroupFunction](
	[FunctionId] [varchar](10) NOT NULL,
	[GroupId] [varchar](20) NOT NULL,
 CONSTRAINT [PK_tblGroupFunction] PRIMARY KEY CLUSTERED 
(
	[FunctionId] ASC,
	[GroupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblIgnoredEmailRequest]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblIgnoredEmailRequest](
	[IndexNo] [bigint] IDENTITY(1,1) NOT NULL,
	[MailID] [varchar](150) NOT NULL,
	[Email] [varchar](150) NOT NULL,
	[CustomerId] [varchar](20) NULL,
	[RecivedDate] [datetime] NOT NULL,
	[EmailSubject] [varchar](50) NOT NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [varchar](20) NULL,
	[ModifiedDate] [date] NULL,
	[ModifiedBy] [varchar](20) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblInvoiceDetail]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblInvoiceDetail](
	[InvoiceLineNo] [bigint] IDENTITY(1,1) NOT NULL,
	[RequestNo] [varchar](20) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[UnitCharge] [decimal](18, 8) NOT NULL,
	[CreatedBy] [varchar](20) NOT NULL,
	[Modifiedby] [varchar](20) NOT NULL,
	[InvoiceNo] [varchar](20) NOT NULL,
 CONSTRAINT [PK_tblInvoiceDetail] PRIMARY KEY CLUSTERED 
(
	[InvoiceLineNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblInvoiceHeader]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblInvoiceHeader](
	[InvoiceNo] [varchar](20) NOT NULL,
	[CustomerId] [varchar](10) NOT NULL,
	[FromDate] [date] NOT NULL,
	[ToDate] [date] NOT NULL,
	[GrossTotal] [decimal](18, 2) NOT NULL,
	[InvoiceTotal] [decimal](18, 6) NOT NULL,
	[IsTaxInvoice] [varchar](4) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedBy] [varchar](50) NOT NULL,
	[PrintTime] [int] NOT NULL,
 CONSTRAINT [PK_tblInvoiceHeader_1] PRIMARY KEY CLUSTERED 
(
	[InvoiceNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblInvoicePrintCount]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblInvoicePrintCount](
	[InvoiceNo] [varchar](20) NOT NULL,
	[PrintCount] [int] NOT NULL,
	[PrintDate] [date] NOT NULL,
	[PrintReason] [text] NOT NULL,
	[PrintedBy] [varchar](20) NOT NULL,
 CONSTRAINT [PK_tblInvoicePrintCount] PRIMARY KEY CLUSTERED 
(
	[InvoiceNo] ASC,
	[PrintCount] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblInvoiceRate]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblInvoiceRate](
	[InvoiceRateId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [varchar](20) NOT NULL,
	[InvoiceNo] [varchar](20) NOT NULL,
	[SupportingDocName] [varchar](50) NOT NULL,
	[RateId] [varchar](10) NOT NULL,
	[RateValue] [decimal](18, 6) NOT NULL,
	[CreatedBy] [varchar](20) NOT NULL,
	[CreatedDate] [varchar](20) NOT NULL,
 CONSTRAINT [PK_tblInvoiceRate] PRIMARY KEY CLUSTERED 
(
	[InvoiceRateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblInvoiceTax]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblInvoiceTax](
	[InvoiceNo] [varchar](20) NOT NULL,
	[TaxCode] [varchar](50) NOT NULL,
	[Amount] [decimal](18, 6) NOT NULL,
	[CreatedBy] [varchar](50) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[TaxPercentage] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_tblInvoiceTax] PRIMARY KEY CLUSTERED 
(
	[InvoiceNo] ASC,
	[TaxCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblLoginInfo]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblLoginInfo](
	[SessionId] [bigint] IDENTITY(1,1) NOT NULL,
	[UserId] [varchar](20) NOT NULL,
	[SessionStart] [datetime] NOT NULL,
	[SessionEnd] [datetime] NOT NULL,
 CONSTRAINT [PK_tblLoginInfo] PRIMARY KEY CLUSTERED 
(
	[SessionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblManualCertificate]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[tblManualCertificate](
	[ReferenceNo] [varchar](20) NOT NULL,
	[IssuedDate] [datetime] NULL,
	[ExporterInvoiceNo] [varchar](20) NULL,
	[ItemDescription] [varchar](1) NULL,
	[Status] [varchar](2) NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [varchar](20) NULL,
	[CustomerId] [varchar](20) NULL,
 CONSTRAINT [PK_tblManualCertificate] PRIMARY KEY CLUSTERED 
(
	[ReferenceNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblMember]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblMember](
	[MemberId] [varchar](8) NOT NULL,
	[MemberName] [varchar](150) NOT NULL,
	[JoinedDate] [datetime] NOT NULL,
	[MemberType] [varchar](8) NULL,
 CONSTRAINT [PK_tblMember] PRIMARY KEY CLUSTERED 
(
	[MemberId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblMemberRates]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblMemberRates](
	[RateID] [varchar](20) NOT NULL,
	[RateValue] [decimal](18, 6) NOT NULL,
	[Member] [varchar](1) NOT NULL,
 CONSTRAINT [PK_tblMemberRates] PRIMARY KEY CLUSTERED 
(
	[RateID] ASC,
	[RateValue] ASC,
	[Member] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblMemberType]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblMemberType](
	[MemberTypeId] [varchar](8) NOT NULL,
	[MemeberType] [varchar](50) NOT NULL,
 CONSTRAINT [PK_tblMemberType] PRIMARY KEY CLUSTERED 
(
	[MemberTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblOwnerDetails]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblOwnerDetails](
	[OrganizationName] [varchar](150) NOT NULL,
	[OwnerId] [varchar](8) NOT NULL,
	[PostBox] [varchar](10) NOT NULL,
	[Address1] [varchar](120) NULL,
	[Address2] [varchar](120) NULL,
	[Address3] [varchar](50) NOT NULL,
	[VARRegNo] [varchar](50) NULL,
	[SVATregNo] [varchar](50) NULL,
	[TelephoneNo] [varchar](10) NOT NULL,
	[FaxNo] [varchar](15) NULL,
	[Email] [varchar](100) NULL,
	[WebAddress] [varchar](150) NULL,
	[ImageUrls] [varchar](150) NULL,
	[Name] [varchar](150) NULL,
 CONSTRAINT [PK_tblOwnerDetails] PRIMARY KEY CLUSTERED 
(
	[OwnerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblPackageType]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblPackageType](
	[PackageType] [varchar](20) NOT NULL,
	[PackageDescription] [varchar](150) NULL,
	[IsActive] [varchar](1) NULL,
	[ModifiedBy] [varchar](20) NULL,
	[ModifiedDate] [date] NULL,
	[CreatedBy] [varchar](20) NULL,
	[CreatedDate] [date] NULL,
 CONSTRAINT [PK_tblPackageType] PRIMARY KEY CLUSTERED 
(
	[PackageType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblParameter]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblParameter](
	[ParameterCode] [varchar](20) NOT NULL,
	[ParameterDescription] [varchar](150) NOT NULL,
	[ParameterValue] [varchar](200) NOT NULL,
 CONSTRAINT [PK_tblParameter] PRIMARY KEY CLUSTERED 
(
	[ParameterCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblPort]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblPort](
	[PortId] [varchar](20) NOT NULL,
	[PortName] [varchar](150) NOT NULL,
	[Active] [varchar](1) NOT NULL,
 CONSTRAINT [PK_tblPort] PRIMARY KEY CLUSTERED 
(
	[PortId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblRates]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblRates](
	[RateId] [varchar](10) NOT NULL,
	[RateName] [varchar](50) NOT NULL,
	[Status] [varchar](2) NOT NULL,
 CONSTRAINT [PK_tblRates] PRIMARY KEY CLUSTERED 
(
	[RateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblRejectReasonCategory]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblRejectReasonCategory](
	[RejectReasonsCategory] [varchar](20) NOT NULL,
	[CategoryDescription] [varchar](100) NOT NULL,
 CONSTRAINT [PK_tblRejectReasonCategory] PRIMARY KEY CLUSTERED 
(
	[RejectReasonsCategory] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblRejectReasons]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblRejectReasons](
	[RejectCode] [varchar](20) NOT NULL,
	[ReasonName] [varchar](150) NOT NULL,
	[Category] [varchar](20) NOT NULL,
	[ModifiedBy] [varchar](20) NULL,
	[ModifiedDate] [date] NULL,
	[IsActive] [varchar](1) NULL,
	[CreatedDate] [date] NULL,
	[CreatedBy] [varchar](20) NULL,
 CONSTRAINT [PK_tblRejectReasons] PRIMARY KEY CLUSTERED 
(
	[RejectCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblRowCertificateRequestDetails]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblRowCertificateRequestDetails](
	[SeqNo] [bigint] IDENTITY(1,1) NOT NULL,
	[RequestId] [varchar](20) NOT NULL,
	[GoodDetails] [varchar](500) NOT NULL,
	[QuantityDetails] [varchar](300) NULL,
	[HSCodeDetails] [varchar](300) NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [varchar](20) NULL,
 CONSTRAINT [PK_tblRowCertificateRequestDetails] PRIMARY KEY CLUSTERED 
(
	[SeqNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblSequence]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblSequence](
	[SequenceName] [varchar](50) NOT NULL,
	[SequesnceValue] [bigint] NULL,
 CONSTRAINT [PK_tblSequence] PRIMARY KEY CLUSTERED 
(
	[SequenceName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblSignatureLevelHeader]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblSignatureLevelHeader](
	[LevelID] [varchar](10) NOT NULL,
	[Description] [varchar](50) NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblSignatureLevels]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblSignatureLevels](
	[UserId] [varchar](20) NOT NULL,
	[LevelId] [varchar](20) NOT NULL,
	[TemplateId] [varchar](20) NOT NULL,
	[IsActive] [varchar](1) NULL,
	[ModifiedDate] [date] NULL,
	[CreatedBy] [varchar](20) NULL,
	[CreatedDate] [date] NULL,
 CONSTRAINT [PK_tblSignatureLevels] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[TemplateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblSupportingDocApproveRequest]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblSupportingDocApproveRequest](
	[RequestID] [varchar](20) NOT NULL,
	[SupportingDocID] [varchar](20) NULL,
	[CustomerID] [varchar](20) NULL,
	[RequestDate] [datetime] NULL,
	[RequestBy] [varchar](20) NULL,
	[Status] [varchar](5) NOT NULL,
	[ApprovedBy] [varchar](20) NULL,
	[ApprovedDate] [datetime] NULL,
	[UploadPath] [varchar](250) NOT NULL,
	[UploadDocName] [varchar](50) NOT NULL,
	[DownloadPath] [varchar](250) NULL,
	[DownloadDocName] [varchar](50) NULL,
	[RejectReasonCode] [varchar](20) NULL,
	[DocExpireDate] [date] NULL,
	[IsDownloaded] [varchar](5) NULL,
	[IsValid] [varchar](5) NULL,
	[CertificateRequestId] [varchar](20) NULL,
 CONSTRAINT [PK_tblSupportingDoc] PRIMARY KEY CLUSTERED 
(
	[RequestID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblSupportingDocumentConfig]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblSupportingDocumentConfig](
	[SupportingDocId] [varchar](20) NOT NULL,
	[LLXcordinates] [decimal](18, 2) NOT NULL,
	[LLYcordinates] [decimal](18, 2) NOT NULL,
	[URXcordinates] [decimal](18, 2) NOT NULL,
	[URYcordinates] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_tblSupportingDocumentConfig] PRIMARY KEY CLUSTERED 
(
	[SupportingDocId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblSupportingDocuments]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblSupportingDocuments](
	[SupportingDocumentId] [varchar](20) NOT NULL,
	[CreatedBy] [varchar](20) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[IsMandatory] [varchar](2) NULL,
	[IsActive] [varchar](2) NULL,
	[SupportingDocumentName] [varchar](100) NULL,
	[ModifiedBy] [varchar](20) NULL,
	[ModifiedDate] [date] NULL,
 CONSTRAINT [PK_tblSupportingDocuments] PRIMARY KEY CLUSTERED 
(
	[SupportingDocumentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblSupportingDOCUpload]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblSupportingDOCUpload](
	[RequestRefNo] [varchar](20) NOT NULL,
	[SupportingDocumentId] [varchar](8) NOT NULL,
	[Remarks] [varchar](150) NULL,
	[UploadedDate] [datetime] NOT NULL,
	[UploadedBy] [varchar](20) NOT NULL,
	[UploadedPath] [varchar](250) NOT NULL,
	[UploadSeqNo] [bigint] IDENTITY(1,1) NOT NULL,
	[DocumentName] [varchar](150) NULL,
	[SignatureRequired] [varchar](5) NULL,
 CONSTRAINT [PK_tblSupportingDOCUpload_1] PRIMARY KEY CLUSTERED 
(
	[UploadSeqNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblTax]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblTax](
	[TaxCode] [varchar](20) NOT NULL,
	[TaxName] [nvarchar](100) NOT NULL,
	[TaxPercentage] [decimal](18, 2) NOT NULL,
	[TaxPriority] [int] NULL,
	[IsActive] [varchar](1) NULL,
	[ModifiedBy] [varchar](20) NULL,
	[ModifiedDate] [date] NULL,
 CONSTRAINT [PK_tblTax] PRIMARY KEY CLUSTERED 
(
	[TaxCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblTaxPriorityList]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblTaxPriorityList](
	[PriorityNo] [int] NOT NULL,
	[PriorityDescription] [varchar](150) NULL,
 CONSTRAINT [PK_tblTaxPriorityList] PRIMARY KEY CLUSTERED 
(
	[PriorityNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblTaxSummary]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblTaxSummary](
	[TaxId] [varchar](20) NOT NULL,
	[InvoiceNo] [varchar](20) NOT NULL,
	[TaxAmount] [decimal](8, 6) NOT NULL,
	[Date] [datetime] NOT NULL,
	[TaxPercentage] [decimal](8, 6) NOT NULL,
 CONSTRAINT [PK_tblTaxSummary] PRIMARY KEY CLUSTERED 
(
	[TaxId] ASC,
	[InvoiceNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblTemplateDownload]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblTemplateDownload](
	[IndexNo] [bigint] IDENTITY(1,1) NOT NULL,
	[TemplateID] [varchar](20) NOT NULL,
	[TemplateDName] [varchar](150) NOT NULL,
	[TemplateIMGPath] [varchar](250) NOT NULL,
	[DownloadPath] [varchar](250) NOT NULL,
	[DownlaodedTime] [bigint] NULL,
 CONSTRAINT [PK_tblTemplateDownload] PRIMARY KEY CLUSTERED 
(
	[IndexNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblTemplateHeader]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblTemplateHeader](
	[TemplateId] [varchar](20) NOT NULL,
	[TemplateName] [nvarchar](50) NOT NULL,
	[ImgUrl] [nchar](200) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[IsActive] [varchar](1) NOT NULL,
	[ModifiedBy] [varchar](20) NOT NULL,
	[CreatedBy] [varchar](20) NOT NULL,
	[Description] [text] NULL,
	[TemplatePath] [varchar](250) NULL,
	[AdminOnly] [varchar](2) NULL,
 CONSTRAINT [PK_tblTemplateHeader_1] PRIMARY KEY CLUSTERED 
(
	[TemplateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblTemplateSupportingDocument]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblTemplateSupportingDocument](
	[SupportingDocumentId] [varchar](20) NOT NULL,
	[TemplateId] [varchar](20) NOT NULL,
	[CreatedBy] [varchar](20) NULL,
	[IsActive] [varchar](1) NULL,
	[CreatedDate] [date] NULL,
	[ModifiedBy] [varchar](20) NULL,
	[ModifiedDate] [date] NULL,
	[IsMandatory] [varchar](1) NULL,
	[TemplateSupportingDocument] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_tblTemplateSupportingDocument_1] PRIMARY KEY CLUSTERED 
(
	[TemplateSupportingDocument] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblUploadBasedCertificateRequest]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblUploadBasedCertificateRequest](
	[RequestId] [varchar](20) NOT NULL,
	[CustomerId] [varchar](20) NOT NULL,
	[RequestDate] [datetime] NOT NULL,
	[Status] [varchar](5) NOT NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [varchar](20) NULL,
	[InvoiceNo] [varchar](50) NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [varchar](20) NULL,
	[CertificatePath] [varchar](250) NULL,
	[UploadPath] [varchar](250) NULL,
	[RejectReasonCode] [varchar](20) NULL,
	[CertificateId] [varchar](20) NULL,
	[Remark] [varchar](50) NULL,
	[SealRequired] [varchar](5) NULL,
 CONSTRAINT [PK_tblUploadBasedCertificateRequest] PRIMARY KEY CLUSTERED 
(
	[RequestId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblUser]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblUser](
	[UserID] [varchar](20) NOT NULL,
	[UserGroupID] [varchar](20) NOT NULL,
	[PersonName] [varchar](150) NOT NULL,
	[Password] [nvarchar](200) NOT NULL,
	[CreatedBy] [nvarchar](50) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdateDate] [datetime] NULL,
	[IsActive] [varchar](1) NOT NULL,
	[PassowordExpiryDate] [datetime] NOT NULL,
	[ParentCustomerId] [varchar](20) NULL,
	[Designation] [varchar](50) NULL,
	[RandomID] [varchar](20) NULL,
	[Email] [varchar](50) NULL,
 CONSTRAINT [PK_tblUser] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblUserGroup]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblUserGroup](
	[GroupId] [varchar](20) NOT NULL,
	[GroupName] [varchar](100) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NULL,
	[IsActive] [varchar](1) NOT NULL,
	[CreatedBy] [nvarchar](20) NOT NULL,
	[ModifiedBy] [varchar](20) NULL,
 CONSTRAINT [PK_tblUserGroup] PRIMARY KEY CLUSTERED 
(
	[GroupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblUserRequest]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblUserRequest](
	[UserRequestId] [varchar](20) NOT NULL,
	[UserId] [varchar](20) NOT NULL,
	[Status] [varchar](10) NOT NULL,
	[CreatedBy] [varchar](20) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ApprovedBy] [varchar](50) NOT NULL,
	[Password] [varchar](150) NOT NULL,
	[ModifiedBy] [varchar](20) NOT NULL,
	[ModifiedDate] [datetime] NULL,
	[PersonName] [varchar](150) NULL,
	[UserGroupID] [varchar](20) NULL,
	[ParentCustomerId] [varchar](20) NULL,
	[RejectReason] [varchar](20) NULL,
 CONSTRAINT [PK_tblUserRequest] PRIMARY KEY CLUSTERED 
(
	[UserRequestId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblUserSignature]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblUserSignature](
	[UserID] [varchar](20) NOT NULL,
	[PFXpath] [nvarchar](250) NOT NULL,
	[SignatureIMGPath] [nvarchar](250) NOT NULL,
	[CreatedBy] [varchar](20) NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_tblUserSignature] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblWebBasedCertificateRequest]    Script Date: 7/23/2018 12:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblWebBasedCertificateRequest](
	[IndexNo] [bigint] IDENTITY(1,1) NOT NULL,
	[RequestId] [varchar](20) NOT NULL,
	[CertificatePath] [varchar](250) NOT NULL,
	[CertificateName] [varchar](50) NOT NULL,
	[CreatedDate] [datetime] NULL,
	[Status] [varchar](5) NOT NULL,
 CONSTRAINT [PK_tblWebBasedCertificateRequest] PRIMARY KEY CLUSTERED 
(
	[IndexNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tblContactFormDetails] ADD  CONSTRAINT [DF_tblContactFormDetails_ViewStatus]  DEFAULT ('N') FOR [ViewStatus]
GO
ALTER TABLE [dbo].[tblUploadBasedCertificateRequest] ADD  CONSTRAINT [DF_tblUploadBasedCertificateRequest_Remark]  DEFAULT ('A') FOR [Remark]
GO
ALTER TABLE [dbo].[tblCancelledCertificate]  WITH CHECK ADD  CONSTRAINT [FK_tblCancelledcertificate_tblCustomer] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[tblCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[tblCancelledCertificate] CHECK CONSTRAINT [FK_tblCancelledcertificate_tblCustomer]
GO
ALTER TABLE [dbo].[tblCertifcateRequestHeader]  WITH CHECK ADD  CONSTRAINT [FK_tblCertifateRequest_tblTemplateHeader] FOREIGN KEY([TemplateId])
REFERENCES [dbo].[tblTemplateHeader] ([TemplateId])
GO
ALTER TABLE [dbo].[tblCertifcateRequestHeader] CHECK CONSTRAINT [FK_tblCertifateRequest_tblTemplateHeader]
GO
ALTER TABLE [dbo].[tblCertifcateRequestHeader]  WITH CHECK ADD  CONSTRAINT [FK_tblCertifateRequest_tblUser] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[tblUser] ([UserID])
GO
ALTER TABLE [dbo].[tblCertifcateRequestHeader] CHECK CONSTRAINT [FK_tblCertifateRequest_tblUser]
GO
ALTER TABLE [dbo].[tblCertificate]  WITH CHECK ADD  CONSTRAINT [FK_tblCertificate_tblUser] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[tblUser] ([UserID])
GO
ALTER TABLE [dbo].[tblCertificate] CHECK CONSTRAINT [FK_tblCertificate_tblUser]
GO
ALTER TABLE [dbo].[tblCertificateRequestDetails]  WITH CHECK ADD  CONSTRAINT [FK_tblCertificaterRequestDetails_tblCertifcateRequestHeader] FOREIGN KEY([RequestId])
REFERENCES [dbo].[tblCertifcateRequestHeader] ([RequestId])
GO
ALTER TABLE [dbo].[tblCertificateRequestDetails] CHECK CONSTRAINT [FK_tblCertificaterRequestDetails_tblCertifcateRequestHeader]
GO
ALTER TABLE [dbo].[tblCertificateRequestDetails]  WITH CHECK ADD  CONSTRAINT [FK_tblCertificaterRequestDetails_tblUser] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[tblUser] ([UserID])
GO
ALTER TABLE [dbo].[tblCertificateRequestDetails] CHECK CONSTRAINT [FK_tblCertificaterRequestDetails_tblUser]
GO
ALTER TABLE [dbo].[tblCustomer]  WITH CHECK ADD  CONSTRAINT [FK_tblCustomer_tblCustomerParent] FOREIGN KEY([ParentCustomerId])
REFERENCES [dbo].[tblCustomerParent] ([ParentCustomerId])
GO
ALTER TABLE [dbo].[tblCustomer] CHECK CONSTRAINT [FK_tblCustomer_tblCustomerParent]
GO
ALTER TABLE [dbo].[tblCustomer]  WITH CHECK ADD  CONSTRAINT [FK_tblCustomer_tblCustomerRequest] FOREIGN KEY([RequestId])
REFERENCES [dbo].[tblCustomerRequest] ([RequestId])
GO
ALTER TABLE [dbo].[tblCustomer] CHECK CONSTRAINT [FK_tblCustomer_tblCustomerRequest]
GO
ALTER TABLE [dbo].[tblCustomerParent]  WITH CHECK ADD  CONSTRAINT [FK_tblCustomerParent_tblCustomerParentRequest] FOREIGN KEY([RequestId])
REFERENCES [dbo].[tblCustomerParentRequest] ([RequestId])
GO
ALTER TABLE [dbo].[tblCustomerParent] CHECK CONSTRAINT [FK_tblCustomerParent_tblCustomerParentRequest]
GO
ALTER TABLE [dbo].[tblCustomerRequest]  WITH CHECK ADD  CONSTRAINT [FK_tblCustomerRequest_tblCustomerParent] FOREIGN KEY([ParentCustomerId])
REFERENCES [dbo].[tblCustomerParent] ([ParentCustomerId])
GO
ALTER TABLE [dbo].[tblCustomerRequest] CHECK CONSTRAINT [FK_tblCustomerRequest_tblCustomerParent]
GO
ALTER TABLE [dbo].[tblCustomerRequest]  WITH CHECK ADD  CONSTRAINT [FK_tblCustomerRequest_tblTemplateHeader] FOREIGN KEY([TemplateId])
REFERENCES [dbo].[tblTemplateHeader] ([TemplateId])
GO
ALTER TABLE [dbo].[tblCustomerRequest] CHECK CONSTRAINT [FK_tblCustomerRequest_tblTemplateHeader]
GO
ALTER TABLE [dbo].[tblCustomerTemplate]  WITH CHECK ADD  CONSTRAINT [FK_tblCustomerTemplate_tblTemplateHeader] FOREIGN KEY([TemplateId])
REFERENCES [dbo].[tblTemplateHeader] ([TemplateId])
GO
ALTER TABLE [dbo].[tblCustomerTemplate] CHECK CONSTRAINT [FK_tblCustomerTemplate_tblTemplateHeader]
GO
ALTER TABLE [dbo].[tblCustomerTemplate]  WITH CHECK ADD  CONSTRAINT [FK_tblCustomerTemplate_tblUser] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[tblUser] ([UserID])
GO
ALTER TABLE [dbo].[tblCustomerTemplate] CHECK CONSTRAINT [FK_tblCustomerTemplate_tblUser]
GO
ALTER TABLE [dbo].[tblGroupFunction]  WITH CHECK ADD  CONSTRAINT [FK_tblGroupFunction_tblFunction] FOREIGN KEY([FunctionId])
REFERENCES [dbo].[tblFunction] ([FunctionId])
GO
ALTER TABLE [dbo].[tblGroupFunction] CHECK CONSTRAINT [FK_tblGroupFunction_tblFunction]
GO
ALTER TABLE [dbo].[tblIgnoredEmailRequest]  WITH CHECK ADD  CONSTRAINT [FK_tblIgnoredEmailRequest_tblCustomer] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[tblCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[tblIgnoredEmailRequest] CHECK CONSTRAINT [FK_tblIgnoredEmailRequest_tblCustomer]
GO
ALTER TABLE [dbo].[tblIgnoredEmailRequest]  WITH CHECK ADD  CONSTRAINT [FK_tblIgnoredEmailRequest_tblUser] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[tblUser] ([UserID])
GO
ALTER TABLE [dbo].[tblIgnoredEmailRequest] CHECK CONSTRAINT [FK_tblIgnoredEmailRequest_tblUser]
GO
ALTER TABLE [dbo].[tblInvoicePrintCount]  WITH CHECK ADD  CONSTRAINT [FK_tblInvoicePrintCount_tblInvoiceHeader] FOREIGN KEY([InvoiceNo])
REFERENCES [dbo].[tblInvoiceHeader] ([InvoiceNo])
GO
ALTER TABLE [dbo].[tblInvoicePrintCount] CHECK CONSTRAINT [FK_tblInvoicePrintCount_tblInvoiceHeader]
GO
ALTER TABLE [dbo].[tblInvoicePrintCount]  WITH CHECK ADD  CONSTRAINT [FK_tblInvoicePrintCount_tblUser] FOREIGN KEY([PrintedBy])
REFERENCES [dbo].[tblUser] ([UserID])
GO
ALTER TABLE [dbo].[tblInvoicePrintCount] CHECK CONSTRAINT [FK_tblInvoicePrintCount_tblUser]
GO
ALTER TABLE [dbo].[tblRejectReasons]  WITH CHECK ADD  CONSTRAINT [FK_tblRejectReasons_tblRejectReasonCategory] FOREIGN KEY([Category])
REFERENCES [dbo].[tblRejectReasonCategory] ([RejectReasonsCategory])
GO
ALTER TABLE [dbo].[tblRejectReasons] CHECK CONSTRAINT [FK_tblRejectReasons_tblRejectReasonCategory]
GO
ALTER TABLE [dbo].[tblRejectReasons]  WITH CHECK ADD  CONSTRAINT [FK_tblRejectReasons_tblUser] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[tblUser] ([UserID])
GO
ALTER TABLE [dbo].[tblRejectReasons] CHECK CONSTRAINT [FK_tblRejectReasons_tblUser]
GO
ALTER TABLE [dbo].[tblRowCertificateRequestDetails]  WITH CHECK ADD  CONSTRAINT [FK_tblRowCertificateRequestDetails_tblCertifcateRequestHeader] FOREIGN KEY([RequestId])
REFERENCES [dbo].[tblCertifcateRequestHeader] ([RequestId])
GO
ALTER TABLE [dbo].[tblRowCertificateRequestDetails] CHECK CONSTRAINT [FK_tblRowCertificateRequestDetails_tblCertifcateRequestHeader]
GO
ALTER TABLE [dbo].[tblRowCertificateRequestDetails]  WITH CHECK ADD  CONSTRAINT [FK_tblRowCertificateRequestDetails_tblUser] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[tblUser] ([UserID])
GO
ALTER TABLE [dbo].[tblRowCertificateRequestDetails] CHECK CONSTRAINT [FK_tblRowCertificateRequestDetails_tblUser]
GO
ALTER TABLE [dbo].[tblSignatureLevels]  WITH CHECK ADD  CONSTRAINT [FK_tblSignatureLevels_tblTemplateHeader] FOREIGN KEY([TemplateId])
REFERENCES [dbo].[tblTemplateHeader] ([TemplateId])
GO
ALTER TABLE [dbo].[tblSignatureLevels] CHECK CONSTRAINT [FK_tblSignatureLevels_tblTemplateHeader]
GO
ALTER TABLE [dbo].[tblSignatureLevels]  WITH CHECK ADD  CONSTRAINT [FK_tblSignatureLevels_tblUser] FOREIGN KEY([UserId])
REFERENCES [dbo].[tblUser] ([UserID])
GO
ALTER TABLE [dbo].[tblSignatureLevels] CHECK CONSTRAINT [FK_tblSignatureLevels_tblUser]
GO
ALTER TABLE [dbo].[tblSupportingDocApproveRequest]  WITH CHECK ADD  CONSTRAINT [FK_tblSupportingDoc_tblSupportingDoc] FOREIGN KEY([RejectReasonCode])
REFERENCES [dbo].[tblRejectReasons] ([RejectCode])
GO
ALTER TABLE [dbo].[tblSupportingDocApproveRequest] CHECK CONSTRAINT [FK_tblSupportingDoc_tblSupportingDoc]
GO
ALTER TABLE [dbo].[tblSupportingDocApproveRequest]  WITH CHECK ADD  CONSTRAINT [FK_tblSupportingDocApproveRequest_tblCustomer] FOREIGN KEY([CustomerID])
REFERENCES [dbo].[tblCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[tblSupportingDocApproveRequest] CHECK CONSTRAINT [FK_tblSupportingDocApproveRequest_tblCustomer]
GO
ALTER TABLE [dbo].[tblSupportingDocApproveRequest]  WITH CHECK ADD  CONSTRAINT [FK_tblSupportingDocApproveRequest_tblUser] FOREIGN KEY([RequestBy])
REFERENCES [dbo].[tblUser] ([UserID])
GO
ALTER TABLE [dbo].[tblSupportingDocApproveRequest] CHECK CONSTRAINT [FK_tblSupportingDocApproveRequest_tblUser]
GO
ALTER TABLE [dbo].[tblSupportingDocApproveRequest]  WITH CHECK ADD  CONSTRAINT [FK_tblSupportingDocApproveRequest_tblUser1] FOREIGN KEY([ApprovedBy])
REFERENCES [dbo].[tblUser] ([UserID])
GO
ALTER TABLE [dbo].[tblSupportingDocApproveRequest] CHECK CONSTRAINT [FK_tblSupportingDocApproveRequest_tblUser1]
GO
ALTER TABLE [dbo].[tblSupportingDocuments]  WITH CHECK ADD  CONSTRAINT [FK_tblSupportingDocuments_tblSupportingDocuments] FOREIGN KEY([SupportingDocumentId])
REFERENCES [dbo].[tblSupportingDocuments] ([SupportingDocumentId])
GO
ALTER TABLE [dbo].[tblSupportingDocuments] CHECK CONSTRAINT [FK_tblSupportingDocuments_tblSupportingDocuments]
GO
ALTER TABLE [dbo].[tblSupportingDocuments]  WITH CHECK ADD  CONSTRAINT [FK_tblSupportingDocuments_tblUser] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[tblUser] ([UserID])
GO
ALTER TABLE [dbo].[tblSupportingDocuments] CHECK CONSTRAINT [FK_tblSupportingDocuments_tblUser]
GO
ALTER TABLE [dbo].[tblSupportingDocuments]  WITH CHECK ADD  CONSTRAINT [FK_tblSupportingDocuments_tblUser1] FOREIGN KEY([ModifiedBy])
REFERENCES [dbo].[tblUser] ([UserID])
GO
ALTER TABLE [dbo].[tblSupportingDocuments] CHECK CONSTRAINT [FK_tblSupportingDocuments_tblUser1]
GO
ALTER TABLE [dbo].[tblSupportingDOCUpload]  WITH CHECK ADD  CONSTRAINT [FK_tblSupportingDOCUpload_tblUser] FOREIGN KEY([UploadedBy])
REFERENCES [dbo].[tblUser] ([UserID])
GO
ALTER TABLE [dbo].[tblSupportingDOCUpload] CHECK CONSTRAINT [FK_tblSupportingDOCUpload_tblUser]
GO
ALTER TABLE [dbo].[tblTax]  WITH CHECK ADD  CONSTRAINT [FK_tblTax_tblTaxPriorityList] FOREIGN KEY([TaxPriority])
REFERENCES [dbo].[tblTaxPriorityList] ([PriorityNo])
GO
ALTER TABLE [dbo].[tblTax] CHECK CONSTRAINT [FK_tblTax_tblTaxPriorityList]
GO
ALTER TABLE [dbo].[tblTax]  WITH CHECK ADD  CONSTRAINT [FK_tblTax_tblUser] FOREIGN KEY([ModifiedBy])
REFERENCES [dbo].[tblUser] ([UserID])
GO
ALTER TABLE [dbo].[tblTax] CHECK CONSTRAINT [FK_tblTax_tblUser]
GO
ALTER TABLE [dbo].[tblTemplateHeader]  WITH CHECK ADD  CONSTRAINT [FK_tblTemplateHeader_tblUser] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[tblUser] ([UserID])
GO
ALTER TABLE [dbo].[tblTemplateHeader] CHECK CONSTRAINT [FK_tblTemplateHeader_tblUser]
GO
ALTER TABLE [dbo].[tblTemplateHeader]  WITH CHECK ADD  CONSTRAINT [FK_tblTemplateHeader_tblUser1] FOREIGN KEY([ModifiedBy])
REFERENCES [dbo].[tblUser] ([UserID])
GO
ALTER TABLE [dbo].[tblTemplateHeader] CHECK CONSTRAINT [FK_tblTemplateHeader_tblUser1]
GO
ALTER TABLE [dbo].[tblTemplateSupportingDocument]  WITH CHECK ADD  CONSTRAINT [FK_tblTemplateSupportingDocument_tblTemplateHeader] FOREIGN KEY([TemplateId])
REFERENCES [dbo].[tblTemplateHeader] ([TemplateId])
GO
ALTER TABLE [dbo].[tblTemplateSupportingDocument] CHECK CONSTRAINT [FK_tblTemplateSupportingDocument_tblTemplateHeader]
GO
ALTER TABLE [dbo].[tblUploadBasedCertificateRequest]  WITH CHECK ADD  CONSTRAINT [FK_tblUploadBasedCertificateRequest_tblCertificate] FOREIGN KEY([CertificateId])
REFERENCES [dbo].[tblCertificate] ([CertificateId])
GO
ALTER TABLE [dbo].[tblUploadBasedCertificateRequest] CHECK CONSTRAINT [FK_tblUploadBasedCertificateRequest_tblCertificate]
GO
ALTER TABLE [dbo].[tblUploadBasedCertificateRequest]  WITH CHECK ADD  CONSTRAINT [FK_tblUploadBasedCertificateRequest_tblRejectReasons] FOREIGN KEY([RejectReasonCode])
REFERENCES [dbo].[tblRejectReasons] ([RejectCode])
GO
ALTER TABLE [dbo].[tblUploadBasedCertificateRequest] CHECK CONSTRAINT [FK_tblUploadBasedCertificateRequest_tblRejectReasons]
GO
ALTER TABLE [dbo].[tblUploadBasedCertificateRequest]  WITH CHECK ADD  CONSTRAINT [FK_tblUploadBasedCertificateRequest_tblUser] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[tblUser] ([UserID])
GO
ALTER TABLE [dbo].[tblUploadBasedCertificateRequest] CHECK CONSTRAINT [FK_tblUploadBasedCertificateRequest_tblUser]
GO
ALTER TABLE [dbo].[tblUploadBasedCertificateRequest]  WITH CHECK ADD  CONSTRAINT [FK_tblUploadBasedCertificateRequest_tblUser1] FOREIGN KEY([ModifiedBy])
REFERENCES [dbo].[tblUser] ([UserID])
GO
ALTER TABLE [dbo].[tblUploadBasedCertificateRequest] CHECK CONSTRAINT [FK_tblUploadBasedCertificateRequest_tblUser1]
GO
ALTER TABLE [dbo].[tblUser]  WITH CHECK ADD  CONSTRAINT [FK_tblUser_tblCustomer] FOREIGN KEY([ParentCustomerId])
REFERENCES [dbo].[tblCustomerParent] ([ParentCustomerId])
GO
ALTER TABLE [dbo].[tblUser] CHECK CONSTRAINT [FK_tblUser_tblCustomer]
GO
ALTER TABLE [dbo].[tblUserGroup]  WITH CHECK ADD  CONSTRAINT [FK_tblUserGroup_tblUserGroup1] FOREIGN KEY([GroupId])
REFERENCES [dbo].[tblUserGroup] ([GroupId])
GO
ALTER TABLE [dbo].[tblUserGroup] CHECK CONSTRAINT [FK_tblUserGroup_tblUserGroup1]
GO
ALTER TABLE [dbo].[tblUserRequest]  WITH CHECK ADD  CONSTRAINT [FK_tblUserRequest_tblCustomer] FOREIGN KEY([ParentCustomerId])
REFERENCES [dbo].[tblCustomerParent] ([ParentCustomerId])
GO
ALTER TABLE [dbo].[tblUserRequest] CHECK CONSTRAINT [FK_tblUserRequest_tblCustomer]
GO
ALTER TABLE [dbo].[tblUserRequest]  WITH CHECK ADD  CONSTRAINT [FK_tblUserRequest_tblRejectReasons] FOREIGN KEY([RejectReason])
REFERENCES [dbo].[tblRejectReasons] ([RejectCode])
GO
ALTER TABLE [dbo].[tblUserRequest] CHECK CONSTRAINT [FK_tblUserRequest_tblRejectReasons]
GO
ALTER TABLE [dbo].[tblUserRequest]  WITH CHECK ADD  CONSTRAINT [FK_tblUserRequest_tblUserGroup] FOREIGN KEY([UserGroupID])
REFERENCES [dbo].[tblUserGroup] ([GroupId])
GO
ALTER TABLE [dbo].[tblUserRequest] CHECK CONSTRAINT [FK_tblUserRequest_tblUserGroup]
GO
ALTER TABLE [dbo].[tblUserSignature]  WITH CHECK ADD  CONSTRAINT [FK_tblUserSignature_tblUserSignature] FOREIGN KEY([UserID])
REFERENCES [dbo].[tblUser] ([UserID])
GO
ALTER TABLE [dbo].[tblUserSignature] CHECK CONSTRAINT [FK_tblUserSignature_tblUserSignature]
GO
USE [master]
GO
ALTER DATABASE [NCEDCO] SET  READ_WRITE 
GO
