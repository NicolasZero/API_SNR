const bcrypt = require('bcryptjs')

const encrypt = async (text) => {
    const hash = await bcrypt.hashSync(text, 10);
    return hash
}

const compare = async (password, hashPassword) =>{
    return await bcrypt.compare(password,hashPassword)
}

module.exports = {
    encrypt,
    compare
}