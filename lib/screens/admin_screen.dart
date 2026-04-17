import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  String filter = "PENDING";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text("Admin Panel")),

      body: Column(
        children: [

          /// 🔥 FILTER BUTTONS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: ["PENDING", "APPROVED", "REJECTED", "ALL"]
                .map((f) => TextButton(
                      onPressed: () {
                        setState(() => filter = f);
                      },
                      child: Text(
                        f,
                        style: TextStyle(
                          color: filter == f
                              ? Colors.orange
                              : Colors.grey,
                        ),
                      ),
                    ))
                .toList(),
          ),

          /// 🔥 CLAIM LIST
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("claims")
                  .orderBy("createdAt", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                      child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;

                final claims = docs.where((doc) {
                  if (filter == "ALL") return true;
                  return doc["status"] == filter;
                }).toList();

                if (claims.isEmpty) {
                  return const Center(
                      child: Text("No Claims",
                          style: TextStyle(color: Colors.white)));
                }

                return ListView.builder(
                  itemCount: claims.length,
                  itemBuilder: (context, i) {
                    final c = claims[i];

                    return Card(
                      color: Colors.grey[900],
                      child: ListTile(
                        title: Text(
                          c["workerName"] ?? "Unknown",
                          style:
                              const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          c["type"],
                          style:
                              const TextStyle(color: Colors.grey),
                        ),
                        trailing: Column(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            Text(
                              "₹${c["amount"]}",
                              style: const TextStyle(
                                  color: Colors.orange),
                            ),
                            Text(
                              c["status"],
                              style: TextStyle(
                                color: c["status"] == "APPROVED"
                                    ? Colors.green
                                    : c["status"] == "REJECTED"
                                        ? Colors.red
                                        : Colors.yellow,
                              ),
                            ),
                          ],
                        ),

                        /// 👉 OPEN DETAILS
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) =>
                                claimDialog(context, c.id, c),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 🔥 CLAIM DETAIL POPUP
  Widget claimDialog(
      BuildContext context, String id, dynamic claim) {
    TextEditingController commentController =
        TextEditingController();

    return AlertDialog(
      backgroundColor: Colors.black,
      title: const Text("Claim Details",
          style: TextStyle(color: Colors.white)),
      content: SingleChildScrollView(
        child: Column(
          children: [
            Text("Worker: ${claim["workerName"]}",
                style: const TextStyle(color: Colors.white)),
            Text("Amount: ₹${claim["amount"]}",
                style: const TextStyle(color: Colors.orange)),
            Text("Type: ${claim["type"]}",
                style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 10),

            TextField(
              controller: commentController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Admin Comment",
              ),
            ),
          ],
        ),
      ),
      actions: [

        /// ❌ REJECT
        TextButton(
          onPressed: () async {
            await updateStatus(id, "REJECTED",
                commentController.text);
            Navigator.pop(context);
          },
          child: const Text("Reject",
              style: TextStyle(color: Colors.red)),
        ),

        /// ✅ APPROVE
        ElevatedButton(
          onPressed: () async {
            await updateStatus(id, "APPROVED",
                commentController.text);
            Navigator.pop(context);
          },
          child: const Text("Approve"),
        ),
      ],
    );
  }

  /// 🔥 UPDATE STATUS
  Future<void> updateStatus(
      String id, String status, String comment) async {
    await FirebaseFirestore.instance
        .collection("claims")
        .doc(id)
        .update({
      "status": status,
      "adminComment": comment,
      "updatedAt": DateTime.now(),
    });
  }
}