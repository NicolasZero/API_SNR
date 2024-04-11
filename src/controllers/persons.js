const httpError = require("../helpers/helperError");
const { query } = require("../../config/postgresql");
const { onlyLetters, onlyNumbers } = require("../helpers/helperPattern");

// Consulta todos
const getItems = async (req, res) => {
  try {
    const response = await query("SELECT * FROM persons");
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
      const text = `SELECT * FROM persons WHERE ${column}=$1`;
      const response = await query(text, value)
      return res.json({ data: response.rows })
    } else {
      return res.status(400).json({
        status: "FAILED",
        data: {
          error: `'${value}': No es un valor válido! Debe de ser solo números y no un string`,
        },
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
      first_name,
      other_names,
      first_last_name,
      other_last_names,
      email,
      phone,
      gender_id,
    } = req.body;

    // Verifica que existan los campos obligatorios
    if (!identity_card && !first_name && !first_last_name && !gender_id) {
      return res.status(400).send({
        status: "FAILED",
        data: {
          error: 'Request body invalido'
        }
      })
    }

    // Verifica que la cedula de la persona no este registrada previamente
    const existPerson = await query('SELECT id FROM persons WHERE identity_card = $1', [identity_card])
    if (existPerson.rows.length !== 0) {
      return res.status(409).json({
        status: "FAILED",
        data: {
          error: `cedula repetida`,
          identity_card
        }
      })
    }

    const varQuery = [identity_card, is_foreign, first_name, other_names, first_last_name, other_last_names, email, phone, gender_id,]
    const textQuery = "INSERT INTO persons (identity_card, is_foreign, first_name, other_names, first_last_name, other_last_names, email, phone, gender_id) VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9) RETURNING *"
    const resp = await query(textQuery, varQuery);
    return res.json({ status: "OK", data: resp.rows });

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
      const { columns, values } = req.body;

      // Verifica que "columns" y "values" son arrays de igual longitud
      if (!Array.isArray(columns) || !Array.isArray(values) || columns.length !== values.length) {
        return res.status(400).send({
          status: "FAILED",
          data: {
            error: 'Request body inválido'
          }
        })
      }

      // extrae los valores de "columns" y "values" para formar la clausula SET del Update
      const newQuery = columns.map((col, i) => `${col} = $${i + 1}`)

      const textQuery = `UPDATE persons SET ${newQuery} WHERE id = ${id} RETURNING *`
      const varQuery = values

      const resp = await query(textQuery,varQuery);
      res.json({status:"OK", data: resp.rows });
    } else {
      res.status(400).json({
        status: "FAILED",
        data: {
          error: `'${id}': No es un valor válido! Debe de ser solo números y no un string`,
        },
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
