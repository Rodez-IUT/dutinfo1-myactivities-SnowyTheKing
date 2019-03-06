CREATE OR REPLACE FUNCTION find_all_activities_for_owner(nom_personne varchar(500)) RETURNS SETOF activity AS $$
    	select activity.*
    	from activity
    	join "user"
    	on owner_id = "user".id
    	where username = nom_personne
$$ LANGUAGE SQL;
