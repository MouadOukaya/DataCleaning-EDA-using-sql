-- Select all data from the working table
SELECT * FROM nashvillehousing2;

-- Create a new table as a duplicate of the original
CREATE TABLE nashvillehousing2 LIKE nashvillehousing;
INSERT INTO nashvillehousing2 SELECT * FROM nashvillehousing;

-- Convert the SaleDate column from text format to a proper date format
UPDATE nashvillehousing2
SET SaleDate = STR_TO_DATE(SaleDate, '%M %d,%Y');

-- Standardize the 'SoldAsVacant' column values ('n' -> 'NO', 'Y' -> 'YES')
UPDATE nashvillehousing2 SET SoldAsVacant = 'NO' WHERE SoldAsVacant LIKE 'n';
UPDATE nashvillehousing2 SET SoldAsVacant = 'YES' WHERE SoldAsVacant LIKE 'Y';

-- Split the PropertyAddress column into separate Address and City fields
ALTER TABLE nashvillehousing2 ADD PropertySplitAddress NVARCHAR(255);
ALTER TABLE nashvillehousing2 ADD PropertyCity NVARCHAR(255);

UPDATE nashvillehousing2
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, LOCATE(',', PropertyAddress) - 1);
UPDATE nashvillehousing2
SET PropertyCity = SUBSTRING(PropertyAddress, LOCATE(',', PropertyAddress) + 1, LENGTH(PropertyAddress));

-- Split the OwnerAddress column into separate Address, City, and State fields
ALTER TABLE nashvillehousing2 ADD OwnerSplitAddress NVARCHAR(255);
ALTER TABLE nashvillehousing2 ADD OwnerCity NVARCHAR(255);
ALTER TABLE nashvillehousing2 ADD OwnerState NVARCHAR(255);

UPDATE nashvillehousing2
SET OwnerSplitAddress = SUBSTRING_INDEX(SUBSTRING_INDEX(REPLACE(OwnerAddress, ',', '.'), '.', 1), '.', -1);
UPDATE nashvillehousing2
SET OwnerCity = SUBSTRING_INDEX(SUBSTRING_INDEX(REPLACE(OwnerAddress, ',', '.'), '.', 2), '.', -1);
UPDATE nashvillehousing2
SET OwnerState = SUBSTRING_INDEX(SUBSTRING_INDEX(REPLACE(OwnerAddress, ',', '.'), '.', 3), '.', -1);

-- Handle missing values by replacing empty PropertyAddress values with 'Unknown Property Address'
UPDATE nashvillehousing2 
SET PropertyAddress = 'Unknown Property Address'
WHERE PropertyAddress = '';

-- Remove duplicate rows based on key property identifiers
DELETE FROM nashvillehousing2
WHERE UniqueID IN (
    SELECT UniqueID FROM (
        SELECT UniqueID, ROW_NUMBER() OVER (
            PARTITION BY ParcelID, PropertySplitAddress, PropertyCity, SaleDate, SalePrice, LegalReference
            ORDER BY UniqueID
        ) AS row_num
        FROM nashvillehousing2
    ) subquery
    WHERE row_num > 1
);

-- Drop original PropertyAddress and OwnerAddress columns after splitting
ALTER TABLE nashvillehousing2 DROP COLUMN PropertyAddress, DROP COLUMN OwnerAddress;