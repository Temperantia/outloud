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
    name: DataTypes.STRING,
    description: DataTypes.STRING,
    image: DataTypes.STRING,
    location: DataTypes.STRING,
    email: {
      type: DataTypes.STRING,
      //unique,
    },
    birthDate: DataTypes.DATE,
    password: DataTypes.STRING,
  });
  User.associate = models => {
    User.hasMany(models.Message, { onDelete: 'CASCADE' });
    // User.hasMany(models.Rooms);
    // User.hasMany(models.User);
    // User.hasMany(models.Interest);
  };
  User.findByLogin = async (login) => {
    let user = await User.findOne({
      where: { username: login },
    });

    if (!user) {
      user = await User.findOne({
        where: { email: login },
      });
    }
    return user;
  };
  return User;
};
export { user };

export default user;
