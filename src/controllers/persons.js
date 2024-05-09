const httpError = require("../helpers/helperError");
const { query } = require("../../config/postgresql");
const { onlyLetters, onlyNumbers, onlyDbNamePattern } = require("../helpers/helperPattern");

// Consulta todos
const getItems = async (req, res) => {
    try {
        const response = await query("SELECT * FROM view_person_data");
        res.json({ status: "OK", data: response.rows });
    } catch (error) {
        httpError(res, error);
    }
};

// consulta 1 solo por id o cedula
const getItem = (column) => async (req, res) => {
    try {
        const value = [req.params.value]
        if (onlyNumbers(req.params.value)) {
            const text = `SELECT * FROM view_person_data WHERE ${column}=$1`;
            const response = await query(text, value)
            return res.json({ data: response.rows })
        } else {
            return res.status(400).json({
                status: "FAILED",
                error: { msg: 'Error, identificador no válido' },
            })
        }
    } catch (error) {
        httpError(res, error)
    }
};

// inserta
const createItem = async (req, res) => {
    try {
        const {
            identity_card,
            is_foreign,
            names,
            last_names,
            email,
            phone,
            phone2,
            birthdate,
            pregnant,
            num_children,
            civil_status_id,
            ethnicity_id,
            gender_id,
            state_id,
            municipality_id,
            parish_id,
            address
        } = req.body;

        // Verifica que existan los campos obligatorios
        if (!identity_card && !names && !last_names && !gender_id) {
            return res.status(409).send({
                status: "FAILED",
                error: { msg: 'Los campos obligatorios no pueden estar vácios' }
            })
        }

        // Verifica que la cedula de la persona no este registrada previamente
        const existPerson = await query('SELECT id FROM general.persons WHERE identity_card = $1', [identity_card])
        if (existPerson.rows.length !== 0) {
            return res.status(409).json({
                status: "FAILED",
                error: { msg: `Ya existe un registro con esa cédula: ${identity_card}` },
            })
        }

        let varQuery = [identity_card, is_foreign, names, last_names, email, phone, phone2, birthdate, pregnant, num_children, civil_status_id, ethnicity_id, gender_id]
        let textQuery = "INSERT INTO general.persons (identity_card,is_foreign,names,last_names,email,phone,phone2,birthdate,pregnant,num_children,civil_status_id,ethnicity_id,gender_id) VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13) RETURNING id"
        const resp1 = await query(textQuery, varQuery);

        const person_id = resp1.rows[0].id

        varQuery = [person_id, state_id, municipality_id, parish_id, address]
        textQuery = 'INSERT INTO general.location (person_id, state_id, municipality_id, parish_id, address) VALUES ($1,$2,$3,$4,$5)'
        const resp2 = await query(textQuery, varQuery);
        return res.json({ status: "OK", data: { msg: "Los datos se registraron correctamente" }});

    } catch (error) {
        httpError(res, error)
    }
};

// actualiza
const updateItem = async (req, res) => {
    try {
        const id = req.params.id
        // Verifica que la id solo sea numerico
        if (onlyNumbers(req.params.id)) {
            // const { columns, values } = req.body;
            let checkProcess = false

            if ('person' in req.body) {
                const { columns, values } = req.body.person;
                if (checkColEqVal(res, columns, values)) {
                    const newQuery = setColAndVal(columns)
                    const textQuery = `UPDATE general.persons SET ${newQuery} WHERE id = ${id}`
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
                    const textQuery = `UPDATE general.location SET ${newQuery} WHERE person_id = ${id}`
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
                    error: { msj: 'Ocurrió un error al actualizar los datos' }
                })
            }
        } else {
            return res.status(409).json({
                status: "FAILED",
                error: { msj: 'Error, identificador no válido' },
            })
        }
    } catch (error) {
        httpError(res, error);
    }
};

// elimina
const deleteItem = async (req, res) => {
    try {
        const response = await query("SELECT * FROM persons");
        res.json({ data: response.rows });
    } catch (error) {
        httpError(res, error);
    }
};

module.exports = { getItem, getItems, createItem, updateItem, deleteItem };
