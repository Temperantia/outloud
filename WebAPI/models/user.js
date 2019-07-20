/*
 * Filename: c:\Users\50448\Source\Repos\inclusive\WebAPI\src\models\user.js
 * Path: c:\Users\50448\Source\Repos\inclusive\WebAPI
 * Created Date: Monday, July 15th 2019, 3:38:28 am
 * Autho  r: 50448
 *
 * Copyright (c) 2019 Inclusive
 */
const user = (sequelize, DataTypes) => {
  const User = sequelize.define('user', {
    birthDate: DataTypes.DATE,
    description: DataTypes.STRING,
    email: {
      type: DataTypes.STRING,
      unique: true,
    },
    image: DataTypes.STRING,
    location: DataTypes.STRING,
    name: DataTypes.STRING,
    password: DataTypes.STRING
  });

  User.associate = models => {
    User.hasMany(models.Message);
    // User.hasMany(models.Rooms);
    // User.hasMany(models.User);
    // User.hasMany(models.Interest);
  };

  return User;
};

export default user;
