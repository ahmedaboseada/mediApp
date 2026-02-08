const notificationSchema = new mongoose.Schema({
    userId: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true },
    taskId: { type: mongoose.Schema.Types.ObjectId, ref: "Task" },
    type: { type: String, enum: ["email", "push", "in-app"], required: true },
    message: { type: String },
    sendAt: { type: Date, required: true },
    isSent: { type: Boolean, default: false }
});

export default mongoose.model("Notification", notificationSchema);
