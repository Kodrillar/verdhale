const express = require("express");
const router = express.Router();
const client = require("../start/database")();
const asyncErrorHandler = require("../middleware/async_error_handler");
const auth = require("../middleware/auth");


router.get("/me", auth, asyncErrorHandler(async(req, res)=>{

    const {email} = req.user;
    const getUserQuery = "SELECT email, image, fullname FROM users_by_email WHERE email = ?";
    const getCurrentUser = await (await client).execute(getUserQuery, [email]);
    if(!getCurrentUser.rowLength) return res.status(404)
        .json({
            "msg":"User does not exist"
        });
    res.send(getCurrentUser.first());
}));


module.exports = router;
