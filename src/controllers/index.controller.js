const { Pool } = require('pg')
const { compare, encrypt } = require('../helpers/helper.encrypt.js')

const pool = new Pool({
    host: 'localhost',
    user: 'postgres',
    password: '28076011',
    database: 'development_snr',
    port: '5432'
})

const getUsers = async (req, res) => {
    try {
        const response = await pool.query('SELECT * FROM auth.users')
        res.json({ data: response.rows[0] })
    } catch (error) {
        res.json(error)
    }
}

const getPersons = async (req, res) => {
    const response = await pool.query('SELECT * FROM persons')
    res.json(response.rows)
}

const pruebas = async (req, res) => {
    const hash = await encrypt(req.params.val)
    const checkHash = await compare(req.params.val, hash)
    res.send({
        data: {
            hash: hash,
            checkHash: checkHash
        }
    })
}

const registerPerson = async (req, res) => {
    try {
        const {
            identity_card,
            is_foreign,
            first_name,
            other_names,
            first_last_name,
            other_last_names,
            email,
            phone,
            gender_id
        } = req.body
        const resp1 = await pool.query('INSERT INTO persons (identity_card, is_foreign, first_name, other_names, first_last_name, other_last_names, email, phone, gender_id) VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9) RETURNING id', [identity_card, is_foreign, first_name, other_names, first_last_name, other_last_names, email, phone, gender_id])
        res.json({ data: resp1.rows[0] })
    } catch (error) {
        res.json(error)
    }
}

const createUser = async (req, res) => {
    try {
        const {
            username,
            password,
            rol_id,
            department_id,
            identity_card,
            is_foreign,
            first_name,
            other_names,
            first_last_name,
            other_last_names,
            email,
            phone,
            gender_id
        } = req.body
        const hash = await encrypt(password)
        const resp1 = await pool.query('INSERT INTO persons (identity_card, is_foreign, first_name, other_names, first_last_name, other_last_names, email, phone, gender_id) VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9) RETURNING id', [identity_card, is_foreign, first_name, other_names, first_last_name, other_last_names, email, phone, gender_id])
        const person_id = resp1.rows[0].id
        const resp2 = await pool.query('INSERT INTO auth.users (username, password, person_id, rol_id, department_id, is_active) VALUES ($1,$2,$3,$4,$5,$6) RETURNING id', [username, hash, person_id, rol_id, department_id, true])
        res.json({
            data: resp2.rows
        })
    } catch (error) {
        res.json({ error })
    }
}

const authUser = async (req, res) => {
    try {
        const { username, password } = req.body
        const response = await pool.query('SELECT * FROM auth.users WHERE username = $1', [username])
        // console.log(response)
        const checkPass = await compare(password, response.rows[0].password)
        if (checkPass) {
            res.json({
                data: response.rows
            })
        }else{
            res.json({error:'Contraseña no coinciden'})
        }
    } catch (error) {
        res.json(error)
    }
}

module.exports = {
    getUsers,
    registerPerson,
    createUser,
    authUser,
    getPersons,
    pruebas
}