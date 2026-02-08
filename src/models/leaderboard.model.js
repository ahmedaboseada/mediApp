const leaderboardSchema = new mongoose.Schema({
    week: { type: String, required: true }, // e.g. "2025-W35"
    userId: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true },
    points: { type: Number, default: 0 },
    rank: { type: Number }
});

export default mongoose.model("Leaderboard", leaderboardSchema);
