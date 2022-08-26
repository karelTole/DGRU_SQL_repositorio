CREATE TABLE ddl_history (

  id serial primary key,

  ddl_date timestamptz,

  ddl_tag text,

  object_name text

);

CREATE OR REPLACE FUNCTION public.log_ddl()

  RETURNS event_trigger AS $$

DECLARE

  audit_query TEXT;

  r RECORD;

BEGIN

  IF tg_tag <> 'DROP TABLE'

  THEN

    r := pg_event_trigger_ddl_commands();

    INSERT INTO ddl_history (ddl_date, ddl_tag, object_name) VALUES (statement_timestamp(), tg_tag, r.object_identity);

  END IF;

END;

$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION log_ddl_drop()

  RETURNS event_trigger AS $$

DECLARE

  audit_query TEXT;

  r RECORD;

BEGIN

  IF tg_tag = 'DROP TABLE'

  THEN

    FOR r IN SELECT * FROM pg_event_trigger_ddl_commands() 

    LOOP

      INSERT INTO ddl_history (ddl_date, ddl_tag, object_name) VALUES (statement_timestamp(), tg_tag, r.object_identity);

    END LOOP;

  END IF;

END;

$$ LANGUAGE plpgsql;


CREATE EVENT TRIGGER log_ddl_info ON ddl_command_end EXECUTE PROCEDURE log_ddl();

CREATE EVENT TRIGGER log_ddl_drop_info ON sql_drop EXECUTE PROCEDURE log_ddl_drop();


postgres=# CREATE TABLE testtable (id int, first_name text);

CREATE TABLE

postgres=# ALTER TABLE testtable ADD COLUMN last_name text;

ALTER TABLE

postgres=# ALTER TABLE testtable ADD COLUMN midlname text;

ALTER TABLE

postgres=# ALTER TABLE testtable RENAME COLUMN midlname TO middle_name;

ALTER TABLE

postgres=# ALTER TABLE testtable DROP COLUMN middle_name;

ALTER TABLE

postgres=# DROP TABLE testtable;

DROP TABLE

postgres=# SELECT * FROM ddl_history;
