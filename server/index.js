const _ = require('lodash');
const Promise = require('bluebird');
const express = require('express');
const bodyParser = require('body-parser');
const rp = require('request-promise');
const app = express();

app.use(bodyParser.text());

app.get('/', (req, res) => res.send('Poker hands digger server is running!'));

function printRound(name, data, players, previousCards, bet = 0) {
    let output = `*** ${name} `;
    if (data.CARD) {
        if (previousCards) {
            output += `[${previousCards}] `;
        }
        output += `[${data.CARD}]`;
    }
    output += ` ***\r\n`;

    data.PLAYER.forEach((object) => {
        output += `${players[object.NUMBER - 1].name}: `;
        if ('fold 0' === object.ACTION) {
            output += 'folds\r\n';
        } else if ('check 0' === object.ACTION) {
            output += 'checks\r\n';
        } else if (_.includes(object.ACTION, 'call')) {
            output += `calls $${object.ACTION.slice(5)}\r\n`;
        } else if (_.includes(object.ACTION, 'raise')) {
            const coins = Number(object.ACTION.slice(6));
            if (bet) {
                output += `raises $${coins} to $${coins + bet}\r\n`;
            } else {
                bet = coins;
                output += `bets $${coins}\r\n`;
            }
        }
    });
    return output
}

app.post('/parse', (req, res) => {
    Promise.any([
        Promise.delay(15000),
        rp(req.body)
    ]).then((htmlString) => {
        let slicedBody = htmlString;
        const startIndex = slicedBody.indexOf('parseJSON(\'{') + 11;
        slicedBody = slicedBody.slice(startIndex);
        const endIndex = slicedBody.indexOf('}\');') + 1;
        slicedBody = slicedBody.slice(0, endIndex);

        console.log(slicedBody);

        res.send(slicedBody);
    }).catch(() => {
        res.sendStatus(200);
    })


});

app.listen(process.env.PORT || 3000, () => console.log(`Poker hands digger server listening on port ${process.env.PORT || 3000}`));
