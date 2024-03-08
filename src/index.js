const express =  require('express');
const app = express();
require('dotenv').config()

const port = process.env.API_PORT || 3000;

//middlewares
app.use(express.json())
app.use(express.urlencoded({extended:false}))

// routes
app.use('/api/1.0',require('./routes/index'))

app.listen(port, ()=>{
    console.log(`Puerto ${port} en linea`)
})
