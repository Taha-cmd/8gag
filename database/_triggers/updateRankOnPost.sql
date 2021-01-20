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
