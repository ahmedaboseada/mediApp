import { Router } from 'express';
import { verifyToken } from '../../middlewares/authentication.js';
import { validation } from '../../middlewares/validation.js';
import * as MVS from './message.validation.js';
import * as MS from './message.service.js';

const messageRouter = Router({ mergeParams: true });

messageRouter.post('/', verifyToken, validation(MVS.sendMessageSchema), MS.send);

export default messageRouter;
