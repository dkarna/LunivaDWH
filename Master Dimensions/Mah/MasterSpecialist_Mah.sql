CREATE TABLE DataWareHouse.[dbo].[MasterSpecialist_Mah](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[_SpecialistIdOrig] [int] NOT NULL,
	[Name] [varchar](100) NULL,
	[Designation] [varchar](100) NULL,
	[NMCRegID] [varchar](100) NULL,
	[NHPCRegID] [varchar](100) NULL,
	[OtherReg] [varchar](100) NULL,
	[PrimarySpeciality] [varchar](100) NULL,
	[SecondarySpeciality] [varchar](100) NULL,
	[PrimaryHospital] [varchar](100) NULL,
	[IsActive] [bit] NULL,
	[IsReferrer] [bit] NULL,
	[_OrigTabId] [int] NULL,
 CONSTRAINT [PK_MasterSpecialist_Mah] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

-- Insert data

Insert into DataWareHouse.dbo.MasterSpecialist_Mah
select distinct s.*
from
  (
    select
	  ptpr.Id as _SpecialistIdOrig,
      ptpr.Name as Name,
      case when ptpr.Name like 'Dr%' then 'Doctor'
 when ptpr.Name like '%Hospital%' THEN 'Hospital'
 when ptpr.Name like '%Health%Care%' THEN  'HealthCare' else 'Other' end as Designation, '0' as NMCRegID, '0' as NHPCRegID, '0' as OtherReg, '' AS PrimarySpeciality
, '' as SecondarySpeciality
, case when Hospital='N' or Hospital='' or Hospital is null THEN ''
 ELSE Hospital END as PrimaryHospital
 , 1 AS IsActive
 , 1 as IsReferrer
, 0 as _OrigTabId
    from pat.tbl_PatReferDoctor ptpr
  union
    select
	  tptc.Id as _SpecialistIdOrig,
      tptc.Name as Name,
      tptc.Designation,
      case when Reg_No like '%NMC%' then Reg_No 
   when tptc.Designation like '%NMC%' THEN Designation else '' end as NMCRegID
, case when Reg_No like '%nhpc%' then Reg_No else '' end as NHPCRegID
, case when Reg_No Not Like '%nmc%' and Reg_No not like '%nhpc%' then Reg_No else '' end as OtherReg
, case when tptc.Designation like '%lab%' or tptc.Designation like '%patholog%' then 'Pathologist'
   when tptc.Designation like '%biochem%' then 'BioChemist'
   when tptc.Designation like '%techno%' then 'Technologist'
   when tptc.Designation like '%microbio%' then 'Microbiologist'
   else ''
end as PrimarySpeciality
, case when tptc.Designation like '%consult%' then 'Consultant'
  else ''
 end as SecondarySpeciality
, '' as PrimaryHospital
, 1 as IsActive
, 0 as IsReferrer
, 0 as _OrigTabId
    from tbl_PatTestCheckedBy tptc
    where tptc.Name NOT IN ('' ,'SELECT')
) as s 
order by s._SpecialistIdOrig