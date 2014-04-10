express = require 'express'
path = require 'path'

app = express()

rootDir = path.resolve __dirname,".."
app.use express.static rootDir

app.get "/", (req, res)-> res.render(rootDir+'/index.html')

app.listen 3000

console.log "running localhost on port 3000"