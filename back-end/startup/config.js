require('dotenv').config();

//check if JWT private key is an environment variable
module.exports = function () {
    if(!process.env.JWT_PRIVATE_KEY) {
        throw new Error('FATAL Error: JWT_PRIVATE_KEY not defined!');
    }
}