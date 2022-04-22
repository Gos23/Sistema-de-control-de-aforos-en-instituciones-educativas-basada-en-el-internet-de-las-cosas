const express = require('express');
const router = express.Router();

const db = require('../database');           // Se importa la conexion de la base de datos
const { Logueado } = require('../lib/auth'); // Se importan las funciones para saber si el usuario esta logueado


//Lista de laboratorios y Aulas compartidas (GET).
router.get('/', Logueado, async (req, res) => {
    const LabyAula = await db.query('SELECT * FROM laboratoriosyaulas');
    res.render('laboratorios/list',{LabyAula});
});

//Metodo para representar la vista de agregar Laboratorios (GET).
router.get('/add', Logueado, (req, res) => {
    res.render('laboratorios/add');
});

//Metodo para Registrar un Nuevo Laboratorio o Aula.
router.post('/add', Logueado,  async (req, res) => {
    const { nombre , url } = req.body;
    const newLaboratorio = {
        nombre,
        aforoPermitido : 0 ,
        aforoActual : 0 ,
        estadoPuerta : "cerrado" ,
        LecturaTemperatura : "false" ,
        notificaciones : "false" ,
        profesorAdentro : "false" ,
        noEmpleado : " " ,
        nombrePro : " " ,
        url 
    };
    await db.query('INSERT INTO laboratoriosyaulas set ?',[newLaboratorio]);
    req.flash('success','Laboratorio registrado correctamente');
    res.redirect('/laboratorios');
});

//Metodo para representar la vista de editar Laboratorios (GET).
router.get('/edit/:id', Logueado, async (req, res) => {
    const { id } = req.params;
    const laboratorios = await db.query('SELECT * FROM laboratoriosyaulas WHERE id = ?',[id]);
    res.render('laboratorios/edit',{laboratorio :laboratorios[0]});
 });

 //Metodo para editar un Laboratorio o Aula.
 router.post('/edit/:id', Logueado, async (req, res) => {
    const { id } = req.params;
    const { nombre , url } = req.body;
    await db.query('UPDATE laboratoriosyaulas SET nombre = ? , url = ? WHERE id = ? ',[nombre, url, id]);
    req.flash('success','Laboratorio/Aula actualizado');
    res.redirect('/laboratorios');
});

 //Metodo para eliminar un Laboratorio o Aula.
router.get('/delete/:id', Logueado, async (req, res) => {
   const { id } = req.params;
   await db.query('DELETE FROM laboratoriosyaulas WHERE id = ?',[id]);
   req.flash('success','LAboratorio/Aula eliminada');
   res.redirect('/laboratorios');
});

