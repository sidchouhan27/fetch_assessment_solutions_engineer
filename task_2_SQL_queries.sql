#Siddharth Singh Chouhan for Solutions Engineer @ Fetch

#1. Top 5 Brands by Receipts Scanned for the Most Recent Month:

WITH RecentMonth AS (
    SELECT DATE_TRUNC('month', MAX(dateScanned)) AS latest_month
    FROM receipts
)
SELECT 
    b.name AS brand_name, 
    COUNT(r._id) AS receipt_count
FROM receipts r
JOIN rewardsReceiptItemList ri ON r._id = ri.receipt_id
JOIN brands b ON ri.barcode = b.barcode
WHERE DATE_TRUNC('month', r.dateScanned) = (SELECT latest_month FROM RecentMonth)
GROUP BY b.name
ORDER BY receipt_count DESC
LIMIT 5;

#2. Comparing the Ranking of Top 5 Brands Between Recent and Previous Month:

WITH RankedBrands AS (
    SELECT 
        DATE_TRUNC('month', r.dateScanned) AS month,
        b.name AS brand_name, 
        COUNT(r._id) AS receipt_count,
        RANK() OVER (PARTITION BY DATE_TRUNC('month', r.dateScanned) ORDER BY COUNT(r._id) DESC) AS rank
    FROM receipts r
    JOIN rewardsReceiptItemList ri ON r._id = ri.receipt_id
    JOIN brands b ON ri.barcode = b.barcode
    WHERE DATE_TRUNC('month', r.dateScanned) >= DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '1 month'
    GROUP BY month, b.name
)
SELECT 
    rb1.brand_name, 
    rb1.receipt_count AS recent_month_count, 
    rb1.rank AS recent_rank, 
    rb2.receipt_count AS prev_month_count, 
    rb2.rank AS prev_rank
FROM RankedBrands rb1
LEFT JOIN RankedBrands rb2 
ON rb1.brand_name = rb2.brand_name 
AND rb1.month = DATE_TRUNC('month', CURRENT_DATE)
AND rb2.month = DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '1 month'
WHERE rb1.rank <= 5 OR rb2.rank <= 5
ORDER BY recent_rank;