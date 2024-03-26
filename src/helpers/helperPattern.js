const onlyLetters = (val, exception = '') => {
    
    const pattern = /^[A-Za-zñÑáéíóúÁÉÍÓÚüÜ]+$/
    return val.match(pattern) ? true : false
}

const onlyNumbers = (val, exception = '') => {
    const pattern = /^[0-9]+$/
    return val.match(pattern) ? true : false
}

const onlyLettersAndNumbes = (val, exception = '') => {
    const pattern = /^[0-9A-Za-zñÑáéíóúÁÉÍÓÚüÜ]+$/
    return val.match(pattern) ? true : false
}

module.exports = {
    onlyLetters,
    onlyNumbers,
    onlyLettersAndNumbes
}