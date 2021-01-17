CREATE VIEW tag_post_overview AS
	SELECT "tag"."id" AS TagID, "tag"."name" AS  TagName,
		"post"."id" AS PostID, "post"."title" AS PostTitle, "post"."content" AS PostContent,
		"post"."post_date" AS PostDate, "post"."hot" AS PostIsHot
	FROM "tag"
	JOIN "post_tag" ON "post_tag"."tag_id" = "tag"."id"
	JOIN "post" ON "post"."id" = "post_tag"."post_id";
