const {Router} = require('express')
const router = Router()
const {stateBy,statesAll,municipalitiesAll,municipalityBy, parishAll, parishBy} = require('../controllers/location')

router.get('/state',statesAll)
router.get('/state/id/:val',stateBy('id'))
router.get('/state/name/:val',stateBy('state'))

router.get('/municipality',municipalitiesAll)
router.get('/municipality/id/:val',municipalityBy('id'))
router.get('/municipality/state/:val',municipalityBy('state_id'))
// router.get('/',state)

router.get('/parish',parishAll)
router.get('/parish/id/:val',parishBy('id'))
router.get('/parish/municipality/:val',parishBy('municipality_id'))


module.exports = router