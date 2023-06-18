-- DATA CLEANING

SELECT * FROM PortfolioProject.dbo.NashvilleHousingData;


-- Populate PropertyAddress data

SELECT * FROM PortfolioProject.dbo.NashvilleHousingData
WHERE PropertyAddress IS NULL
ORDER BY ParcelID;

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousingData AS a
JOIN PortfolioProject.dbo.NashvilleHousingData AS b ON a.ParcelID= b.ParcelID AND a.UniqueID != b.UniqueID
WHERE a.PropertyAddress IS NULL;

UPDATE a 
SET PropertyAddress= ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousingData AS a
JOIN PortfolioProject.dbo.NashvilleHousingData AS b ON a.ParcelID= b.ParcelID AND a.UniqueID != b.UniqueID
WHERE a.PropertyAddress IS NULL;


-- Breaking out PropertyAddress and OwnerAddress into individual columns (Address, City and State)

SELECT PropertyAddress FROM PortfolioProject.dbo.NashvilleHousingData;

SELECT SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) AS City
FROM PortfolioProject.dbo.NashvilleHousingData

ALTER TABLE PortfolioProject.dbo.NashvilleHousingData
ADD PropertyAddressAddress VARCHAR(288);

ALTER TABLE PortfolioProject.dbo.NashvilleHousingData
ADD PropertyAddressCity VARCHAR(288);

UPDATE PortfolioProject.dbo.NashvilleHousingData
SET PropertyAddressAddress= SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1)

UPDATE PortfolioProject.dbo.NashvilleHousingData
SET PropertyAddressCity= SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))

SELECT * FROM PortfolioProject.dbo.NashvilleHousingData

SELECT OwnerAddress FROM PortfolioProject.dbo.NashvilleHousingData

SELECT 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) AS Address,
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2) AS City,
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1) AS State
FROM PortfolioProject.dbo.NashvilleHousingData

ALTER TABLE PortfolioProject.dbo.NashvilleHousingData
ADD OwnerAddressAddress VARCHAR(288);

ALTER TABLE PortfolioProject.dbo.NashvilleHousingData
ADD OwnerAddressCity VARCHAR(288);

ALTER TABLE PortfolioProject.dbo.NashvilleHousingData
ADD OwnerAddressState VARCHAR(288);

UPDATE PortfolioProject.dbo.NashvilleHousingData
SET OwnerAddressAddress= PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

UPDATE PortfolioProject.dbo.NashvilleHousingData
SET OwnerAddressCity= PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

UPDATE PortfolioProject.dbo.NashvilleHousingData
SET OwnerAddressState= PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

SELECT * FROM PortfolioProject.dbo.NashvilleHousingData;


-- Change 'Y' and 'N' to 'Yes' and 'No' respectively in SoldAsVacant.

SELECT SoldAsVacant FROM PortfolioProject.dbo.NashvilleHousingData;

SELECT SoldAsVacant,
CASE
WHEN SoldAsVacant= 'Y' THEN 'Yes'
WHEN SoldAsVacant= 'N' THEN 'No'
ELSE SoldAsVacant
END
FROM PortfolioProject.dbo.NashvilleHousingData;

UPDATE PortfolioProject.dbo.NashvilleHousingData
SET SoldAsVacant= 
CASE
WHEN SoldAsVacant= 'Y' THEN 'Yes'
WHEN SoldAsVacant= 'N' THEN 'No'
ELSE SoldAsVacant
END


-- Remove Duplicate.

SELECT * FROM PortfolioProject.DBO.NashvilleHousingData;

WITH duplicate AS(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY ParcelID, PropertyAddress, SaleDate, SalePrice, LegalReference, OwnerAddress ORDER BY UniqueID) AS row_num 
FROM PortfolioProject.dbo.NashvilleHousingData
)
DELETE FROM duplicate
WHERE row_num > 1;


-- Delete Unused or less useful Columns

ALTER TABLE PortfolioProject.dbo.NashvilleHousingData
DROP COLUMN PropertyAddress, OwnerAddress;

SELECT * FROM PortfolioProject.dbo.NashvilleHousingData;