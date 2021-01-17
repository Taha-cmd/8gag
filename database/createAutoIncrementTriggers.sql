
-- Generate ID using sequence and trigger


CREATE OR REPLACE TRIGGER "user_seq_tr"
 BEFORE INSERT ON "user" FOR EACH ROW
 WHEN (NEW."id" IS NULL)
BEGIN
 SELECT "user_seq".NEXTVAL INTO :NEW."id" FROM DUAL;
END;
/

-- Generate ID using sequence and trigger


CREATE OR REPLACE TRIGGER "rank_seq_tr"
 BEFORE INSERT ON "rank" FOR EACH ROW
 WHEN (NEW."id" IS NULL)
BEGIN
 SELECT "rank_seq".NEXTVAL INTO :NEW."id" FROM DUAL;
END;
/

-- Generate ID using sequence and trigger


CREATE OR REPLACE TRIGGER "location_seq_tr"
 BEFORE INSERT ON "location" FOR EACH ROW
 WHEN (NEW."id" IS NULL)
BEGIN
 SELECT "location_seq".NEXTVAL INTO :NEW."id" FROM DUAL;
END;
/

-- Generate ID using sequence and trigger


CREATE OR REPLACE TRIGGER "image_seq_tr"
 BEFORE INSERT ON "image" FOR EACH ROW
 WHEN (NEW."id" IS NULL)
BEGIN
 SELECT "image_seq".NEXTVAL INTO :NEW."id" FROM DUAL;
END;
/

-- Generate ID using sequence and trigger


CREATE OR REPLACE TRIGGER "post_seq_tr"
 BEFORE INSERT ON "post" FOR EACH ROW
 WHEN (NEW."id" IS NULL)
BEGIN
 SELECT "post_seq".NEXTVAL INTO :NEW."id" FROM DUAL;
END;
/

-- Generate ID using sequence and trigger


CREATE OR REPLACE TRIGGER "tag_seq_tr"
 BEFORE INSERT ON "tag" FOR EACH ROW
 WHEN (NEW."id" IS NULL)
BEGIN
 SELECT "tag_seq".NEXTVAL INTO :NEW."id" FROM DUAL;
END;
/

-- Generate ID using sequence and trigger


CREATE OR REPLACE TRIGGER "comment_seq_tr"
 BEFORE INSERT ON "comment" FOR EACH ROW
 WHEN (NEW."id" IS NULL)
BEGIN
 SELECT "comment_seq".NEXTVAL INTO :NEW."id" FROM DUAL;
END;
/

-- Generate ID using sequence and trigger


CREATE OR REPLACE TRIGGER "session_seq_tr"
 BEFORE INSERT ON "session" FOR EACH ROW
 WHEN (NEW."id" IS NULL)
BEGIN
 SELECT "session_seq".NEXTVAL INTO :NEW."id" FROM DUAL;
END;
/

-- Generate ID using sequence and trigger


CREATE OR REPLACE TRIGGER "post_image_seq_tr"
 BEFORE INSERT ON "post_image" FOR EACH ROW
 WHEN (NEW."id" IS NULL)
BEGIN
 SELECT "post_image_seq".NEXTVAL INTO :NEW."id" FROM DUAL;
END;
/

-- Generate ID using sequence and trigger


CREATE OR REPLACE TRIGGER "post_tag_seq_tr"
 BEFORE INSERT ON "post_tag" FOR EACH ROW
 WHEN (NEW."id" IS NULL)
BEGIN
 SELECT "post_tag_seq".NEXTVAL INTO :NEW."id" FROM DUAL;
END;
/

-- Generate ID using sequence and trigger


CREATE OR REPLACE TRIGGER "comment_likes_seq_tr"
 BEFORE INSERT ON "comment_likes" FOR EACH ROW
 WHEN (NEW."id" IS NULL)
BEGIN
 SELECT "comment_likes_seq".NEXTVAL INTO :NEW."id" FROM DUAL;
END;
/

-- Generate ID using sequence and trigger


CREATE OR REPLACE TRIGGER "post_likes_seq_tr"
 BEFORE INSERT ON "post_likes" FOR EACH ROW
 WHEN (NEW."id" IS NULL)
BEGIN
 SELECT "post_likes_seq".NEXTVAL INTO :NEW."id" FROM DUAL;
END;
/

-- Generate ID using sequence and trigger


CREATE OR REPLACE TRIGGER "board_seq_tr"
 BEFORE INSERT ON "board" FOR EACH ROW
 WHEN (NEW."id" IS NULL)
BEGIN
 SELECT "board_seq".NEXTVAL INTO :NEW."id" FROM DUAL;
END;
/

-- Generate ID using sequence and trigger


CREATE OR REPLACE TRIGGER "board_category_seq_tr"
 BEFORE INSERT ON "board_category" FOR EACH ROW
 WHEN (NEW."id" IS NULL)
BEGIN
 SELECT "board_category_seq".NEXTVAL INTO :NEW."id" FROM DUAL;
END;
/

-- Generate ID using sequence and trigger


CREATE OR REPLACE TRIGGER "board_post_seq_tr"
 BEFORE INSERT ON "board_post" FOR EACH ROW
 WHEN (NEW."id" IS NULL)
BEGIN
 SELECT "board_post_seq".NEXTVAL INTO :NEW."id" FROM DUAL;
END;
/

-- Generate ID using sequence and trigger


CREATE OR REPLACE TRIGGER "subscription_seq_tr"
 BEFORE INSERT ON "subscription" FOR EACH ROW
 WHEN (NEW."id" IS NULL)
BEGIN
 SELECT "subscription_seq".NEXTVAL INTO :NEW."id" FROM DUAL;
END;
/

-- Generate ID using sequence and trigger


CREATE OR REPLACE TRIGGER "notification_seq_tr"
 BEFORE INSERT ON "notification" FOR EACH ROW
 WHEN (NEW."id" IS NULL)
BEGIN
 SELECT "notification_seq".NEXTVAL INTO :NEW."id" FROM DUAL;
END;
/

