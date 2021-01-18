CREATE OR REPLACE VIEW "view_board_posts" AS
	select * from board inner join board_post on board.id = board_post.board_id;
