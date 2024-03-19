const httpError = require('../helpers/helperError')
const pool = require('../../config/postgresql')

const getItems = async (req,res) => {
    try {
        const response = await pool.query('SELECT * FROM persons')
        res.json({ data: response.rows})
    } catch (error) {
        httpError(res,error)
    }
}

const getItem = async (req,res) => {
    try {
        const ic = req.params.ic
        const response = await pool.query('SELECT * FROM persons WHERE identity_card=$1',[ic])
        res.json({ data: response.rows})
    } catch (error) {
        httpError(res,error)
    }
}

const getItemById = async (req,res) => {
    try {
        const ic = req.params.id
        const response = await pool.query('SELECT * FROM persons WHERE id=$1',[id])
        res.json({ data: response.rows})
    } catch (error) {
        httpError(res,error)
    }
}

const createItem = async (req,res) => {
    try {
        const response = await pool.query('SELECT * FROM persons WHERE identity_card=$1',[ic])
        res.json({ data: response.rows})
    } catch (error) {
        httpError(res,error)
    }
}

const updateItem = async (req,res) => {
    try {
        const response = await pool.query('SELECT * FROM persons')
        res.json({ data: response.rows})
    } catch (error) {
        httpError(res,error)
    }
}

const deleteItem = async (req,res) => {
    try {
        const response = await pool.query('SELECT * FROM persons')
        res.json({ data: response.rows})
    } catch (error) {
        httpError(res,error)
    }
}

module.exports = {getItem,getItems,createItem,updateItem,deleteItem,getItemById}