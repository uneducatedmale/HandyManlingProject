const mongoose = require('mongoose');
require('dotenv').config();

//connecting back end to database (MongoDB)
module.exports = async function connectToDb() {
    try{
        await mongoose.connect(
            process.env.MONGO_URI
        );
        console.log('connected to db');
    } catch(error) {
        console.log(error);
        throw error;
    }
}