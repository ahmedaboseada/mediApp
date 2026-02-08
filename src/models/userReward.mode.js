const userRewardSchema = new mongoose.Schema({
    userId: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true },
    rewardId: { type: mongoose.Schema.Types.ObjectId, ref: "Reward", required: true },
    acquiredAt: { type: Date, default: Date.now }
});

export const UserReward = mongoose.model("UserReward", userRewardSchema);