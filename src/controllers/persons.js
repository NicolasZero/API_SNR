const httpError = require("../helpers/helperError");
const { query } = require("../../config/postgresql");
const { onlyLetters, onlyNumbers } = require("../helpers/helperPattern");

const getItems = async (req, res) => {
  try {
    const response = await query("SELECT * FROM persons");
    res.json({ status: "OK", data: response.rows });
  } catch (error) {
    httpError(res, error);
  }
};

const getItem = (column) => async (req, res) => {
  try {
    const value = [req.params.value]
    if (onlyNumbers(req.params.value)) {
      const text = `SELECT * FROM persons WHERE ${column}=$1`;
      const response = await query(text, value)
      res.json({ data: response.rows })
    } else {
      res.status(400).json({
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
    // Verifica que "columns" y "values" son arrays de igual longitud
    if (!identity_card && !first_name && !first_last_name && !gender_id) {
      return res.status(400).send({
        status: "FAILED",
        data: {
          error: 'Request body inválido'
        }
      })
    }
    const varQuery = [identity_card, is_foreign, first_name, other_names, first_last_name, other_last_names, email, phone, gender_id,]
    const textQuery = "INSERT INTO persons (identity_card, is_foreign, first_name, other_names, first_last_name, other_last_names, email, phone, gender_id) VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9) RETURNING id"
    const resp = await query(textQuery, varQuery);
    res.json({ status: "OK", data: resp.rows });
  } catch (error) {
    httpError(res, error)
  }
};

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

const deleteItem = async (req, res) => {
  try {
    const response = await query("SELECT * FROM persons");
    res.json({ data: response.rows });
  } catch (error) {
    httpError(res, error);
  }
};

module.exports = { getItem, getItems, createItem, updateItem, deleteItem };
