/*
 * Filename: c:\Users\50448\Source\Repos\inclusive\WebAPI\server.js
 * Path: c:\Users\50448\Source\Repos\inclusive\WebAPI
 * Created Date: Monday, July 15th 2019, 12:45:28 am
 * Author: 50448
 *
 * Copyright (c) 2019 Inclusive
 */

import express from 'express';
import bearerToken from 'express-bearer-token';
import bodyParser from 'body-parser';
import './env';

const app = express();

app.use(bodyParser.json());
app.use(bearerToken());

import { sequelize } from './models';
import { userRouter } from './routes';

app.use('/user', userRouter);

sequelize
  .sync()
  .then(() => {
    app.listen(3000);
  });
