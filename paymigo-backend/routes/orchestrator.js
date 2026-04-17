import express from "express";
import axios from "axios";

const router = express.Router();

/// 🔥 ML SERVICE URL
const ML_URL = "http://127.0.0.1:8000";

/// 🔥 TEST SCENARIO API
router.post("/scenario", async (req, res) => {
  const { command } = req.body;

  if (!command) {
    return res.status(400).json({
      success: false,
      message: "Missing command",
    });
  }

  try {
    const mlResponse = await axios.post(
      `${ML_URL}/orchestrator/testing/parse`,
      { comment: command },
      { timeout: 5000 } // 🔥 Prevent hanging
    );

    res.json({
      success: true,
      data: mlResponse.data,
    });

  } catch (error) {
    console.error("❌ ML error:", error.message);

    /// 🔥 SAFE FALLBACK (VERY IMPORTANT)
    res.json({
      success: true,
      fallback: true,
      data: {
        scenario: "SIMULATED",
        message: "ML service unavailable, using fallback",
      },
    });
  }
});

export default router;