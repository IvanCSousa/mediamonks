//import express
const express = require("express");
//port expose app 3000
const PORT = 3000;
//instancia do express
const app = express();
//utilizando html
app.set('view engine','ejs');
//carregando css e imagens
app.use(express.static('public'));
var path = require('path');
//return route / (retorno da rota principal)
app.get('/', function(req, res) {
    res.render("../views/home")
});
app.listen(PORT, function(){
    console.log("App rodando na porta 3000!")
});