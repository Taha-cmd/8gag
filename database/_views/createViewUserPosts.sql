CREATE VIEW user_posts AS 
	SELECT "post"."id" AS PostID, "post"."title" AS PostTitle, "post"."content" AS PostContent,
		"post"."post_date" AS PostDate, "post"."hot" AS PostIsHot
	FROM "post"
	JOIN "comment" ON "comment"."post_id"="post"."id"
	JOIN "post_image" ON "post_image"."post_id"="post"."id"
	JOIN "post_likes" ON "post_likes"."post_id"="post"."id"
	WHERE "post"."user_id"=1;