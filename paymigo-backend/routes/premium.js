import express from "express";
import axios from "axios";
import { getZoneFeatures } from "../lib/csvLoader.js";

const router = express.Router();

/// 🔥 BASE ML URL (CHANGE IF DEPLOYED)
const ML_BASE_URL = "http://127.0.0.1:8000";

router.post("/calculate", async (req, res) => {
  try {
    const { age, jobType, experienceYears, zone } = req.body;

    /// 🔥 CLEAN ZONE
    const zoneName = zone || "Unknown";
    let cityName = "unknown";

    if (zoneName.includes("Coimbatore")) cityName = "coimbatore";
    else if (zoneName.includes("Chennai")) cityName = "chennai";
    else if (zoneName.includes("Bangalore")) cityName = "bengaluru";
    else if (zoneName.includes("Mumbai")) cityName = "mumbai";
    else cityName = zoneName.split(" ")[0].toLowerCase();

    let premium = 69;
    let risk = 1.0;
    let factors = [];

    try {
      /// 🔥 LOAD CSV FEATURES
      const stats = await getZoneFeatures(cityName);

      /// 🔥 GET RISK
      if (stats?.zone_risk_tier) {
        risk = stats.zone_risk_tier;
      } else {
        const clusterRes = await axios.post(
          `${ML_BASE_URL}/cluster/predict`,
          stats
        );
        risk = clusterRes.data.zone_risk_tier || 1.0;
      }

      /// 🔥 AI FACTORS
      if (risk > 1.2) {
        factors.push("High risk area");
      } else if (risk < 1.0) {
        factors.push("Low risk area");
      } else {
        factors.push("Moderate risk");
      }

      /// 🔥 PREMIUM ML
      const premiumRes = await axios.post(
        `${ML_BASE_URL}/premium/predict`,
        {
          age: parseInt(age) || 30,
          zone_risk_tier: risk,
          job_type: jobType || "Delivery",
          experience_years: parseInt(experienceYears) || 0,
          incident_history: 0,
        }
      );

      premium = premiumRes.data?.premium || 69;

    } catch (mlErr) {
      console.log("⚠️ ML fallback:", mlErr.message);
      factors.push("AI unavailable → fallback pricing");
    }

    /// 🔥 FINAL RESPONSE (MOBILE FRIENDLY)
    res.json({
      success: true,
      data: {
        premium: Math.round(premium),
        riskMultiplier: risk,
        factors,
      },
    });

  } catch (err) {
    console.error("❌ Premium error:", err.message);

    res.status(500).json({
      success: false,
      message: "Premium calculation failed",
    });
  }
});

export default router;