const {verifyToken} = require('../helpers/helperToken')
const pool = require("../../config/postgresql");

const checkRoleAuth = (roles) => async (req, res, next) =>{
    try {
        const token = req.headers.authorization.split(' ').pop()
        const tokenData = await verifyToken(token)
        const userData = await pool.query('SELECT * FROM auth.users WHERE id=$1',[tokenData._id])
        const userRole = userData.rows[0].role_id
        if (roles.includes(userRole)) {
            next()
        }else{
            res.status(409);
            res.json({status: "FAILED", error: "Tú no tienes permisos" });
        }
    } catch (error) {
        console.log(error);
        res.status(409);
        res.json({status: "FAILED", error: "Tú no tienes permisos" });
    }
}

module.exports = checkRoleAuth