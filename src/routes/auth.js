const {Router} = require('express')
const router = Router()
const {authUser,refreshToken} = require('../controllers/auth')

router.post('/login',authUser)//{username,password}
router.post('/refresh',refreshToken)

module.exports = router