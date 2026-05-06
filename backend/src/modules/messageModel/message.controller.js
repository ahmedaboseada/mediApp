import { Router } from 'express';
import { verifyToken } from '../../middlewares/authentication.js';
import { validation } from '../../middlewares/validation.js';
import { isApprovedDoctor } from '../../middlewares/isApprovedDoctor.js';
import * as MVS from './message.validation.js';
import * as MS from './message.service.js';

const messageRouter = Router({ mergeParams: true });

messageRouter.post('/', verifyToken, isApprovedDoctor, validation(MVS.sendMessageSchema), MS.send);
messageRouter.get('/verify/:targetUserId', verifyToken, MS.verifyChat);

export default messageRouter;
