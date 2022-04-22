//Sirve para la seguridad de los demas links.
module.exports = {

    // Aqui se comprueba si se ah logueado el usuario.
    Logueado(req, res, next){
        if(req.isAuthenticated()){
            return next();
        }
        return res.redirect('/signin');
    },

    // Aqui se comprueba si NO se ah logueado el usuario.
    NoLogueado(req, res, next){
        if(!req.isAuthenticated()){
            return next();
        }
        return res.redirect('/profile');
    }

}