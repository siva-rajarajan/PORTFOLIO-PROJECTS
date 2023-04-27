select*
from [PORTFOLIO PROJECT].dbo.Nashvillehousing


-- Standardize Date Format



ALTER TABLE [PORTFOLIO PROJECT].dbo.NashvilleHousing
Add SaleDateConverted Date;

Update [PORTFOLIO PROJECT].dbo.NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)


Select SaleDateConverted, CONVERT(Date,SaleDate)
From [PORTFOLIO PROJECT].dbo.NashvilleHousing


-- Populate Property Address data

Select *
From [PORTFOLIO PROJECT].dbo.NashvilleHousing
--Where PropertyAddress is null
order by ParcelID



Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From [PORTFOLIO PROJECT].dbo.NashvilleHousing a
JOIN [PORTFOLIO PROJECT].dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From [PORTFOLIO PROJECT].dbo.NashvilleHousing a
JOIN [PORTFOLIO PROJECT].dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null




-- Breaking out Address into Individual Columns (Address, City)


Select PropertyAddress
From [PORTFOLIO PROJECT].dbo.NashvilleHousing


SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as city

From [PORTFOLIO PROJECT].dbo.NashvilleHousing


ALTER TABLE [PORTFOLIO PROJECT].dbo.NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update [PORTFOLIO PROJECT].dbo.NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE [PORTFOLIO PROJECT].dbo.NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update [PORTFOLIO PROJECT].dbo.NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))




Select *
From [PORTFOLIO PROJECT].dbo.NashvilleHousing




--breraking out owners's address

Select OwnerAddress
From [PORTFOLIO PROJECT].dbo.NashvilleHousing


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From [PORTFOLIO PROJECT].dbo.NashvilleHousing

ALTER TABLE [PORTFOLIO PROJECT].dbo.NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update [PORTFOLIO PROJECT].dbo.NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE [PORTFOLIO PROJECT].dbo.NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update [PORTFOLIO PROJECT].dbo.NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE [PORTFOLIO PROJECT].dbo.NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update [PORTFOLIO PROJECT].dbo.NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From [PORTFOLIO PROJECT].dbo.NashvilleHousing


-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From [PORTFOLIO PROJECT].dbo.NashvilleHousing
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From [PORTFOLIO PROJECT].dbo.NashvilleHousing


Update [PORTFOLIO PROJECT].dbo.NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

select*
from [PORTFOLIO PROJECT].dbo.NashvilleHousing

-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From [PORTFOLIO PROJECT].dbo.NashvilleHousing
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From [PORTFOLIO PROJECT].dbo.NashvilleHousing


-- Delete Unused Columns



Select *
From [PORTFOLIO PROJECT].dbo.NashvilleHousing


ALTER TABLE [PORTFOLIO PROJECT].dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
