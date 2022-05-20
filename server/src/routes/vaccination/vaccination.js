const express = require("express");
const router = express.Router();
const asyncErrorHandler = require("../../middleware/async_error_handler");
const client = require("../../start/database")();
const auth = require("../../middleware/auth");



router.post("/", auth, asyncErrorHandler(async(req, res)=>{

    const {email} = req.user;
    if(!req.body.hospital || !req.body.date || !req.body.time || req.body.location) return res.status(400).json({"msg": "hospital,location, date and time is required"});
    const {hospital,location ,date, time} = req.body;
    const addVaccinationQuery = "INSERT INTO vaccination_by_user(email, hospital, location, date, time) VALUES(?, now(), ?, ? , ? )";
    const addVaccination = await(await client).execute(addVaccinationQuery, [email, hospital, location, date, time]);
    res.json({"msg":"success"});


}));

router.get("/", auth, asyncErrorHandler(async(req, res)=>{
    
    const {email} =  req.user;
    const getVaccinationQuery = "SELECT email, hospital, location, date, time FROM vaccination_by_user WHERE email = ?";
    const getVaccination = await (await client).execute(getVaccinationQuery, [email]);
    if(!getVaccination.rowLength) return res.status(404).json({"msg":"vaccination not found"});
    res.send(getVaccination.rows);
}));

module.exports = router;