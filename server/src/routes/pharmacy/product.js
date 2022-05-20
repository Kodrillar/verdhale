const express = require("express");
const router = express.Router();
const client = require("../../start/database")()
const auth = require("../../middleware/auth")
const asyncErrorHandler =require("../../middleware/async_error_handler");
const imgurClient = require("../../utils/imgur_client");



router.get("/:category", auth, asyncErrorHandler(async(req, res)=>{

   
    const {category} = req.params;

    const query = "SELECT * FROM products_by_category WHERE category = ?";
    let pharmacyProducts = await (await client).execute(query, [category]);
    if(!pharmacyProducts.rowLength) return res.status(404).json({"msg":"pharmacy product not found"});
    res.send(pharmacyProducts.rows);
}));

router.post('/', asyncErrorHandler(async(req, res)=>{
   
    const {name, category,price,description} = req.body;

    if(!name || !category || !price || !description ) return res.status(400).json({"msg":"name, category, price and description are required"});

    const addProductQuery = "INSERT INTO products_by_category(id, name, category, image, price, description) VALUES(now(), ?,?,?,?,?)";
    const addProduct = await(await client).execute(addProductQuery, [ name, category, "image", price, description]);
    res.json({"msg":"success"});
}));

router.patch("/:category",  asyncErrorHandler(async(req, res)=>{
    
    
    const {category} = req.params;
    const getProductQuery = "SELECT * FROM products_by_category WHERE category = ?" ;
    const getProduct = await(await client).execute(getProductQuery, [category]);
    if(!getProduct.rowLength) return res.status(404).json({"msg":"product not found"});
    const productId = getProduct.first().id;

    const uploadImage =  await imgurClient.upload({
        image: req.files.image.data,
        type: "stream"
    });

    const imagePath = uploadImage.data.link;

    const updateProductQuery = "UPDATE products_by_category SET image= ? WHERE category = ? and id = ?";
    const updateProduct = await(await client).execute(updateProductQuery,[imagePath, category, productId ]);
    
    res.send({"msg":"success"});
   

}))


module.exports = router;