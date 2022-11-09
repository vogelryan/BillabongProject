using Genie

greet() = "Welcome to Genie!"

route("/hi", greet)          # [GET] /greet => greet

up()