const express = require("express");
const app = express();
const port = 8080;
const path = require("path");
const fileUpload = require("express-fileupload");
const { v4: uuidv4 } = require("uuid");
const oracledb = require('oracledb');

oracledb.outFormat = oracledb.OUT_FORMAT_OBJECT;

app.set("view engine", "ejs");
app.set("views", "./views");

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

let loggedIn = true;

app.get("/", (req, res) =>
	!loggedIn
		? res.render("index", { data: { menu: menu } })
		: res.render("homepage", {
				data: {
					username: "taha",
					profile_pic: "images/cat.png",
					menu: menu,
					loggedIn: loggedIn,
				},
		  })
);
app.get("/browse", (req, res) =>
	res.render("homepage", { data: { loggedIn: false, menu: menuNotLoggedIn } })
);
app.get("/login", (req, res) => res.render("login", { data: { menu: menu } }));
app.get("/register", (req, res) =>
	res.render("register", { data: { menu: menu } })
);

app.post('/login', async function (req, res) {
	let connection;
	var pwd = null;
	
	try{
		connection = await oracledb.getConnection( {
			user          : "hr",
			password      : mypw,
			connectString : "localhost/XEPDB1"
		});

		var result = await connection.execute("select id, password_hash from user where username = :un", [req.body.username]);
		pwd = result.rows[0]["password_hash"];
		
		password(req.body.password).verifyAgainst(pwd, function(error, verified) {
            if(error)
                console.log(error);
            if(!verified) {
                res.sendStatus(401);
            } else {
				var uid = result.rows[0]["id"];
				
				await connection.execute("insert into session values(0, CURRENT_TIMESTAMP, DATE_ADD(CURRENT_TIMESTAMP, INTERVAL 1 DAY), :id)", [uid]);
                res.sendStatus(200);
            }
        });
		
	} catch(err){
		console.error(err);
	} finally {
		if (connection) {
			try {
				await connection.close();
			} catch (err) {
				console.error(err);
			}
		}
	}
});

app.post("/register", async function (req, res) {
	let connection;
	var pwd = null;
	
	try{
		connection = await oracledb.getConnection( {
			user          : "hr",
			password      : mypw,
			connectString : "localhost/XEPDB1"
		});
		
		res.set('Content-Type', 'text/html');
		
		password(req.body.psw).hash(function(error, hash) {
			if(error)
				throw new Error('Something went wrong!');

			pwd = hash;
			
			await connection.execute("insert into user" + 
									"values" + 
									"(0, :fn, :ln, :un, :pw, :em), :id)", 
									[req.body.first_name, req.body.last_name, req.body.username, pwd, req.body.email], 
									function(err, result){
										if (err) {
											res.sendStatus(400);
										} else{
											res.sendStatus(200);
										}
									});    
		});
		
		res.redirect('http://127.0.0.1/home);
		
	} catch(err){
		console.error(err);
	} finally {
		if (connection) {
			try {
				await connection.close();
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

app.listen(port, () => console.log(`Example app listening on port ${port}`));

const menuLoggedIn = [
	{ name: "profile", href: "/profile" },
	{ name: "homepage", href: "/" },
];

const menuNotLoggedIn = [
	{ name: "homepage", href: "/" },
	{ name: "login", href: "/login" },
	{ name: "register", href: "/register" },
];

const menu = loggedIn ? menuLoggedIn : menuNotLoggedIn;
