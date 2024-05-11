# Restaurants-orders_Project

This repository contains my SQL project on the 2023 orders of a fictive restaurant.

Please don't hesitate to give me feedback, thank you! 
I'm going to complete this SQL project with visualisations on Tableau soon.

The dataset comes from mavenanalytics : https://mavenanalytics.io/data-playground?accessType=open&dataStructure=2lXwWbWANQgI727tVx3DRC&page=2&pageSize=5&tags=NXBNqbCUPNOBzgZYNeH6x&tags=3cgwtPRmxwnqScuhpPMCoF&tags=5S6IPpopvH1sCebCbeUJbz&tags=10btmr8wmkqkEgJMfgtOv2&tags=5qOZ7YrIptmdsL081BSli&tags=20BiJ97LqXh92nR4jQGg9W&tags=7cmbUxVbAT9riaGUveKqzj

# Context : 

A quarter's worth of orders from a fictitious restaurant serving international cuisine, including the date and time of each order, the items ordered, and additional details on the type, name and price of the items.

The main data available to us:
    - Sales data for the first quarter of 2023 only. 
    - The ID of each order
    - The date and time of each order 
    - The price of each dish.

With all the data available, let's see what relevant information we can extract. 

# Dataset Glossary : 

Table Menu_items : 
    - menu_item_id : Unique ID of a menu item
    - item_name : Name of a menu item
    - category : Category or type of cuisine of the menu item
    - price : Price of the menu item (US Dollars $)

Table Order_details :
    - order_details_id : Unique ID of an item in an order
    - order_id : ID of an order
    - order_date - Date an order was put in (MM/DD/YY)
    - order_time - Time an order was put in (HH:MM:SS AM/PM)
    - item_id : Matches the menu_item_id in the menu_items table
