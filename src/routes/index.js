const {Router} = require('express')
const router = Router()

const {getUsers, createUser, authUser, registerPerson, getPersons, pruebas} = require('../controllers/index.controller')

router.get('/', (req, res) => {res.send('Hello Everynyan ᓬ:3');});

router.get('/users', getUsers);

router.get('/pruebas/:val',pruebas)

router.get('/persons', getPersons)
router.post('/persons', registerPerson)

router.post('/auth/register', createUser);
router.get('/auth/login', authUser)


module.exports = router