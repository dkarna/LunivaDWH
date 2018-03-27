CREATE TABLE DiagnosisMaster
(
	ID INT IDENTITY(1,1) PRIMARY KEY
	,_DiagnosisIDOrig VARCHAR(255) 
	,DiagnosisName VARCHAR(255) 
	,CreateTs DATETIME
	,UpdateTs DATEtIME
)

-- Data insert

INSERT INTO DataWareHouse..DiagnosisMaster

SELECT
  diag.Id		AS _DiagnosisIDOrig
, Diagnosis		AS DiagnosisName
,getdate() as CreateTs
,getdate()as UpdateTs
FROM tbl_DiagnosisGroup Diag