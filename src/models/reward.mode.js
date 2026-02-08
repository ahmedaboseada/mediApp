const rewardSchema = new mongoose.Schema({
    name: { type: String, required: true },
    type: { type: String, enum: ["theme", "sound", "badge"], required: true },
    cost: { type: Number, required: true },
    description: { type: String }
});

export const Reward = mongoose.model("Reward", rewardSchema);
