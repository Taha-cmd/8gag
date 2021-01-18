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
