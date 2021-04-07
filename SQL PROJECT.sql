-- QUERY 1
SELECT ClaimantID, ReopenedDate 
FROM Claimant;

-- QUERY 2
SELECT PK, MAX(EntryDate) AS ExamnierAssignedDate
FROM ClaimLog
WHERE FieldName = 'ExaminerCode'
GROUP BY PK;

-- QUERY 3
SELECT ClaimNumber, MAX(EnteredOn) AS LastSavedOn
FROM ReservingTool
WHERE IsPublished = 1
GROUP BY ClaimNumber;

-- QUERY 4
SELECT C.ClaimNumber, O.OfficeDesc, O.[State], CS.ClaimStatusDesc, 
    P.FirstName +  P.LastName AS ClaimantName, Clmt.ReopenedDate, CT.ClaimantTypeDesc,
    U.ReserveLimit, R.ReserveAmount, RT.ReserveTypeDesc, U.UserName AS ExaminerCode,
    Users2.UserName AS SupervisorCode, Users3.UserName AS ManagerCode,
    U.Title AS ExaminerTitle, Users2.Title AS SupervisorTitle, Users3.Title AS ManagerTitle,
    U.LastFirstName AS ExaminerName, Users2.LastFirstName AS SupervisorName, Users3.LastFirstName AS ManagerName,
    (CASE WHEN RT.ParentID IN (1,2,3,4,5) THEN RT.ParentID 
        ELSE RT.reserveTypeID END) AS ReserveCostID
FROM Claimant Clmt
INNER JOIN Claim C ON C.ClaimID = Clmt.ClaimID
INNER JOIN Users U ON U.UserName = Clmt.EnteredBy
INNER JOIN Users Users2 ON Users2.Supervisor = U.UserName
INNER JOIN Users Users3 ON Users3.UserName = Users2.UserName
INNER JOIN Office O ON O.OfficeID = U.OfficeID 
INNER JOIN ClaimantType CT ON CT.ClaimantTypeID = Clmt.ClaimantTypeID
INNER JOIN Reserve R ON R.ClaimantID = Clmt.ClaimantID
LEFT JOIN ClaimStatus CS ON CS.ClaimStatusID = Clmt.claimStatusID 
LEFT JOIN ReserveType RT ON RT.reserveTypeID = R.ReserveTypeID 
LEFT JOIN Patient P ON P.PatientID = Clmt.PatientID
WHERE O.OfficeDesc IN ('Sacramento', 'San Diego', 'San Francisco')
    AND (RT.ParentID IN (1,2,3,4,5) OR RT.reserveTypeID IN (1,2,3,4,5))
    AND (CS.ClaimStatusID = 1 OR CS.ClaimStatusID = 2 AND Clmt.ReopenedReasonID <> 3)

