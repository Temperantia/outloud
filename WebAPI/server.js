/*
 * Filename: c:\Users\50448\Source\Repos\inclusive\WebAPI\server.js
 * Path: c:\Users\50448\Source\Repos\inclusive\WebAPI
 * Created Date: Monday, July 15th 2019, 12:45:28 am
 * Author: 50448
 * 
 * Copyright (c) 2019 Inclusive
 */

// server.js
import express from 'express';
const app = express()
import models, { sequelize } from './src/';

app.get('/', (req, res) => {
    return res.send('Received a GET HTTP method');
  });

app.post('/users/register', async  (req, res) => {
  await models.User.create(
    {
      username: 'firstGay',
      messages: [
        {
          text: 'faker hhh',
        },
      ],
    },
    {
      include: [models.Message],
    },
  );

  return res.send('user created');
});
app.put('/', (req, res) => {
  return res.send('Received a PUT HTTP method');
});

app.delete('/', (req, res) => {
  return res.send('Received a DELETE HTTP method');
});

const eraseDatabaseOnSync = true;

sequelize.sync({ force: eraseDatabaseOnSync }).then(async () => {
    app.listen(3000, () => {
    })
});
