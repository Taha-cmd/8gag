CREATE OR REPLACE VIEW "view_hot_post_likes" AS
 select "hot","post"."user_id","post_likes"."post_id"
 from "post" 
 join "post_likes" on "post_likes"."post_id"="post"."id"