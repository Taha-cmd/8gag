CREATE OR REPLACE TRIGGER tr_notify_on_board_post
BEFORE INSERT ON "board_post"
FOR EACH ROW
BEGIN
		for "usr" in (select "id" from "user" where "id" in (select "user_id" from "subscription" where "board_id" = :new."board_id"))
		loop
			insert into "notification" values(0, 'New Post on one of your subscribed Boards!', CURRENT_TIMESTAMP, 0);
		end loop;
END;
/