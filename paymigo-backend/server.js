import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import { PrismaClient } from "@prisma/client";

// Routes
import workerRoutes from "./routes/worker.js";
import premiumRoutes from "./routes/premium.js";
import triggerRoutes from "./routes/triggers.js";
import aiRoutes from "./routes/ai.js";
import weatherRoutes from "./routes/weather.js";
import payoutRoutes from "./routes/payouts.js";
import orchestratorRoutes from "./routes/orchestrator.js";
import walletRoutes from "./routes/wallet.js";

dotenv.config();

const app = express();
const prisma = new PrismaClient();

/// 🔥 GLOBAL MIDDLEWARE
app.use(cors());
app.use(express.json());

/// 🔥 HEALTH CHECK (for mobile testing)
app.get("/", (req, res) => {
  res.send("🚀 Paymigo Backend Running");
});

app.get("/health", (req, res) => {
  res.json({ status: "OK" });
});

/// 🔥 API ROUTES
app.use("/api/workers", workerRoutes);
app.use("/api/premium", premiumRoutes);
app.use("/api/triggers", triggerRoutes);
app.use("/api/ai", aiRoutes);
app.use("/api/weather", weatherRoutes);
app.use("/api/payouts", payoutRoutes);
app.use("/api/orchestrator", orchestratorRoutes);
app.use("/api/wallet", walletRoutes);

/// 🔥 GLOBAL ERROR HANDLER
app.use((err, req, res, next) => {
  console.error("❌ ERROR:", err);

  res.status(500).json({
    success: false,
    message: err.message || "Internal Server Error",
  });
});

/// 🔥 START SERVER (IMPORTANT FIX)
const PORT = process.env.PORT || 3000;

app.listen(PORT, "0.0.0.0", () => {
  console.log(`🚀 Server running on http://0.0.0.0:${PORT}`);
});