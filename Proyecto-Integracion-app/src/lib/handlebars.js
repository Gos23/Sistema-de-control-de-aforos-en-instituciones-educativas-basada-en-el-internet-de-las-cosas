// Funciones de handeblasrs
const { format } =  require('timeago.js')

const helpers = {} ;

helpers.timeago = (timestamp) => {
    return format(timestamp);
};

//Convierte el texto true o false a activado o desactivado respectivamente.
helpers.TrueoFalse = (edo) => {
    if(edo == "true"){
        return "Activado";
    }else {
        return "Desactivado";
    }
};

module.exports = helpers ;
