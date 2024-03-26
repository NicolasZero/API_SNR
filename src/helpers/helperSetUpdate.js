// Helper function to generate SET clause for UPDATE operation
// ES: Función auxiliar para generar la cláusula SET para la operación ACTUALIZAR
const generateSetClause = (columns, values) => {
    return columns.map((col, index) => `${col} = '${values[index]}'`).join(', ');
};

module.exports = {generateSetClause}