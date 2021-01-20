const express = require("express");
const app = express();
const port = 8080;
const { join } = require("path");
const { readFileSync } = require("fs");
const fileUpload = require("express-fileupload");
const { v4: uuidv4 } = require("uuid");
const oracledb = require("oracledb");
const session = require("express-session");
const password = require("password-hash-and-salt");

oracledb.outFormat = oracledb.OUT_FORMAT_OBJECT;

app.set("view engine", "ejs");
app.set("views", "./views");

app.use(
	session({ secret: "notASecret", saveUninitialized: true, resave: true })
);
app.use(express.static(join(__dirname, "public")));

// for parsing application/json
app.use(express.json());

// for parsing application/xwww-
app.use(express.urlencoded({ extended: true }));
//form-urlencoded

app.use(
	fileUpload({
		limits: { fileSize: 50 * 1024 * 1024 },
	})
);

const config = JSON.parse(readFileSync("config.json"));
var sess;
var loggedIn = false;

const menuLoggedIn = [
	{ name: "profile", href: "/profile" },
	{ name: "homepage", href: "/" },
];

const menuNotLoggedIn = [
	{ name: "homepage", href: "/" },
	{ name: "login", href: "/login" },
	{ name: "register", href: "/register" },
];

app.get("/", async (req, res) => {
	const menu = loggedIn ? menuLoggedIn : menuNotLoggedIn;

	const posts = [];

	try {
		connection = await oracledb.getConnection({
			user: config.database.user,
			password: config.database.password,
			connectString: config.database.connectString,
		});

		await connection.execute(
			`select * from "post" join "user" on "post"."user_id" = "user"."id"
			join "post_tag" on "post"."id" = "post_tag"."post_id" join "tag" on "tag"."id" = "post_tag"."tag_id"
			left join "post_image" on "post"."id" = "post_image"."post_id" 
			left join "image" on "image"."id" = "post_image"."image_id"`,
			(err, result) => {
				if (err) {
					console.log("Result: ", err);
					connection.close();
				} else {
					console.log(result);
					result.rows.forEach((row) => {
						posts.push({
							id: row["id"],
							title: row["title"],
							content: row["content"],
							username: row["username"],
							tag: row["name"],
							image: row["path"] === null ? null : join("images", row["path"]),
							id: row["id"],
						});
					});
					!loggedIn
						? res.render("index", { data: { menu: menu } })
						: res.render("homepage", {
								data: {
									username: sess.username,
									profile_pic: "images/cat.png",
									menu: menu,
									loggedIn: loggedIn,
									posts: posts,
								},
						  });
				}
			}
		);
	} catch (err) {
		console.error(err);
	} finally {
		if (connection) {
			try {
				//await connection.close();
			} catch (err) {
				console.error(err);
			}
		}
		//posts.forEach((post) => (post["images"] = getImages(post.id)));
	}
});

app.get("/browse", (req, res) => {
	const menu = loggedIn ? menuLoggedIn : menuNotLoggedIn;
	res.render("homepage", { data: { loggedIn: false, menu: menu } });
});

app.get("/login", (req, res) => {
	const menu = loggedIn ? menuLoggedIn : menuNotLoggedIn;
	res.render("login", { data: { menu: menu } });
});

app.get("/register", (req, res) => {
	const menu = loggedIn ? menuLoggedIn : menuNotLoggedIn;
	res.render("register", { data: { menu: menu } });
});

app.post("/login", async function (req, res) {
	let connection;
	var pwd = null;

	try {
		connection = await oracledb.getConnection({
			user: config.database.user,
			password: config.database.password,
			connectString: config.database.connectString,
		});

		await connection.execute(
			'select "id", "password_hash" from "user" where "username" = :un',
			[req.body.username],
			function (err, result) {
				if (err) {
					console.log("Result: ", err);
					res.sendStatus(400);
					connection.close();
				} else {
					//console.log("Result: ", result);
					pwd = result.rows[0]["password_hash"];

					password(req.body.password).verifyAgainst(
						pwd,
						async function (error, verified) {
							if (error) console.log(error);
							if (!verified) {
								res.sendStatus(401);
							} else {
								var uid = result.rows[0]["id"];

								//await connection.execute("insert into \"session\" values(0, CURRENT_TIMESTAMP, DATE_ADD(CURRENT_TIMESTAMP, INTERVAL 1 DAY), :id)", [uid]);

								sess = req.session;
								sess.username = req.body.username;
								loggedIn = true;

								res.redirect("http://127.0.0.1:8080/");
							}
						}
					);

					connection.close();
				}
			}
		);
	} catch (err) {
		console.error(err);
	} finally {
		if (connection) {
			try {
				//await connection.close();
			} catch (err) {
				console.error(err);
			}
		}
	}
});

