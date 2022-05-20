const express = require("express");
const app = express();
const cors = require("cors");
const fileUpload = require("express-fileupload");


app.use(cors());
app.use(fileUpload());
require("dotenv").config();
require("./start/logger")();
require("./start/routes")(app);


const port = process.env.PORT || 3000;
const server = app.listen(port, ()=>{
    console.log(`listening on port ${port}`);
})