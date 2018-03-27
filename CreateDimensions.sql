CREATE TABLE LoginInfo
(
	 ID				INT IDENTITY(1,1) PRIMARY KEY
	,LoginType		VARCHAR(20) -- Doctor, Member, Patient
	,LoginID		VARCHAR(50)
	,LoginPw		VARCHAR(50)
	,CreateTs		DATETIME
	,UpdateTS		DATETIME
	,IsActive		BIT
)




