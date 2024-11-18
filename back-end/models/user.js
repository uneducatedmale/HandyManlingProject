/*
  File: user.js
  Purpose:
  - Defines the MongoDB schemas and models for users, projects, materials, and laborers.
  - Provides methods and utilities for user authentication and data validation.

  Functionality:
  - **Schemas and Models**:
    - `materialSchema`: Defines the structure of materials in a project, including name, quantity, and value.
    - `laborerSchema`: Defines the structure of laborers in a project, including job details, hourly wage, and hours worked.
    - `projectSchema`: Defines the structure of a project, including name, memo, materials, laborers, job payment, and timestamp. Includes a virtual field `finances` to compute project financials dynamically.
    - `mongoSchema`: Defines the structure of a user, including personal details, authentication credentials, and associated projects.
  - **JWT Authentication**:
    - `generateAuthToken`: Generates a JSON Web Token for secure user authentication using `JWT_PRIVATE_KEY`.
  - **Validation**:
    - `validateUser`: Validates user input for account creation using `Joi`.

  How It Works:
  - The `mongoose` library is used to define schemas and interact with the MongoDB database.
  - User credentials are securely stored with hashed passwords and are authenticated via JWT.
  - The `finances` virtual field computes dynamic financial data for projects by summing material costs, labor costs, and calculating gross income.

  Files It Interacts With:
  - `users.js`: Backend routes use these models and methods for operations like account creation, project management, and authentication.
  - `db.js`: Ensures database connection for storing and retrieving user data.
  - `config.js`: Ensures `JWT_PRIVATE_KEY` is present for secure token generation.
*/

const mongoose = require('mongoose');
const Joi = require('joi');
const jwt = require('jsonwebtoken');
require('dotenv').config();

// Define material schema
const materialSchema = mongoose.Schema({
    name: { type: String, required: true },
    quantity: { type: Number, required: true },
    value: { type: Number, required: true },
});

// Define laborer schema
const laborerSchema = mongoose.Schema({
    name: { type: String, required: true },
    job: { type: String, required: true },
    hourlyWage: { type: Number, required: true },
    hoursWorked: { type: Number, required: true },
});

// Define project schema
const projectSchema = mongoose.Schema({
    name: { type: String, required: true },
    memo: { type: String, required: true },
    materials: [materialSchema],
    laborers: [laborerSchema],
    jobPay: { type: Number, default: 0 }, // Initialize to 0
    timeStamp: { type: String }, // Fixed timestamp
});


// Virtual for finances
projectSchema.virtual('finances').get(function () {
    const totalMaterialCost = this.materials.reduce(
        (sum, material) => sum + material.quantity * material.value,
        0
    );
    const totalLaborCost = this.laborers.reduce(
        (sum, laborer) => sum + laborer.hourlyWage * laborer.hoursWorked,
        0
    );
    const grossIncome = this.jobPay - (totalMaterialCost + totalLaborCost);

    return { totalMaterialCost, totalLaborCost, grossIncome };
});

// Define user schema
const mongoSchema = mongoose.Schema({
    firstName: { type: String, required: true },
    lastName: { type: String, required: true },
    email: { type: String, required: true },
    password: { type: String, required: true },
    projects: [projectSchema],
});

// Generate JWT
mongoSchema.methods.generateAuthToken = function () {
    return jwt.sign({ _id: this._id }, process.env.JWT_PRIVATE_KEY);
};

// Model creation
const User = mongoose.model('User', mongoSchema);

// REST Validation
function validateUser(user) {
    const schema = Joi.object({
        firstName: Joi.string().required(),
        lastName: Joi.string().required(),
        email: Joi.string().email().required(),
        password: Joi.string().required(),
    });
    return schema.validate(user);
}

// Exports
module.exports = {
    User,
    validateUser,
};
