const express = require('express');
const router = express.Router();

const db = require('../database');           // Se importa la conexion de la base de datos
const { Logueado } = require('../lib/auth'); // Se importan las funciones para saber si el usuario esta logueado


//Lista de profesores (GET).
router.get('/', Logueado, async (req, res) => {
    const profesores = await db.query('SELECT * FROM profesoresypersonal');
    res.render('profesores/list',{profesores});
});

//Metodo para representar la vista de agregar profesor/personal (GET).
router.get('/add', Logueado, (req, res) => {
    res.render('profesores/add');
});

//Metodo para Registrar un nuevo profesor/personal.
router.post('/add', Logueado,  async (req, res) => {
    const {  noEmpleado, nombre, apellidos, unidad, division, edad, email, telefono, clave, huella } = req.body;
    const newProfesor = {
        noEmpleado,
        nombre,
        apellidos,
        unidad,
        division,
        edad,
        email,
        telefono,
        clave,
        huella
    };

    try {
        await db.query('INSERT INTO profesoresypersonal set ?',[newProfesor]);
        req.flash('success','Profeso/Personal registrado correctamente');
        res.redirect('/profesores');
    } catch (err) {
       if (err.code === 'ER_DUP_ENTRY') {
            req.flash('success','No de empleado existente');
            res.redirect('/profesores');
       } else {
            req.flash('success','ERROR DESCONOCIDO');
            res.redirect('/profesores');
        }
    }
   
});

//Metodo para representar la vista de editar profesor/personal (GET).
router.get('/edit/:id', Logueado, async (req, res) => {
    const { id } = req.params;
    const profesores = await db.query('SELECT * FROM profesoresypersonal WHERE id = ?',[id]);
    res.render('profesores/edit',{profesor :profesores[0]});
 });

 //Metodo para editar un profesor.
 router.post('/edit/:id', Logueado, async (req, res) => {
    const { id } = req.params;
    const {  noEmpleado, nombre, apellidos, unidad, division, edad, email, telefono, clave, huella } = req.body;

    try {
        await db.query('UPDATE profesoresypersonal SET noEmpleado = ?,  nombre = ?,  apellidos = ?,  unidad = ?,  division = ?, edad = ?,  email = ?,  telefono = ?,  clave = ?, huella = ? WHERE id = ? ',[noEmpleado,nombre,apellidos,unidad,division,edad,email,telefono,clave,huella,id]);
        req.flash('success','Profesor actualizado');
        res.redirect('/profesores');
        
    } catch (err) {
       if (err.code === 'ER_DUP_ENTRY') {
            req.flash('success','No de empleado existente');
            res.redirect('/profesores');
       } else {
            req.flash('success','ERROR DESCONOCIDO');
            res.redirect('/profesores');
        }
    }
});

 //Metodo para eliminar un profesor/personal.
router.get('/delete/:id', Logueado, async (req, res) => {
   const { id } = req.params;
   await db.query('DELETE FROM profesoresypersonal WHERE id = ?',[id]);
   req.flash('success','Profesor/Personal eliminado');
   res.redirect('/profesores');
});

module.exports = router;