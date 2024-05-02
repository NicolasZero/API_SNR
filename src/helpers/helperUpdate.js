// Verifica que "columns" y "values" son arrays de igual longitud
const checkColEqVal = (columns, values) => async (req, res, next) => {
    try {
        if (!Array.isArray(columns) || !Array.isArray(values) || columns.length !== values.length) {
            return res.status(400).send({
                status: "FAILED",
                data: {
                    error: 'Request body inválido'
                }
            })
        }else{
            next()
        }
    } catch (error) {
        console.log(error);
        res.status(409).json({status: "FAILED", error: "Error de servidor" });
    }
}

module.exports = {
    checkColEqVal
}