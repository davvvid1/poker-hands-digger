const _ = require('lodash');
const express = require('express');
const bodyParser = require('body-parser');
const app = express();

app.use(bodyParser.text());

app.get('/', (req, res) => res.send('Poker hands digger server is running!'));

function printRound(name, data, players, previousCards, bet = 0)
{
    let output = `*** ${name} `;
    if (data.CARD) {
        if (previousCards) {
            output += `[${previousCards}] `;
        }
        output += `[${data.CARD}]`;
    }
    output += ` ***\r\n`;

    data.PLAYER.forEach((object) =>
    {
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

app.post('/parse', (req, res) =>
{
    let slicedBody = req.body;
    const startIndex = slicedBody.indexOf('parseJSON(\'{') + 11;
    slicedBody = slicedBody.slice(startIndex);
    const endIndex = slicedBody.indexOf('}\');') + 1;
    slicedBody = slicedBody.slice(0, endIndex);

    const parsedBody = JSON.parse(slicedBody).STAGE;
    const table = parsedBody.TABLE;
    const smallBlind = Number(table.SBLIND.CHIPS);
    const bigBlind = Number(table.BBLIND.CHIPS);
    const game = parsedBody.POKERCARD;

    const players = parsedBody.TABLE.SEAT.map((seat) => ({
        name: seat.NAME,
        chips: seat.CHIPS,
        number: seat.NUMBER
    }));


    let winPlayers = [];
    let previousCards = '';
    let output = '';
    output += `PokerStars Hand #${Date.now()}:  Hold'em No Limit ($${smallBlind}/$${bigBlind} USD) - ${parsedBody.TIME}\r\n`;
    output += `Table '${parsedBody.TIME}' ${table.SEATS}-max Seat #${table.DEALER} is the button\r\n`;
    players.forEach((player) =>
    {
        output += `Seat ${player.number}: ${player.name} ($${player.chips} in chips)\r\n`;
    });
    output += `${players[0].name}: posts small blind $${smallBlind}\r\n`;
    output += `${players[1].name}: posts big blind $${bigBlind}\r\n`;
    output += printRound('HOLE CARDS', game.PREFLOP, players, null, bigBlind);
    if (game.FLOP) {
        output += printRound('FlOP', game.FLOP, players);
    }
    if (game.TURN) {
        previousCards += game.FLOP.CARD;
        output += printRound('TURN', game.TURN, players, previousCards);
    }
    if (game.RIVER) {
        previousCards += ` ${game.TURN.CARD}`;
        output += printRound('RIVER', game.RIVER, players, previousCards);
    }
    if (1 < parsedBody.SHOWDOWN.PLAYER.length) {
        output += `*** SHOW DOWN ***\r\n`;
        parsedBody.SHOWDOWN.PLAYER.forEach((player) =>
        {
            if (_.includes(player.ACTION, 'win')) {
                winPlayers.push(player);
                players[player.NUMBER - 1].win = player.ACTION.slice(4);
            }
            if (_.includes(player.ACTION, 'noshow')) {
                output += `${players[player.NUMBER - 1].name}: mucks hand\r\n`;
            } else {
                output += `${players[player.NUMBER - 1].name}: shows [${player.CARD}]\r\n`;
            }
        })
    } else {
        const player = parsedBody.SHOWDOWN.PLAYER[0];
        winPlayers.push(player);
        if (_.includes(player.ACTION, 'noshow')) {
            players[player.NUMBER - 1].win = player.ACTION.slice(7);
        } else {
            players[player.NUMBER - 1].win = player.ACTION.slice(5);
        }
    }
    winPlayers.forEach((player) =>
    {
        output += `${players[player.NUMBER - 1].name} collected ${players[player.NUMBER - 1].win} from pot\r\n`;
    });
    output += `*** SUMMARY ***\r\n`;
    players.forEach((player) =>
    {
        if (player.win) {
            output += `Seat ${player.number}: ${player.name} collected $${player.win}\r\n`;

        } else {
            output += `Seat ${player.number}: ${player.name} folded\r\n`;
        }
    });

    console.log(output);

    res.send(output);
});

app.listen(process.env.PORT || 3000, () => console.log(`Poker hands digger server listening on port ${process.env.PORT || 3000}`));
