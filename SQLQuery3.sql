
------------------------Data Cleaning Project----------------------------
Select * 
From PortfolioProject.dbo.NashvilleHousing


-------------------------------------------------------------------------
--Standardize Date Format
--1.
Select SaleDate , CONVERT(Date, SaleDate)
From PortfolioProject.dbo.NashvilleHousing

--2.
Alter Table PortfolioProject.dbo.NashvilleHousing
ADD SaleDateConverted Date;

Update PortfolioProject.dbo.NashvilleHousing
SET SaleDateConverted = CONVERT(Date , SaleDate)

Select SaleDateConverted , Convert(Date,SaleDate)
From PortfolioProject..NashvilleHousing


------------------------------------------------------------------------
--Populate Property Address Data (SELF JOIN)

Select A.ParcelID , A.PropertyAddress , B.ParcelID , B.PropertyAddress ,  ISNULL(A.PropertyAddress , B.PropertyAddress) --(Populating A is null , add B)
From PortfolioProject.dbo.NashvilleHousing as A
Join PortfolioProject.dbo.NashvilleHousing as B
on A.ParcelID = B.ParcelID
AND A.[UniqueID] <> B.[UniqueID] 
where a.PropertyAddress is null
 

UPDATE  A                                                       --it modifies values in existing rows
SET  A.PropertyAddress =  ISNULL(A.PropertyAddress , B.PropertyAddress) 
From PortfolioProject.dbo.NashvilleHousing as A
Join PortfolioProject.dbo.NashvilleHousing as B
on A.ParcelID = B.ParcelID
AND A.[UniqueID] <> B.[UniqueID] 
where a.PropertyAddress is null


------------------------------------------------------------------------

--Breaking Out Address into individual Columns(Address , city , State)

Select PropertyAddress
From PortfolioProject..NashvilleHousing

Select 
SUBSTRING(PropertyAddress , 1 , CHARINDEX( ',' , PropertyAddress) -1 ) as Address ,  --SUBSTRING(text, start_position, length)    --CHARINDEX(search_text, full_text)
SUBSTRING(PropertyAddress , CHARINDEX(',' , PropertyAddress) +1 , len(PropertyAddress)) as Location
From PortfolioProject..NashvilleHousing

--Adding the column

USE PortfolioProject;

--1.
ALTER TABLE NashvilleHousing
ADD  Address Varchar(255) NULL;

UPDATE NashvilleHousing
SET Address = SUBSTRING(PropertyAddress , 1 , CHARINDEX( ',' , PropertyAddress) -1 )

--2.
ALTER TABLE NashvilleHousing
ADD  Location Varchar(255) NULL;

UPDATE NashvilleHousing
SET Location = SUBSTRING(PropertyAddress , CHARINDEX( ',' , PropertyAddress) +1  , Len(PropertyAddress))

Select *
From PortfolioProject..NashvilleHousing



--Using Parsename

Select OwnerAddress
From PortfolioProject..NashvilleHousing

Select 
PARSENAME(REPLACE(OwnerAddress , ',' , '.') , 3 ) as Address, 
PARSENAME(REPLACE(OwnerAddress , ',' , '.') , 2 ) as City , 
PARSENAME(REPLACE(OwnerAddress ,',' , '.') ,1)   as State              --PARSENAME('your.string.here', part_number)  -- REPLACE(text, find_this, replace_with_this)
From PortfolioProject..NashvilleHousing

--Adding the column
USE PortfolioProject;

ALTER TABLE NashvilleHousing
ADD  OwnerSpiltAddress Varchar(255) NULL;

UPDATE NashvilleHousing
SET OwnerSpiltAddress = PARSENAME(REPLACE(OwnerAddress , ',' , '.') , 3 )


ALTER TABLE NashvilleHousing
ADD  City Varchar(255) NULL;

UPDATE NashvilleHousing
SET City = PARSENAME(REPLACE(OwnerAddress , ',' , '.') , 2 ) 


ALTER TABLE NashvilleHousing
ADD  State Varchar(255) NULL;

UPDATE NashvilleHousing
SET State = PARSENAME(REPLACE(OwnerAddress , ',' , '.') , 1 ) 

Select * 
From PortfolioProject..NashvilleHousing


--------------------------------------------------------------------------

--Changing and replacing Values

Select  DISTINCT (SoldAsVacantCleaned) as yn, COUNT (SoldAsVacantCleaned) as number
From PortfolioProject..NashvilleHousing
Group By SoldAsVacantCleaned
order by 2


Select SoldAsVacant ,
CASE When SoldAsVacant IN ('1') THEN 'YES'
	 When SoldAsVacant IN ('0') THEN 'NO'
	END  AS SoldASCleaned
FROM PortfolioProject..NashvilleHousing


ALTER Table PortfolioProject..NashvilleHousing
ADD SoldAsVacantCleaned VARCHAR(10) ;


USE PortfolioProject;
Update NashvilleHousing
SET  SoldAsVacantCleaned = CASE 
	When SoldAsVacant = '1' THEN 'YES'
	When SoldAsVacant = '0' THEN 'NO'
	END;

----------------------------------------------------------------------

--REMOVING Duplicate


WITH RowN AS (
Select  *,
 ROW_NUMBER() OVER( PARTITION BY  ParcelID,
								PropertyAddress,
								SalePrice,
								SaleDate,
								LegalReference
								ORDER BY UniqueID) AS row_num
From PortfolioProject..NashvilleHousing
)
SELECT *
FROM RowN
WHERE row_num > 1;


--------------------------------------------------------------------

Select *
From PortfolioProject..NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress , TaxDistrict , PropertyAddress 

