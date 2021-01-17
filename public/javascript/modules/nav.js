const burger = document.getElementById("burger");
const menu = document.getElementById("menu");
const closebtn = document.getElementById("closebtn");

burger.addEventListener("click", (e) => {
	menu.style.width = "25vw";
	menu.style.padding = "2rem";
});

closebtn.addEventListener("click", (e) => {
	menu.style.width = "0";
	menu.style.padding = "";
});
