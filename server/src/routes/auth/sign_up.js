const express = require("express");
const router = express.Router();
const client = require("../../start/database")();
const {jsonwebtoken} = require("../../utils/web_token")
const asyncErrorHandler = require("../../middleware/async_error_handler");
const imgurClient = require("../../utils/imgur_client");
const auth = require("../../middleware/auth");



router.post("/", asyncErrorHandler( async (req, res)=>{

    const {email, fullname, password} = req.body;

    const findUserQuery = "SELECT email FROM users_by_email WHERE email= ?";
    let user = await (await client).execute(findUserQuery, [email]); 
    if(user.rowLength) return res.status(400)
        .json({
            "userAlreadyExist":true, 
            "msg":"User already exist!"
        });
   
    const registerUserQuery = "INSERT INTO users_by_email (email, fullname, password, image, id) VALUES(?, ?, ?, ?, now())";
    user = await (await client).execute(registerUserQuery, [email, fullname,  password, "image"]);
    const webToken = jsonwebtoken(email, fullname);

    res.send({
        "userAlreadyExist":false,
         "token":webToken,
          msg:"success"
        });
   
}))

router.patch("/upload/profileImage", auth,  asyncErrorHandler(async(req, res)=>{
    

    const {email } = req.user;
    const getUserQuery = "SELECT * FROM users_by_email WHERE email = ?" ;
    const getUser = await(await client).execute(getUserQuery, [email]);
    if(!getUser.rowLength) return res.status(404).json({"msg":"User not found"});
    const userId = getUser.first().id;

    const uploadImage =  await imgurClient.upload({
        image: req.files.image.data,
        type: "stream"
    });

    const imagePath = uploadImage.data.link;

    const updateUserQuery = "UPDATE users_by_email SET image= ? WHERE email = ? and id = ?";
    const updateUser = await(await client).execute(updateUserQuery,[imagePath, email, userId ]);
    
    res.send({"msg":"success"});
   

}))




module.exports = router;