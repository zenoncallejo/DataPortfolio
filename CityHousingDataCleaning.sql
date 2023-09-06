

USE PortfolioProjects

Select *
FROM PortfolioProjects.dbo.CityHousing


-- Cleaning SalesDate column

Select SaleDate
FROM PortfolioProjects.dbo.CityHousing

ALTER TABLE CityHousing
Add SaleDateConverted Date;

Update CityHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)

Select SaleDateConverted
FROM PortfolioProjects.dbo.CityHousing


-- Filling Null Data
-- from PropertyAdress


-- Self JOIN to find matching IDs _ filling data from not null rows
Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProjects.dbo.CityHousing a
JOIN PortfolioProjects.dbo.CityHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProjects.dbo.CityHousing a
JOIN PortfolioProjects.dbo.CityHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]




-- Breaking out Adress into different columns

Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +2, LEN(PropertyAddress)) as Address
From PortfolioProjects.dbo.CityHousing

ALTER TABLE CityHousing
Add PropertySplitAddress Nvarchar(255);

ALTER TABLE CityHousing
Add PropertySplitCity Nvarchar(255);

Update CityHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

Update CityHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +2, LEN(PropertyAddress))


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)
, PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)
, PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
From PortfolioProjects.dbo.CityHousing

ALTER TABLE CityHousing
Add OwnerSplitAddress Nvarchar(255);

ALTER TABLE CityHousing
Add OwnerSplitCity Nvarchar(255);

ALTER TABLE CityHousing
Add OwnerSplitState Nvarchar(255);

Update CityHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)
Update CityHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

Update CityHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)


-- Changing Y and N to Yes and No in SoldAsVacant column

Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
From  PortfolioProjects.dbo.CityHousing
Group by SoldAsVacant

Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' then 'Yes'
	When SoldAsVacant = 'N' then 'No'
	Else SoldAsVacant
	END
From  PortfolioProjects.dbo.CityHousing

Update CityHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' then 'Yes'
	When SoldAsVacant = 'N' then 'No'
	Else SoldAsVacant
	END


-- Removing duplicates


WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() Over(
	Partition by ParcelID,
				 PropertyAddress,
				 SaleDate,
				 SalePrice,
				 LegalReference
				 Order by
					UniqueID
					) row_num

From PortfolioProjects.dbo.CityHousing
)

DELETE
From RowNumCTE
Where row_num > 1



-- Delete useless columns

ALTER TABLE PortfolioProjects.dbo.CityHousing
DROP COLUMN PropertyAddress, SaleDate, OwnerAddress


