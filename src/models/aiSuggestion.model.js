const aiSuggestionSchema = new mongoose.Schema({
    taskId: { type: mongoose.Schema.Types.ObjectId, ref: "Task", required: true },
    userId: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true },
    type: { type: String, enum: ["subtasks", "reminder"], required: true },
    suggestions: { type: mongoose.Schema.Types.Mixed }, // can store array/object
    createdAt: { type: Date, default: Date.now }
});

export default mongoose.model("AiSuggestion", aiSuggestionSchema);
