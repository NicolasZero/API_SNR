const httpError = require("../helpers/helperError");
const { encrypt, compare } = require("../helpers/helperEncrypt.js");
const {query} = require("../../config/postgresql");
const { tokenSign } = require("../helpers/helperToken.js");

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

const registerUser = async (req, res) => {
  try {
    const { username, password, rol_id, department_id, person_id } = req.body;
    const passwordHash = await encrypt(password);
    const resp = await query(
      "INSERT INTO auth.users (username, password, person_id, rol_id, department_id) VALUES ($1,$2,$3,$4,$5) RETURNING id",
      [username, passwordHash, person_id, rol_id, department_id]
    );
    res.json({ data: resp.rows });
  } catch (error) {
    httpError(res, error);
  }
};

module.exports = { authUser, registerUser };
