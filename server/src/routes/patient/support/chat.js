const express = require("express");
const router = express.Router();
const asyncErrorHandler = require("../../../middleware/async_error_handler");
const client = require("../../../start/database")();
const auth = require("../../../middleware/auth");


router.post("/", auth, asyncErrorHandler(async(req, res)=>{

    const from_patient = req.user;
    const {to_doctor, chat_body} = req.body;
    const addChatQuery = "INSERT INTO support_chat(chat_id, from_patient, to_doctor, chat_body, created_at) VALUES(uuid(), ?,?,?, now())";
    const addChat = await(await client).execute(addChatQuery,[from_patient, to_doctor, chat_body]);
    res.json({"msg":"success"});
}))

router.get("/", auth, asyncErrorHandler(async(req, res)=>{

    const from_patient = req.user;
    const {to_doctor} = req.query;
    const getChatQuery = "SELECT * FROM support_chat WHERE from_patient= ? AND to_doctor = ? ORDER BY created_at DESC";
    const getChat = await(await client).execute(getChatQuery,[from_patient, to_doctor]);
    if(!getChat.rowLength) return res.status(404).json({"msg":"chat not found"});
    res.send(getChat.rows);
}))


module.exports = router;