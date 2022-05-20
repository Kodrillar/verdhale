const express = require("express");
const router = express.Router();
const asyncErrorHandler = require("../middleware/async_error_handler");
const client = require("../start/database")();


router.get("/", asyncErrorHandler(async(req, res)=>{


        const {country} = req.query 
        const getFreeServiceQuery = "SELECT * FROM freeservices_by_country  WHERE country = ?"
        const getFreeService = await (await client).execute(getFreeServiceQuery ,[country]);
        if(!getFreeService) return res.status(404).json({"msg":"service not found"});
        res.send(getFreeService.rows);

}))

router.post("/", asyncErrorHandler(async(req, res)=>{
        
        if(!req.body.image || !req.body.url || !req.body.country) return res.status(400).json({"msg": "image, url and country is required"});
        const {image, country, url} = req.body;
        const addFreeServiceQuery = "INSERT INTO freeservices_by_country(id, image, url, country) VALUES(now(), ?, ?, ?)";
        const addFreeService = await (await client).execute(addFreeServiceQuery, [image, url, country]);
        res.json({"msg":"success"});
}))

module.exports = router;