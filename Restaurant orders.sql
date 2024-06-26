-- The first stage of the project is to clean up and harmonise the data so that we can work more efficiently. 
-- We will first process the "order_details" table, perform a join to create a final database and check whether any null values exist.

-- Here are some code examples for the "order_details" table:

-- Create a column with the day from the order_date column : 

ALTER TABLE `order_details`
ADD COLUMN Jour INT;

UPDATE `order_details`
SET Jour = SUBSTRING_INDEX(SUBSTRING_INDEX(order_date, '/', 2), '/', -1);

-- Create a column with the formatted dates "Sunday 1 January 2023" :

ALTER TABLE `order_details`
ADD COLUMN order_date_formatted INT;

UPDATE `order_details`
SET order_date_formatted = DATE_FORMAT(STR_TO_DATE(order_date, '%m/%d/%y'), '%W %e %M %Y');

-- The final database is created using the Inner Join method between the order_details table and the menu_items table: 

CREATE TABLE base_finale
SELECT 
    order_details.order_details_id, 
    order_details.order_id, 
    order_details.menu_item_id, 
    order_details.Mois, 
    order_details.Jour_semaine, 
    order_details.order_date_formatted, 
    order_details.Jour_Mois, 
    order_details.Heure_commande,
    menu_items.item_name,
    menu_items.category,
    menu_items.price
FROM order_details
INNER JOIN menu_items ON menu_items.menu_item_id = order_details.menu_item_id;

-- Create a copy of the final database :

CREATE TABLE base_finale_2 LIKE base_finale;
INSERT INTO base_finale_2
SELECT * FROM base_finale;

-- Check whether the final table contains null values:

SELECT *
FROM base_finale_2
WHERE order_details_id IS NULL
    OR order_id IS NULL
    OR menu_item_id IS NULL
    OR Mois IS NULL
    OR Jour_semaine IS NULL
    OR order_date_formatted IS NULL
    OR Jour_Mois IS NULL
    OR Heure_commande IS NULL
    OR item_name IS NULL
    OR category IS NULL
    OR price IS NULL;

-- Now that the final database has been created, we can exploit it to extract relevant information.

-- INSIGHTS : 

  -- Calculation of total sales : 
SELECT ROUND(SUM(price),2) AS Total_of_Sales
FROM base_finale_2;

  -- Calculation of sales for January, February and March :

      -- Method 1 :
SELECT 
    ROUND(SUM(CASE WHEN Mois = 'January' THEN price ELSE 0 END), 2) AS Sales_of_January,
    ROUND(SUM(CASE WHEN Mois = 'February' THEN price ELSE 0 END), 2) AS Sales_of_February,
    ROUND(SUM(CASE WHEN Mois = 'March' THEN price ELSE 0 END), 2) AS Sales_of_March
FROM base_finale_2;

      -- Method 2 :
SELECT 
    Mois,
    ROUND(SUM(price),2) AS Sales 
FROM base_finale_2
GROUP BY `Mois`

    -- Calculating the ratio of sales to orders by day of the week : 
SELECT 
    `Jour_semaine`,
    ROUND(SUM(price) / COUNT(DISTINCT order_id), 2) AS rapport_ventes_par_commande
FROM 
    base_finale_2
GROUP BY 
    `Jour_semaine`
ORDER BY rapport_ventes_par_commande DESC;

  -- Sales generated by time of day :
SELECT 
    `Heure_commande`, 
    ROUND(SUM(price),2) AS chiffre_affaires
FROM base_finale_2  
GROUP BY `Heure_commande`
ORDER BY `Heure_commande` ASC;

  -- Sales generated by day of the week : 
SELECT 
    Jour_semaine,
    ROUND(SUM(price),2) AS chiffre_affaires
FROM base_finale_2
GROUP BY `Jour_semaine`
ORDER BY chiffre_affaires DESC;

  -- Which dish category generates the most sales ? 
SELECT 
    category,
    ROUND(SUM(price),2) AS Sales
FROM base_finale_2
GROUP BY category
ORDER BY Sales DESC;

  -- Which dish generates the most sales ?
SELECT 
    item_name,
    ROUND(SUM(price),2) AS Sales
FROM base_finale_2
GROUP BY item_name
ORDER BY Sales DESC;

  -- What is the average price of a dish in each category ?
SELECT 
    category,
    ROUND(AVG(price),2) AS Prix_moyen
FROM base_finale_2
GROUP BY `category`
ORDER BY Prix_moyen DESC;

  -- Total sales generated by each dish in the Asian category : 
SELECT 
    item_name,
    ROUND(SUM(price),2) AS chiffre_affaires
FROM base_finale_2
WHERE category = 'Asian'
GROUP BY item_name
ORDER BY chiffre_affaires DESC;

  -- Which category generates the most orders ?
SELECT 
    category,
    ROUND(COUNT(category),2) AS NB_de_fois_commander
FROM base_finale_2
GROUP BY category
ORDER BY NB_de_fois_commander DESC;

  -- What is the total number of orders placed by category in January ?
SELECT 
`category`,
ROUND(COUNT(order_id),2) AS NB_commande
FROM base_finale_2
WHERE Mois = 'January'
GROUP BY category
ORDER BY NB_commande DESC;

  -- What is the average number of dishes ordered per order in January ?
SELECT 
ROUND(COUNT(item_name)/ COUNT(DISTINCT order_id),1) AS Nb_moyen_de_commande_en_Janvier
FROM base_finale_2
WHERE Mois = 'January'

  -- What is the most popular dish ? (the one that generates the most orders)
SELECT 
    item_name,
    COUNT(item_name) AS NB_de_fois_commander
FROM base_finale_2
GROUP BY item_name
ORDER BY NB_de_fois_commander DESC;

  -- On which day are orders highest ?
SELECT 
    `Jour_semaine`,
    ROUND(COUNT(item_name),2) AS NB_de_fois_commander
FROM base_finale_2
GROUP BY `Jour_semaine`
ORDER BY NB_de_fois_commander DESC;

  -- Which category contains the most dishes in this restaurant ? 
SELECT category,
COUNT(DISTINCT item_name) AS Nb_de_plat
FROM base_finale_2
GROUP BY category;

  -- Restaurant attendance by month :
SELECT 
    Mois,
    COUNT(item_name) AS NB_commande
FROM base_finale_2
GROUP BY `Mois`

  -- Restaurant attendance by hour : 
SELECT 
    `Heure_commande`,
    COUNT(item_name) AS NB_commande
FROM base_finale_2
GROUP BY `Heure_commande`
ORDER BY `Heure_commande` ASC;
