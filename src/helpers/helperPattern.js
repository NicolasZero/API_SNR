const onlyLetters = (val) => {
    const pattern = /^[A-Za-z]+$/
    return val.match(pattern) ? true : false
}

const onlyNumbers = (val) => {
    const pattern = /^[0-9]+$/
    return val.match(pattern) ? true : false
}

module.exports = {
    onlyLetters,
    onlyNumbers
}