app.post("/register", async function (req, res) {
	var connection;

	try {
		connection = await oracledb.getConnection({
			user: config.database.user,
			password: config.database.password,
			connectString: config.database.connectString,
		});

		res.set("Content-Type", "text/html");

		password(req.body.psw).hash(async function (error, hash) {
			if (error) throw new Error("Something went wrong!");

			var pwd = hash;

			var st =
				'insert into "user" ' +
				"values" +
				"(null, '" +
				req.body.first_name +
				"', '" +
				req.body.last_name +
				"', '" +
				req.body.username +
				"', '" +
				pwd +
				"', '" +
				req.body.email +
				"', null, null, null, null)";

			console.log("Insert: ", st);

			await connection.execute(
				st,
				[],
				{ autoCommit: true },
				function (err, result) {
					if (err) {
						console.log("Result: ", err);
						res.sendStatus(400);
						connection.close();
					} else {
						console.log("Result: ", result);
						res.redirect("http://127.0.0.1:8080/");
						connection.close();
					}
				}
			);
		});
	} catch (err) {
		console.error(err);
	} finally {
		if (connection) {
			try {
				//await connection.close();
			} catch (err) {
				console.error(err);
			}
		}
	}
});

app.post("/upload", async (req, res) => {
	if (!loggedIn) return res.status(400).end();

	const newName = uuidv4() + ".png";
	const newPath = join(__dirname, "public", "images", newName);
	if (req.files) {
		req.files.post_picture.mv(newPath, (err) => console.log(err));
	}

	const post = {
		username: sess.username,
		title: req.body.post_title,
		content: req.body.post_content,
		tag: req.body.post_tag,
		image_name: null,
	};

	if (req.files) {
		post.image_name = newName;
	}

	try {
		connection = await oracledb.getConnection({
			user: config.database.user,
			password: config.database.password,
			connectString: config.database.connectString,
		});

		await connection.execute(
			`begin
			 addPost(:username, :title, :content, :tag, :image_name);
			 end;`,
			post,
			{ autoCommit: true },
			(err, result) => {
				if (err) {
					console.log("Result: ", err);
					connection.close();
					return res.sendStatus(400);
				} else {
					console.log("Result: ", result);
					connection.close();
					return res.redirect("/");
				}
			}
		);
	} catch (err) {
		console.error(err);
	} finally {
		if (connection) {
			try {
				//await connection.close();
			} catch (err) {
				console.error(err);
			}
		}
	}

	//res.redirect("/");
});

app.get("/likes/:id", async (req, res) => {
	res.header("Access-Control-Allow-Origin", "*");
	try {
		connection = await oracledb.getConnection({
			user: config.database.user,
			password: config.database.password,
			connectString: config.database.connectString,
		});

		await connection.execute(
			`select count(*) as "likes" from "post_likes" where "post_id" = :id`,
			[req.params.id],
			{ autoCommit: true },
			(err, result) => {
				if (err) {
					console.log("Result: ", err);
					connection.close();
					return res.sendStatus(400);
				} else {
					connection.close();
					res.json({ success: true, likes: result.rows[0]["likes"] });
				}
			}
		);
	} catch (err) {
		console.error(err);
	} finally {
		if (connection) {
			try {
				//await connection.close();
			} catch (err) {
				console.error(err);
			}
		}
	}
});

app.post("/likes/:id", async (req, res) => {
	try {
		connection = await oracledb.getConnection({
			user: config.database.user,
			password: config.database.password,
			connectString: config.database.connectString,
		});

		await connection.execute(
			`insert into "post_likes"("user_id", "post_id") 
			values((select "id" from "user" where "username" = :username), :id)`,
			[sess.username, req.params.id],
			{ autoCommit: true },
			(err, result) => {
				if (err) {
					console.log("Result: ", err);
					connection.close();
					return res.sendStatus(400);
				} else {
					connection.close();
					return res.json({ success: true });
				}
			}
		);
	} catch (err) {
		console.error(err);
	} finally {
		if (connection) {
			try {
				//await connection.close();
			} catch (err) {
				console.error(err);
			}
		}
	}
});

app.listen(port, () => console.log(`8gag listening on port ${port}`));
