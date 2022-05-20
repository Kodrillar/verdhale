const express = require("express");
const router = express.Router();

router.get("/", (req, res)=>{

    res.json({"msg":"Welcome to Verdhale API"})
})

module.exports = router;