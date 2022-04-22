const express = require('express');
const router = express.Router();

const db = require('../database');           // Se importa la conexion de la base de datos
const { Logueado } = require('../lib/auth'); // Se importan las funciones para saber si el usuario esta logueado



//Lista de administradores (GET).
router.get('/', Logueado, async (req, res) => {
    const users = await db.query('SELECT * FROM users');

    res.render('administradores/list',{users});
});


//Metodo para representar la vista de editar Administradores (GET).
router.get('/edit/:id', Logueado, async (req, res) => {
    const { id } = req.params;
    const users = await db.query('SELECT * FROM users WHERE id = ?',[id]);
    res.render('administradores/edit',{user :users[0]});
 });

 //Metodo para editar un Administrador.
 router.post('/edit/:id', Logueado, async (req, res) => {
    const { id } = req.params;
    const {  username, fullname } = req.body;
    try {
        await db.query('UPDATE users SET username = ?,  fullname = ? WHERE id = ? ',[username, fullname,id]);
        req.flash('success','Administrador actualizado');
        res.redirect('/administradores');    
    } catch (err) {
        req.flash('success','ERROR DESCONOCIDO');
        res.redirect('/administradores');    
    }
});

 //Metodo para eliminar un Administrador.
router.get('/delete/:id', Logueado, async (req, res) => {
   const { id } = req.params;
   await db.query('DELETE FROM users WHERE id = ?',[id]);
   req.flash('success','Administrador eliminado');
   res.redirect('/administradores');   
});

// Historial (GET).
router.get('/historial', Logueado, async (req, res) => {
    res.render('administradores/historial');
});

//Metodo para eliminar HAE.
router.post('/delete/HAE', Logueado, async (req, res) => {
    await db.query('DELETE FROM registroentradaalumnoshistorial');
    req.flash('success','Historial de entrada alumnos eliminado! ');
    res.redirect('/administradores/historial');
 });

//Metodo para eliminar HAS.
router.post('/delete/HAS', Logueado, async (req, res) => {
    await db.query('DELETE FROM registrosalidaalumnoshistorial');
   req.flash('success','Historial de salida alumnos eliminado! ');
   res.redirect('/administradores/historial');
});

//Metodo para eliminar HPE.
 router.post('/delete/HPE', Logueado, async (req, res) => {
    await db.query('DELETE FROM registroentradaprofesoresypersonalhistorial');
   req.flash('success','Historial de entrada profesores y personal eliminado! ');
   res.redirect('/administradores/historial');
});

//Metodo para eliminar HSE.
router.post('/delete/HPS', Logueado, async (req, res) => {
    await db.query('DELETE FROM registrosalidaprofesoresypersonalhistorial');
   req.flash('success','Historial de salida profesores y personal eliminado! ');
   res.redirect('/administradores/historial');
});

//Metodo para eliminar TA.
router.post('/delete/TA', Logueado, async (req, res) => {
    await db.query('DELETE FROM temperaturaaltaalumnos');
   req.flash('success','Historial de temperaturas altas (Alumnos) eliminado! ');
   res.redirect('/administradores/historial');
});

//Metodo para eliminar TP.
router.post('/delete/TP', Logueado, async (req, res) => {
    await db.query('DELETE FROM temperaturaaltaprofesoresypersonal');
   req.flash('success','Historial de temperaturas altas (Profesores y Personal) eliminado! ');
   res.redirect('/administradores/historial');
});


module.exports = router;