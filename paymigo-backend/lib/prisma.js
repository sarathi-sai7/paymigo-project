import pkg from "@prisma/client";

const { PrismaClient } = pkg;

/// 🔥 GLOBAL CACHE (IMPORTANT)
const globalForPrisma = globalThis;

/// 🔥 SINGLE INSTANCE
const prisma =
  globalForPrisma.prisma ||
  new PrismaClient({
    log: ["query", "error", "warn"], // helpful for debugging
  });

/// 🔥 SAVE INSTANCE (DEV ONLY)
if (process.env.NODE_ENV !== "production") {
  globalForPrisma.prisma = prisma;
}

export default prisma;