import express from "express";
import { PrismaClient } from "@prisma/client";

const router = express.Router();
const prisma = new PrismaClient();

/// 🔥 GET WALLET (BALANCE + TRANSACTIONS)
router.get("/:firebaseUid", async (req, res) => {
  const { firebaseUid } = req.params;

  try {
    /// 🔥 GET WORKER
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
        message: "User not found",
      });
    }

    /// 🔥 COLLECT ALL TRANSACTIONS
    const transactions =
      worker.policies.flatMap((p) => p.payouts) || [];

    /// 🔥 SORT LATEST FIRST
    transactions.sort(
      (a, b) => new Date(b.createdAt) - new Date(a.createdAt)
    );

    res.json({
      success: true,
      data: {
        balance: worker.balance ?? 0,
        transactions,
      },
    });

  } catch (e) {
    console.error("❌ Wallet fetch error:", e.message);
    res.status(500).json({
      success: false,
      message: "Wallet fetch failed",
    });
  }
});


/// 🔥 ADD MONEY (MANUAL / TEST / AUTO PAYOUT)
router.post("/add", async (req, res) => {
  const { firebaseUid, amount } = req.body;

  try {
    const worker = await prisma.worker.findUnique({
      where: { firebaseUid },
      include: { policies: true },
    });

    if (!worker || worker.policies.length === 0) {
      return res.status(404).json({
        success: false,
        message: "No active policy",
      });
    }

    const policy = worker.policies[0];

    /// 🔥 CREATE PAYOUT ENTRY
    const payout = await prisma.payout.create({
      data: {
        claimId: null, // FIXED (no string error)
        policyId: policy.id,
        amount: amount,
        status: "SUCCESS",
        provider: "AUTO_OR_MANUAL",
      },
    });

    /// 🔥 UPDATE WALLET BALANCE
    await prisma.worker.update({
      where: { id: worker.id },
      data: {
        balance: {
          increment: amount,
        },
      },
    });

    res.json({
      success: true,
      message: "Money added successfully",
      data: payout,
    });

  } catch (e) {
    console.error("❌ Add money error:", e.message);
    res.status(500).json({
      success: false,
      message: "Wallet update failed",
    });
  }
});


/// 🔥 OPTIONAL: GET TRANSACTIONS ONLY
router.get("/transactions/:firebaseUid", async (req, res) => {
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
        message: "User not found",
      });
    }

    const transactions =
      worker.policies.flatMap((p) => p.payouts) || [];

    transactions.sort(
      (a, b) => new Date(b.createdAt) - new Date(a.createdAt)
    );

    res.json({
      success: true,
      data: transactions,
    });

  } catch (e) {
    console.error("❌ Transactions error:", e.message);
    res.status(500).json({
      success: false,
      message: "Failed to fetch transactions",
    });
  }
});

export default router;