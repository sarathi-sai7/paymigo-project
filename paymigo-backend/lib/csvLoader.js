import fs from "fs";
import path from "path";
import csvParser from "csv-parser";

/// 🔥 RELATIVE PATH (PORTABLE)
const CSV_FILE_PATH = path.resolve("./data/zone_clustered_output.csv");

/// 🔥 CACHE (VERY IMPORTANT FOR PERFORMANCE)
let cachedData = null;

/**
 * 🔥 Load CSV once and cache it
 */
export async function getZoneData() {
  return new Promise((resolve) => {
    /// ✅ RETURN FROM CACHE
    if (cachedData) {
      return resolve(cachedData);
    }

    const results = {};

    /// ❌ FILE NOT FOUND → SAFE FALLBACK
    if (!fs.existsSync(CSV_FILE_PATH)) {
      console.warn("⚠️ CSV not found → using fallback");
      cachedData = {};
      return resolve(cachedData);
    }

    fs.createReadStream(CSV_FILE_PATH)
      .pipe(csvParser())
      .on("data", (data) => {
        if (data.city) {
          const key = data.city
            .toLowerCase()
            .replace(/ /g, "_");

          results[key] = data;
        }
      })
      .on("end", () => {
        console.log("✅ CSV loaded successfully");
        cachedData = results;
        resolve(results);
      })
      .on("error", (err) => {
        console.error("❌ CSV parse error:", err.message);
        cachedData = {};
        resolve(cachedData);
      });
  });
}

/**
 * 🔥 Extract ML features for given zone
 */
export async function getZoneFeatures(zoneId) {
  const dictionary = await getZoneData();

  const key = zoneId?.toLowerCase().replace(/ /g, "_");
  const zoneStats = dictionary[key];

  if (zoneStats) {
    return {
      storm_days: parseFloat(zoneStats.storm_days || 0),
      heavy_rain_days: parseFloat(zoneStats.heavy_rain_days || 0),
      avg_aqi: parseFloat(zoneStats.avg_aqi || 100),
      zone_risk_tier: zoneStats.zone_risk_tier
        ? parseFloat(zoneStats.zone_risk_tier)
        : null,
    };
  }

  /// 🔥 SMART FALLBACK (better than zeros)
  return {
    storm_days: 2,
    heavy_rain_days: 5,
    avg_aqi: 120,
    zone_risk_tier: null,
  };
}