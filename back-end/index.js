/*
  File: index.js
  Purpose:
  - Entry point for the Handyman App's backend server. Initializes and configures the server to handle incoming requests.

  Functionality:
  - Loads essential configurations, routes, and database connections through modularized startup scripts.
  - Sets up the Express.js server.
  - Listens for incoming connections on the specified port.

  How It Works:
  - Imports the Express framework to create a server instance.
  - Executes startup modules:
    - `config.js`: Loads configuration settings (e.g., environment variables).
    - `routes.js`: Defines API endpoints and middleware.
    - `db.js`: Establishes a database connection.
  - Starts the server, listening on a port defined in the environment variables or defaulting to 3000.

  Files It Interacts With:
  - `startup/config.js`: Loads environment-specific configurations.
  - `startup/routes.js`: Sets up routes and middleware.
  - `startup/db.js`: Connects to the database.
*/

const express = require('express');

const app = express();

require('./startup/config')();
require('./startup/routes')(app);
require('./startup/db')();

const port = process.env.PORT || 3000;

app.listen(port, console.log('listening on port ' + port));