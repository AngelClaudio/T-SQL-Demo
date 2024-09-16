  USE AdventureWorks2019
  -- Demo of COUNT function in T-SQL, which returns the number of items found in a group.

  -- Aggregation Function Syntax: COUNT ( { [ [ ALL | DISTINCT ] expression ] | * } )
  -- Analytic Function Syntax:    COUNT ( [ ALL ]  { expression | * } ) OVER ( [ <partition_by_clause> ] )
  -- Aggregation vs Analytic reviewed at the end (3rd Question)

  -- Reference: https://learn.microsoft.com/en-us/sql/t-sql/functions/count-transact-sql?view=sql-server-ver16

  -- Question 1 (by Shine): Doesn't COUNT(*) and COUNT(expression) do the same, count all rows?
  SELECT *   FROM [AdventureWorks2019].[Sales].[SalesPerson];

  SELECT COUNT(*) NumberOfRowsInSalesPerson
  FROM Sales.SalesPerson;

  /*
  The asterisk (*) specifies to count all rows to determine the total table row count.
  - Doesn't support DISTINCT
  - Doesn't care about information about any one attribute.
  - Preserves duplicate row (counts duplicates).
  - Counts rows with null values.
  */

  SELECT COUNT(TerritoryID) NumberOfNonNullTerritoryID
  FROM Sales.SalesPerson;
  GO
  /*
  When you choose to use an expression in lieu of *, it counts all rows via evaluation of the expression.
  - Defaults to ALL argument (meaning duplicates allowed).
  - Counts only non-null evaluations.
  */

  -- Question 2 (by Maruf): Is COUNT(1) equivalent to using the first column's name as the expression in COUNT?
  SELECT *   FROM [AdventureWorks2019].[Sales].[SalesPerson];
  
  SELECT COUNT(1) CountOfTheEvaluationOfOne
  FROM Sales.SalesPerson;
  
  /*
  Recall that the expression (aside from asterisk which is a special convention that doesn't get evaluated)
  is evaluated per record. Essentially what you are saying is evaluate your expression (is not null),
  as a condition, per record.
  */
  SELECT COUNT(DISTINCT 1) CountOfTheResultSetAsUnique
  FROM Sales.SalesPerson;
  GO
  /*
  The above verifies that since your evaluation of 1 will be the same for all records,
  if you apply the DISTINCT argument (which will forbid duplicates), you will get only 1 count.
  */

  -- Bonus Question 3: What are analytic functions?

SELECT DISTINCT d.[Name]
    , MIN(eph.Rate) OVER (PARTITION BY edh.DepartmentID) AS MinSalary
    , MAX(eph.Rate) OVER (PARTITION BY edh.DepartmentID) AS MaxSalary
    , AVG(eph.Rate) OVER (PARTITION BY edh.DepartmentID) AS AvgSalary
    , COUNT(edh.BusinessEntityID) OVER (PARTITION BY edh.DepartmentID) AS EmployeesPerDept
FROM HumanResources.EmployeePayHistory AS eph
		JOIN HumanResources.EmployeeDepartmentHistory AS edh
			ON eph.BusinessEntityID = edh.BusinessEntityID
		JOIN HumanResources.Department AS d
			ON d.DepartmentID = edh.DepartmentID
WHERE edh.EndDate IS NULL
ORDER BY Name;
/*
- A function is considered "Analytic" when it uses the OVER clause, which defines a window (a user specified set of rows),
- in which it may return multiple rows for each window.
- Analytics do not reduce the number of rows returned.
- Aggregate functions, may be considered "Analytic" when used with "Over", and there are some functions that are purely "Analytic".
- Aggregate function which are used as "Analytic" function will mostly use the PARTITION BY sub-clause of OVER.
*/

-- Bonus Question 4: How can I better study T-SQL independently (or in my interpretation, make it fun)?

/*
 The key to increasing your understanding of anything, is by increasing your "vocabulary" in that thing.

 - YouTube & Blogs; quick and dirty vs clean and sustainable

 - Establish the "manual" (yes "RTFM" is legit), sources of information that are official or recognized authorities.
   (Review Question 3, e.g. look at how to read conventions, understanding expressions, and reading "Remarks" section,

 - Making "work" easier; a little bit daily goes a long way, try to end with a deep understanding aka "solid fundamentals"
*/