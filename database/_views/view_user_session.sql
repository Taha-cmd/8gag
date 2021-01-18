CREATE OR REPLACE VIEW "view_user_session" AS
	SELECT "first_name","last_name","session"."id","email"
	FROM "user"
	JOIN "session" on "user"."id" = "session"."user_id"