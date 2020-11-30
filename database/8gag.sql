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

-- Generate ID using sequence and trigger
CREATE SEQUENCE "user_seq" START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER "user_seq_tr"
 BEFORE INSERT ON "user" FOR EACH ROW
 WHEN (NEW."id" IS NULL)
BEGIN
 SELECT "user_seq".NEXTVAL INTO :NEW."id" FROM DUAL;
END;
/

CREATE TABLE "rank" (
  "id" NUMBER(10) PRIMARY KEY,
  "level" number(10),
  "title" varchar2(4000),
  "description" varchar2(4000)
);

-- Generate ID using sequence and trigger
CREATE SEQUENCE "rank_seq" START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER "rank_seq_tr"
 BEFORE INSERT ON "rank" FOR EACH ROW
 WHEN (NEW."id" IS NULL)
BEGIN
 SELECT "rank_seq".NEXTVAL INTO :NEW."id" FROM DUAL;
END;
/

CREATE TABLE "location" (
  "id" NUMBER(10) PRIMARY KEY,
  "country" varchar2(4000),
  "country_code" varchar2(4000)
);

-- Generate ID using sequence and trigger
CREATE SEQUENCE "location_seq" START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER "location_seq_tr"
 BEFORE INSERT ON "location" FOR EACH ROW
 WHEN (NEW."id" IS NULL)
BEGIN
 SELECT "location_seq".NEXTVAL INTO :NEW."id" FROM DUAL;
END;
/

CREATE TABLE "image" (
  "id" NUMBER(10) PRIMARY KEY,
  "path" varchar2(4000)
);

-- Generate ID using sequence and trigger
CREATE SEQUENCE "image_seq" START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER "image_seq_tr"
 BEFORE INSERT ON "image" FOR EACH ROW
 WHEN (NEW."id" IS NULL)
BEGIN
 SELECT "image_seq".NEXTVAL INTO :NEW."id" FROM DUAL;
END;
/

CREATE TABLE "post" (
  "id" NUMBER(10) PRIMARY KEY,
  "title" varchar2(4000),
  "content" varchar2(4000),
  "post_date" timestamp,
  "user_id" number(10),
  "hot" number(10) DEFAULT 0
);

-- Generate ID using sequence and trigger
CREATE SEQUENCE "post_seq" START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER "post_seq_tr"
 BEFORE INSERT ON "post" FOR EACH ROW
 WHEN (NEW."id" IS NULL)
BEGIN
 SELECT "post_seq".NEXTVAL INTO :NEW."id" FROM DUAL;
END;
/

CREATE TABLE "tag" (
  "id" NUMBER(10) PRIMARY KEY,
  "name" varchar2(4000)
);

-- Generate ID using sequence and trigger
CREATE SEQUENCE "tag_seq" START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER "tag_seq_tr"
 BEFORE INSERT ON "tag" FOR EACH ROW
 WHEN (NEW."id" IS NULL)
BEGIN
 SELECT "tag_seq".NEXTVAL INTO :NEW."id" FROM DUAL;
END;
/

CREATE TABLE "comment" (
  "id" NUMBER(10) PRIMARY KEY,
  "content" varchar2(4000),
  "comment_date" timestamp,
  "user_id" number(10),
  "post_id" number(10),
  "image_id" number(10)
);

-- Generate ID using sequence and trigger
CREATE SEQUENCE "comment_seq" START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER "comment_seq_tr"
 BEFORE INSERT ON "comment" FOR EACH ROW
 WHEN (NEW."id" IS NULL)
BEGIN
 SELECT "comment_seq".NEXTVAL INTO :NEW."id" FROM DUAL;
END;
/

CREATE TABLE "session" (
  "id" NUMBER(10) PRIMARY KEY,
  "creation_date" timestamp,
  "exipration_date" timestamp,
  "user_id" number(10)
);

-- Generate ID using sequence and trigger
CREATE SEQUENCE "session_seq" START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER "session_seq_tr"
 BEFORE INSERT ON "session" FOR EACH ROW
 WHEN (NEW."id" IS NULL)
BEGIN
 SELECT "session_seq".NEXTVAL INTO :NEW."id" FROM DUAL;
END;
/

CREATE TABLE "post_image" (
  "id" NUMBER(10) PRIMARY KEY,
  "post_id" number(10),
  "image_id" number(10)
);

-- Generate ID using sequence and trigger
CREATE SEQUENCE "post_image_seq" START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER "post_image_seq_tr"
 BEFORE INSERT ON "post_image" FOR EACH ROW
 WHEN (NEW."id" IS NULL)
BEGIN
 SELECT "post_image_seq".NEXTVAL INTO :NEW."id" FROM DUAL;
END;
/

CREATE TABLE "post_tag" (
  "id" NUMBER(10) PRIMARY KEY,
  "post_id" number(10),
  "tag_id" number(10)
);

-- Generate ID using sequence and trigger
CREATE SEQUENCE "post_tag_seq" START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER "post_tag_seq_tr"
 BEFORE INSERT ON "post_tag" FOR EACH ROW
 WHEN (NEW."id" IS NULL)
