/*
  File: db.js
  Purpose:
  - Establishes a connection to the MongoDB database for the Handyman App.

  Functionality:
  - Uses `mongoose` to connect to a MongoDB instance using the URI stored in environment variables.
  - Logs a success message if the connection is established.
  - Catches and logs errors if the connection fails and propagates the error for handling.

  How It Works:
  - The `connectToDb` function asynchronously connects to the database using `mongoose.connect()`.
  - Retrieves the database URI from `process.env.MONGO_URI` (requires `.env` file setup).
  - Outputs the connection status to the console for debugging.

  Files It Interacts With:
  - `.env`: Contains the `MONGO_URI` string for connecting to the database.
  - Other backend files requiring database access will call this function to ensure connectivity.
*/


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

