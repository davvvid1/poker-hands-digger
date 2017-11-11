const express = require('express');
const bodyParser = require('body-parser');
const app = express();

app.use(bodyParser.text());

app.get('/', (req, res) => res.send('Hello World!'));

app.post('/parse', (req, res) =>
{
    let slicedBody = req.body;
    const startIndex = slicedBody.indexOf('parseJSON(\'{') + 11;
    slicedBody = slicedBody.slice(startIndex);
    const endIndex = slicedBody.indexOf('}\');') + 1;
    slicedBody = slicedBody.slice(0, endIndex);

    console.log(JSON.parse(slicedBody));

    res.sendStatus(200);

});

app.listen(process.env.PORT || 3000, () => console.log('Example app listening on port 3000!'));
