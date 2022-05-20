const express = require("express");
const router = express.Router();
const client = require("../start/database")();
const asyncErrorHandler = require("../middleware/async_error_handler");
const auth = require("../middleware/auth");




router.post("/", auth, asyncErrorHandler(async(req, res)=>{

    const {email} = req.user;
    if(!req.body.aid || !req.body.date || !req.body.time) return res.status(400).json({"msg": "aid, date and time is required"});
    const {aid, date, time} = req.body;
    const addAppointmentQuery = "INSERT INTO appointments_by_user(email, id, aid, date, time) VALUES(?, now(), ?, ? , ? )";
    const addAppointment = await(await client).execute(addAppointmentQuery, [email, aid, date, time]);
    res.json({"msg":"success"});


}));

router.get("/", auth, asyncErrorHandler(async(req, res)=>{
    
    const {email} =  req.user;
    const getAppointmentQuery = "SELECT email, aid, date, time FROM appointments_by_user WHERE email = ?";
    const getAppointment = await (await client).execute(getAppointmentQuery, [email]);
    if(!getAppointment.rowLength) return res.status(404).json({"msg":"appointment not found"});
    res.send(getAppointment.rows);
}));

router.delete("/remove", auth, asyncErrorHandler(async(req, res)=>{
    
    const {email} = req.user;
    if(!req.body.id) return res.status(400).json({"msg":"id is required"});
    const {id} = req.body; //consider req.query
    const deleteAppointmentQuery = "DELETE FROM appointments_by_user WHERE email = ? AND id = ?";
    const deleteAppointment = await (await client).execute(deleteAppointmentQuery, [email, id]);
    res.json({"msg":"success"});
}))

module.exports = router;

