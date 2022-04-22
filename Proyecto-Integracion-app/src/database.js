const myqsl = require('mysql');
const {promisify} = require('util');
const { database } = require('./keys');

const db = myqsl.createPool(database);
db.getConnection((err, connection) => {    
    if (connection){
        connection.release();
        console.log('DB is Connected');
    } 
    return;
});

//Promisify Pool Querys 
db.query = promisify(db.query);
module.exports = db;