//Metodo para representar la vista de DashLaboratorios Alumnos (GET).
router.get('/dashAlumnos/:id', Logueado, async (req, res) => {
    const { id } = req.params;
    const laboratorio  = await db.query('SELECT * FROM laboratoriosyaulas WHERE id = ?',[id]);
    const datosEntrada = await db.query('SELECT * FROM registroentradaalumnoshistorial WHERE area = ?',[laboratorio[0].nombre]);
    const datosSalida  = await db.query('SELECT * FROM registrosalidaalumnoshistorial WHERE area = ?',[laboratorio[0].nombre]);
    

    /////// INFORMACION PARA GRAFICAR DE DIAS ///////
    // X = 31 Dias.
    // Enero       -->  1  X
    // Febreo      -->  2  --
    // Marzo       -->  3  X
    // Abril       -->  4
    // Mayo        -->  5  X
    // Junio       -->  6
    // Julio       -->  7  X
    // Agosto      -->  8  X 
    // Septiembre  -->  9  
    // Octubre     --> 10  X
    // Nobiembre   --> 11  
    // Diciembre   --> 12  X

    let fecha = new Date();
    let hoy = fecha.getDate();
    let mesActual = fecha.getMonth() + 1; 
    let year = fecha.getFullYear();

    //Fecha opcional para prubebas , cuando no se necesite se comenta.
    //year = 2022;
    //mesActual = 3;
    //hoy = 25;
    let CincoDias = [ 1 , 2 , 3 , 4 , 5 ];
    let morning = "";

    function Dias() {
        let temp = hoy;
        for (let i = 0; i < 5; i++) {
            if(temp > 0 ){
                CincoDias[i] = temp;
                temp -= 1 ;
            }else if(mesActual == 1 ) { // Si es enero
                temp = 31;
                year -= 1;
                CincoDias[i] = temp;
                temp -= 1 ;
                mesActual = 12 ;
            } else if ((mesActual - 1) == 2 ) {
                if(esBisiesto(year) ){
                    temp = 29;
                    CincoDias[i] = temp;
                    temp -= 1 ;
                    mesActual -= 1 ;
                } else {
                    temp = 28;
                    CincoDias[i] = temp;
                    temp -= 1 ;
                    mesActual -= 1 ;
                }
            } else if ( mesActual == 3 || mesActual == 5 || mesActual == 7 || mesActual == 8 || mesActual == 10 || mesActual == 12){
                temp = 30;
                CincoDias[i] = temp;
                temp -= 1 ;
                mesActual -= 1 ;
            } else {
                temp = 31;
                CincoDias[i] = temp;
                temp -= 1 ;
                mesActual -= 1 ;
            }
        
            CincoDias[i] = year + "-" + mesActual + "-" + CincoDias[i];
        }
    }

    function DiasB() {
        let temp = hoy;
        
        if((temp == 28 || temp == 29) && mesActual == 2 ){
            if(temp == 29){
                temp = 1;
                morning = temp;
                temp += 1 ;
                mesActual += 1 ;
            } else if(esBisiesto(year)){
                temp = 29;
                morning = temp;
                temp = +1 ;
                mesActual = 2 ;
            } else {
                temp = 1;
                morning = temp;
                temp = +1 ;
                mesActual += 1 ;
            }
        }else if(temp == 31 && mesActual == 12 ) { // Si es enero
            temp = 1;
            year += 1;
            morning = temp;
            temp += 1 ;
            mesActual = 1 ;
        
        } else if ( (mesActual == 1 || mesActual == 3 || mesActual == 3 || mesActual == 5 || mesActual == 7 || mesActual == 8 || mesActual == 10) && temp == 31 ){
            temp = 1;
            morning = temp;
            temp += 1 ;
            mesActual += 1 ;
        }else if ( (mesActual == 4 || mesActual == 6 || mesActual == 9 || mesActual == 11 ) && temp == 30 ) {
            temp = 1;
            morning = temp;
            temp += 1 ;
            mesActual += 1 ;
        
        } else {
            temp += 1 ;
            morning = temp;
        }
    
        morning = year + "-" + mesActual + "-" + morning;
    }
    
   

    function esBisiesto (year)  {
    return (year % 400 === 0) ? true : 
           (year % 100 === 0) ? false : 
            year % 4 === 0;
    }


    Dias();
    DiasB();
    // console.log(  CincoDias[0] + "---------------"  + morning);
    // console.log(  CincoDias[1] + "---------------"  + CincoDias[0]);
    // console.log(  CincoDias[2] + "---------------"  + CincoDias[1]);
    // console.log(  CincoDias[3] + "---------------"  + CincoDias[2]);
    // console.log(  CincoDias[4] + "---------------"  + CincoDias[3]);
    
    let dias = [ 1 , 2 , 3 , 4 , 5 ];

    let cuantos = await db.query('SELECT COUNT(*) as total FROM registroentradaalumnoshistorial WHERE area = ? AND fecha >= ? AND fecha < ? ', [laboratorio[0].nombre,CincoDias[0],morning]);
    dias[0] = cuantos[0].total;

    for (let i = 1 ; i < 5 ; i++){
        let cuantos = await db.query('SELECT COUNT(*) as total FROM registroentradaalumnoshistorial WHERE area = ? AND fecha >= ? AND fecha < ? ', [laboratorio[0].nombre,CincoDias[i],CincoDias[i-1]]);
        dias[i] = cuantos[0].total;
    }
    
    /////////////////////////////////////////

    /////// INFORMACION PARA GRAFICAR DE HORAS ///////
    // Se consultara uy=n total de 9 horas
    let horasCuantos = [ 1 , 2 , 3 , 4 , 5 , 6 , 7 , 8, 9 ];
    let fehaAct  = CincoDias[0] ;
    
    // Consulta 1
    let H1I = fehaAct  + " 07:00:00" ;
    let H1F = fehaAct  + " 08:29:00" ;
    let C1 = await db.query('SELECT COUNT(*) as total FROM registroentradaalumnoshistorial WHERE area = ? AND fecha >= ? AND fecha < ? ', [laboratorio[0].nombre,H1I,H1F]);
    horasCuantos[0] = C1[0].total;
    
    // Consulta 2
    let H2I = fehaAct  + " 08:30:00" ;
    let H2F = fehaAct  + " 09:59:00" ;
    let C2 = await db.query('SELECT COUNT(*) as total FROM registroentradaalumnoshistorial WHERE area = ? AND fecha >= ? AND fecha < ? ', [laboratorio[0].nombre,H2I,H2F]);
    horasCuantos[1] = C2[0].total;

    // Consulta 3
    let H3I = fehaAct  + " 10:00:00" ;
    let H3F = fehaAct  + " 11:29:00" ;
    let C3 = await db.query('SELECT COUNT(*) as total FROM registroentradaalumnoshistorial WHERE area = ? AND fecha >= ? AND fecha < ? ', [laboratorio[0].nombre,H3I,H3F]);
    horasCuantos[2] = C3[0].total;

    // Consulta 4
    let H4I = fehaAct  + " 11:30:00" ;
    let H4F = fehaAct  + " 12:59:00" ;
    let C4 = await db.query('SELECT COUNT(*) as total FROM registroentradaalumnoshistorial WHERE area = ? AND fecha >= ? AND fecha < ? ', [laboratorio[0].nombre,H4I,H4F]);
    horasCuantos[3] = C4[0].total;
    
    // Consulta 5
    let H5I = fehaAct  + " 13:00:00" ;
    let H5F = fehaAct  + " 14:29:00" ;
    let C5 = await db.query('SELECT COUNT(*) as total FROM registroentradaalumnoshistorial WHERE area = ? AND fecha >= ? AND fecha < ? ', [laboratorio[0].nombre,H5I,H5F]);
    horasCuantos[4] = C5[0].total;
    
    // Consulta 6
    let H6I = fehaAct  + " 14:30:00" ;
    let H6F = fehaAct  + " 15:59:00" ;
    let C6 = await db.query('SELECT COUNT(*) as total FROM registroentradaalumnoshistorial WHERE area = ? AND fecha >= ? AND fecha < ? ', [laboratorio[0].nombre,H6I,H6F]);
    horasCuantos[5] = C6[0].total;

    // Consulta 7
    let H7I = fehaAct  + " 16:00:00" ;
    let H7F = fehaAct  + " 17:29:00" ;
    let C7 = await db.query('SELECT COUNT(*) as total FROM registroentradaalumnoshistorial WHERE area = ? AND fecha >= ? AND fecha < ? ', [laboratorio[0].nombre,H7I,H7F]);
    horasCuantos[6] = C7[0].total;

    // Consulta 8
    let H8I = fehaAct  + " 17:30:00" ;
    let H8F = fehaAct  + " 18:59:00" ;
    let C8 = await db.query('SELECT COUNT(*) as total FROM registroentradaalumnoshistorial WHERE area = ? AND fecha >= ? AND fecha < ? ', [laboratorio[0].nombre,H8I,H8F]);
    horasCuantos[7] = C8[0].total;

    // Consulta 9
    let H9I = fehaAct  + " 19:00:00" ;
    let H9F = fehaAct  + " 22:00:00" ;
    let C9 = await db.query('SELECT COUNT(*) as total FROM registroentradaalumnoshistorial WHERE area = ? AND fecha >= ? AND fecha < ? ', [laboratorio[0].nombre,H9I,H9F]);
    horasCuantos[8] = C9[0].total;

    /*console.log(horasCuantos[0]);
    console.log(horasCuantos[1]);
    console.log(horasCuantos[2]);
    console.log(horasCuantos[3]);
    console.log(horasCuantos[4]);
    console.log(horasCuantos[5]);
    console.log(horasCuantos[6]);
    console.log(horasCuantos[7]);
    console.log(horasCuantos[8]);*/

    /////////////////////////////////////////

    res.render('laboratorios/dashAlumnos',{laboratorio , datosSalida, datosEntrada, dias, CincoDias, horasCuantos});
 });

 //Metodo para representar la vista de DashLaboratorios Profesores (GET).
