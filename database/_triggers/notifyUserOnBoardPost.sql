CREATE OR REPLACE TRIGGER tr_notify_on_board_post
BEFORE INSERT ON "board_post"
FOR EACH ROW
BEGIN
		for "usr" in (select * from (select "user"."id" as USID, "name", "board"."id" as BID from "user" inner join "subscription" on "user"."id" = "subscription"."user_id" inner join "board" on "subscription"."board_id" = "board"."id") 
									where USID in (select "user_id" from "subscription" where "board_id" = 0) and BID = :new."board_id")
		loop
			insert into "notification" ("message", "notification_date", "user_id") values(CONCAT('New Post in Board: ', "usr"."name"), CURRENT_TIMESTAMP, TO_NUMBER("usr".USID));
		end loop;
END;
/