//Rutas principales de nuestra aplicacion ,Acerca de , contacto  etc.

//Router = al ajecutarse se vuelve un objeto que almaceno en router
const express = require('express');
const router = express.Router();

router.get('/', (req,res) => {
    res.render('index');
});

module.exports = router;