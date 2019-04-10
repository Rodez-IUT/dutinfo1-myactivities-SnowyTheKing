CREATE OR REPLACE FUNCTION register_user_on_activity(userID bigint, activity bigint) RETURNS registration AS $$
	
	DECLARE
		res_registration registration%rowtype;
	BEGIN
	SELECT * INTO res_registration FROM registration WHERE user_id = userID AND activity_id = activity;
		if not found then
			INSERT INTO registration (id, user_id, activity_id)
			VALUES (nextval('id_generator'), userID, activity);
			SELECT * INTO res_registration 
			FROM registration 
			WHERE user_id = userID
			AND activity_id = activity;
			RETURN res_registration;
		else 
			RAISE EXCEPTION 'registration already exist';
		end if;
	END;
	
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS add_log ON registration;

CREATE OR REPLACE FUNCTION notifie_add() RETURNS TRIGGER AS $action_log$

	BEGIN
		INSERT INTO action_log (id,action_name,entity_name,entity_id,author,action_date)
		VALUES (nextval('id_generator'),'insert','registration',NEW.id,'postgres',NOW());
		RETURN NULL;

	END;
$action_log$ language plpgsql;

CREATE TRIGGER add_log AFTER INSERT ON registration
FOR EACH ROW EXECUTE PROCEDURE notifie_add();

CREATE OR REPLACE FUNCTION unregister_user_on_activity(userID bigint, activity bigint) RETURNS void AS $$
	DECLARE
		res_registration registration%rowtype; 
	BEGIN
		SELECT * INTO res_registration FROM registration WHERE user_id = userID AND activity_id = activity;
		if not found then
			RAISE EXCEPTION 'registration_not_found';
		else
			DELETE FROM registration
			WHERE user_id = userID
			AND activity_id = activity;		
		end if;
	END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS delete_log ON registration;

CREATE OR REPLACE FUNCTION notifie_delete() RETURNS TRIGGER AS $action_log$

	BEGIN
		INSERT INTO action_log (id,action_name,entity_name,entity_id,author,action_date)
		VALUES (nextval('id_generator'),'delete','registration',OLD.id,'postgres',NOW());
		RETURN NULL;

	END;
$action_log$ language plpgsql;

CREATE TRIGGER delete_log AFTER DELETE ON registration
FOR EACH ROW EXECUTE PROCEDURE notifie_delete();


