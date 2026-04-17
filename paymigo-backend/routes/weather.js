import express from "express";
import axios from "axios";
import prisma from "../lib/prisma.js";

const router = express.Router();

/// 🔥 WEATHER API KEY
const API_KEY = process.env.OPENWEATHER_API_KEY;

/// 🔥 GET WEATHER FOR USER (MAIN API)
router.get("/user/:firebaseUid", async (req, res) => {
  const { firebaseUid } = req.params;

  try {
    /// 🔥 GET USER
    const worker = await prisma.worker.findUnique({
      where: { firebaseUid },
    });

    if (!worker) {
      return res.status(404).json({
        success: false,
        message: "Worker not found",
      });
    }

    /// 🔥 DEFAULT LOCATION (can improve later)
    const lat = 12.9716;
    const lon = 77.5946;

    const weatherRes = await axios.get(
      "https://api.openweathermap.org/data/2.5/weather",
      {
        params: {
          lat,
          lon,
          appid: API_KEY,
          units: "metric",
        },
        timeout: 5000,
      }
    );

    const data = weatherRes.data;

    const rainfall = data.rain?.["1h"] || 0;
    const windSpeed = (data.wind?.speed || 0) * 3.6;

    /// 🔥 SIMPLE STATUS LOGIC
    let status = "MONITORING";

    if (rainfall > 15 || windSpeed > 45) {
      status = "PAYOUT_TRIGGERED";
    } else if (rainfall > 5 || windSpeed > 30) {
      status = "WARNING";
    }

    res.json({
      success: true,
      data: {
        rainfall,
        windSpeed,
        temperature: data.main.temp,
        city: data.name,
        status,
      },
    });

  } catch (error) {
    console.error("❌ Weather error:", error.message);

    /// 🔥 FALLBACK (IMPORTANT)
    res.json({
      success: true,
      fallback: true,
      data: {
        rainfall: 10,
        windSpeed: 20,
        temperature: 28,
        city: "Default",
        status: "MONITORING",
      },
    });
  }
});

export default router;