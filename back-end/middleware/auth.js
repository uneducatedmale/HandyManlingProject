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