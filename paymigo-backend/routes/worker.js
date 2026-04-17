import express from "express";
import { PrismaClient } from "@prisma/client";

const router = express.Router();
const prisma = new PrismaClient();

/// 🔥 CREATE / SYNC USER (called after login)
router.post("/", async (req, res) => {
  const { firebaseUid, name, phone } = req.body;

  try {
    const worker = await prisma.worker.upsert({
      where: { firebaseUid },
      update: {},
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
    res.status(500).json({ message: e.message });
  }
});


/// 🔥 GET PROFILE
router.get("/:firebaseUid", async (req, res) => {
  const { firebaseUid } = req.params;

  try {
    const worker = await prisma.worker.findUnique({
      where: { firebaseUid },
    });

    if (!worker) {
      return res.status(404).json({ message: "User not found" });
    }

    res.json(worker);
  } catch (e) {
    res.status(500).json({ message: e.message });
  }
});


/// 🔥 UPDATE PROFILE
router.put("/:firebaseUid", async (req, res) => {
  const { firebaseUid } = req.params;
  const { name, phone, city } = req.body;

  try {
    const worker = await prisma.worker.update({
      where: { firebaseUid },
      data: {
        name,
        phone,
        city,
      },
    });

    res.json(worker);
  } catch (e) {
    res.status(500).json({ message: e.message });
  }
});

export default router;