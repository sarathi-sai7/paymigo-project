import express from "express";
import prisma from "../lib/prisma.js";

const router = express.Router();

/// 🔥 AUTO PAYOUT TRIGGER
router.post("/trigger-payout", async (req, res) => {
  const { firebaseUid, rainfall, threshold } = req.body;

  try {
    /// 🔥 GET WORKER
    const worker = await prisma.worker.findUnique({
      where: { firebaseUid },
      include: { policies: true },
    });

    if (!worker) {
      return res.status(404).json({ message: "Worker not found" });
    }

    if (!worker.policies.length) {
      return res.status(400).json({ message: "No active policy" });
    }

    const policy = worker.policies[0];

    /// 🔥 PREVENT DUPLICATE PAYOUT (last 12 hrs)
    const recentPayout = await prisma.payout.findFirst({
      where: {
        policyId: policy.id,
        createdAt: {
          gte: new Date(Date.now() - 12 * 60 * 60 * 1000),
        },
      },
    });

    if (recentPayout) {
      return res.json({
        success: false,
        message: "Payout already triggered recently",
      });
    }

    /// 🔥 CREATE CLAIM
    const claim = await prisma.claim.create({
      data: {
        policyId: policy.id,
        description: `Rainfall ${rainfall}mm exceeded threshold ${threshold}mm`,
        amount: 150,
        status: "APPROVED",
      },
    });

    /// 🔥 CREATE PAYOUT
    const payout = await prisma.payout.create({
      data: {
        claimId: claim.id,
        policyId: policy.id,
        amount: 150,
        status: "SUCCESS",
        provider: "AUTO_TRIGGER",
      },
    });

    res.json({
      success: true,
      message: "Payout triggered",
      payout,
    });

  } catch (error) {
    console.error("❌ Payout Error:", error.message);

    res.status(500).json({
      success: false,
      message: "Failed to trigger payout",
    });
  }
});

export default router;