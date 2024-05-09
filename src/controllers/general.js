const httpError = require('../helpers/helperError')
const { query } = require('../../config/postgresql')

const generalsOptions = async (req, res) => {
    try {
        const civilStatus = await query('SELECT * FROM civil_status')
        const ethnicity = await query('SELECT * FROM ethnicity')
        const genders = await query('SELECT * FROM genders')
        
        return res.json({ 
            status: "OK", 
            data: {
                civilStatus: civilStatus.rows,
                ethnicity: ethnicity.rows,
                genders: genders.rows
            }
        })
    } catch (error) {
        httpError(res, error)
    }
}

module.exports = {
    generalsOptions
}
