CREATE OR REPLACE TRIGGER notify_user
AFTER INSERT ON "comment"
FOR EACH ROW 
DECLARE 
post_user NUMBER;
comment_user varchar2(4000);
BEGIN 
	SELECT "user"."username" INTO comment_user FROM "user" WHERE :OLD."user_id"="user"."id";
	SELECT "post"."user_id" INTO post_user FROM "post" WHERE :OLD."user_id"="post"."user_id"; 
	INSERT INTO "notification" ("message","user_id") VALUES (comment_user||' commented on your post',post_user);
END;
/