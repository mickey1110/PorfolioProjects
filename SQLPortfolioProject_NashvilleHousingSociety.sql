select * from NashvilleHousingSociety

-------------------- Standardize Date Format -------------
                           --- // Converting Date and adding a new column//

select SaleDate, convert(Date, saledate) as Sales_Date, YEAR(SaleDate) as Sale_Year
from NashvilleHousingSociety

                        -- now Adding Sale_Date and Sale_Year as a column in a Table ---

UPDATE NashvilleHousingSociety
SET SaleDate = cast(saledate as date) 

Alter Table NashvilleHousingSociety
add Sales_Date Date

Alter Table NashvilleHousingSociety
Drop column SaleDate

-------------------------- // Populate Property Address Column // ----------------------
           -- lets just check, if its same address, the we will populate ------

Select parcelid, propertyaddress 
from NashvilleHousingSociety
where parcelid='092 06 0 273.00'


select a.ParcelID, a.PropertyAddress,b.ParcelID, b.PropertyAddress
from NashvilleHousingSociety a
join NashvilleHousingSociety b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

select a.ParcelID, a.PropertyAddress,b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from NashvilleHousingSociety a
join NashvilleHousingSociety b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

UPDATE a
SET PropertyAddress=ISNULL(a.PropertyAddress, b.PropertyAddress)
From NashvilleHousingSociety a
join NashvilleHousingSociety b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

-------------------------------------------------------------------------------
--- // Breaking out Property Address into individual columns say Address, City, State

select PropertyAddress from NashvilleHousingSociety
order by ParcelID

select PropertyAddress, SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) As Address,
                        SUBSTRING(PropertyAddress, CHARINDEX(',' , PropertyAddress)+1, LEN(PropertyAddress)) as City
from NashvilleHousingSociety

Alter Table NashvilleHousingSociety
Add Ppty_Add nvarchar(255)

Alter Table NashvilleHousingSociety
Add Ppty_City nvarchar(255)

Update NashvilleHousingSociety
Set Ppty_Add=SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)

Update NashvilleHousingSociety
Set Ppty_City=SUBSTRING(PropertyAddress, CHARINDEX(',' , PropertyAddress)+1, LEN(PropertyAddress))

select PropertyAddress, Ppty_Add, Ppty_City, Sales_Date
from NashvilleHousingSociety


select OwnerAddress, PARSENAME(Replace(OwnerAddress,',','.'),3) As Owner_Add, 
					 PARSENAME(Replace(OwnerAddress,',','.'),2) As Owner_City, 
					 PARSENAME(Replace(OwnerAddress,',','.'),1) As Owner_State
from NashvilleHousingSociety

Alter Table NashvilleHousingSociety
Add Owner_Add nvarchar(255)

Alter Table NashvilleHousingSociety
Add Owner_City nvarchar(255)

Alter Table NashvilleHousingSociety
Add Owner_State nvarchar(255)

Update NashvilleHousingSociety
SET Owner_Add=PARSENAME(Replace(OwnerAddress,',','.'),3)

Update NashvilleHousingSociety
SET Owner_City=PARSENAME(Replace(OwnerAddress,',','.'),2)

Update NashvilleHousingSociety

SET Owner_State= PARSENAME(Replace(OwnerAddress,',','.'),1)

select Sales_Date, Ppty_Add, Ppty_City, Owner_Add, Owner_City, Owner_State
from NashvilleHousingSociety

select * from NashvilleHousingSociety


---------------------------------------------------------------
-------- // all Y to YES and N to NO --------// ---------------


Select DISTinct(SoldAsVacant), COUNT(SoldAsVacant) 
from NashvilleHousingSociety
group by SoldAsVacant
order by 2


select SoldAsVacant
,CASE When SoldAsVacant= 'Y' then 'Yes'
	 When SoldAsVacant= 'N' then 'No'
	 Else SoldAsVacant
END
from NashvilleHousingSociety

update NashvilleHousingSociety
SET SoldAsVacant =CASE When SoldAsVacant= 'Y' then 'Yes'
	 When SoldAsVacant= 'N' then 'No'
	 Else SoldAsVacant
END


----------------------------------------- REMOVING DUPLICATES ---------------------------

select *,
ROW_NUMBER() Over (Partition By ParcelID, Sales_Date, LegalReference, SalePrice, Ppty_Add, Owner_Add, OwnerName Order By uniqueID) 
as Row_Num
from NashvilleHousingSociety
--where Rw_Num > 1 

with RowNUMCTE AS (select *,
ROW_NUMBER() Over (Partition By ParcelID, Sales_Date, LegalReference, SalePrice, Ppty_Add, Owner_Add, OwnerName Order By uniqueID) 
as Row_Num
from NashvilleHousingSociety )

 ------------- // were gonna delete it // --------------
Delete from ROwNumCTe
where row_num >1

--------------------------------------------- // Remove unsed columns // -----------

Alter Table NashvilleHousingSociety
Drop Column PropertyAddress, OwnerAddress, TaxDistrict 

select * from NashvilleHousingSociety































































































