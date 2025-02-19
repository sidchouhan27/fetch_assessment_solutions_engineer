import pandas as pd
import json

# Load JSON files
with open(C:/Users/siddh/Downloads/"receipts.json") as f:
    receipts = pd.DataFrame(json.load(f))
    
with open(C:/Users/siddh/Downloads/"users.json") as f:
    users = pd.DataFrame(json.load(f))

with open(C:/Users/siddh/Downloads/"brands.json") as f:
    brands = pd.DataFrame(json.load(f))

# Check for missing values
missing_receipts = receipts.isnull().sum()
missing_users = users.isnull().sum()
missing_brands = brands.isnull().sum()

# Check for duplicate user IDs
duplicate_users = users['_id'].duplicated().sum()

# Check for invalid dates
receipts_invalid_dates = receipts[~receipts['purchaseDate'].between(receipts['createDate'], receipts['modifyDate'])]

# Check for mismatched brand barcodes
invalid_barcode_matches = receipts.merge(brands, how="left", left_on="rewardsReceiptItemList.barcode", right_on="barcode")
invalid_barcode_counts = invalid_barcode_matches['name'].isnull().sum()

# Display findings
print("Missing Values in Receipts:\n", missing_receipts)
print("Missing Values in Users:\n", missing_users)
print("Missing Values in Brands:\n", missing_brands)
print(f"Duplicate Users: {duplicate_users}")
print(f"Receipts with Invalid Dates: {len(receipts_invalid_dates)}")
print(f"Receipts with Unmatched Barcodes: {invalid_barcode_counts}")

'''
Findings:
Missing Values: Identified in key fields such as purchaseDate, totalSpent, and bonusPointsEarned.
Duplicate Users: Checking for duplicate user IDs revealed inconsistencies.
Date Validity Issues: Some purchaseDate values fall outside createDate and modifyDate.
Barcode Mismatches: Some receipts contain items with barcodes that do not exist in the brands table.
'''