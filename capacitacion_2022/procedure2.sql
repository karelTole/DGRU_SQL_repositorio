create or replace function clean_record (
    p_pattern varchar
) 
returns table (
	f_occurrebce_id varchar,
	f_original_campo_1 varchar,
    f_modified_campo_1 varchar
) 
language plpgsql
as $$
declare 
    var_r record;
begin
	for var_r in(
            select occurrence_id, scientific_name 
            from test_biodiversity 
	     where scientific_name ~ p_pattern 
        ) loop  f_occurrebce_id := var_r.occurrence_id ; 
        f_original_campo_1 := var_r.scientific_name;
		f_modified_campo_1 := regexp_replace(f_original_campo_1, p_pattern, '');
           return next;
	end loop;
end; $$ 


SELECT * FROM clean_record('\s+$');



CREATE OR REPLACE FUNCTION my_function(user_id integer) RETURNS TABLE(id integer, firstname character varying, lastname character varying) AS $$
    DECLARE
        ids INTEGER[];
    BEGIN
         ids := ARRAY[1,2];
         RETURN QUERY
             SELECT users.id, users.firstname, users.lastname
             FROM public.users
             WHERE users.id = ANY(ids);
    END;
$$ LANGUAGE plpgsql;



CREATE TABLE db (a INT PRIMARY KEY, b TEXT);

CREATE FUNCTION merge_db(key INT, data TEXT) RETURNS VOID AS
$$
BEGIN
    LOOP
        -- first try to update the key
        UPDATE db SET b = data WHERE a = key;
        IF found THEN
            RETURN;
        END IF;
        -- not there, so try to insert the key
        -- if someone else inserts the same key concurrently,
        -- we could get a unique-key failure
        BEGIN
            INSERT INTO db(a,b) VALUES (key, data);
            RETURN;
        EXCEPTION WHEN unique_violation THEN
            -- Do nothing, and loop to try the UPDATE again.
        END;
    END LOOP;
END;
$$
LANGUAGE plpgsql;

SELECT merge_db(1, 'david');
SELECT merge_db(1, 'dennis');