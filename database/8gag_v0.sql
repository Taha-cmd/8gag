CREATE TABLE "user" (
  "id" SERIAL PRIMARY KEY,
  "first_name" varchar,
  "last_name" varchar,
  "username" varchar,
  "password_hash" varchar,
  "email" varchar,
  "location_id" int,
  "image_id" int,
  "rank_id" int
);

CREATE TABLE "rank" (
  "id" SERIAL PRIMARY KEY,
  "level" int,
  "title" varchar,
  "description" varchar
);

CREATE TABLE "location" (
  "id" SERIAL PRIMARY KEY,
  "country" varchar,
  "country_code" varchar
);

CREATE TABLE "image" (
  "id" SERIAL PRIMARY KEY,
  "path" varchar
);

CREATE TABLE "post" (
  "id" SERIAL PRIMARY KEY,
  "title" varchar,
  "content" varchar,
  "post_date" datetime,
  "user_id" int
);

CREATE TABLE "tag" (
  "id" SERIAL PRIMARY KEY,
  "name" varchar
);

CREATE TABLE "comment" (
  "id" SERIAL PRIMARY KEY,
  "content" varchar,
  "comment_date" datetime,
  "user_id" int,
  "post_id" int,
  "image_id" int
);

CREATE TABLE "session" (
  "id" SERIAL PRIMARY KEY,
  "creation_date" datetime,
  "exipration_date" datetime,
  "user_id" int
);

CREATE TABLE "post_image" (
  "id" SERIAL PRIMARY KEY,
  "post_id" int,
  "image_id" int
);

CREATE TABLE "post_tag" (
  "id" SERIAL PRIMARY KEY,
  "post_id" int,
  "image_id" int
);

CREATE TABLE "comment_likes" (
  "id" SERIAL PRIMARY KEY,
  "user_id" int,
  "comment_id" int
);

CREATE TABLE "post_likes" (
  "id" SERIAL PRIMARY KEY,
  "user_id" int,
  "post_id" int
);

ALTER TABLE "user" ADD FOREIGN KEY ("location_id") REFERENCES "location" ("id");

ALTER TABLE "image" ADD FOREIGN KEY ("id") REFERENCES "user" ("image_id");

ALTER TABLE "rank" ADD FOREIGN KEY ("id") REFERENCES "user" ("rank_id");

ALTER TABLE "post" ADD FOREIGN KEY ("user_id") REFERENCES "user" ("id");

ALTER TABLE "comment" ADD FOREIGN KEY ("user_id") REFERENCES "user" ("id");

ALTER TABLE "comment" ADD FOREIGN KEY ("post_id") REFERENCES "post" ("id");

ALTER TABLE "image" ADD FOREIGN KEY ("id") REFERENCES "comment" ("image_id");

ALTER TABLE "session" ADD FOREIGN KEY ("user_id") REFERENCES "user" ("id");

ALTER TABLE "post_image" ADD FOREIGN KEY ("post_id") REFERENCES "post" ("id");

ALTER TABLE "post_image" ADD FOREIGN KEY ("image_id") REFERENCES "image" ("id");

ALTER TABLE "post_tag" ADD FOREIGN KEY ("post_id") REFERENCES "post" ("id");

ALTER TABLE "post_tag" ADD FOREIGN KEY ("image_id") REFERENCES "image" ("id");

ALTER TABLE "comment_likes" ADD FOREIGN KEY ("comment_id") REFERENCES "comment" ("id");

ALTER TABLE "comment_likes" ADD FOREIGN KEY ("user_id") REFERENCES "user" ("id");

ALTER TABLE "post_likes" ADD FOREIGN KEY ("user_id") REFERENCES "user" ("id");

ALTER TABLE "post_likes" ADD FOREIGN KEY ("post_id") REFERENCES "post" ("id");
