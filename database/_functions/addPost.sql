create or replace procedure addPost(username varchar, title varchar, content varchar, tag varchar, image_name varchar default null)
is
	v_postId int;
	v_tagId int;
	v_userId int;
	v_imageId int;
	v_tagExists int;

begin

	select "id" into v_userId from "user" where "user"."username" = username;
	insert into "post"("title", "content", "post_date", "user_id") values(title, content, sysdate, v_userId);
	select "id" into v_postId from "post" where "id" = (select max("id") from "post");
	
	select count(*) into v_tagExists from "tag" where "name" = tag;
	
	if v_tagExists = 0 then
		insert into "tag"("name") values(tag);
	end if;
	
	select "id" into v_tagId from "tag" where "id" = (select max("id") from "tag");
	insert into "post_tag"("post_id", "tag_id") values(v_postId, v_tagId);

	if image_name is not null then
	
		insert into "image"("path") values(image_name);
		select "id" into v_imageId from "image" where "id" = (select max("id") from "image");
		insert into "post_image"("post_id", "image_id") values(v_postId, v_imageId);
	
	end if;

exception
	when others then
		raise_application_error(-20420, sqlcode || ' ' || sqlerrm);

end;
/

