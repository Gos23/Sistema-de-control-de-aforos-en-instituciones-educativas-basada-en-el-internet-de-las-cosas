const express = require('express');
const router = express.Router();

const db = require('../database');           // Se importa la conexion de la base de datos
const { Logueado } = require('../lib/auth'); // Se importan las funciones para saber si el usuario esta logueado


//Lista de alumnos (GET).
router.get('/', Logueado, async (req, res) => {
    const alumnos = await db.query('SELECT * FROM alumnos');
    res.render('alumnos/list',{alumnos});
});

//Metodo para representar la vista de agregar Laboratorios (GET).
router.get('/add', Logueado, (req, res) => {
    res.render('alumnos/add');
});

//Metodo para Registrar un Nuevo alumno.
router.post('/add', Logueado,  async (req, res) => {
    const {  matricula, nombre, apellidos, unidad, division, planEstudio, edad, email, telefono, RFID } = req.body;
    const newAlumno = {
        matricula,
        nombre,
        apellidos,
        unidad,
        division,
        planEstudio,
        edad,
        email,
        telefono,
        RFID
    };
    
    try {
        await db.query('INSERT INTO alumnos set ?',[newAlumno]);
        req.flash('success','Alumno registrado correctamente');
        res.redirect('/alumnos');
        
    } catch (err) {
       if (err.code === 'ER_DUP_ENTRY') {
            req.flash('success','Matricula existente');
            res.redirect('/alumnos');  
       } else {
            req.flash('success','ERROR DESCONOCIDO');
            res.redirect('/alumnos');  
        }
    }
});

//Metodo para representar la vista de editar alumnos (GET).
router.get('/edit/:id', Logueado, async (req, res) => {
    const { id } = req.params;
    const alumnos = await db.query('SELECT * FROM alumnos WHERE id = ?',[id]);
    res.render('alumnos/edit',{alumno :alumnos[0]});
 });

 //Metodo para editar un alumno.
 router.post('/edit/:id', Logueado, async (req, res) => {
    const { id } = req.params;
    const {  matricula, nombre, apellidos, unidad, division, planEstudio, edad, email, telefono, RFID } = req.body;
    try {
        await db.query('UPDATE alumnos SET matricula = ?,  nombre = ?,  apellidos = ?,  unidad = ?,  division = ?,  planEstudio = ?,  edad = ?,  email = ?,  telefono = ?,  RFID = ? WHERE id = ? ',[matricula,nombre,apellidos,unidad,division,planEstudio,edad,email,telefono,RFID,id]);
        req.flash('success','Alumno actualizado');
        res.redirect('/alumnos');    
    } catch (err) {
       if (err.code === 'ER_DUP_ENTRY') {
            req.flash('success','Matricula existente');
            res.redirect('/alumnos'); 
       } else {
            req.flash('success','ERROR DESCONOCIDO');
            res.redirect('/alumnos'); 
        }
    }
});

 //Metodo para eliminar un alumno.
router.get('/delete/:id', Logueado, async (req, res) => {
   const { id } = req.params;
   await db.query('DELETE FROM alumnos WHERE id = ?',[id]);
   req.flash('success','Alumno eliminado');
   res.redirect('/alumnos');
});

module.exports = router;