const {Router} = require('express')
const router = Router()
const {authUser,registerUser} = require('../controllers/auth')

router.post('/login',authUser)
router.post('/register',registerUser)


module.exports = router