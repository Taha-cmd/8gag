create view view_post_comment as
select "post"."id" as post_id, "post"."title" as post_title, "comment"."id" as comment_id,
"comment"."content"
from "post" join "comment" on "post"."id" = "comment"."post_id"; 
