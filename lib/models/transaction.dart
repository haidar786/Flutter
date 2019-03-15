class Transaction {
  final int id;
  final DateTime created;
  final DateTime modified;
  final double amount;
  final String note;
  final String txid;
  final int user;
  final int subscription;
  final int alert;

  Transaction.fromJSON(Map<String, dynamic> json)
      : this.id = json["id"],
        this.created = DateTime.parse(json["created"]),
        this.modified = DateTime.parse(json["modified"]),
        this.amount = double.parse(json["amount"] ?? 0),
        this.note = json["note"],
        this.txid = json["emrals_txid"],
        this.user = json["user"],
        this.subscription = json["subscription"],
        this.alert = json["alert"];
}
