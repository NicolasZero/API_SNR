const { verifyToken } = require("../helpers/helperToken");

const checkAuth = async (req, res, next) => {
  try {
    const token = req.headers.authorization.split(" ").pop();
    const tokenData = await verifyToken(token);
    // console.log(tokenData);
    if (tokenData._id) {
      next();
    } else {
      res.status(409);
      res.send({status:"FAILED",
      data:{ error: "Tú, no pasaras" }});
    }
  } catch (error) {
    console.log(error);
    res.status(409);
    res.send({status:"FAILED",
    data:{ error: "Tú, no pasaras" }});
  }
};

module.exports = checkAuth