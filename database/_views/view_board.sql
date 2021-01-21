CREATE OR REPLACE VIEW "view_board" AS
	select * from "board" inner join "board_category" on "board"."category_id" = "board_category"."id";
