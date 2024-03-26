const {Router} = require('express')
const router = Router()
const checkAuth = require('../middleware/checkAuth')
const checkRoleAuth = require('../middleware/checkRoleAuth')
const {createItem,deleteItem,getItem,getItems,updateItem} = require('../controllers/persons')

router.get('/',checkAuth, checkRoleAuth([1,2]), getItems)

router.get('/id/:value',checkAuth, checkRoleAuth([1,2]),getItem('id'))

router.get('/ic/:value',checkAuth, checkRoleAuth([1,2]),getItem('identity_card'))

router.put('/',checkAuth, checkRoleAuth([1,2]),createItem)

router.patch('/:id',updateItem)

router.delete('/:id',checkAuth, checkRoleAuth([1,2]),deleteItem)

module.exports = router