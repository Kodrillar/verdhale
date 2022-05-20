const express = require("express");
const router = express.Router();
const asyncErrorHandler = require("../../middleware/async_error_handler");
const client =  require("../../start/database")();
const {jsonwebtoken} = require("../../utils/web_token")



router.post("/", asyncErrorHandler(async(req, res)=>{
    
    if(!req.body.email || !req.body.password) return res.status(400).send("Request body can't be empty");
    const {email, password} = req.body;

    const findUserQuery = "SELECT * FROM users_by_email WHERE email=?";
    let user = await(await client).execute(findUserQuery, [email]);
    
    if(!user.rowLength) return res.status(404).json({"userAlreadyExist":false, "msg":"User not found!"});
    if(user.first().password !== password) return res.status(400)
        .json({ 
            "wrongPassword":true,
            "userAlreadyExist":true,
            "msg":"Wrong/Invalid password"
        });
    
        const webToken = jsonwebtoken(email, user.first().fullname);

    res.header("x-auth-token", webToken)
    .json({
        "userAlreadyExist":true,
        "msg":"success",
        "token": webToken, 
        "wrongPassword":"false"
        });

    

}))





module.exports = router;