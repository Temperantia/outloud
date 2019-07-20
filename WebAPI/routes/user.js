import { compareSync, hashSync } from 'bcrypt';
import { Router } from 'express';
import { sign, verify } from 'jsonwebtoken';

import models from '../models';

function generateToken(user) {
  return sign({
    email: user.email,
    id: user.id,
    name: user.name,
  }, process.env.JWT_SECRET);
}

export const userRouter = Router()
  .post('/', async (req, res) => {
    try {
      const user = await models.User.create({
        birthDate: req.body.birthDate,
        email: req.body.email,
        name: req.body.name,
        password: await hashSync(req.body.password, Math.random() * (20 - 10) + 10),
      });

      return res.send({
        token: generateToken(user),
      });
    } catch (error) {
      console.error(error);
      return res.sendStatus(500);
    }
  })
  .post('/login', async (req, res) => {
    try {
      const user = await models.User.findOne({
        where: {
          email: req.body.email,
        },
      });

      if (!user || !compareSync(req.body.password, user.password)) {
        return res.sendStatus(403);
      }

      return res.send({
        token: generateToken(user),
      });
    } catch (error) {
      console.error(error);
      return res.sendStatus(500);
    }
  })
  .use((req, res, next) => {
    if (!req.token) {
      return res.sendStatus(403);
    }

    try {
      req.decoded = verify(req.token, process.env.JWT_SECRET);

      if (!req.decoded) {
        return res.sendStatus(403);
      }

      next();
    } catch (error) {
      console.error(error);
      return res.sendStatus(500);
    }
  })
  .get('/', async (req, res) => {
    return res.send(await models.User.findAll({
      attributes: {
        exclude: ['password'],
      },
    }));
  })
  .put('/:userId', async (req, res) => {
    try {
      const user = await models.User.findOne({
        where: {
          id: req.params.userId,
        },
      });

      if (user.id !== req.decoded.id) {
        return res.sendStatus(403);
      }

      user.update(req.body);
    } catch (error) {
      console.error(error);
      return res.sendStatus(500);
    }
    return res.send();
  })
  .delete('/:userId', async (req, res) => {
    try {
      const user = await models.User.findOne({
        where: {
          id: req.params.userId,
        },
      });

      if (user.id !== req.decoded.id) {
        return res.sendStatus(403);
      }

      user.destroy();
    } catch (error) {
      console.error(error);
      return res.sendStatus(500);
    }
    return res.send();
  });
