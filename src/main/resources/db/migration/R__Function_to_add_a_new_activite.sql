CREATE OR REPLACE FUNCTION add_activity_with_title (title varchar(300)) RETURNS bigint AS $$
    INSERT INTO activity(id, title) 
    VALUES (nextval('id_generator'), add_activity_with_title.title) --on récupère l'id generator de la sequence
    RETURNING id;
$$ LANGUAGE SQL;
