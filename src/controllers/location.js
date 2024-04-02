const httpError = require('../helpers/helperError')
const { query } = require('../../config/postgresql')

const stateBy = (column) => async (req, res) => {
    try {
        const val = column == "state" ? req.params.val.toUpperCase() : req.params.val

        const response = await query(`SELECT * FROM states WHERE ${column} = $1`, [val])
        res.json({ status: "OK", data: response.rows })
    } catch (error) {
        httpError(res, error)
    }
}

const statesAll = async (req, res) => {
    try {
        const response = await query('SELECT * FROM states')
        res.json({ status: "OK", data: response.rows })
    } catch (error) {
        httpError(res, error)
    }
}

const municipalityBy = (column) => async (req, res) => {
    try {
        const val = column == "municipality" ? req.params.val.toUpperCase() : req.params.val

        const response = await query(`SELECT id, municipality FROM municipalities WHERE ${column} = $1`, [val])
        res.json({ status: "OK", data: response.rows })
    } catch (error) {
        httpError(res, error)
    }
}

const municipalitiesAll = async (req, res) => {
    try {
        const response = await query('SELECT id, municipality FROM municipalities')
        res.json({ status: "OK", data: response.rows })
    } catch (error) {
        httpError(res, error)
    }
}

const parishBy = (column) => async (req, res) => {
    try {
        const val = column == "parish" ? req.params.val.toUpperCase() : req.params.val

        const response = await query(`SELECT id, parish FROM parishes WHERE ${column} = $1`, [val])
        res.json({ status: "OK", data: response.rows })
    } catch (error) {
        httpError(res, error)
    }
}

const parishAll = async (req, res) => {
    try {
        const response = await query('SELECT id, parish FROM parishes')
        res.json({ status: "OK", data: response.rows })
    } catch (error) {
        httpError(res, error)
    }
}

module.exports = { stateBy, statesAll, municipalitiesAll, municipalityBy, parishAll, parishBy}