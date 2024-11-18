/*
  File: routes.js
  Purpose:
  - Configures API endpoint routes and middleware for the Handyman App's backend server.

  Functionality:
  - Sets up middleware to parse incoming JSON requests and handle cross-origin requests using CORS.
  - Defines route prefixes for different API functionalities:
    - `/api/auth`: Middleware for authentication.
    - `/api/users`: Handles user-related operations such as account management, project handling, and other user-specific endpoints.

  How It Works:
  - Uses Express.js `app.use()` to register middleware and route handlers.
  - `express.json()`: Parses incoming JSON payloads for request bodies.
  - `cors()`: Enables Cross-Origin Resource Sharing to allow secure requests from different origins.
  - Registers `auth` and `users` routes for specific API functionality.

  Files It Interacts With:
  - `middleware/auth.js`: Middleware for authentication and authorization.
  - `routes/users.js`: Defines routes for user operations such as account creation, sign-in, and project management.
*/


const express = require('express');
const cors = require('cors');
const auth = require('../middleware/auth');
const users = require('../routes/users');

module.exports = function(app) {
    app.use(express.json());
    app.use(cors());
    app.use('/api/auth', auth);
    app.use('/api/users', users);
    
}