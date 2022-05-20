const express = require("express");
const router = express.Router();
const stripeDev = require("stripe")(process.env.STRIPE_KEY);

router.get("/payment", async(req, res)=>{

    //test stripe intent
    const paymentIntent = await stripeDev.paymentIntent.create({
        amount:req.body.amount,
        currency:req.body.currency,
    });
    if(!paymentIntent) return res.json({"msg":"Invalid transaction"});
    res.json({
        "paymentIntent": paymentIntent.client_secret,
        "paymentIntentData":paymentIntent,
        "amount":req.body.amount,
        "currency":req.body.currency,
    })
})

module.exports = router;