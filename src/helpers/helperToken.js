const jwt = require('jsonwebtoken')

const tokenSign = async (user) => {
    return jwt.sign(
        {
            _id: user.id,
            role: user.role,
            department: user.department,
            is_active: user.is_active
        },
        process.env.JWT_SECRET,
        {
            expiresIn: "2h",
        }
    )
}

const verifyToken = async (token) => {
try {
    return jwt.verify(token,process.env.JWT_SECRET)
} catch (e) {
    return null
}
}

module.exports ={
    tokenSign,
    verifyToken
}