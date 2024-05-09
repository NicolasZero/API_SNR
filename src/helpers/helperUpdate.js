const { onlyLetters, onlyNumbers, onlyDbNamePattern } = require("./helperPattern");

// Verifica que la estructura de "columns" y "values" sean correcta
const checkColEqVal = (res, columns, values) => {
    // verifica que los nombres de las columnas sean posibles nombres permitidos
    const verifiedColumn = columns.filter(col => onlyDbNamePattern(col))

    // Verifica que "columns" y "values" son arrays de igual longitud
    if (!Array.isArray(verifiedColumn) || !Array.isArray(values) || verifiedColumn.length !== values.length || verifiedColumn.length !== columns.length) {
        res.status(409).send({
            status: "FAILED",
            error: { msj: 'Ocurrió un error al actualizar los datos' }
        })
        return false
    }else{
        return true
    }
}

// extrae los valores de "columns" para formar la clausula SET del Update
const setColAndVal = (columns) => {
    return columns.map((col, i) => `${col} = $${i + 1}`)
}

module.exports = {
    checkColEqVal,
    setColAndVal
}