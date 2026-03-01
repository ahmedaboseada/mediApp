export const errorHandler = (err, req, res, _next) => {
    const status = err?.cause || err?.status || 500;
    res.status(status).json({
        message: err?.message || 'Server Error',
    });
};
