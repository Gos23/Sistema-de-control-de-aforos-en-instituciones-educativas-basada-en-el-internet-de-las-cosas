const express = require('express');
const morgan  = require('morgan');
const { engine } = require('express-handlebars');
const path    = require('path');
const flash = require('connect-flash');
const session = require('express-session');
const mysqlStore = require('express-mysql-session');
const passport = require('passport');


const { database } = require('./keys');


//Initializations

const app = express();
require('./lib/passport');

//Settings
app.set('port', process.env.PORT || 4000);
app.set('views', path.join(__dirname, 'views')); //Obtengo la direecion de la carpeta views
app.engine('.hbs', engine({ 
    defaultLayout: "main", // Partes comunes de la Navegacion.
    layoutsDir: path.join(app.get('views'), 'layouts'), //Direccion de la carpeta layouts
    partialsDir: path.join(app.get('views') , 'partials'), //Direccion de la carpeta partials (Codigos que estan en todas las vistas).
    extname: '.hbs', // Archivos de handlebars , los archivos teminaran en hbs. 
    helpers: require('./lib/handlebars') // Funciones estaran en handeblebars.
}));
app.set('view engine', '.hbs'); // Utilizamos el motor que acabmos de configurar.

//Middleware (Se ejecutan cada vez que un usuario envia una peticion)
app.use(session({
    secret: 'GOSmysql',
    resave: false,
    saveUninitialized: false,
    store: new mysqlStore(database)
}));
app.use(flash());
app.use(morgan('dev'));
app.use(express.urlencoded({extended: false})); // Acepto desde el formularios los datos que me manden el usuario.
app.use(express.json()); // Aceptar JSON.
app.use(passport.initialize());
app.use(passport.session());


//Global variables
app.use((req, res, next) => {
    app.locals.success = req.flash('success'); // Mensaje de exito.
    app.locals.message = req.flash('message'); // Mensaje de no exito. 
    app.locals.user = req.user // Dato de session del usuario.
;    next();
});

//Routes(URL de nuestro servidor)
app.use(require('./routes'));
app.use(require('./routes/authentication')); // Ruta de authenticacion.
app.use('/laboratorios',require('./routes/laboratorios')); // Ruta de Laboratorios y Aulas. ***
app.use('/alumnos',require('./routes/alumnos')); // Ruta de Alumnos. ***
app.use('/profesores',require('./routes/profesores')); // Ruta de Profesores y personal. ***
app.use('/administradores',require('./routes/administradores')); // Ruta de administradores. ***

//Public (Codigo al que el navegador puede acceder)
app.use(express.static(path.join(__dirname, 'public')));

//Starting the server
app.listen(app.get('port'), () => {
    console.log(`Server on port`, app.get('port'));
} );

