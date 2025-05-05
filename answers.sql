-- Question 1 Achieving 1NF (First Normal Form) 

INSERT INTO OrderProducts (OrderID, CustomerName, Products)
with recursive SplitProducts as (
select 
    OrderID,
    CustomerName,
    trim(substring_index(Products, ',', 1)) as Product,
    substring(Products, length(substring_index(Products, ',', 1)) + 2) as RemainingProducts
from ProductDetail
where Products is not null
union all
select
   OrderID,
   CustomerName,
   trim(substring_index(RemainingProducts, ',', 1)) as Product,
   substring(RemainingProducts, length(substring_index(RemainingProducts, ',', 1)) + 2) as RemainingProducts
from SplitProducts
where RemainingProducts != ''
)

select
    OrderID,
    CustomerName,
    Product as Products
from SplitProducts
where Product != '';
-- verifying the data
select * from OrderProducts order by OrderID, Products;

-- Question 2 Achieving 2NF (Second Normal Form)

-- orders Table
create table Orders (
    OrderID int primary key,
    CustomerName varchar(50)
);
-- updated orderDetails Table
create table OrderDetails (
    OrderID int,
    Product varchar(50),
    Quantity int,
    primary key (OrderID, Product),
    foreign key (OrderID) references Orders(OrderID)
    );

-- populating the orders table
INSERT INTO Orders (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM Order_Details_old;

-- populate the updated OrderDetails table
INSERT INTO OrderDetails (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM Order_Details_old;

select * from Orders;
select * from OrderDetails order by OrderID, Product;
