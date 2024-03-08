const {Router} = require('express')
const router = Router()
const {createItem,deleteItem,getItem,getItems,updateItem} = require('../controllers/users')

router.get('/',getItems)

router.get('/:id',getItem)

router.post('/',createItem)

router.patch('/:id',updateItem)

router.delete('/:id',deleteItem)

module.exports = router