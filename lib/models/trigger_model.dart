class TriggerModel {
  final double rainfall;
  final double windSpeed;
  final double waterLogging;
  final String status;
  final String zone;

  TriggerModel({
    required this.rainfall,
    required this.windSpeed,
    required this.waterLogging,
    required this.status,
    required this.zone,
  });

  factory TriggerModel.fromJson(Map<String, dynamic> json) {
    return TriggerModel(
      rainfall: (json["rainfall"] ?? 0).toDouble(),
      windSpeed: (json["windSpeed"] ?? 0).toDouble(),
      waterLogging: (json["waterLogging"] ?? 0).toDouble(),
      status: json["status"] ?? "MONITORING",
      zone: json["zone"] ?? "Unknown",
    );
  }
}