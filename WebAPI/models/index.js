/*
 * Filename: c:\Users\50448\Source\Repos\inclusive\WebAPI\src\models\index.js
 * Path: c:\Users\50448\Source\Repos\inclusive\WebAPI
 * Created Date: Monday, July 15th 2019, 4:00:55 am
 * Author: 50448
 *
 * Copyright (c) 2019 Inclusive
 */

import Sequelize from 'sequelize';

const sequelize = new Sequelize(process.env.DB_NAME, process.env.DB_USER, process.env.DB_PASSWORD, {
  dialect: 'postgres',
  host: process.env.DB_HOST,
  logging: false,
});

sequelize
  .authenticate()
  .then(() => {
    console.info('Connection has been established successfully.');
  })
  .catch((err) => {
    console.error('Unable to connect to the database:', err);
  });

const models = {
  User: sequelize.import('./user'),
  Message: sequelize.import('./message'),
};

for (const key of Object.keys(models)) {
  if ('associate' in models[key]) {
    models[key].associate(models);
  }
}

export { sequelize };

export default models;
