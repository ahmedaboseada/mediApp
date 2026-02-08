const subtaskSchema = new mongoose.Schema({
    title: { type: String, required: true },
    subtasks: [subtaskSchema],
    isCompleted: { type: Boolean, default: false },
    isSuggested: { type: Boolean, default: false }, // AI Suggested
});

const taskSchema = new mongoose.Schema({
    userId: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true },
    title: { type: String, required: true },
    description: { type: String },
    deadline: { type: Date },
    isCompleted: { type: Boolean, default: false },

    subtasks: [subtaskSchema],

    progress: { type: Number, default: 0 }, // percentage

    pointsEarned: { type: Number, default: 0 },

    createdAt: { type: Date, default: Date.now }
});

export default mongoose.model("Task", taskSchema);
