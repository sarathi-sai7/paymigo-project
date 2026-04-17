import express from "express";
import axios from "axios";
import prisma from "../lib/prisma.js";

const router = express.Router();

/// 🔥 ENV (IMPORTANT)
const OPENWEATHER_API_KEY = process.env.OPENWEATHER_API_KEY;

/// 🔥 ZONE MAP
const ZONE_COORDS = {
  "coimbatore_(zone_1)": { lat: 11.0168, lon: 76.9558 },
  "chennai_(zone_4)": { lat: 13.0827, lon: 80.2707 },
  "bangalore_east": { lat: 12.9716, lon: 77.5946 },
  "mumbai_west": { lat: 19.0760, lon: 72.8777 },
  default: { lat: 12.9716, lon: 77.5946 },
};

router.get("/", async (req, res) => {
  try {
    const { mode, firebaseUid } = req.query;

    /// 🔥 GET USER ZONE (BETTER FOR MOBILE)
    let zoneId = "default";

    if (firebaseUid) {
      const worker = await prisma.worker.findUnique({
        where: { firebaseUid },
      });

      if (worker?.zoneId) {
        zoneId = worker.zoneId;
      }
    }

    const coords = ZONE_COORDS[zoneId] || ZONE_COORDS.default;

    let rainfall = 0;
    let windSpeed = 0;
    let waterLogging = 0;

    /// 🔥 TEST MODES (FOR DEBUG)
    if (mode === "flood") {
      rainfall = 120.5;
      windSpeed = 35.0;
      waterLogging = 45.0;
    } else if (mode === "extreme_wind") {
      rainfall = 2.0;
      windSpeed = 85.0;
      waterLogging = 0.5;
    } else if (mode === "normal") {
      rainfall = 0.0;
      windSpeed = 12.0;
      waterLogging = 0.0;
    } else {
      /// 🔥 REAL WEATHER API
      const weatherRes = await axios.get(
        `https://api.openweathermap.org/data/2.5/weather`,
        {
          params: {
            lat: coords.lat,
            lon: coords.lon,
            appid: OPENWEATHER_API_KEY,
            units: "metric",
          },
          timeout: 5000,
        }
      );

      const current = weatherRes.data;

      rainfall = current.rain?.["1h"] || 0;
      windSpeed = (current.wind?.speed || 0) * 3.6;

      waterLogging =
          rainfall > 10 ? rainfall * 0.8 : rainfall * 0.2;
    }

    /// 🔥 STATUS LOGIC
    let status = "MONITORING";

    const rainfallThreshold = 15;
    const windThreshold = 45;

    if (rainfall >= rainfallThreshold || windSpeed >= windThreshold) {
      status = "PAYOUT_TRIGGERED";
    } else if (rainfall > 5 || windSpeed > 30) {
      status = "WARNING";
    }

    /// 🔥 MOBILE FRIENDLY RESPONSE
    res.json({
      success: true,
      data: {
        rainfall: parseFloat(rainfall.toFixed(1)),
        windSpeed: parseFloat(windSpeed.toFixed(1)),
        waterLogging: parseFloat(waterLogging.toFixed(1)),
        status,
        thresholds: {
          rainfall: rainfallThreshold,
          wind: windThreshold,
        },
        zone: zoneId,
        lastUpdated: new Date().toISOString(),
      },
    });

  } catch (error) {
    console.error("Weather API error:", error.message);

    /// 🔥 SAFE FALLBACK
    res.json({
      success: true,
      data: {
        rainfall: 14.2,
        windSpeed: 22.5,
        waterLogging: 4.5,
        status: "MONITORING",
        fallback: true,
      },
    });
  }
});

export default router;