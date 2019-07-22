import { compareSync, hashSync } from 'bcrypt';
import Router from 'express-promise-router';
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
  .get('/exist/email/:email', async (req, res) => {
    const email = req.params.email;
    const user = await models.User.findOne({
      where: {
        email,
      },
    });

    return res.send({
      exist: !!user,
    });
  })

  .get('/exist/username/:username', async (req, res) => {
    const username = req.params.username;
    const user = await models.User.findOne({
      where: {
        username,
      },
    });

    return res.send({
      exist: !!user,
    });
  })

  .post('/', async (req, res) => {
    const user = await models.User.create({
      birthDate: req.body.birthDate,
      email: req.body.email,
      name: req.body.name,
      password: await hashSync(req.body.password, 10), // TODO variable env
      username: req.body.username,
    });

    return res.send({
      token: generateToken(user),
    });
  })

  .post('/login', async (req, res) => {
    const email = req.body.email || '';
    const password = req.body.password || '';

    const user = await models.User.findOne({
      where: {
        email,
      },
    });

    if (!user || !compareSync(password, user.password)) {
      return res.sendStatus(403);
    }

    return res.send({
      token: generateToken(user),
    });
  })

  // auth middleware
  .use((req, res, next) => {
    if (!req.token) {
      return res.sendStatus(403);
    }

    req.decoded = verify(req.token, process.env.JWT_SECRET);

    if (!req.decoded) {
      return res.sendStatus(403);
    }

    next();
  })

  .get('/', async (req, res) => {
    return res.send(await models.User.findAll({
      attributes: {
        exclude: ['password'],
      },
    }));
  })

  .put('/:userId', async (req, res) => {
    const user = await models.User.findOne({
      where: {
        id: req.params.userId,
      },
    });

    if (!user || user.id !== req.decoded.id) {
      return res.sendStatus(403);
    }

    user.update(req.body);

    return res.send();
  })

  .delete('/:userId', async (req, res) => {
    const user = await models.User.findOne({
      where: {
        id: req.params.userId,
      },
    });

    if (!user || user.id !== req.decoded.id) {
      return res.sendStatus(403);
    }

    user.destroy();

    return res.send();
  });
