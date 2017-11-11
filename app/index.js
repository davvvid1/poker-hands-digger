const express = require('express');
const bodyParser = require('body-parser');
const app = express();

app.use(bodyParser.text());

app.get('/', (req, res) => res.send('Hello World!'));

app.post('/parse', (req, res) =>
{
    console.log(req.body);
    res.sendStatus(200);

});

app.listen(process.env.PORT || 3000, () => console.log('Example app listening on port 3000!'));
