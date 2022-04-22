const express = require('express');
const router = express.Router();

const passport = require('passport');
const { Logueado, NoLogueado } = require('../lib/auth');


// Metodos signIn
router.get('/signin', NoLogueado,  (req, res) => {
    res.render('auth/signin');
});

router.post('/signin', NoLogueado, (req, res, next) => {
    passport.authenticate('local.signin', {
        successRedirect: '/laboratorios',
        failureRedirect: '/signin',
        failureFlash: true
    })(req, res, next);
});


// Metodos signUp
router.get('/signup', Logueado, (req, res) => {
    res.render('auth/signup');
});

router.post('/signup',passport.authenticate('local.signup',{
        successRedirect: '/profile',
        failureRedirect: '/signup',
        failureFlash: true
}))
    
router.get('/profile', Logueado, (req, res) => {
    res.render('profile');
});

router.get('/logout', (req, res) => {
    req.logOut();
    res.redirect('/signin');
});

module.exports = router