router.get('/dashProfesores/:id', Logueado, async (req, res) => {
    const { id } = req.params;
    const laboratorio  = await db.query('SELECT * FROM laboratoriosyaulas WHERE id = ?',[id]);
    const datosEntrada = await db.query('SELECT * FROM registroentradaprofesoresypersonalhistorial WHERE area = ?',[laboratorio[0].nombre]);
    const datosSalida  = await db.query('SELECT * FROM registrosalidaprofesoresypersonalhistorial WHERE area = ?',[laboratorio[0].nombre]);
    

    /////// INFORMACION PARA GRAFICAR DE DIAS ///////
    // X = 31 Dias.
    // Enero       -->  1  X
    // Febreo      -->  2  --
    // Marzo       -->  3  X
    // Abril       -->  4
    // Mayo        -->  5  X
    // Junio       -->  6
    // Julio       -->  7  X
    // Agosto      -->  8  X 
    // Septiembre  -->  9  
    // Octubre     --> 10  X
    // Nobiembre   --> 11  
    // Diciembre   --> 12  X

    let fecha = new Date();
    let hoy = fecha.getDate();
    let mesActual = fecha.getMonth() + 1; 
    let year = fecha.getFullYear();

    //Fecha opcional para prubebas , cuando no se necesite se comenta.
    //year = 2022;
    //mesActual = 3;
    //hoy = 25;
    let CincoDias = [ 1 , 2 , 3 , 4 , 5 ];
    let morning = "";

    function Dias() {
        let temp = hoy;
        for (let i = 0; i < 5; i++) {
            if(temp > 0 ){
                CincoDias[i] = temp;
                temp -= 1 ;
            }else if(mesActual == 1 ) { // Si es enero
                temp = 31;
                year -= 1;
                CincoDias[i] = temp;
                temp -= 1 ;
                mesActual = 12 ;
            } else if ((mesActual - 1) == 2 ) {
                if(esBisiesto(year) ){
                    temp = 29;
                    CincoDias[i] = temp;
                    temp -= 1 ;
                    mesActual -= 1 ;
                } else {
                    temp = 28;
                    CincoDias[i] = temp;
                    temp -= 1 ;
                    mesActual -= 1 ;
                }
            } else if ( mesActual == 3 || mesActual == 5 || mesActual == 7 || mesActual == 8 || mesActual == 10 || mesActual == 12){
                temp = 30;
                CincoDias[i] = temp;
                temp -= 1 ;
                mesActual -= 1 ;
            } else {
                temp = 31;
                CincoDias[i] = temp;
                temp -= 1 ;
                mesActual -= 1 ;
            }
        
            CincoDias[i] = year + "-" + mesActual + "-" + CincoDias[i];
        }
    }

    function DiasB() {
        let temp = hoy;
        
        if((temp == 28 || temp == 29) && mesActual == 2 ){
            if(temp == 29){
                temp = 1;
                morning = temp;
                temp += 1 ;
                mesActual += 1 ;
            } else if(esBisiesto(year)){
                temp = 29;
                morning = temp;
                temp = +1 ;
                mesActual = 2 ;
            } else {
                temp = 1;
                morning = temp;
                temp = +1 ;
                mesActual += 1 ;
            }
        }else if(temp == 31 && mesActual == 12 ) { // Si es enero
            temp = 1;
            year += 1;
            morning = temp;
            temp += 1 ;
            mesActual = 1 ;
        
        } else if ( (mesActual == 1 || mesActual == 3 || mesActual == 3 || mesActual == 5 || mesActual == 7 || mesActual == 8 || mesActual == 10) && temp == 31 ){
            temp = 1;
            morning = temp;
            temp += 1 ;
            mesActual += 1 ;
        }else if ( (mesActual == 4 || mesActual == 6 || mesActual == 9 || mesActual == 11 ) && temp == 30 ) {
            temp = 1;
            morning = temp;
            temp += 1 ;
            mesActual += 1 ;
        
        } else {
            temp += 1 ;
            morning = temp;
        }
    
        morning = year + "-" + mesActual + "-" + morning;
    }
    
   

    function esBisiesto (year)  {
    return (year % 400 === 0) ? true : 
           (year % 100 === 0) ? false : 
            year % 4 === 0;
    }


    Dias();
    DiasB();
    // console.log(  CincoDias[0] + "---------------"  + morning);
    // console.log(  CincoDias[1] + "---------------"  + CincoDias[0]);
    // console.log(  CincoDias[2] + "---------------"  + CincoDias[1]);
    // console.log(  CincoDias[3] + "---------------"  + CincoDias[2]);
    // console.log(  CincoDias[4] + "---------------"  + CincoDias[3]);
    
    let dias = [ 1 , 2 , 3 , 4 , 5 ];

    let cuantos = await db.query('SELECT COUNT(*) as total FROM registroentradaprofesoresypersonalhistorial WHERE area = ? AND fecha >= ? AND fecha < ? ', [laboratorio[0].nombre,CincoDias[0],morning]);
    dias[0] = cuantos[0].total;

    for (let i = 1 ; i < 5 ; i++){
        let cuantos = await db.query('SELECT COUNT(*) as total FROM registroentradaprofesoresypersonalhistorial WHERE area = ? AND fecha >= ? AND fecha < ? ', [laboratorio[0].nombre,CincoDias[i],CincoDias[i-1]]);
        dias[i] = cuantos[0].total;
    }
    
    /////////////////////////////////////////

    /////// INFORMACION PARA GRAFICAR DE HORAS ///////
    // Se consultara uy=n total de 9 horas
    let horasCuantos = [ 1 , 2 , 3 , 4 , 5 , 6 , 7 , 8, 9 ];
    let fehaAct  = CincoDias[0] ;
    
    // Consulta 1
    let H1I = fehaAct  + " 07:00:00" ;
    let H1F = fehaAct  + " 08:29:00" ;
    let C1 = await db.query('SELECT COUNT(*) as total FROM registroentradaprofesoresypersonalhistorial WHERE area = ? AND fecha >= ? AND fecha < ? ', [laboratorio[0].nombre,H1I,H1F]);
    horasCuantos[0] = C1[0].total;
    
    // Consulta 2
    let H2I = fehaAct  + " 08:30:00" ;
    let H2F = fehaAct  + " 09:59:00" ;
    let C2 = await db.query('SELECT COUNT(*) as total FROM registroentradaprofesoresypersonalhistorial WHERE area = ? AND fecha >= ? AND fecha < ? ', [laboratorio[0].nombre,H2I,H2F]);
    horasCuantos[1] = C2[0].total;

    // Consulta 3
    let H3I = fehaAct  + " 10:00:00" ;
    let H3F = fehaAct  + " 11:29:00" ;
    let C3 = await db.query('SELECT COUNT(*) as total FROM registroentradaprofesoresypersonalhistorial WHERE area = ? AND fecha >= ? AND fecha < ? ', [laboratorio[0].nombre,H3I,H3F]);
    horasCuantos[2] = C3[0].total;

    // Consulta 4
    let H4I = fehaAct  + " 11:30:00" ;
    let H4F = fehaAct  + " 12:59:00" ;
    let C4 = await db.query('SELECT COUNT(*) as total FROM registroentradaprofesoresypersonalhistorial WHERE area = ? AND fecha >= ? AND fecha < ? ', [laboratorio[0].nombre,H4I,H4F]);
    horasCuantos[3] = C4[0].total;
    
    // Consulta 5
    let H5I = fehaAct  + " 13:00:00" ;
    let H5F = fehaAct  + " 14:29:00" ;
    let C5 = await db.query('SELECT COUNT(*) as total FROM registroentradaprofesoresypersonalhistorial WHERE area = ? AND fecha >= ? AND fecha < ? ', [laboratorio[0].nombre,H5I,H5F]);
    horasCuantos[4] = C5[0].total;
    
    // Consulta 6
    let H6I = fehaAct  + " 14:30:00" ;
    let H6F = fehaAct  + " 15:59:00" ;
    let C6 = await db.query('SELECT COUNT(*) as total FROM registroentradaprofesoresypersonalhistorial WHERE area = ? AND fecha >= ? AND fecha < ? ', [laboratorio[0].nombre,H6I,H6F]);
    horasCuantos[5] = C6[0].total;

    // Consulta 7
    let H7I = fehaAct  + " 16:00:00" ;
    let H7F = fehaAct  + " 17:29:00" ;
    let C7 = await db.query('SELECT COUNT(*) as total FROM registroentradaprofesoresypersonalhistorial WHERE area = ? AND fecha >= ? AND fecha < ? ', [laboratorio[0].nombre,H7I,H7F]);
    horasCuantos[6] = C7[0].total;

    // Consulta 8
    let H8I = fehaAct  + " 17:30:00" ;
    let H8F = fehaAct  + " 18:59:00" ;
    let C8 = await db.query('SELECT COUNT(*) as total FROM registroentradaprofesoresypersonalhistorial WHERE area = ? AND fecha >= ? AND fecha < ? ', [laboratorio[0].nombre,H8I,H8F]);
    horasCuantos[7] = C8[0].total;

    // Consulta 9
    let H9I = fehaAct  + " 19:00:00" ;
    let H9F = fehaAct  + " 22:00:00" ;
    let C9 = await db.query('SELECT COUNT(*) as total FROM registroentradaprofesoresypersonalhistorial WHERE area = ? AND fecha >= ? AND fecha < ? ', [laboratorio[0].nombre,H9I,H9F]);
    horasCuantos[8] = C9[0].total;

    /*console.log(horasCuantos[0]);
    console.log(horasCuantos[1]);
    console.log(horasCuantos[2]);
    console.log(horasCuantos[3]);
    console.log(horasCuantos[4]);
    console.log(horasCuantos[5]);
    console.log(horasCuantos[6]);
    console.log(horasCuantos[7]);
    console.log(horasCuantos[8]);*/

    /////////////////////////////////////////

    res.render('laboratorios/dashProfesores',{laboratorio , datosSalida, datosEntrada, dias, CincoDias, horasCuantos});
 });

