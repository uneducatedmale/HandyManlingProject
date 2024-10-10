const mongoose = require('mongoose');
const Joi = require('joi');
const jwt = require('jsonwebtoken');
require('dotenv').config();

//user model
const mongoSchema = mongoose.Schema({
    firstName: {
        type: String,
        required: true,
    },
    lastName: {
        type: String,
        required: true,
    },
    email: {
        type: String,
        required: true,
    },
    password:{
        type: String,
        required: true,
    },
    memos: [
        {
            timeStamp: {
                type: Date,
            },
            content: {
                type: String,
                required: true,
            }
        }
    ]
});

mongoSchema.methods.generateAuthToken = function () {
    const token = jwt.sign({_id: this._id}, process.env.JWT_PRIVATE_KEY);
    return token;
}

const User = mongoose.model('User' , mongoSchema);

//REST Validation
function validateUser(user) {
    const schema = Joi.object({
        firstName: Joi.string().required(),
        lastName: Joi.string().required(),
        email: Joi.string().email().required(),
        password: Joi.string().required(),
    });
    return schema.validate(user);
    
}

//exports
module.exports = {
    User,
    validateUser,
}