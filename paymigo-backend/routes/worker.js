import express from "express";
import prisma from "../lib/prisma.js";

const router = express.Router();

// Helper to map city names to database zone IDs
const CITY_TO_ZONE_ID = {
  "coimbatore": "coimbatore_(zone_1)",
  "chennai": "chennai_(zone_4)",
  "bangalore": "bangalore_east",
  "bengaluru": "bangalore_east",
  "mumbai": "mumbai_west"
};

// Seed/Ensure default zones exist to prevent Foreign Key constraints
async function ensureZonesExist() {
  const defaultZones = [
    { id: "default-zone-id", name: "Default Zone", city: "Default", pincode: "000000", riskTier: 1, riskMultiplier: 1.0 },
    { id: "coimbatore_(zone_1)", name: "Coimbatore Zone 1", city: "Coimbatore", pincode: "641001", riskTier: 1, riskMultiplier: 1.0 },
    { id: "chennai_(zone_4)", name: "Chennai Zone 4", city: "Chennai", pincode: "600001", riskTier: 2, riskMultiplier: 1.4 },
    { id: "bangalore_east", name: "Bangalore East", city: "Bangalore", pincode: "560001", riskTier: 1, riskMultiplier: 1.1 },
    { id: "mumbai_west", name: "Mumbai West", city: "Mumbai", pincode: "400001", riskTier: 2, riskMultiplier: 1.5 }
  ];

  for (const zone of defaultZones) {
    try {
      await prisma.zone.upsert({
        where: { id: zone.id },
        update: {},
        create: zone,
      });
    } catch (err) {
      console.error(`Error seeding zone ${zone.id}:`, err.message);
    }
  }
}

/// 🔥 CREATE / SYNC USER (called after login)
router.post("/", async (req, res) => {
  const { firebaseUid, name, phone } = req.body;

  try {
    // Ensure zones exist before creating worker
    await ensureZonesExist();

    const worker = await prisma.worker.upsert({
      where: { firebaseUid },
      update: {
        name,
        phone,
      },
      create: {
        firebaseUid,
        name,
        phone,
        pincode: "637211",
        zoneId: "default-zone-id",
        riskTier: 1,
      },
    });

    res.json(worker);
  } catch (e) {
    console.error("❌ Sync worker error:", e.message);
    res.status(500).json({ message: e.message });
  }
});


/// 🔥 GET PROFILE
router.get("/:firebaseUid", async (req, res) => {
  const { firebaseUid } = req.params;

  try {
    const worker = await prisma.worker.findUnique({
      where: { firebaseUid },
      include: { zone: true }
    });

    if (!worker) {
      return res.status(404).json({ message: "User not found" });
    }

    // Return city from the related zone to match frontend expected fields
    res.json({
      ...worker,
      city: worker.zone?.city || "Unknown"
    });
  } catch (e) {
    console.error("❌ Get profile error:", e.message);
    res.status(500).json({ message: e.message });
  }
});


/// 🔥 UPDATE PROFILE
router.put("/:firebaseUid", async (req, res) => {
  const { firebaseUid } = req.params;
  const { name, phone, city } = req.body;

  try {
    await ensureZonesExist();

    // Map input city name to a valid zone ID
    let mappedZoneId = "default-zone-id";
    if (city) {
      const cityKey = city.toLowerCase().trim();
      mappedZoneId = CITY_TO_ZONE_ID[cityKey] || "default-zone-id";
    }

    const worker = await prisma.worker.update({
      where: { firebaseUid },
      data: {
        name,
        phone,
        zoneId: mappedZoneId
      },
      include: { zone: true }
    });

    res.json({
      ...worker,
      city: worker.zone?.city || "Unknown"
    });
  } catch (e) {
    console.error("❌ Update profile error:", e.message);
    res.status(500).json({ message: e.message });
  }
});

export default router;