const express = require("express");
const app = express();
const port = 8080;
const path = require("path");
const fileUpload = require("express-fileupload");

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

let loggedIn = false;

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

app.post("/login", (req, res) => {
	console.log(req.body);
	res.redirect("/");
});

app.post("/register", (req, res) => {
	console.log(req.body);
	res.redirect("/");
});

app.post("/upload", (req, res) => {
	console.log(req.files);
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
	{ name: "register", href: "register" },
];

const menu = loggedIn ? menuLoggedIn : menuNotLoggedIn;
