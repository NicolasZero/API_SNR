const {Router} = require('express')
const router = Router()
const fs = require('fs')

const pathRouter = `${__dirname}`

const removeExtension = (fileName) =>{
    return fileName.split('.').shift()
} 

fs.readdirSync(pathRouter).filter((file)=>{
    const fileName = removeExtension(file)
    const skip = ['index','docs'].includes(fileName)
    if (!skip) {
        router.use(`/${fileName}`,require(`./${fileName}`))
        // console.log('--->',fileName)
    }
})

router.get('*',(req,res) => {
    res.status(404)
    res.send({error:'Not found'})
})

// const {getUsers, createUser, authUser, registerPerson, getPersons, pruebas} = require('../controllers/index.controller')

// router.get('/', (req, res) => {
//     res.setHeader('Content-Type', 'text/html')
//     res.send('<img src="https://i1.sndcdn.com/artworks-000205716223-76o1tw-t500x500.jpg"/><h2>Hello Everynyan ᓬ:3</h2>')
// });

// router.get('/users', getUsers);

// router.get('/pruebas/:val',pruebas)

// router.get('/persons', getPersons)
// router.post('/persons', registerPerson)

// router.post('/auth/register', createUser);
// router.get('/auth/login', authUser)


module.exports = router