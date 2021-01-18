CREATE OR REPLACE TRIGGER tr_notify_on_board_post
AFTER INSERT ON board_post
FOR EACH ROW
BEGIN	
		create table temp_users as select id from user where id in (select user_id from subscription where board_id = new.board_id);
		
		for usr in (select * from temp_users)
		loop
			insert into notification values(0, "New Post on one of your Subscribed Boards!", CURRENT_TIMESTAMP, temp_users.id);
		end loop;
		
		drop table temp_users;
END;
/