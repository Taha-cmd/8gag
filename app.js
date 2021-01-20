const express = require("express");
const app = express();
const port = 8080;
const path = require("path");
const fileUpload = require("express-fileupload");
const { v4: uuidv4 } = require("uuid");
const oracledb = require('oracledb');
const session = require('express-session');
const password = require('password-hash-and-salt');
const url = require('url');

oracledb.outFormat = oracledb.OUT_FORMAT_OBJECT;

app.set("view engine", "ejs");
app.set("views", "./views");

app.use(session({secret: 'notASecret',saveUninitialized: true,resave: true}));
app.use(express.static(path.join(__dirname, "public")));

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

var sess;
var loggedIn = false;

app.get("/", (req, res) =>
	!loggedIn
		? res.render("index", { data: { menu: menu } })
		: res.render("homepage", {
				data: {
					username: sess.username,
					profile_pic: "images/cat.png",
					menu: menuLoggedIn,
					loggedIn: loggedIn,
				},
		  })
);

app.get("/browse", (req, res) =>
	!loggedIn
		?res.render("homepage", { data: { loggedIn: false, menu: menuNotLoggedIn } })
		:res.render("homepage", { data: { loggedIn: true, menu: menuLoggedIn } })
);

app.get("/boards", async function (req, res) {
	let connection;
	var mypw = "dbsw20";
	var pwd = null;
	
	try{
		connection = await oracledb.getConnection( {
			user          : "w20bif3_if20b185",
			password      : mypw,
			connectString : "infdb.technikum-wien.at:1521/o10"
		});

		await connection.execute("select * from \"board\"", [], function(err, result){
			if (err) {
				console.log('Result: ', err);
				res.sendStatus(400);
				connection.close();
			} else {
				if(loggedIn)
					res.render("boards", { data: { loggedIn: true, menu: menuLoggedIn, uid: sess.uid, boards: result, username: sess.username, subs: sess.subs} })
				else
					res.render("boards", { data: { loggedIn: false, menu: menuNotLoggedIn, boards: result} })
				connection.close();
			}
		});
		
	} catch(err){
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

app.get("/board", async function (req, res) {
	const queryObject = url.parse(req.url,true).query;
	console.log("Request: ", queryObject["boardName"]);
	
	let connection;
	var mypw = "dbsw20";
	var pwd = null;
	
	try{
		connection = await oracledb.getConnection( {
			user          : "w20bif3_if20b185",
			password      : mypw,
			connectString : "infdb.technikum-wien.at:1521/o10"
		});

		await connection.execute("select * from" + 
								"(select \"user\".\"id\", \"board_post\".\"board_id\", \"content\", \"username\", \"board_post\".\"id\" as BID from \"board_post\" inner join \"user\" on \"user\".\"id\" = \"board_post\".\"user_id\")" + 
								"where \"board_id\" = :id order by BID",
								[queryObject["board"]], function(err, result){
			if (err) {
				console.log('Result: ', err);
				res.sendStatus(400);
				connection.close();
			} else {
				if(loggedIn)
					res.render("board", { data: { loggedIn: true, menu: menuLoggedIn, uid: sess.uid, board: result, boardName: queryObject["boardName"], boardID: queryObject["board"], username: sess.username} })
				else
					res.render("board", { data: { loggedIn: false, menu: menuNotLoggedIn, board: result, boardName: queryObject["boardName"], boardID: queryObject["board"]} })
				connection.close();
			}
		});
		
	} catch(err){
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

app.get("/login", (req, res) => 
	res.render("login", { data: { menu: menu } })
);

app.get("/register", (req, res) =>
	res.render("register", { data: { menu: menu } })
);

app.post('/login', async function (req, res) {
	let connection;
	var mypw = "dbsw20";
	var pwd = null;
	var res_user;
	
	try{
		connection = await oracledb.getConnection( {
			user          : "w20bif3_if20b185",
			password      : mypw,
			connectString : "infdb.technikum-wien.at:1521/o10"
		});

		await connection.execute("select \"id\", \"password_hash\" from \"user\" where \"username\" = :un", [req.body.username], function(err, result){
			if (err) {
				console.log('Result: ', err);
				res.sendStatus(400);
				connection.close();
			} else {
				pwd = result.rows[0]["password_hash"];
		
				password(req.body.password).verifyAgainst(pwd, async function(error, verified) {
					if(error)
						console.log(error);
					if(!verified) {
						res.sendStatus(401);
					} else {
						res_user = result; 
						
						sess = req.session;
						sess.uid = res_user.rows[0]["id"];
						sess.username = req.body.username;
						loggedIn = true;
					}
					
					connection.close();
				});
			}
		});
		
		connection2 = await oracledb.getConnection( {
			user          : "w20bif3_if20b185",
			password      : mypw,
			connectString : "infdb.technikum-wien.at:1521/o10"
		});
		
		
		if(loggedIn){
			await connection2.execute("select \"board_id\" from \"subscription\" where \"user_id\" = :id", [res_user.rows[0]["id"]], function(err, result){
				if(err)
					console.log(err);
				else {
					console.log(result.rows);
					sess.subs = new Array();
					for(var i = 0; i < result.rows.length; i++) {
						sess.subs[i] = result.rows[i]["board_id"];
					}

					res.redirect('http://127.0.0.1:8080/');
				}
				
				connection2.close();
			});
		}
		
	} catch(err){
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
	var mypw = "dbsw20";
	
	try{
		connection = await oracledb.getConnection({
			user          : "w20bif3_if20b185",
			password      : mypw,
			connectString : "infdb.technikum-wien.at:1521/o10"
		});
			
		res.set('Content-Type', 'text/html');
	
		password(req.body.psw).hash(async function(error, hash) {
			if(error)
				throw new Error('Something went wrong!');

			var pwd = hash;
			
			var st = "insert into \"user\" " + 
					"(\"first_name\", \"last_name\", \"username\", \"password_hash\", \"email\") values" + 
					"('" + req.body.first_name + "', '" + req.body.last_name + "', '" + req.body.username + "', '" + pwd + "', '" + req.body.email + "')"

			await connection.execute(st, 
									[], {autoCommit: true},
									function(err, result){
										if (err) {
											console.log('Result: ', err);
											res.sendStatus(400);
											connection.close();
										} else{
											res.redirect('http://127.0.0.1:8080/');
											connection.close();
										}
									});

		});
		
	} catch(err){
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

app.post("/upload", (req, res) => {
	console.log(req.files);
	console.log(req.body);

	const newPath = path.join(__dirname, "public", "images", uuidv4() + ".png");
	req.files.post_picture.mv(newPath, (err) => console.log(err));
	res.redirect("/");
});

app.post("/uploadBoardPost", async function (req, res) {
	console.log("Body: ", req.body);

	let connection;
	var mypw = "dbsw20";
	
	try{
		connection = await oracledb.getConnection( {
			user          : "w20bif3_if20b185",
			password      : mypw,
			connectString : "infdb.technikum-wien.at:1521/o10"
		});
	
		var st = "insert into \"board_post\" (\"content\", \"user_id\", \"board_id\") values ('" + req.body.post_content + "', " + sess.uid + ", " + req.body.board_id + ")";
		
		await connection.execute(st,
								[], {autoCommit: true}, 
								function(err, result){
			if (err) {
				console.log('Result: ', err);
				res.sendStatus(400);
				connection.close();
			} else {
				res.redirect('http://127.0.0.1:8080/board?board=' + req.body.board_id + '&boardName=' + req.body.board_name);
				connection.close();
			}
		});
		
	} catch(err){
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

app.post("/sub", async function (req, res) {
	console.log("Body: ", req.body);

	let connection;
	var mypw = "dbsw20";
	
	try{
		connection = await oracledb.getConnection( {
			user          : "w20bif3_if20b185",
			password      : mypw,
			connectString : "infdb.technikum-wien.at:1521/o10"
		});
	
		var st = "insert into \"subscription\" (\"user_id\", \"board_id\") values (" + sess.uid + ", " + req.body.board_id + ")";
		
		
		
		await connection.execute(st,
								[], {autoCommit: true}, 
								function(err, result){
			if (err) {
				console.log('Result: ', err);
				res.sendStatus(400);
				connection.close();
			} else {
				sess.subs[sess.subs.length] = Number(req.body.board_id);
				res.redirect('http://127.0.0.1:8080/boards');
				connection.close();
			}
		});
		
	} catch(err){
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

app.post("/unSub", async function (req, res) {
	console.log("Body: ", req.body);

	let connection;
	var mypw = "dbsw20";
	
	try{
		connection = await oracledb.getConnection( {
			user          : "w20bif3_if20b185",
			password      : mypw,
			connectString : "infdb.technikum-wien.at:1521/o10"
		});
	
		var st = "delete from \"subscription\" where \"user_id\" = " + sess.uid + " and \"board_id\" = " + req.body.board_id;
		
		await connection.execute(st,
								[], {autoCommit: true}, 
								function(err, result){
			if (err) {
				console.log('Result: ', err);
				res.sendStatus(400);
				connection.close();
			} else {
				for(var i = 0; i < sess.subs.length; i++)
					if(sess.subs[i] == Number(req.body.board_id))
						sess.subs[i] = -1;
					
				res.redirect('http://127.0.0.1:8080/boards');
				connection.close();
			}
		});
		
	} catch(err){
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

app.get("/notifications", async function (req, res) {
	let connection;
	var mypw = "dbsw20";
	var pwd = null;
	
	try{
		connection = await oracledb.getConnection( {
			user          : "w20bif3_if20b185",
			password      : mypw,
			connectString : "infdb.technikum-wien.at:1521/o10"
		});

		await connection.execute("select * from \"notification\" where \"user_id\" = :id", [sess.uid], function(err, result){
			if (err) {
				console.log('Result: ', err);
				res.sendStatus(400);
				connection.close();
			} else {
				console.log('Result: ', result);
				if(loggedIn)
					res.render("notifications", { data: { loggedIn: true, menu: menuLoggedIn, uid: sess.uid, notifications: result}})
				connection.close();
			}
		});
		
	} catch(err){
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

app.post("/delNote", async function (req, res) {
	console.log("Body: ", req.body);

	let connection;
	var mypw = "dbsw20";
	
	try{
		connection = await oracledb.getConnection( {
			user          : "w20bif3_if20b185",
			password      : mypw,
			connectString : "infdb.technikum-wien.at:1521/o10"
		});
	
		var st = "delete from \"notification\" where \"user_id\" = " + sess.uid;
		
		await connection.execute(st,
								[], {autoCommit: true}, 
								function(err, result){
			if (err) {
				console.log('Result: ', err);
				res.sendStatus(400);
				connection.close();
			} else {
				res.redirect('http://127.0.0.1:8080/notifications');
				connection.close();
			}
		});
		
	} catch(err){
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

app.listen(port, () => console.log(`Example app listening on port ${port}`));

const menuLoggedIn = [
	{ name: "homepage", href: "/" },
	{ name: "profile", href: "/profile" },
	{ name: "browse", href: "/browse" },
	{ name: "boards", href: "/boards" },
	{ name: "notifications", href: "/notifications" },
];

const menuNotLoggedIn = [
	{ name: "homepage", href: "/" },
	{ name: "login", href: "/login" },
	{ name: "register", href: "/register" },
];

const menu = loggedIn ? menuLoggedIn : menuNotLoggedIn;