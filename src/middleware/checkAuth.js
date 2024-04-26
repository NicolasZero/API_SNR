const { verifyToken } = require("../helpers/helperToken");

const checkAuth = async (req, res, next) => {
  try {
    if (req.headers.authorization) {
      const token = req.headers.authorization.split(" ").pop();
      const tokenData = await verifyToken(token);
      if (tokenData) {
        next();
      } else {
        return res.status(409).send({
          status: "FAILED",
          data: { error: "Tú, no pasaras" }
        });
      }
    } else {
      return res.status(409).send({
        status: "FAILED",
        data: { error: "Falta auntentificación" }
      })
    }

  } catch (error) {
    console.log(error);
    res.status(409).send({
      status: "FAILED",
      data: { error: "Ocurrio un error" }
    });
  }
};

module.exports = checkAuth