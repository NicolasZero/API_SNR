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
    const value = [req.params.value];
    if (onlyNumbers(req.params.value)) {
      const text = `SELECT * FROM persons WHERE ${column}=$1`;
      const response = await query(text, value);
      res.json({ data: response.rows });
    } else {
      res.status(400).json({
        status: "FAILED",
        data: {
          error: `'${value}': No es un valor válido! Debe de ser solo números y no un string`,
        },
      });
    }
  } catch (error) {
    httpError(res, error);
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
    const varQuery = [identity_card,is_foreign,first_name,other_names,first_last_name,other_last_names,email,phone,gender_id,]
    const textQuery = "INSERT INTO persons (identity_card, is_foreign, first_name, other_names, first_last_name, other_last_names, email, phone, gender_id) VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9) RETURNING id"
    const resp = await query(textQuery,varQuery);
    res.json({ status:"OK", data: resp.rows });
  } catch (error) {
    httpError(res, error);
  }
};

const updateItem = async (req, res) => {
  try {

    const { columns, values } = req.body;

    if (!Array.isArray(columns) || !Array.isArray(values) || columns.length !== values.length) {
        return res.status(400).send({
            status:"FAILED",
            data:{
                error:'Inválido request body'
            }
        })
    }

    // const textQuery = "UPDATE persons SET ContactName = $1, City= $2 WHERE CustomerID = $3"
    const textQuery = `${columns}`
    
    res.json({msj:textQuery})
    // const varQuery = []
    // const response = await query(textQuery,varQuery);
    // res.json({status:"OK", data: response.rows });
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
