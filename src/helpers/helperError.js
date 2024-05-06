const httpError = (res, err) =>{
    console.log(err)
    res.status(500).json({
        status: "FAILED",
        error:{msg:'Ocurrió un error con el servidor'}
    })
}

module.exports = httpError