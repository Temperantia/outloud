/*
 * Filename: c:\Users\50448\Source\R
 epos\inclusive\WebAPI\src\models\index.js
 * Path: c:\Users\50448\Source\Repos\inclusive\WebAPI
 * Created Date: Monday, July 15th 2019, 4:00:55 am
 * Author: 50448
 * 
 * Copyright (c) 2019 Inclusive
 */

 import Sequelize from 'sequelize';

 const sequelize = new Sequelize('db_inclusive', 'root', 'notlgbt', {
    host: 'localhost',
    dialect: 'postgres'
  });
sequelize
  .authenticate()
  .then(() => {
     console.log('Connection has been established successfully.');
  })
  .catch(err => {
     error('Unable to connect to the database:', err);
  });
  
const models = {
  User: sequelize.import('./models/user'),
  Message: sequelize.import('./models/message'),
};

Object.keys(models).forEach(key => {
  if ('associate' in models[key]) {
    models[key].associate(models);
  }
});

export { sequelize };

export default models;