const {Router} = require('express')
const router = Router()
const checkAuth = require('../middleware/checkAuth')
const checkRoleAuth = require('../middleware/checkRoleAuth')
const {createItem,deleteItem,getItem,getItems,updateItem} = require('../controllers/users')

router.get('/',checkAuth, checkRoleAuth([1,2]),getItems)

router.get('/:id', checkAuth, checkRoleAuth([1,2]),getItem)//id

router.post('/',checkAuth, checkRoleAuth([1,2]),createItem)

router.patch('/:id',checkAuth, checkRoleAuth([1,2]),updateItem)

router.delete('/:id',checkAuth, checkRoleAuth([1,2]),deleteItem)

module.exports = router