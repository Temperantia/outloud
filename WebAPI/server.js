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
console.debug(models);

app.get('/', (req, res) => {
    return res.send('Received a GET HTTP method');
  });
  
  app.post('/users/register', async  (req, res) => {
      console.log(req)
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
    if (eraseDatabaseOnSync) {
  //      createUsersWithMessages();
      }
    app.listen(3000, () => {
      console.log(`Example app listening!`);
    })
});
/*
const createUsersWithMessages = async () => {
    await models.User.create(
      {
        username: 'rwieruch',
        messages: [
          {
            text: 'Published the Road to learn React',
          },
        ],
      },
      {
        include: [models.Message],
      },
    );
  
    await models.User.create(
      {
        username: 'ddavids',
        messages: [
          {
            text: 'Happy to release ...',
          },
          {
            text: 'Published a complete ...',
          },
        ],
      },
      {
        include: [models.Message],
      },
    );
  };
*/