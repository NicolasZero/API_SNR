const httpError = require('../helpers/helperError')
const pool = require('../../config/postgresql')


const getItems = async (req,res) => {
    try {
        const response = await pool.query('SELECT * FROM auth.users')
        res.json({ data: response.rows})
    } catch (error) {
        httpError(res,error)
    }
}

const getItem = async (req,res) => {
    try {
        const id = req.params.id
        const response = await pool.query('SELECT * FROM auth.users WHERE id=$1',[id])
        res.json({ data: response.rows})
    } catch (error) {
        httpError(res,error)
    }
}

const createItem = async (req,res) => {
    try {
        const response = await pool.query('SELECT * FROM auth.users')
        res.json({ data: response.rows})
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