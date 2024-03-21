const httpError = require('../helpers/helperError')
const pool = require('../../config/postgresql')


const getItems = async (req,res) => {
    try {
        const response = await pool.query('SELECT * FROM view_user_profile')
        res.json({ data: response.rows})
    } catch (error) {
        httpError(res,error)
    }
}

const getItem = async (req,res) => {
    try {
        const id = req.params.id
        const response = await pool.query('SELECT * FROM view_user_profile WHERE id=$1',[id])
        res.json({ data: response.rows})
    } catch (error) {
        httpError(res,error)
    }
}

const createItem = async (req,res) => {
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
        res.json({data: resp2.rows})
    } catch (error) {
        httpError(res,error)
    }
}

const updateItem = async (req,res) => {
    try {
        const response = await pool.query('SELECT * FROM auth.users')
        res.json({ data: response.rows})
    } catch (error) {
        httpError(res,error)
    }
}

const deleteItem = async (req,res) => {
    try {
        const response = await pool.query('SELECT * FROM auth.users')
        res.json({ data: response.rows})
    } catch (error) {
        httpError(res,error)
    }
}

module.exports = {getItem,getItems,createItem,updateItem,deleteItem}