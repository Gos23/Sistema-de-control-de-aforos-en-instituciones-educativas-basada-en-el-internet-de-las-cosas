//Definimeros nuestros metodos de authenticacion
const passport = require('passport');
const LocalStrategy = require('passport-local').Strategy;

const db = require('../database');
const helpers = require('../lib/helpers');


// Login
passport.use('local.signin', new LocalStrategy({
    usernameField: 'username',
    passworField: 'password',
    passReqToCallback: true,
}, async (req, username, password, done) => {
    const rows = await db.query('SELECT * FROM users WHERE username = ?',[username]);
    if(rows.length > 0){
        const user = rows[0];
        const validPassword = await helpers.matchPassword(password,user.password);
        if(validPassword){
            done(null,user,req.flash('success','Bienvenido ' + username));
        } else {
            done(null,false,req.flash('message','Password incorrecto'));
        }
    } else {
        return done(null,false,req.flash('message','Usuario incorrecto'));
    }

}));

// Resgitrar un nuveo usuario en la aplicacion

passport.use('local.signup', new LocalStrategy({
    usernameField: 'username',
    passworField: 'password',
    passReqToCallback: true,
}, async (req, username, password, done) =>{
    
    const { fullname } = req.body;
    const newUser = {
        username,
        password,
        fullname
    };
    newUser.password = await helpers.encryptPassword(password); //Cifrado
    const result = await db.query('INSERT INTO users set ?',[newUser]);
    newUser.id = result.insertId;
    return done(null, newUser);      
}));

passport.serializeUser((user, done) => {
    done(null, user.id);
});

passport.deserializeUser( async (id,done) => {
    const rows = await db.query('SELECT * FROM users WHERE id = ?',[id]);
    done(null, rows[0]);
});

