const {Router} = require('express')
const router = Router()
const {authUser,registerUser,refreshToken} = require('../controllers/auth')

router.post('/login',authUser)//{username,password}
router.post('/refresh',refreshToken)
// router.post('/register',registerUser) //{username,password,rol_id,department_id,person_id}

module.exports = router