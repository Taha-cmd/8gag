create or replace procedure deleteNotificationByUserID(u_id number)
is
	usr_id number(10) := u_id;
	p_pdata person%rowtype;
begin
	delete from notification where user_id = usr_id;
exception	
	when others then
		DBMS_OUTPUT.PUT_LINE(SQLCODE || ' ' || SUBSTR(SQLERRM, 1, 200));
end;
/