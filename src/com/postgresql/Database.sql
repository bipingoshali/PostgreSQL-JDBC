-- Table: public.product

-- DROP TABLE public.product;

CREATE TABLE public.product
(
    prodid integer NOT NULL DEFAULT nextval('product_prodid_seq'::regclass),
    prodname character varying(50) COLLATE pg_catalog."default" NOT NULL,
    prodprice numeric(6,2) NOT NULL,
    prodstock integer NOT NULL,
    CONSTRAINT pk_prodid PRIMARY KEY (prodid)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.product
    OWNER to postgres;


-- Table: public.bill

-- DROP TABLE public.bill;

CREATE TABLE public.bill
(
    billid integer NOT NULL DEFAULT nextval('bill_billid_seq'::regclass),
    billdate timestamp without time zone,
    grandtotal numeric(10,2),
    CONSTRAINT pk_billid PRIMARY KEY (billid)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.bill
    OWNER to postgres;


-- Table: public.billdetails

-- DROP TABLE public.billdetails;

CREATE TABLE public.billdetails
(
    billid integer,
    details json,
    CONSTRAINT fk_billid FOREIGN KEY (billid)
        REFERENCES public.bill (billid) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.billdetails
    OWNER to postgres;

-- FUNCTION: public.get_products()

-- DROP FUNCTION public.get_products();

CREATE OR REPLACE FUNCTION public.get_products(
	)
    RETURNS TABLE(prod_id_table integer, prod_name_table character varying, prod_price_table numeric, prod_stock_table integer) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$
declare
	prod_rec record;
begin
	for prod_rec in (select * from product)
	loop
		prod_id_table := prod_rec.prodid;
		prod_name_table := upper(prod_rec.prodname);
		prod_price_table := prod_rec.prodprice;
		prod_stock_table := prod_rec.prodstock;
	return next;
	end loop;
end; $BODY$;

ALTER FUNCTION public.get_products()
    OWNER TO postgres;


-- FUNCTION: public.get_products_by_id(integer)

-- DROP FUNCTION public.get_products_by_id(integer);

CREATE OR REPLACE FUNCTION public.get_products_by_id(
	p_productid integer)
    RETURNS TABLE(prodid_table integer, prodname_table character varying, prodprice_table numeric, prodstock_table integer) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$
declare
	product_record record;
	product_cursor cursor(productid integer) for select * from product where prodid=productid;
begin
	open product_cursor(p_productid);
		loop
			fetch product_cursor into product_record;
			exit when not found;
			prodid_table := product_record.prodid;
			prodname_table := product_record.prodname;
			prodprice_table := product_record.prodprice;
			prodstock_table := product_record.prodstock;
			return next;
		end loop;
	close product_cursor;
end; $BODY$;

ALTER FUNCTION public.get_products_by_id(integer)
    OWNER TO postgres;



-- FUNCTION: public.add_stock(integer, integer)

-- DROP FUNCTION public.add_stock(integer, integer);

CREATE OR REPLACE FUNCTION public.add_stock(
	p_productid integer,
	p_quantity integer)
    RETURNS void
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
declare
	product_record record;
begin
	for product_record in(select prodstock from product where prodid=p_productid)
	loop
	update product set prodstock=product_record.prodstock + p_quantity where prodid=p_productid;
	end loop;
end; $BODY$;

ALTER FUNCTION public.add_stock(integer, integer)
    OWNER TO postgres;


-- FUNCTION: public.get_bill()

-- DROP FUNCTION public.get_bill();

CREATE OR REPLACE FUNCTION public.get_bill(
	)
    RETURNS TABLE(billid_table integer, billdate_table timestamp without time zone, grandtotal_table numeric) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$
declare
	bill_rec record;
begin
	for bill_rec in (select * from bill)
	loop
		billid_table := bill_rec.billid;
		billdate_table := bill_rec.billdate;
		grandtotal_table := bill_rec.grandtotal;		
	return next;
	end loop;
end; $BODY$;

ALTER FUNCTION public.get_bill()
    OWNER TO postgres;


-- FUNCTION: public.get_bill_details(integer)

-- DROP FUNCTION public.get_bill_details(integer);

CREATE OR REPLACE FUNCTION public.get_bill_details(
	p_billid integer)
    RETURNS TABLE(product_name_table character varying, product_price_table numeric, product_quantity integer, product_total numeric) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$
declare
	product_record record;
	product_cursor cursor(p_billid integer) for select 
		details -> 'products' ->> 'name' as Product_Name,
		details -> 'products' ->> 'price' as Product_Price,
		details -> 'products' ->> 'quantity' as Quantity,
		details -> 'products' ->> 'total' as Total
		from billdetails 
		where billid=p_billid;
begin
	open product_cursor(p_billid);
	loop
		fetch product_cursor into product_record;
		exit when not found;
		product_name_table := product_record.Product_Name;
		product_price_table := product_record.Product_Price;
		product_quantity := product_record.Quantity;
		product_total := product_record.Total;
		return next;
	end loop;
	close product_cursor;
end;
$BODY$;

ALTER FUNCTION public.get_bill_details(integer)
    OWNER TO postgres;


-- FUNCTION: public.update_stock(integer, integer)

-- DROP FUNCTION public.update_stock(integer, integer);

CREATE OR REPLACE FUNCTION public.update_stock(
	p_productid integer,
	p_quantity integer)
    RETURNS void
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
declare
	product_record record;
begin
	for product_record in(select prodstock from product where prodid=p_productid)
	loop
	update product set prodstock=product_record.prodstock - p_quantity where prodid=p_productid;
	end loop;
end; $BODY$;

ALTER FUNCTION public.update_stock(integer, integer)
    OWNER TO postgres;
