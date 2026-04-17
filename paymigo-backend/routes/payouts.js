import express from "express";
import prisma from "../lib/prisma.js";

const router = express.Router();

/// 🔥 GET USER PAYOUT HISTORY
router.get("/:firebaseUid", async (req, res) => {
  const { firebaseUid } = req.params;

  try {
    const worker = await prisma.worker.findUnique({
      where: { firebaseUid },
      include: {
        policies: {
          include: {
            payouts: true,
          },
        },
      },
    });

    if (!worker) {
      return res.status(404).json({
        success: false,
        message: "Worker not found",
      });
    }

    const payouts =
      worker.policies.flatMap((p) => p.payouts) || [];

    res.json({
      success: true,
      data: payouts,
    });

  } catch (error) {
    console.error("❌ Fetch payouts error:", error.message);
    res.status(500).json({
      success: false,
      message: "Failed to fetch payouts",
    });
  }
});


/// 🔥 MANUAL CLAIM (USER INITIATED)
router.post("/claim", async (req, res) => {
  const { firebaseUid, amount, description } = req.body;

  try {
    const worker = await prisma.worker.findUnique({
      where: { firebaseUid },
      include: { policies: true },
    });

    if (!worker || !worker.policies.length) {
      return res.status(400).json({
        success: false,
        message: "No active policy",
      });
    }

    const policy = worker.policies[0];

    /// 🔥 CREATE CLAIM
    const claim = await prisma.claim.create({
      data: {
        policyId: policy.id,
        description: description || "Manual claim",
        amount: amount || 0,
        status: "PENDING",
      },
    });

    res.json({
      success: true,
      claim,
    });

  } catch (error) {
    console.error("❌ Claim error:", error.message);
    res.status(500).json({
      success: false,
      message: "Failed to create claim",
    });
  }
});


/// 🔥 APPROVE CLAIM (SIMULATION / ADMIN)
router.post("/approve/:claimId", async (req, res) => {
  const { claimId } = req.params;

  try {
    const claim = await prisma.claim.update({
      where: { id: parseInt(claimId) },
      data: { status: "APPROVED" },
    });

    /// 🔥 CREATE PAYOUT
    const payout = await prisma.payout.create({
      data: {
        claimId: claim.id,
        policyId: claim.policyId,
        amount: claim.amount,
        status: "SUCCESS",
        provider: "MANUAL",
      },
    });

    res.json({
      success: true,
      payout,
    });

  } catch (error) {
    console.error("❌ Approve error:", error.message);
    res.status(500).json({
      success: false,
      message: "Failed to approve claim",
    });
  }
});

export default router;