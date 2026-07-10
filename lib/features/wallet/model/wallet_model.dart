class WalletModel {
  final String id;
  final int userId;
  final double availableBalance;
  final double frozenBalance;
  final String status;
  final double totalBalance;

  WalletModel({
    required this.id,
    required this.userId,
    required this.availableBalance,
    required this.frozenBalance,
    required this.status,
    required this.totalBalance,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: json["id"] ?? "",
      userId: int.tryParse(json["userId"]?.toString() ?? "0") ?? 0,

      availableBalance:
          double.tryParse(json["availableBalance"]?.toString() ?? "0.0") ?? 0.0,
      frozenBalance:
          double.tryParse(json["frozenBalance"]?.toString() ?? "0.0") ?? 0.0,
      status: json["status"] ?? "ACTIVE",
      totalBalance:
          double.tryParse(json["totalBalance"]?.toString() ?? "0.0") ?? 0.0,
    );
  }
}
