const httpError = require('../helpers/helperError')
const { query } = require('../../config/postgresql')
const { encrypt, compare } = require("../helpers/helperEncrypt.js");
const { onlyLetters, onlyNumbers } = require("../helpers/helperPattern");
const {checkColEqVal} = require('../helpers/helperUpdate.js')

const getItems = async (req, res) => {
    try {
        const response = await query('SELECT * FROM view_user_profile')
        return res.json({ status: "OK", data: response.rows })
    } catch (error) {
        httpError(res, error)
    }
}

const getItem = async (req, res) => {
    try {
        const id = req.params.id
        const response = await query('SELECT * FROM view_user_profile WHERE id=$1', [id])
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
            role_id,
            department_id,
            identity_card,
            is_foreign,
            first_name,
            other_names,
            first_last_name,
            other_last_names,
            email,
            phone,
            gender_id,
            state_id,
            municipality_id,
            parish_id,
            address
        } = req.body
        const hash = await encrypt(password)

        // verifica si la persona fue registrada previamente o no para evitar errores de datos repetidos
        const existPerson = await query('SELECT id FROM persons WHERE identity_card = $1', [identity_card])
        if (existPerson.rows.length !== 0) {
            const person_id = existPerson.rows[0].id

            // verifica si tiene un usuario esa persona o no para evitar errores
            const existUser = await query('SELECT id FROM auth.users WHERE person_id = $1', [person_id])
            if (existUser.rows.length !== 0) {
                return res.status(409).json({
                    status: "FAILED",
                    data: {
                        error: 'ya existe un usuario con esa cedula',
                        identity_card
                    }
                })
            }

            // verifica si ya existe un usuario con ese username o no para evitar errores
            const existUsername = await query('SELECT id FROM auth.users WHERE username = $1', [username])
            if (existUsername.rows.length !== 0) {
                return res.status(409).json({
                    status: "FAILED",
                    data: {
                        error: 'nombre de usuario repetido',
                        username
                    }
                })
            }

            const resp = await query('INSERT INTO auth.users (username, password, person_id, role_id, department_id, is_active) VALUES ($1,$2,$3,$4,$5,$6) RETURNING *', [username, hash, person_id, role_id, department_id, true])
            const resp2 = await query('INSERT INTO location (person_id, state_id, municipality_id, parish_id, address) VALUES ($1,$2,$3,$4,$5) RETURNING *', [person_id, state_id, municipality_id, parish_id, address])
            
            const result = Object.assign({}, resp.rows[0], resp2.rows[0])

            return res.json({ status: "OK", data: [result] })
        } else {
            // verifica si ya existe un usuario con ese username o no para evitar errores
            const existUsername = await query('SELECT id FROM auth.users WHERE username = $1', [username])
            if (existUsername.rows.length !== 0) {
                return res.status(409).json({
                    status: "FAILED",
                    data: {
                        error: 'nombre de usuario repetido',
                        username
                    }
                })
            }

            let resp = await query('INSERT INTO persons (identity_card, is_foreign, first_name, other_names, first_last_name, other_last_names, email, phone, gender_id) VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9) RETURNING id', [identity_card, is_foreign, first_name, other_names, first_last_name, other_last_names, email, phone, gender_id])
            const person_id = resp.rows[0].id
            resp = await query('INSERT INTO auth.users (username, password, person_id, role_id, department_id, is_active) VALUES ($1,$2,$3,$4,$5,$6) RETURNING *', [username, hash, person_id, role_id, department_id, true])
            
            const resp2 = await query('INSERT INTO location (person_id, state_id, municipality_id, parish_id, address) VALUES ($1,$2,$3,$4,$5) RETURNING *', [person_id, state_id, municipality_id, parish_id, address])
            const data = Object.assign({}, resp.rows[0], resp2.rows[0])

            return res.json({ status: "OK", data: [data] })
        }
    } catch (error) {
        httpError(res, error)
    }
}

const updateItem = async (req, res) => {
    try {
        const id = req.params.id
        // Verifica que la id solo sea numerico
        if (onlyNumbers(req.params.id)) {
            if ('person' in req.body) {
                const { columns, values } = req.body.person;
                if ('status' in checkColEqVal(columns,values)) {
                    res.status(401).json({status:"TEST",data:{columns,values}})
                } 
                console.log("Esto no se debe de ver")
            }else{
                res.status(200).json({status:"TEST",data:"No existe person"})
            }

            if ('user' in req.body) {
                const { columns, values } = req.body.user;
                res.status(200).json({status:"TEST",data:{columns,values}})
            }else{
                res.status(200).json({status:"TEST",data:"No existe person"})
            }

            if ('location' in req.body) {
                const { columns, values } = req.body.location;
                res.status(200).json({status:"TEST",data:{columns,values}})
            }else{
                res.status(200).json({status:"TEST",data:"No existe person"})
            }
            // {
            //     "person":{
            //         "columns":["first_name","other_names"],
            //         "values":["Nicolas", "Jose"]
            //     },
            //     "user":{
            //         "columns":["role"],
            //         "values":[2]
            //     },
            //     "location":{
            //         "columns":["state"],
            //         "values":[13]
            //     }
            // }

            // // Verifica que "columns" y "values" son arrays de igual longitud
            // if (!Array.isArray(columns) || !Array.isArray(values) || columns.length !== values.length) {
            //     return res.status(400).send({
            //         status: "FAILED",
            //         data: {
            //             error: 'Request body inválido'
            //         }
            //     })
            // }

            // // extrae los valores de "columns" y "values" para formar la clausula SET del Update
            // const newQuery = columns.map((col, i) => `${col} = $${i + 1}`)

            // const textQuery = `UPDATE auth.users SET ${newQuery} WHERE id = ${id} RETURNING *`
            // const varQuery = values

            // const resp = await query(textQuery, varQuery);
            // res.json({ status: "OK", data: resp.rows });
        } else {
            res.status(400).json({
                status: "FAILED",
                data: {
                    error: `'${id}': No es un valor válido! Debe de ser solo números y no un string`,
                },
            })
        }
    } catch (error) {
        httpError(res, error)
    }
}

const deleteItem = async (req, res) => {
    try {
        const response = await query('SELECT * FROM auth.users')
        res.json({ data: response.rows })
    } catch (error) {
        httpError(res, error)
    }
}

module.exports = { getItem, getItems, createItem, updateItem, deleteItem }