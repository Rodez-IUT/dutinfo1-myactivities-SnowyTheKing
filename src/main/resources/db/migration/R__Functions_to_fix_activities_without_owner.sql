CREATE OR REPLACE FUNCTION get_default_owner() RETURNS "user" AS $$
DECLARE
	DefaultOwner "user"%ROWTYPE;
	

BEGIN
	SELECT *
	INTO DefaultOwner
	FROM "user"
	WHERE username = 'Default Owner' ;
	
	IF FOUND THEN
		RETURN DefaultOwner;
	ELSE
		INSERT INTO "user" (id, username) 
		VALUES (1, 'Default Owner');
		
		SELECT *
		INTO DefaultOwner
		FROM "user"
		WHERE username = 'Default Owner';
		
		RETURN DefaultOwner;
	END IF;
END;

$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION fix_activities_without_owner() RETURNS SETOF activity AS $$

	
BEGIN


	UPDATE activity
	SET owner_id = (SELECT id FROM "user" WHERE username = 'Default Owner')
	WHERE owner_id IS NULL;
	
	RETURN QUERY SELECT * FROM activity WHERE owner_id = (SELECT id FROM "user" WHERE username = 'Default Owner');
	RETURN;
END;
	
	
	
	
	
$$ LANGUAGE plpgsql;