const {Router} = require('express')
const router = Router()
const checkAuth = require('../middleware/checkAuth')
const checkRoleAuth = require('../middleware/checkRoleAuth')
const {createItem,changeStatus,getItem,getItems,updateItem} = require('../controllers/users')

router.get('/',checkAuth, checkRoleAuth([1,2]),getItems)

router.get('/:id', checkAuth, checkRoleAuth([1,2]),getItem)

router.put('/',checkAuth, checkRoleAuth([1,2]),createItem) //const {username,password,rol_id,department_id,identity_card,is_foreign,first_name,other_names,first_last_name,other_last_names,email,phone,gender_id}

router.patch('/:id',checkAuth, checkRoleAuth([1,2]),updateItem)

// body {
//     "user":{
//         "columns":["names","last_names"],
//         "values":["Nicolás José", "zapata Morillo"]
//     },
//     "location":{
//         "columns":["address"],
//         "values":["Mikasa 2"]
//     }
// }

router.patch('/activate/:id',checkAuth, checkRoleAuth([1,2]),changeStatus(true))
router.delete('/:id',checkAuth, checkRoleAuth([1,2]),changeStatus(false))


module.exports = router