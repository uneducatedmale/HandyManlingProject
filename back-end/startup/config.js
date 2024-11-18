/*
  File: config.js
  Purpose:
  - Ensures that the `JWT_PRIVATE_KEY` environment variable is defined, which is critical for authentication and token generation in the Handyman App.

  Functionality:
  - Checks for the presence of the `JWT_PRIVATE_KEY` in the environment variables.
  - Throws an error and halts the application if the key is missing.

  How It Works:
  - Uses `dotenv` to load environment variables from a `.env` file into `process.env`.
  - Verifies that the `JWT_PRIVATE_KEY` is defined.
  - Prevents the application from running without the necessary key for secure token operations.

  Files It Interacts With:
  - `.env`: Contains the `JWT_PRIVATE_KEY` used for generating and verifying JSON Web Tokens.
  - `middleware/auth.js` and any other modules that rely on token-based authentication.
*/


require('dotenv').config();

//check if JWT private key is an environment variable
module.exports = function () {
    if(!process.env.JWT_PRIVATE_KEY) {
        throw new Error('FATAL Error: JWT_PRIVATE_KEY not defined!');
    }
}