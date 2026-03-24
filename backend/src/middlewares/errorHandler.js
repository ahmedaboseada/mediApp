export const errorHandler = (err, req, res, _next) => {
    console.error("ERROR HANDLER CAUGHT AN ERROR:", err.stack);
    const status = err?.cause || err?.status || 500;
    res.status(status).json({
        message: err?.message || 'Server Error',
    });
};
