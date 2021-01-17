CREATE OR REPLACE TRIGGER tr_update_loginstreak
AFTER INSERT ON "session"
FOR EACH ROW
BEGIN
		UPDATE "user" SET "login_streak" = "login_streak" + 1
		WHERE "user"."id" = :new."user_id";
END;
/