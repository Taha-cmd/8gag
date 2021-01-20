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

CREATE OR REPLACE TRIGGER tr_update_loginstreak
AFTER INSERT ON "session"
FOR EACH ROW
BEGIN
		UPDATE "user" SET "login_streak" = "login_streak" + 1
		WHERE "user"."id" = :new."user_id";
END;
/

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

create or replace TRIGGER "post_hot_likes"
BEFORE insert ON  "post_likes"
for each row
declare
pragma autonomous_transaction;
v_count_likes   number;
begin
    select count(*) into v_count_likes from "post_likes" where "post_id" = :new."post_id";
    if v_count_likes > 100 then
        update  "post" set "hot" = 1 where "id" = :new."post_id";
    end if;
exception
    when others then
        raise_application_error(-20001, sqlerrm);
END;
/


create or replace trigger updateRankOnPost
after insert on "post"
for each row
declare
	v_postCount int := 0;
	v_currentLevel int := 0;  
	v_levelIncrease int := 0; -- increase level by 1 for each 10 posts
	v_increaseOrNot int := -1;

begin
	select count(*) into v_postCount from "post" where "user_id" = :new."user_id";
	select "rank"."level" into v_currentLevel from "user" join "rank" on "user"."rank_id" = "rank"."id"
	join "post" on "user"."id"  = "post"."user_id" where "user"."id" = :new."user_id";
	
	v_increaseOrNot := mod(v_postCount, 10);
	
	if v_increaseOrNot = 0 then
		v_levelIncrease := ceil(v_postCount/10) - 1; 
	end if;
	
	update "user" set "rank_id" = v_currentLevel + v_levelIncrease where "id" = :new."user_id";
	
exception
when others then
		raise_application_error(-20420, sqlcode || ' ' || sqlerrm);

end;
/
