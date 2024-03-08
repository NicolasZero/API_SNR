const {Router} = require('express')
const router = Router()
const {createItem,deleteItem,getItem,getItems,updateItem} = require('../controllers/persons')

router.get('/',getItems)

router.get('/:ic',getItem) //identity_card

router.post('/',createItem)

router.patch('/:id',updateItem)

router.delete('/:id',deleteItem)

module.exports = router