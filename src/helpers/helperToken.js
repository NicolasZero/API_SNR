const jwt = require('jsonwebtoken')

const tokenSign = async (user) => {
    return jwt.sign(
        {
            _id: user._id,
            role: user.role,
            department: user.department
        },
        process.env,JWT_SECRET,
        {
            expiresIn: "2h",
        }
    )
}