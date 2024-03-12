const {Router} = require('express')
const router = Router()
const {authUser,registerUser} = require('../controllers/auth')

router.post('/login',authUser)//{username,password}
router.post('/register',registerUser) //{username,password,rol_id,department_id,person_id}

module.exports = router