//Metodo para representar la vista de Temperaturas Alumnos (GET).
router.get('/TempAlumnos/:id', Logueado, async (req, res) => {
    const { id } = req.params;
    const laboratorio  = await db.query('SELECT * FROM laboratoriosyaulas WHERE id = ?',[id]);
    const datosEntrada = await db.query('SELECT * FROM temperaturaaltaalumnos WHERE area = ?',[laboratorio[0].nombre]);    

    /////// INFORMACION PARA GRAFICAR DE DIAS ///////
    // X = 31 Dias.
    // Enero       -->  1  X
    // Febreo      -->  2  --
    // Marzo       -->  3  X
    // Abril       -->  4
    // Mayo        -->  5  X
    // Junio       -->  6
    // Julio       -->  7  X
    // Agosto      -->  8  X 
    // Septiembre  -->  9  
    // Octubre     --> 10  X
    // Nobiembre   --> 11  
    // Diciembre   --> 12  X

    let fecha = new Date();
    let hoy = fecha.getDate();
    let mesActual = fecha.getMonth() + 1; 
    let year = fecha.getFullYear();

    //Fecha opcional para prubebas , cuando no se necesite se comenta.
    //year = 2022;
    //mesActual = 3;
    //hoy = 25;
    let CincoDias = [ 1 , 2 , 3 , 4 , 5 ];
    let morning = "";

    function Dias() {
        let temp = hoy;
        for (let i = 0; i < 5; i++) {
            if(temp > 0 ){
                CincoDias[i] = temp;
                temp -= 1 ;
            }else if(mesActual == 1 ) { // Si es enero
                temp = 31;
                year -= 1;
                CincoDias[i] = temp;
                temp -= 1 ;
                mesActual = 12 ;
            } else if ((mesActual - 1) == 2 ) {
                if(esBisiesto(year) ){
                    temp = 29;
                    CincoDias[i] = temp;
                    temp -= 1 ;
                    mesActual -= 1 ;
                } else {
                    temp = 28;
                    CincoDias[i] = temp;
                    temp -= 1 ;
                    mesActual -= 1 ;
                }
            } else if ( mesActual == 3 || mesActual == 5 || mesActual == 7 || mesActual == 8 || mesActual == 10 || mesActual == 12){
                temp = 30;
                CincoDias[i] = temp;
                temp -= 1 ;
                mesActual -= 1 ;
            } else {
                temp = 31;
                CincoDias[i] = temp;
                temp -= 1 ;
                mesActual -= 1 ;
            }
        
            CincoDias[i] = year + "-" + mesActual + "-" + CincoDias[i];
        }
    }

    function DiasB() {
        let temp = hoy;
        
        if((temp == 28 || temp == 29) && mesActual == 2 ){
            if(temp == 29){
                temp = 1;
                morning = temp;
                temp += 1 ;
                mesActual += 1 ;
            } else if(esBisiesto(year)){
                temp = 29;
                morning = temp;
                temp = +1 ;
                mesActual = 2 ;
            } else {
                temp = 1;
                morning = temp;
                temp = +1 ;
                mesActual += 1 ;
            }
        }else if(temp == 31 && mesActual == 12 ) { // Si es enero
            temp = 1;
            year += 1;
            morning = temp;
            temp += 1 ;
            mesActual = 1 ;
        
        } else if ( (mesActual == 1 || mesActual == 3 || mesActual == 3 || mesActual == 5 || mesActual == 7 || mesActual == 8 || mesActual == 10) && temp == 31 ){
            temp = 1;
            morning = temp;
            temp += 1 ;
            mesActual += 1 ;
        }else if ( (mesActual == 4 || mesActual == 6 || mesActual == 9 || mesActual == 11 ) && temp == 30 ) {
            temp = 1;
            morning = temp;
            temp += 1 ;
            mesActual += 1 ;
        
        } else {
            temp += 1 ;
            morning = temp;
        }
    
        morning = year + "-" + mesActual + "-" + morning;
    }
    

    function esBisiesto (year)  {
    return (year % 400 === 0) ? true : 
           (year % 100 === 0) ? false : 
            year % 4 === 0;
    }


    Dias();
    DiasB();
    // console.log(  CincoDias[0] + "---------------"  + morning);
    // console.log(  CincoDias[1] + "---------------"  + CincoDias[0]);
    // console.log(  CincoDias[2] + "---------------"  + CincoDias[1]);
    // console.log(  CincoDias[3] + "---------------"  + CincoDias[2]);
    // console.log(  CincoDias[4] + "---------------"  + CincoDias[3]);
    
    let dias = [ 1 , 2 , 3 , 4 , 5 ];

    let cuantos = await db.query('SELECT COUNT(*) as total FROM temperaturaaltaalumnos WHERE area = ? AND fecha >= ? AND fecha < ? ', [laboratorio[0].nombre,CincoDias[0],morning]);
    dias[0] = cuantos[0].total;

    for (let i = 1 ; i < 5 ; i++){
        let cuantos = await db.query('SELECT COUNT(*) as total FROM temperaturaaltaalumnos WHERE area = ? AND fecha >= ? AND fecha < ? ', [laboratorio[0].nombre,CincoDias[i],CincoDias[i-1]]);
        dias[i] = cuantos[0].total;
    }
    
    /////////////////////////////////////////

    /////// INFORMACION PARA GRAFICAR DE HORAS ///////
    // Se consultara uy=n total de 9 horas
    let horasCuantos = [ 1 , 2 , 3 , 4 , 5 , 6 , 7 , 8, 9 ];
    let fehaAct  = CincoDias[0] ;
    
    // Consulta 1
    let H1I = fehaAct  + " 07:00:00" ;
    let H1F = fehaAct  + " 08:29:00" ;
    let C1 = await db.query('SELECT COUNT(*) as total FROM temperaturaaltaalumnos WHERE area = ? AND fecha >= ? AND fecha < ? ', [laboratorio[0].nombre,H1I,H1F]);
    horasCuantos[0] = C1[0].total;
    
    // Consulta 2
    let H2I = fehaAct  + " 08:30:00" ;
    let H2F = fehaAct  + " 09:59:00" ;
    let C2 = await db.query('SELECT COUNT(*) as total FROM temperaturaaltaalumnos WHERE area = ? AND fecha >= ? AND fecha < ? ', [laboratorio[0].nombre,H2I,H2F]);
    horasCuantos[1] = C2[0].total;

    // Consulta 3
    let H3I = fehaAct  + " 10:00:00" ;
    let H3F = fehaAct  + " 11:29:00" ;
    let C3 = await db.query('SELECT COUNT(*) as total FROM temperaturaaltaalumnos WHERE area = ? AND fecha >= ? AND fecha < ? ', [laboratorio[0].nombre,H3I,H3F]);
    horasCuantos[2] = C3[0].total;

    // Consulta 4
    let H4I = fehaAct  + " 11:30:00" ;
    let H4F = fehaAct  + " 12:59:00" ;
    let C4 = await db.query('SELECT COUNT(*) as total FROM temperaturaaltaalumnos WHERE area = ? AND fecha >= ? AND fecha < ? ', [laboratorio[0].nombre,H4I,H4F]);
    horasCuantos[3] = C4[0].total;
    
    // Consulta 5
    let H5I = fehaAct  + " 13:00:00" ;
    let H5F = fehaAct  + " 14:29:00" ;
    let C5 = await db.query('SELECT COUNT(*) as total FROM temperaturaaltaalumnos WHERE area = ? AND fecha >= ? AND fecha < ? ', [laboratorio[0].nombre,H5I,H5F]);
    horasCuantos[4] = C5[0].total;
    
    // Consulta 6
    let H6I = fehaAct  + " 14:30:00" ;
    let H6F = fehaAct  + " 15:59:00" ;
    let C6 = await db.query('SELECT COUNT(*) as total FROM temperaturaaltaalumnos WHERE area = ? AND fecha >= ? AND fecha < ? ', [laboratorio[0].nombre,H6I,H6F]);
    horasCuantos[5] = C6[0].total;

    // Consulta 7
    let H7I = fehaAct  + " 16:00:00" ;
    let H7F = fehaAct  + " 17:29:00" ;
    let C7 = await db.query('SELECT COUNT(*) as total FROM temperaturaaltaalumnos WHERE area = ? AND fecha >= ? AND fecha < ? ', [laboratorio[0].nombre,H7I,H7F]);
    horasCuantos[6] = C7[0].total;

    // Consulta 8
    let H8I = fehaAct  + " 17:30:00" ;
    let H8F = fehaAct  + " 18:59:00" ;
    let C8 = await db.query('SELECT COUNT(*) as total FROM temperaturaaltaalumnos WHERE area = ? AND fecha >= ? AND fecha < ? ', [laboratorio[0].nombre,H8I,H8F]);
    horasCuantos[7] = C8[0].total;

    // Consulta 9
    let H9I = fehaAct  + " 19:00:00" ;
    let H9F = fehaAct  + " 22:00:00" ;
    let C9 = await db.query('SELECT COUNT(*) as total FROM temperaturaaltaalumnos WHERE area = ? AND fecha >= ? AND fecha < ? ', [laboratorio[0].nombre,H9I,H9F]);
    horasCuantos[8] = C9[0].total;

    /*console.log(horasCuantos[0]);
    console.log(horasCuantos[1]);
    console.log(horasCuantos[2]);
    console.log(horasCuantos[3]);
    console.log(horasCuantos[4]);
    console.log(horasCuantos[5]);
    console.log(horasCuantos[6]);
    console.log(horasCuantos[7]);
    console.log(horasCuantos[8]);*/

    /////////////////////////////////////////

    res.render('laboratorios/TempAlumnos',{laboratorio , datosEntrada, dias, CincoDias, horasCuantos});
 });

 //Metodo para representar la vista de Temperaturas Alumnos (GET).
