const {Router} = require("express")
const router = Router()
const {generalsOptions} = require("../controllers/general")

router.get('/',generalsOptions)

module.exports = router