BEGIN
 SELECT "post_tag_seq".NEXTVAL INTO :NEW."id" FROM DUAL;
END;
/

CREATE TABLE "comment_likes" (
  "id" NUMBER(10) PRIMARY KEY,
  "user_id" number(10),
  "comment_id" number(10)
);

-- Generate ID using sequence and trigger
CREATE SEQUENCE "comment_likes_seq" START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER "comment_likes_seq_tr"
 BEFORE INSERT ON "comment_likes" FOR EACH ROW
 WHEN (NEW."id" IS NULL)
BEGIN
 SELECT "comment_likes_seq".NEXTVAL INTO :NEW."id" FROM DUAL;
END;
/

CREATE TABLE "post_likes" (
  "id" NUMBER(10) PRIMARY KEY,
  "user_id" number(10),
  "post_id" number(10)
);

-- Generate ID using sequence and trigger
CREATE SEQUENCE "post_likes_seq" START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER "post_likes_seq_tr"
 BEFORE INSERT ON "post_likes" FOR EACH ROW
 WHEN (NEW."id" IS NULL)
BEGIN
 SELECT "post_likes_seq".NEXTVAL INTO :NEW."id" FROM DUAL;
END;
/

CREATE TABLE "board" (
  "id" NUMBER(10) PRIMARY KEY,
  "name" varchar2(4000) NOT NULL,
  "category_id" number(10)
);

-- Generate ID using sequence and trigger
CREATE SEQUENCE "board_seq" START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER "board_seq_tr"
 BEFORE INSERT ON "board" FOR EACH ROW
 WHEN (NEW."id" IS NULL)
BEGIN
 SELECT "board_seq".NEXTVAL INTO :NEW."id" FROM DUAL;
END;
/

CREATE TABLE "board_category" (
  "id" NUMBER(10) PRIMARY KEY,
  "name" varchar2(4000)
);

-- Generate ID using sequence and trigger
CREATE SEQUENCE "board_category_seq" START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER "board_category_seq_tr"
 BEFORE INSERT ON "board_category" FOR EACH ROW
 WHEN (NEW."id" IS NULL)
BEGIN
 SELECT "board_category_seq".NEXTVAL INTO :NEW."id" FROM DUAL;
END;
/

CREATE TABLE "board_post" (
  "id" NUMBER(10) PRIMARY KEY,
  "content" varchar2(4000),
  "user_id" number(10),
  "board_id" number(10)
);

-- Generate ID using sequence and trigger
CREATE SEQUENCE "board_post_seq" START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER "board_post_seq_tr"
 BEFORE INSERT ON "board_post" FOR EACH ROW
 WHEN (NEW."id" IS NULL)
BEGIN
 SELECT "board_post_seq".NEXTVAL INTO :NEW."id" FROM DUAL;
END;
/

CREATE TABLE "subscription" (
  "id" NUMBER(10) PRIMARY KEY,
  "user_id" number(10),
  "board_id" number(10)
);

-- Generate ID using sequence and trigger
CREATE SEQUENCE "subscription_seq" START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER "subscription_seq_tr"
 BEFORE INSERT ON "subscription" FOR EACH ROW
 WHEN (NEW."id" IS NULL)
BEGIN
 SELECT "subscription_seq".NEXTVAL INTO :NEW."id" FROM DUAL;
END;
/

CREATE TABLE "notification" (
  "id" NUMBER(10) PRIMARY KEY,
  "message" varchar2(4000),
  "notification_date" timestamp DEFAULT 'now()',
  "user_id" number(10)
);

-- Generate ID using sequence and trigger
CREATE SEQUENCE "notification_seq" START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER "notification_seq_tr"
 BEFORE INSERT ON "notification" FOR EACH ROW
 WHEN (NEW."id" IS NULL)
BEGIN
 SELECT "notification_seq".NEXTVAL INTO :NEW."id" FROM DUAL;
END;
/

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

ALTER TABLE "post_tag" ADD FOREIGN KEY ("tag_id") REFERENCES "tag" ("id");

ALTER TABLE "comment_likes" ADD FOREIGN KEY ("comment_id") REFERENCES "comment" ("id");

ALTER TABLE "comment_likes" ADD FOREIGN KEY ("user_id") REFERENCES "user" ("id");

ALTER TABLE "notification" ADD FOREIGN KEY ("user_id") REFERENCES "user" ("id");

ALTER TABLE "subscription" ADD FOREIGN KEY ("user_id") REFERENCES "user" ("id");

ALTER TABLE "subscription" ADD FOREIGN KEY ("board_id") REFERENCES "board" ("id");

ALTER TABLE "board_category" ADD FOREIGN KEY ("id") REFERENCES "board" ("category_id");

ALTER TABLE "board_post" ADD FOREIGN KEY ("user_id") REFERENCES "user" ("id");

ALTER TABLE "board_post" ADD FOREIGN KEY ("board_id") REFERENCES "board" ("id");

ALTER TABLE "post_likes" ADD FOREIGN KEY ("user_id") REFERENCES "user" ("id");

ALTER TABLE "post_likes" ADD FOREIGN KEY ("post_id") REFERENCES "post" ("id");
