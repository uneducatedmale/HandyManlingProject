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
