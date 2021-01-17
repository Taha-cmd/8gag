CREATE TABLE "user" (
  "id" NUMBER(10) PRIMARY KEY,
  "first_name" varchar2(4000),
  "last_name" varchar2(4000),
  "username" varchar2(4000),
  "password_hash" varchar2(4000),
  "email" varchar2(4000),
  "location_id" number(10),
  "image_id" number(10),
  "rank_id" number(10),
  "login_streak" number(10) DEFAULT 0
);

CREATE TABLE "rank" (
  "id" NUMBER(10) PRIMARY KEY,
  "level" number(10),
  "title" varchar2(4000),
  "description" varchar2(4000)
);

CREATE TABLE "location" (
  "id" NUMBER(10) PRIMARY KEY,
  "country" varchar2(4000),
  "country_code" varchar2(4000)
);

CREATE TABLE "image" (
  "id" NUMBER(10) PRIMARY KEY,
  "path" varchar2(4000)
);


CREATE TABLE "post" (
  "id" NUMBER(10) PRIMARY KEY,
  "title" varchar2(4000),
  "content" varchar2(4000),
  "post_date" timestamp,
  "user_id" number(10),
  "hot" number(10) DEFAULT 0
);

CREATE TABLE "tag" (
  "id" NUMBER(10) PRIMARY KEY,
  "name" varchar2(4000)
);

CREATE TABLE "comment" (
  "id" NUMBER(10) PRIMARY KEY,
  "content" varchar2(4000),
  "comment_date" timestamp,
  "user_id" number(10),
  "post_id" number(10),
  "image_id" number(10)
);


CREATE TABLE "session" (
  "id" NUMBER(10) PRIMARY KEY,
  "creation_date" timestamp,
  "exipration_date" timestamp,
  "user_id" number(10)
);


CREATE TABLE "post_image" (
  "id" NUMBER(10) PRIMARY KEY,
  "post_id" number(10),
  "image_id" number(10)
);

CREATE TABLE "post_tag" (
  "id" NUMBER(10) PRIMARY KEY,
  "post_id" number(10),
  "tag_id" number(10)
);

CREATE TABLE "comment_likes" (
  "id" NUMBER(10) PRIMARY KEY,
  "user_id" number(10),
  "comment_id" number(10)
);

CREATE TABLE "post_likes" (
  "id" NUMBER(10) PRIMARY KEY,
  "user_id" number(10),
  "post_id" number(10)
);


CREATE TABLE "board" (
  "id" NUMBER(10) PRIMARY KEY,
  "name" varchar2(4000) NOT NULL,
  "category_id" number(10)
);


CREATE TABLE "board_category" (
  "id" NUMBER(10) PRIMARY KEY,
  "name" varchar2(4000)
);


CREATE TABLE "board_post" (
  "id" NUMBER(10) PRIMARY KEY,
  "content" varchar2(4000),
  "user_id" number(10),
  "board_id" number(10)
);


CREATE TABLE "subscription" (
  "id" NUMBER(10) PRIMARY KEY,
  "user_id" number(10),
  "board_id" number(10)
);


CREATE TABLE "notification" (
  "id" NUMBER(10) PRIMARY KEY,
  "message" varchar2(4000),
  "notification_date" timestamp DEFAULT systimestamp,
  "user_id" number(10)
);


ALTER TABLE "user" ADD FOREIGN KEY ("location_id") REFERENCES "location" ("id");

ALTER TABLE "user" ADD FOREIGN KEY ("image_id") REFERENCES "image" ("id");

ALTER TABLE "user" ADD FOREIGN KEY ("rank_id") REFERENCES "rank" ("id");

ALTER TABLE "post" ADD FOREIGN KEY ("user_id") REFERENCES "user" ("id");

ALTER TABLE "comment" ADD FOREIGN KEY ("user_id") REFERENCES "user" ("id");

ALTER TABLE "comment" ADD FOREIGN KEY ("post_id") REFERENCES "post" ("id");

ALTER TABLE "comment" ADD FOREIGN KEY ("image_id") REFERENCES "image" ("id");

ALTER TABLE "session" ADD FOREIGN KEY ("user_id") REFERENCES "user" ("id");

ALTER TABLE "post_image" ADD FOREIGN KEY ("post_id") REFERENCES "post" ("id");

ALTER TABLE "post_image" ADD FOREIGN KEY ("image_id") REFERENCES "image" ("id");

ALTER TABLE "post_tag" ADD FOREIGN KEY ("post_id") REFERENCES "post" ("id");

ALTER TABLE "post_tag" ADD FOREIGN KEY ("tag_id") REFERENCES "tag" ("id");

ALTER TABLE "comment_likes" ADD FOREIGN KEY ("comment_id") REFERENCES "comment" ("id");

ALTER TABLE "comment_likes" ADD FOREIGN KEY ("user_id") REFERENCES "user" ("id");

ALTER TABLE "notification" ADD FOREIGN KEY ("user_id") REFERENCES "user" ("id");

ALTER TABLE "subscription" ADD FOREIGN KEY ("user_id") REFERENCES "user" ("id");

ALTER TABLE "subscription" ADD FOREIGN KEY ("board_id") REFERENCES "board" ("id");

ALTER TABLE "board" ADD FOREIGN KEY ("category_id") REFERENCES "board" ("id");

ALTER TABLE "board_post" ADD FOREIGN KEY ("user_id") REFERENCES "user" ("id");

ALTER TABLE "board_post" ADD FOREIGN KEY ("board_id") REFERENCES "board" ("id");

ALTER TABLE "post_likes" ADD FOREIGN KEY ("user_id") REFERENCES "user" ("id");

ALTER TABLE "post_likes" ADD FOREIGN KEY ("post_id") REFERENCES "post" ("id");