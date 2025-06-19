/*
Final Task

-- Store Procedure

create a function as soon as the product is sold the the same quantity should reduced from inventory table

after adding any sales records it should update the stock in the inventory table based on the product and qty purchased
*/
CREATE OR REPLACE PROCEDURE add_sales(
    p_order_id INT,
    p_customer_id INT,
    p_seller_id INT,
    p_order_item_id INT,
    p_product_id INT,
    p_quantity INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_count INT;
    v_price FLOAT;
    v_product VARCHAR(50);
    v_current_stock INT;
BEGIN
    -- Get product details
    SELECT price, product_name
    INTO v_price, v_product
    FROM products
    WHERE product_id = p_product_id;
    
    -- Verify product exists
    IF NOT FOUND THEN
        RAISE NOTICE 'Product ID % does not exist', p_product_id;
        RETURN;
    END IF;
    
    -- Check inventory availability
    SELECT MAX(stock), COUNT(*)
    INTO v_current_stock, v_count
    FROM inventory
    WHERE product_id = p_product_id
    AND stock >= p_quantity
	group by product_id;
    
    -- Process order if stock available
    IF v_count > 0 THEN
        BEGIN
			SELECT COALESCE(MAX(order_id), 0) + 1 INTO p_order_id FROM orders;
		    SELECT COALESCE(MAX(order_item_id), 0) + 1 INTO p_order_item_id FROM order_items;
            -- Create order record
            INSERT INTO orders(order_id, order_date, customer_id, seller_id)
            VALUES (p_order_id, CURRENT_DATE, p_customer_id, p_seller_id);
            
            -- Add order item
            INSERT INTO order_items(
                order_item_id, 
                order_id, 
                product_id, 
                quantity, 
                price_per_unit
            )
            VALUES (
                p_order_item_id, 
                p_order_id, 
                p_product_id, 
                p_quantity, 
                v_price
            );
            
            -- Update inventory
            UPDATE inventory
            SET stock = stock - p_quantity
            WHERE product_id = p_product_id;
            
            RAISE NOTICE 'Success: Ordered % units of % (Product ID: %). Remaining stock: %', 
                p_quantity, 
                v_product, 
                p_product_id, 
                (v_current_stock - p_quantity);
        EXCEPTION
            WHEN OTHERS THEN
                RAISE EXCEPTION 'Order processing failed: %', SQLERRM;
        END;
    ELSE
        RAISE NOTICE 'Insufficient stock: Only % units available for % (Product ID: %)', 
            COALESCE(v_current_stock, 0), 
            v_product, 
            p_product_id;
    END IF;
END;
$$;
call add_sales(1006,2,6,1008,7,6);