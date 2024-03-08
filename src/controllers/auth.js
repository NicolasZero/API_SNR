const {httpError} = require('../helpers/helperError')
const { encrypt,compare } = require('../helpers/helperEncrypt.js')
const pool = require('../../config/postgresql')

const authUser = async (req, res) => {
    try {
        const { username, password } = req.body
        const response = await pool.query('SELECT * FROM auth.users WHERE username = $1', [username])
        const checkPass = await compare(password, response.rows[0].password)
        if (checkPass) {
            res.json({data: response.rows})
        }else{
            res.json({error:'Contraseña no coinciden'})
        }
    } catch (error) {
        httpError(res,error)
    }
}

const registerUser = async (req,res) => {
    try {
        const {
            username,
            password,
            rol_id,
            department_id,
            person_id
        } = req.body
        const passwordHash = await encrypt(password)
        const resp = await pool.query('INSERT INTO auth.users (username, password, person_id, rol_id, department_id) VALUES ($1,$2,$3,$4,$5) RETURNING id', [username, passwordHash, person_id, rol_id, department_id])
        res.json({data: resp.rows[0]})
    } catch (error) {
        httpError(res,error)
    }
}

module.exports = {authUser,registerUser}