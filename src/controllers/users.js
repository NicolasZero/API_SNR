const httpError = require('../helpers/helperError')
const { query } = require('../../config/postgresql')
const { encrypt, compare } = require("../helpers/helperEncrypt.js");
const { onlyLetters, onlyNumbers } = require("../helpers/helperPattern");
const { checkColEqVal, setColAndVal } = require('../helpers/helperUpdate.js')

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
    try {
        const id = req.params.id
        // Verifica que la id solo sea numerico
        if (onlyNumbers(id)) {
            let checkProcess = false

            if ('user' in req.body) {
                const { columns, values } = req.body.user;
                if (checkColEqVal(res, columns, values)) {
                    const newQuery = setColAndVal(columns)
                    const textQuery = `UPDATE auth.users SET ${newQuery} WHERE id = ${id}`
                    const resp = await query(textQuery, values);
                    checkProcess = true
                }else{
                    return 0
                }
            }

            if ('location' in req.body) {
                const { columns, values } = req.body.location;
                if (checkColEqVal(res, columns, values)) {
                    const newQuery = setColAndVal(columns)
                    const textQuery = `UPDATE auth.location SET ${newQuery} WHERE user_id = ${id}`
                    const resp = await query(textQuery, values);
                    checkProcess = true
                }else{
                    return 0
                }
            }

            if (checkProcess) {
                return res.json({ status: "OK", data: { msg: "Los datos se actualizaron correctamente" } });
            } else {
                return res.status(409).json({
                    status: "FAILED",
                    error: { msg: 'Ocurrió un error al actualizar los datos' }
                })
            }
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

const changeStatus = (status) => async (req, res) => {
    try {
        const id = req.params.id
        if (onlyNumbers(id)) {
            const resp = await query('UPDATE auth.users SET is_active = $1 WHERE id = $2',[status,id])
            const msg = status == true ?  "Usuario activado" : "Usuario eliminado"
            res.json({ status: "OK", data: {msg: msg}})
        }else{
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