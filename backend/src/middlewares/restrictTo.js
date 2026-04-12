export const restrictTo = (types = []) => {
    return (req, res, next) => {
        const t = req.user?.type;
        if (!t || !types.includes(t)) {
            return res.status(403).json({ message: 'Forbidden' });
        }
        next();
    };
};
