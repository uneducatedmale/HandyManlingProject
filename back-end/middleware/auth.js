/*
  File: auth.js
  Purpose:
  - Middleware to handle user authentication by validating JSON Web Tokens (JWT).
  - Ensures only authenticated users can access protected routes.

  Functionality:
  - Checks for the presence of an `x-auth-token` header in incoming requests.
  - Verifies the token using the `JWT_PRIVATE_KEY` environment variable.
  - Decodes the token and attaches the decoded user information to the `req.user` object for use in subsequent middleware or route handlers.
  - Rejects requests with missing or invalid tokens.

  How It Works:
  - The `jsonwebtoken` library is used to decode and verify the JWT.
  - If the token is valid, the decoded user data is passed along; otherwise, the request is rejected with a 401 (Unauthorized) or 400 (Bad Request) response.

  Files It Interacts With:
  - `config.js`: Ensures the `JWT_PRIVATE_KEY` is properly defined for token validation.
  - `users.js`: Routes use this middleware to secure endpoints requiring authentication.
  - `dependencies.js`: Registers this middleware in the Express app setup.
*/

const jwt = require('jsonwebtoken');
require('dotenv').config();

//export
module.exports = function (req, res, next){
    const token = req.header('x-auth-token');
    if(!token) return res.status(401).send('Access denied, no token provided');
    try {
        const decoded = jwt.verify(token, process.env.JWT_PRIVATE_KEY);
        req.user = decoded;
        next();
    } catch(exception) {
        return res.status(400).send('Invalid token');
    }
}