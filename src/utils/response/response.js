export const successResponse = (res, message, data = undefined, status = 200) => {
    return res.status(status).json({
        success: true,
        message,
        data
    });
};

