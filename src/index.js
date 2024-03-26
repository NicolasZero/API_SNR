const express =  require('express');
const cors = require('cors')
const {swaggerDocs: v1SwaggerDocs} = require('./routes/docs')

require('dotenv').config()
const app = express();
const port = process.env.API_PORT || 3000;
app.use(cors()) // Todo el mundo

//middlewares
app.use(express.json())
app.use(express.urlencoded({extended:false}))

// routes
app.use('/api/1.0',require('./routes/index'))

// app.use('/docs',require('./routes/docs'))

app.listen(port, ()=>{
    console.log(`Puerto ${port} en linea`)
    v1SwaggerDocs(app, port)
})
