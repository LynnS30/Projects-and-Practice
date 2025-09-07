Select *
From PortfolioProject..[National Debt]
----------------------------------------------------------------------------

-- Separating out Quaters


Select [Record Date],
	YEAR([Record Date]) AS Year,
	' Q' + CAST(DATEPART(QUARTER, [Record Date]) AS VARCHAR) as Quarter
From PortfolioProject..[National Debt];



Select YEAR([Record Date]) AS Year,
	DATEPART(Quarter, [Record Date]) AS Quarter,
	SUM([Total Public Debt Outstanding]) AS TotalDebt
From PortfolioProject..[National Debt]
Group by YEAR([Record Date]),
	DATEPART(Quarter, [Record Date])
Order by year, Quarter;
	
Select [Record Date],
	CAST(YEAR([Record Date]) AS VARCHAR) + ' Q' + CAST(DATEPART(QUARTER, [Record Date]) AS VARCHAR) AS YearQuarter,
	[Total Public Debt Outstanding]
From PortfolioProject..[National Debt]

Alter Table [National Debt]
ADD DebtQuart VARCHAR(10);

Update [National Debt]
Set DebtQuart = CAST(YEAR([Record Date]) AS VARCHAR) + ' Q' + CAST(DATEPART(QUARTER, [Record Date]) AS VARCHAR)


Alter Table [National Debt]
Add DebtQuarter VARCHAR(10)

UPDATE dbo.[National Debt]
SET DebtQuarter = 
    CAST([Year] AS VARCHAR) + ' Q' + CAST([Quarter] AS VARCHAR);

UPDATE dbo.[National Debt]
SET DebtQuarter = 
    CAST([Year] AS VARCHAR) + [Quarter];

SELECT DISTINCT DebtQuarter FROM dbo.[National Debt] ORDER BY DebtQuarter;



----------------------------------------------------------------------------

-- Real GDP


Select *
From PortfolioProject..RealGDP


ALTER TABLE PortfolioProject..RealGDP
ADD DebtQuarter VARCHAR(10);

UPDATE PortfolioProject..RealGDP
SET DebtQuarter = 
	CAST(YEAR(CONVERT(date, [observation_date])) AS VARCHAR(4)) + 'Q' +
	CAST(DATEPART(QUARTER, CONVERT(date, [observation_date])) AS VARCHAR(1));

ALTER TABLE PortfolioProject..RealGDP
ADD RealGDP FLOAT;

Update PortfolioProject..RealGDP
SET RealGDP = GDPC1



----------------------------------------------------------------------------

-- Nominal GDP

Select *
From PortfolioProject..NominalGDP



ALTER TABLE PortfolioProject..NominalGDP
ADD DebtQuarter VARCHAR(10);

UPDATE PortfolioProject..NominalGDP
SET DebtQuarter = 
	CAST(YEAR(CONVERT(date, [observation_date])) AS VARCHAR(4)) + 'Q' +
	CAST(DATEPART(QUARTER, CONVERT(date, [observation_date])) AS VARCHAR(1));

ALTER TABLE PortfolioProject..NominalGDP
ADD NominalGDP FLOAT;

Update PortfolioProject..NominalGDP
SET NominalGDP = GDP



----------------------------------------------------------------------------


-- GDP Growth Rate

Select *
From PortfolioProject..GDPGrowthRates

ALTER TABLE PortfolioProject..GDPGrowthRates
ADD DebtQuarter VARCHAR(10);


UPDATE PortfolioProject..GDPGrowthRates
SET DebtQuarter = 
	CAST(YEAR(CONVERT(date, [observation_date])) AS VARCHAR(4)) + 'Q' +
	CAST(DATEPART(QUARTER, CONVERT(date, [observation_date])) AS VARCHAR(1));


ALTER TABLE PortfolioProject..GDPGrowthRates
ADD PercentChange FLOAT;

Update PortfolioProject..GDPGrowthRates
SET PercentChange = A191RL1Q225SBEA

--ALTER TABLE PortfolioProject..GDPGrowthRates
--DROP Column A191RL1Q225SBEA



----------------------------------------------------------------------------

-- Joining Data Sets

Select *
From PortfolioProject..[National Debt]

Use PortfolioProject;
GO

Select
    nd.DebtQuarter,
    nd.[Debt Held By the Public],
    nd.[Total Public Debt Outstanding],
    ng.NominalGDP,
    rg.RealGDP,
    gg.PercentChange

From dbo.[National Debt] nd
LEFT JOIN
    dbo.NominalGDP ng ON nd.DebtQuarter = ng.DebtQuarter
LEFT JOIN
    dbo.RealGDP rg ON nd.DebtQuarter = rg.DebtQuarter
LEFT JOIN
    dbo.GDPGrowthRates gg ON nd.DebtQuarter = gg.DebtQuarter
ORDER BY
    nd.DebtQuarter;

----------------------------------------------------------------------------

--Creating a View

CREATE VIEW vw_DebtAndGDP AS
Select
    nd.DebtQuarter,
    nd.[Debt Held By the Public],
    nd.[Total Public Debt Outstanding],
    ng.NominalGDP,
    rg.RealGDP,
    gg.PercentChange

FROM dbo.[National Debt] nd
LEFT JOIN dbo.NominalGDP ng ON nd.DebtQuarter = ng.DebtQuarter
LEFT JOIN dbo.RealGDP rg ON nd.DebtQuarter = rg.DebtQuarter
LEFT JOIN dbo.GDPGrowthRates gg ON nd.DebtQuarter = gg.DebtQuarter;
