/*
 * Filename: c:\Users\50448\Source\Repos\inclusive\WebAPI\src\models\message.js
 * Path: c:\Users\50448\Source\Repos\inclusive\WebAPI
 * Created Date: Monday, July 15th 2019, 3:50:23 am
 * Author: 50448
 *
 * Copyright (c) 2019 Inclusive
 */

const message = (sequelize, DataTypes) => {
  const Message = sequelize.define("message", {
    text: DataTypes.STRING
  });

  Message.associate = models => {
    Message.belongsTo(models.User);
  };

  return Message;
};

export default message;
