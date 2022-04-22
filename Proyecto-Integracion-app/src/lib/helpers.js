const bcryptjs =  require('bcryptjs');

//Metodo de Cifrado (10) numero de ejecucion para en cifrado
const helpers = {};

helpers.encryptPassword = async (password) => {
     const salt = await bcryptjs.genSalt(10);
     const hash = await bcryptjs.hash(password,salt);
     return hash ;
};

helpers.matchPassword = async (password, savePassword) => {
    try {
        return await bcryptjs.compare(password, savePassword);
    } catch (e) {
        console.log(e);
    }
}

module.exports = helpers ; 