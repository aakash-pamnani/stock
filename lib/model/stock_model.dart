import 'dart:convert';

class StockModel {
  String? id;
  String itemName;
  List<ItemData> itemData;
  List<String> history;
  StockModel({
    this.id,
    required this.itemName,
    required this.itemData,
    required this.history,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'itemName': itemName,
      'itemData': itemData.map((x) => x.toMap()).toList(),
      'history': history,
    };
  }

  factory StockModel.fromMap(Map<String, dynamic> map) {
    return StockModel(
      id: map['id'],
      itemName: map['itemName'] ?? '',
      itemData: List<ItemData>.from(
          map['itemData']?.map((x) => ItemData.fromMap(x)) ?? []),
      history: List<String>.from(map['history']),
    );
  }

  String toJson() => json.encode(toMap());

  factory StockModel.fromJson(String source) =>
      StockModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'StockModel(id: $id, itemName: $itemName, itemData: $itemData, history: $history)';
  }

  static StockModel empty() {
    return StockModel(itemName: "", itemData: [], history: []);
  }

  StockModel copyWith({
    String? id,
    String? itemName,
    List<ItemData>? itemData,
    String? category,
    List<String>? history,
  }) {
    return StockModel(
      id: id ?? this.id,
      itemName: itemName ?? this.itemName,
      itemData:
          itemData ?? this.itemData.map<ItemData>((e) => e.copyWith()).toList(),
      history: history ?? this.history,
    );
  }

  void sortItemData() {
    Map<String, int> values = {
      's': 0,
      'm': 1,
      'l': 2,
      'xl': 3,
      'xxl': 4,
      'xxxl': 5,
      'xxxxl': 6,
      'xxxxxl': 7
    };
    itemData.sort(((a, b) {
      if (values.containsKey(a.size.toLowerCase()) &&
          values.containsKey(b.size.toLowerCase())) {
        return values[a.size.toLowerCase()]! - values[b.size.toLowerCase()]!;
      } else {
        try{
        int? first = int.tryParse(a.size.toLowerCase());
        int? second = int.tryParse(b.size.toLowerCase());
        return first!-second!;
        }
        catch (e){
        return a.size.compareTo(b.size);
        }
      }
    }));
  }


  static int getTotalItems(List<ItemData> value) {
    int items = 0;
    for (var element in value) {
      items += element.quantity;
    }
    return items;
  }
}

class ItemData {
  String size;
  int quantity;

  ItemData({
    required this.size,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'size': size,
      'quantity': quantity,
    };
  }

  factory ItemData.fromMap(Map<String, dynamic> map) {
    return ItemData(
      size: map['size'] ?? '',
      quantity: map['quantity']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ItemData.fromJson(String source) =>
      ItemData.fromMap(json.decode(source));

  @override
  String toString() => 'ItemData(size: $size, quantity: $quantity)';

  ItemData copyWith({
    String? size,
    int? quantity,
  }) {
    return ItemData(
      size: size ?? this.size,
      quantity: quantity ?? this.quantity,
    );
  }
}
