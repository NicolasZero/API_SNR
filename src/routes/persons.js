const {Router} = require('express')
const router = Router()
const checkAuth = require('../middleware/checkAuth')
const checkRoleAuth = require('../middleware/checkRoleAuth')
const {createItem,deleteItem,getItem,getItems,updateItem,getItemById} = require('../controllers/persons')

router.get('/',checkAuth, checkRoleAuth([1,2]),getItems)

router.get('/id/:ic',checkAuth, checkRoleAuth([1,2]),getItemById) //id

router.get('ic/:ic',checkAuth, checkRoleAuth([1,2]),getItem) //identity_card

router.post('/',checkAuth, checkRoleAuth([1,2]),createItem)

router.patch('/:id',checkAuth, checkRoleAuth([1,2]),updateItem)

router.delete('/:id',checkAuth, checkRoleAuth([1,2]),deleteItem)

module.exports = router