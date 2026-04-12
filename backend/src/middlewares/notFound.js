export const notFound = (req, res, _next) => {
    res.status(404).json({ message: 'Page not found' });
};
