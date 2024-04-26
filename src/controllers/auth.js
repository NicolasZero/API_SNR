const httpError = require("../helpers/helperError");
const { encrypt, compare } = require("../helpers/helperEncrypt.js");
const {query} = require("../../config/postgresql");
const { tokenSign,verifyToken } = require("../helpers/helperToken.js");

const authUser = async (req, res) => {
  try {
    const { username, password } = req.body;
    const response = await query("SELECT * FROM view_user_data WHERE username = $1",[username])
    const passwordInDb = response.rows.length !== 0 ? response.rows[0].password : false;

    if (passwordInDb !== false) {
      const checkPass = await compare(password, response.rows[0].password);
      const tokenSession = await tokenSign(response.rows[0]);
      if (checkPass) {
        res.json({
          status:"OK",
          data: response.rows,
          tokenSession,
        });
      } else {
        res.status(409).json({ error: { msg: "Usuario o contraseña no coinciden" } });
      }
    } else {
      res.status(409).json({ error: { msg: "Usuario o contraseña no coinciden" } });
    }
  } catch (error) {
    httpError(res, error);
  }
};

const refreshToken = async (req, res) => {
  const refreshToken = req.headers.refresh
  const tokenData = await verifyToken(refreshToken)
  if (tokenData) {
    const tokenSession = await tokenSign({id:tokenData._id});
    return res.json({
      status: "OK",
      data: "refreshed",
      tokenSession
    })
  } else {
    return res.status(409).send({
      status: "FAILED",
      data: { error: "Tú, no pasaras" }
    })
  }
}

module.exports = { authUser, refreshToken };
