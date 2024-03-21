const {Router} = require('express')
const router = Router()
const checkAuth = require('../middleware/checkAuth')
const checkRoleAuth = require('../middleware/checkRoleAuth')
const {createItem,deleteItem,getItem,getItems,updateItem} = require('../controllers/users')

router.get('/',checkAuth, checkRoleAuth([1,2]),getItems)

router.get('/:id', checkAuth, checkRoleAuth([1,2]),getItem)

router.put('/',checkAuth, checkRoleAuth([1,2]),createItem) //const {username,password,rol_id,department_id,identity_card,is_foreign,first_name,other_names,first_last_name,other_last_names,email,phone,gender_id}

router.patch('/:id',checkAuth, checkRoleAuth([1,2]),updateItem)

router.delete('/:id',checkAuth, checkRoleAuth([1,2]),deleteItem)

module.exports = router