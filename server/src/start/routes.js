const express = require("express");
const temp = require("../routes/temp_route");
const error = require("../middleware/error_handler");
const logIn = require("../routes/auth/log_in");
const signUp = require("../routes/auth/sign_up");
const freeservice = require("../routes/free_service");
const user = require("../routes/user");
const appointment = require("../routes/appointment");
const product = require("../routes/pharmacy/product");
const vaccination = require("../routes/vaccination/vaccination");


module.exports = function(app){

    app.use(express.json());
    app.use("/api/uploads", express.static("uploads"))
    app.use(temp);
    app.use("/api/user/auth", logIn);
    app.use("/api/user/signUp", signUp)
    app.use("/api/freeservice", freeservice);
    app.use("/api/user", user);
    app.use("/api/appointment", appointment);
    app.use("/api/pharmacy/products" , product);
    app.use("/api/vaccination", vaccination);
    app.use(error);
}