class TradeModel {
  int? id;
  String dateTime;
  String pair;
  String position; // BUY / SELL
  double entryPrice;
  double stopLoss;
  double takeProfit;
  double lot;
  String result; // Profit / Loss / BEP
  double profitOrLoss;
  String? reason;
  String? smcSetup;
  String? imageBefore;
  String? imageAfter;
  String? emotion;
  String? isPlanFollowed;
  String? isSlFollowed;

  TradeModel({
    this.id,
    required this.dateTime,
    required this.pair,
    required this.position,
    required this.entryPrice,
    required this.stopLoss,
    required this.takeProfit,
    required this.lot,
    required this.result,
    required this.profitOrLoss,
    this.reason,
    this.smcSetup,
    this.imageBefore,
    this.imageAfter,
    this.emotion,
    this.isPlanFollowed,
    this.isSlFollowed,
  });

  // Konversi dari database (Map) ke Object TradeModel
  factory TradeModel.fromMap(Map<String, dynamic> map) {
    return TradeModel(
      id: map['id'],
      dateTime: map['dateTime'],
      pair: map['pair'],
      position: map['position'],
      entryPrice: map['entryPrice'],
      stopLoss: map['stopLoss'],
      takeProfit: map['takeProfit'],
      lot: map['lot'],
      result: map['result'],
      profitOrLoss: map['profitOrLoss'],
      reason: map['reason'],
      smcSetup: map['smcSetup'],
      imageBefore: map['imageBefore'],
      imageAfter: map['imageAfter'],
      emotion: map['emotion'],
      isPlanFollowed: map['isPlanFollowed'],
      isSlFollowed: map['isSlFollowed'],
    );
  }

  // Konversi dari TradeModel ke Database (Map)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dateTime': dateTime,
      'pair': pair,
      'position': position,
      'entryPrice': entryPrice,
      'stopLoss': stopLoss,
      'takeProfit': takeProfit,
      'lot': lot,
      'result': result,
      'profitOrLoss': profitOrLoss,
      'reason': reason,
      'smcSetup': smcSetup,
      'imageBefore': imageBefore,
      'imageAfter': imageAfter,
      'emotion': emotion,
      'isPlanFollowed': isPlanFollowed,
      'isSlFollowed': isSlFollowed,
    };
  }
}
