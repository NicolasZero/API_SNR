const httpError = require('../helpers/helperError')
const { query, pool } = require('../../config/postgresql')
const { encrypt, compare } = require("../helpers/helperEncrypt.js");
const { onlyNumbers } = require("../helpers/helperPattern");
// const { Pool } = require('pg')
// const pool = new Pool({
//     host: process.env.DB_HOST,
//     user: process.env.DB_USER,
//     password: process.env.DB_PASSWORD,
//     database: process.env.DB_NAME,
//     port: process.env.DB_PORT
// })

const getItems = async (req, res) => {
    try {
        const response = await query('SELECT * FROM view_user_data')
        return res.json({ status: "OK", data: response.rows })
    } catch (error) {
        httpError(res, error)
    }
}

const getItem = async (req, res) => {
    try {
        const id = req.params.id
        const response = await query('SELECT * FROM view_user_data WHERE id=$1', [id])
        return res.json({ status: "OK", data: response.rows })
    } catch (error) {
        httpError(res, error)
    }
}

const createItem = async (req, res) => {
    try {
        const {
            username,
            password,
            identity_card,
            is_foreign,
            names,
            last_names,
            email,
            phone,
            gender_id,
            role_id,
            department_id,
            state_id,
            municipality_id,
            parish_id,
            address
        } = req.body
        const hash = await encrypt(password)
        // verifica que si existe un usuario con esa cédula para retornar un mensaje de error
        const existUser = await query('SELECT id FROM auth.users WHERE identity_card = $1', [identity_card])
        if (existUser.rows.length !== 0) {
            return res.status(409).json({
                status: "FAILED",
                error: { msg: `Ya existe un usuario con esa cédula: ${identity_card}` },
            })
        }

        // verifica que si existe un usuario con ese username para retornar un mensaje de error
        const existUsername = await query('SELECT id FROM auth.users WHERE username = $1', [username])
        if (existUsername.rows.length !== 0) {
            return res.status(409).json({
                status: "FAILED",
                error: { msg: `Ya existe un usuario con ese nombre: ${username}` }
            })
        }

        const resp1 = await query('INSERT INTO auth.users (username,password,identity_card,is_foreign,names,last_names,email,phone,gender_id,role_id,department_id) VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11) RETURNING id', [username, hash, identity_card, is_foreign, names, last_names, email, phone, gender_id, role_id, department_id])
        const id = resp1.rows[0].id
        const resp2 = await query('INSERT INTO auth.location (user_id, state_id, municipality_id, parish_id, address) VALUES ($1,$2,$3,$4,$5)', [id, state_id, municipality_id, parish_id, address])

        return res.json({ status: "OK", data: { msg: "Los datos se registraron correctamente" } })
    } catch (error) {
        httpError(res, error)
    }
}

const updateItem = async (req, res) => {
    const client = await pool.connect()

    try {
        const id = req.params.id
        // Verifica que la id solo sea numerico
        if (onlyNumbers(id)) {
            const {
                address,
                department_id,
                email,
                gender_id,
                identity_card,
                is_foreign,
                last_names,
                municipality_id,
                names,
                parish_id,
                phone,
                resetPassword,
                role_id,
                state_id
            } = req.body;

            // Inicia la transacción
            await client.query("BEGIN")

            // Actualiza los datos básicos del usuario
            let textQuery = "UPDATE auth.users SET department_id = $1,email = $2,gender_id = $3,identity_card = $4,is_foreign = $5,last_names = $6,names = $7,phone = $8,role_id = $9 WHERE id = $10"
            let values = [department_id, email, gender_id, identity_card, is_foreign, last_names, names, phone, role_id, id]
            const resp = await client.query(textQuery, values)

            // Actualiza los datos de localización del usuario
            textQuery = "UPDATE auth.location SET address = $1, municipality_id = $2, parish_id = $3, state_id = $4 WHERE id = $5"
            values = [address, municipality_id, parish_id, state_id, id]
            const resp2 = await client.query(textQuery, values)

            // Si quiere resetear la contraseña
            if (resetPassword == true) {
                // cambia la contraseña por su cédula actual
                const hash = await encrypt(identity_card.toString())
                textQuery = "UPDATE auth.users SET password = $1 WHERE id = $2"
                values = [hash, id]
                const resp2 = await client.query(textQuery, values)
            }
            // Termina la transacción
            await client.query("COMMIT")

            res.json({ status: "OK", data: { msg: "Los datos se actualizaron correctamente" } })

        } else {
            res.status(409).json({
                status: "FAILED",
                error: { msg: 'Error, identificador no válido' },
            })
        }
    } catch (error) {
        await client.query("ROLLBACK")
        httpError(res, error)
    } finally {
        client.release()
    }

}

const changeStatus = (status) => async (req, res) => {
    try {
        const id = req.params.id
        if (onlyNumbers(id)) {
            const resp = await query('UPDATE auth.users SET is_active = $1 WHERE id = $2', [status, id])
            const msg = status == true ? "Usuario activado" : "Usuario eliminado"
            res.json({ status: "OK", data: { msg: msg } })
        } else {
            return res.status(409).json({
                status: "FAILED",
                error: { msg: 'Error, identificador no válido' },
            })
        }
    } catch (error) {
        httpError(res, error)
    }
}

module.exports = { getItem, getItems, createItem, updateItem, changeStatus }