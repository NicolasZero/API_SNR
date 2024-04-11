const httpError = (res, err) =>{
    console.log(err)
    res.status(500).json({
        status: "FAILED",
        data:{error:'Error de servidor'}
    })
}

module.exports = httpError