router.get('/TempProfesores/:id', Logueado, async (req, res) => {
    const { id } = req.params;
    const laboratorio  = await db.query('SELECT * FROM laboratoriosyaulas WHERE id = ?',[id]);
    const datosEntrada = await db.query('SELECT * FROM temperaturaaltaprofesoresypersonal WHERE area = ?',[laboratorio[0].nombre]);    

    /////// INFORMACION PARA GRAFICAR DE DIAS ///////
    // X = 31 Dias.
    // Enero       -->  1  X
    // Febreo      -->  2  --
    // Marzo       -->  3  X
    // Abril       -->  4
    // Mayo        -->  5  X
    // Junio       -->  6
    // Julio       -->  7  X
    // Agosto      -->  8  X 
    // Septiembre  -->  9  
    // Octubre     --> 10  X
    // Nobiembre   --> 11  
    // Diciembre   --> 12  X

    let fecha = new Date();
    let hoy = fecha.getDate();
    let mesActual = fecha.getMonth() + 1; 
    let year = fecha.getFullYear();

    //Fecha opcional para prubebas , cuando no se necesite se comenta.
    //year = 2022;
    //mesActual = 3;
    //hoy = 25;
    let CincoDias = [ 1 , 2 , 3 , 4 , 5 ];
    let morning = "";

    function Dias() {
        let temp = hoy;
        for (let i = 0; i < 5; i++) {
            if(temp > 0 ){
                CincoDias[i] = temp;
                temp -= 1 ;
            }else if(mesActual == 1 ) { // Si es enero
                temp = 31;
                year -= 1;
                CincoDias[i] = temp;
                temp -= 1 ;
                mesActual = 12 ;
            } else if ((mesActual - 1) == 2 ) {
                if(esBisiesto(year) ){
                    temp = 29;
                    CincoDias[i] = temp;
                    temp -= 1 ;
                    mesActual -= 1 ;
                } else {
                    temp = 28;
                    CincoDias[i] = temp;
                    temp -= 1 ;
                    mesActual -= 1 ;
                }
            } else if ( mesActual == 3 || mesActual == 5 || mesActual == 7 || mesActual == 8 || mesActual == 10 || mesActual == 12){
                temp = 30;
                CincoDias[i] = temp;
                temp -= 1 ;
                mesActual -= 1 ;
            } else {
                temp = 31;
                CincoDias[i] = temp;
                temp -= 1 ;
                mesActual -= 1 ;
            }
        
            CincoDias[i] = year + "-" + mesActual + "-" + CincoDias[i];
        }
    }

    function DiasB() {
        let temp = hoy;
        
        if((temp == 28 || temp == 29) && mesActual == 2 ){
            if(temp == 29){
                temp = 1;
                morning = temp;
                temp += 1 ;
                mesActual += 1 ;
            } else if(esBisiesto(year)){
                temp = 29;
                morning = temp;
                temp = +1 ;
                mesActual = 2 ;
            } else {
                temp = 1;
                morning = temp;
                temp = +1 ;
                mesActual += 1 ;
            }
        }else if(temp == 31 && mesActual == 12 ) { // Si es enero
            temp = 1;
            year += 1;
            morning = temp;
            temp += 1 ;
            mesActual = 1 ;
        
        } else if ( (mesActual == 1 || mesActual == 3 || mesActual == 3 || mesActual == 5 || mesActual == 7 || mesActual == 8 || mesActual == 10) && temp == 31 ){
            temp = 1;
            morning = temp;
            temp += 1 ;
            mesActual += 1 ;
        }else if ( (mesActual == 4 || mesActual == 6 || mesActual == 9 || mesActual == 11 ) && temp == 30 ) {
            temp = 1;
            morning = temp;
            temp += 1 ;
            mesActual += 1 ;
        
        } else {
            temp += 1 ;
            morning = temp;
        }
    
        morning = year + "-" + mesActual + "-" + morning;
    }
    

    function esBisiesto (year)  {
    return (year % 400 === 0) ? true : 
           (year % 100 === 0) ? false : 
            year % 4 === 0;
    }


    Dias();
    DiasB();
    // console.log(  CincoDias[0] + "---------------"  + morning);
    // console.log(  CincoDias[1] + "---------------"  + CincoDias[0]);
    // console.log(  CincoDias[2] + "---------------"  + CincoDias[1]);
    // console.log(  CincoDias[3] + "---------------"  + CincoDias[2]);
    // console.log(  CincoDias[4] + "---------------"  + CincoDias[3]);
    
    let dias = [ 1 , 2 , 3 , 4 , 5 ];

    let cuantos = await db.query('SELECT COUNT(*) as total FROM temperaturaaltaprofesoresypersonal WHERE area = ? AND fecha >= ? AND fecha < ? ', [laboratorio[0].nombre,CincoDias[0],morning]);
    dias[0] = cuantos[0].total;

    for (let i = 1 ; i < 5 ; i++){
        let cuantos = await db.query('SELECT COUNT(*) as total FROM temperaturaaltaprofesoresypersonal WHERE area = ? AND fecha >= ? AND fecha < ? ', [laboratorio[0].nombre,CincoDias[i],CincoDias[i-1]]);
        dias[i] = cuantos[0].total;
    }
    
    /////////////////////////////////////////

    /////// INFORMACION PARA GRAFICAR DE HORAS ///////
    // Se consultara uy=n total de 9 horas
    let horasCuantos = [ 1 , 2 , 3 , 4 , 5 , 6 , 7 , 8, 9 ];
    let fehaAct  = CincoDias[0] ;
    
    // Consulta 1
    let H1I = fehaAct  + " 07:00:00" ;
    let H1F = fehaAct  + " 08:29:00" ;
    let C1 = await db.query('SELECT COUNT(*) as total FROM temperaturaaltaprofesoresypersonal WHERE area = ? AND fecha >= ? AND fecha < ? ', [laboratorio[0].nombre,H1I,H1F]);
    horasCuantos[0] = C1[0].total;
    
    // Consulta 2
    let H2I = fehaAct  + " 08:30:00" ;
    let H2F = fehaAct  + " 09:59:00" ;
    let C2 = await db.query('SELECT COUNT(*) as total FROM temperaturaaltaprofesoresypersonal WHERE area = ? AND fecha >= ? AND fecha < ? ', [laboratorio[0].nombre,H2I,H2F]);
    horasCuantos[1] = C2[0].total;

    // Consulta 3
    let H3I = fehaAct  + " 10:00:00" ;
    let H3F = fehaAct  + " 11:29:00" ;
    let C3 = await db.query('SELECT COUNT(*) as total FROM temperaturaaltaprofesoresypersonal WHERE area = ? AND fecha >= ? AND fecha < ? ', [laboratorio[0].nombre,H3I,H3F]);
    horasCuantos[2] = C3[0].total;

    // Consulta 4
    let H4I = fehaAct  + " 11:30:00" ;
    let H4F = fehaAct  + " 12:59:00" ;
    let C4 = await db.query('SELECT COUNT(*) as total FROM temperaturaaltaprofesoresypersonal WHERE area = ? AND fecha >= ? AND fecha < ? ', [laboratorio[0].nombre,H4I,H4F]);
    horasCuantos[3] = C4[0].total;
    
    // Consulta 5
    let H5I = fehaAct  + " 13:00:00" ;
    let H5F = fehaAct  + " 14:29:00" ;
    let C5 = await db.query('SELECT COUNT(*) as total FROM temperaturaaltaprofesoresypersonal WHERE area = ? AND fecha >= ? AND fecha < ? ', [laboratorio[0].nombre,H5I,H5F]);
    horasCuantos[4] = C5[0].total;
    
    // Consulta 6
    let H6I = fehaAct  + " 14:30:00" ;
    let H6F = fehaAct  + " 15:59:00" ;
    let C6 = await db.query('SELECT COUNT(*) as total FROM temperaturaaltaprofesoresypersonal WHERE area = ? AND fecha >= ? AND fecha < ? ', [laboratorio[0].nombre,H6I,H6F]);
    horasCuantos[5] = C6[0].total;

    // Consulta 7
    let H7I = fehaAct  + " 16:00:00" ;
    let H7F = fehaAct  + " 17:29:00" ;
    let C7 = await db.query('SELECT COUNT(*) as total FROM temperaturaaltaprofesoresypersonal WHERE area = ? AND fecha >= ? AND fecha < ? ', [laboratorio[0].nombre,H7I,H7F]);
    horasCuantos[6] = C7[0].total;

    // Consulta 8
    let H8I = fehaAct  + " 17:30:00" ;
    let H8F = fehaAct  + " 18:59:00" ;
    let C8 = await db.query('SELECT COUNT(*) as total FROM temperaturaaltaprofesoresypersonal WHERE area = ? AND fecha >= ? AND fecha < ? ', [laboratorio[0].nombre,H8I,H8F]);
    horasCuantos[7] = C8[0].total;

    // Consulta 9
    let H9I = fehaAct  + " 19:00:00" ;
    let H9F = fehaAct  + " 22:00:00" ;
    let C9 = await db.query('SELECT COUNT(*) as total FROM temperaturaaltaprofesoresypersonal WHERE area = ? AND fecha >= ? AND fecha < ? ', [laboratorio[0].nombre,H9I,H9F]);
    horasCuantos[8] = C9[0].total;

    /*console.log(horasCuantos[0]);
    console.log(horasCuantos[1]);
    console.log(horasCuantos[2]);
    console.log(horasCuantos[3]);
    console.log(horasCuantos[4]);
    console.log(horasCuantos[5]);
    console.log(horasCuantos[6]);
    console.log(horasCuantos[7]);
    console.log(horasCuantos[8]);*/

    /////////////////////////////////////////

    res.render('laboratorios/TempProfesores',{laboratorio , datosEntrada, dias, CincoDias, horasCuantos});
 });

 //Metodo para representar la vista de Temperaturas Alumnos (GET).
router.get('/dash/:id', Logueado, async (req, res) => {
    const { id } = req.params;
    const laboratorio  = await db.query('SELECT * FROM laboratoriosyaulas WHERE id = ?',[id]);
    res.render('laboratorios/dash',{laboratorio});
    
});
 

    module.exports = router;

