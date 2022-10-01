import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../model/stock_model.dart';

import '../model/stock_model.dart';

class DatabaseRepository {
  final FirebaseFirestore _database;
  DatabaseRepository({
    FirebaseFirestore? database,
  }) : _database = database ?? FirebaseFirestore.instance;

  final String _categoryRef = "category";
  final String _itemRef = "itemData";

  Future<void> addStock(StockModel data, String category) async {
// add entries to stock collection;

    Map<String, dynamic> ref =
        (await _database.collection(_categoryRef).doc(category).get())
            .data()?[_itemRef];

    if (ref.containsKey(data.itemName)) {
      Map itemData;
      // if item already exists then update values
      itemData = ref[data.itemName]?["itemData"] ?? [];

      for (var element in data.itemData) {
        // loop on every itemdata provided by user
        if (itemData.containsKey(element.size)) {
          // if size provided by user already exists in database then add new quantaty
          itemData[element.size] += element.quantity;
        } else {
          // else add the new size key in the database with quantity as value
          itemData[element.size] = element.quantity;
        }
      }
      ref[_itemRef][data.itemName][_itemRef] = itemData;
      ref[_itemRef][data.itemName]["history"] =
          FieldValue.arrayUnion(data.history);
      await _database.collection(_categoryRef).doc(category).set(
          {_itemRef: ref[_itemRef][data.itemName]},
          SetOptions(mergeFields: [_itemRef]));
    } else {
      await _database.collection(_categoryRef).doc(category).update(
        {
          "$_itemRef.${data.itemName}": data.toMap()
            ..["itemData"] = customToMap(data.itemData)
        },
      );

      await _database
          .collection(_itemRef)
          .doc(data.itemName)
          .set({"name": data.itemName});
    }

// refrence of items/data.itemName
    // var ref = (await _database.collection(_itemRef).doc(data.itemName).get());
    // Map itemData;
    // if (ref.exists) {
    //   // if item already exists then update values
    //   itemData = ref.get(_godownRef)[data.location] ??
    //       {}; // refrence of items/data.itemName/[_godownRef] if godown not present return empty map {}

    //   for (var element in data.itemData) {
    //     // loop on every itemdata provided by user
    //     if (itemData.containsKey(element.size)) {
    //       // if size provided by user already exists in database then add new quantaty
    //       itemData[element.size] += itemData[element.size] + element.quantity;
    //     } else {
    //       // else add the new size key in the database with quantity as value
    //       itemData[element.size] = element.quantity;
    //     }
    //   }

    //   // update the item data in database
    //   await _database.collection(_itemRef).doc(data.itemName).update({
    //     "parcel":FieldValue.arrayUnion([parcelReff]),
    //     _godownRef: ref.get(_godownRef)?..[data.location]=itemData,
    //     "history": FieldValue.arrayUnion(
    //         data.history), //combine the previous history and new history
    //   });
    // } else {
    //   // if item does not exists create new item with provided data
    //   await _database.collection(_itemRef).doc(data.itemName).set({
    //     "parcel":FieldValue.arrayUnion([parcelReff]),
    //     _godownRef: {
    //       data.location: data.itemData.fold<Map>({}, (previousValue, element) {
    //         // convert list<ItemData> into map of{ItemData.size : ItemData.quantaty,...}
    //         previousValue[element.size] = element.quantity;
    //         return previousValue;
    //       })
    //     },
    //     "history": data.history //add new history
    //   });
    // }
  }

  Map<String, dynamic> customToMap(List<ItemData> itemData) {
    Map<String, dynamic> data = {};

    for (var element in itemData) {
      data[element.size] = element.quantity;
    }
    return data;
  }

  Future<void> updateStock(
      StockModel oldData, StockModel newData, String category) async {
    Map<String, dynamic> mapData = newData.toMap()
      ..["itemData"] = customToMap(newData.itemData);

    mapData["history"] = FieldValue.arrayUnion(mapData["history"]);

    if (oldData.itemName != newData.itemName) {
      await _database.collection(_categoryRef).doc(category).set({
        _itemRef: {oldData.itemName: FieldValue.delete()}
      }, SetOptions(merge: true));
    }
    await _database.collection(_categoryRef).doc(category).set({
      _itemRef: {newData.itemName: mapData}
    }, SetOptions(merge: true));
  }

  Future<List<String>> getCategoryNames() async {
    return (await _database.collection(_categoryRef).get())
        .docs
        .map<String>((e) => e.id)
        .toList();
  }

  Future<List<String>> getItemNames() async {
    return (await _database.collection(_itemRef).get())
        .docs
        .map((e) => e.id)
        .toList();
  }

  Future<void> addCategory(String name) async {
    await _database
        .collection(_categoryRef)
        .doc(name)
        .set({"name": name, _itemRef: {}});
  }

  Future<void> updateCategory(String oldName, String newName) async {
    var oldData =
        (await _database.collection(_categoryRef).doc(oldName).get()).data();

    oldData?["name"] = newName;

    await _database.collection(_categoryRef).doc(oldName).delete();
    await _database.collection(_categoryRef).doc(newName).set(oldData ?? {});
  }

  Future<List<StockModel>> getStockFromCategory(String category) async {
    List<StockModel> data = [];
    Map<String, dynamic> stocks =
        (await _database.collection(_categoryRef).doc(category).get())
            .get(_itemRef);

    List<String> keys = stocks.keys.toList();

    for (var e in keys) {
      Map itemData = stocks[e][_itemRef];
      StockModel temp = StockModel.fromMap(stocks[e]..remove(_itemRef));
      List<ItemData> datas = [];
      for (var e in itemData.entries) {
        datas.add(ItemData(size: e.key, quantity: e.value));
      }
      temp.itemData = datas;
      data.add(temp);
    }
    return data;
  }

  Future<String> getPin() async {
    FirebaseDatabase database = FirebaseDatabase.instance;
    String pin = (await database.ref("pin").get()).value as String;
    return pin;
  }

  Future<void> setPin(String pin) async {
    FirebaseDatabase database = FirebaseDatabase.instance;
    await database.ref("pin").set(pin);
  }

  Future<void> deleteCategory(String name) async {
    await _database.collection(_categoryRef).doc(name).delete();
  }

  Future<void> deleteStock(String category, String name) async {
    await _database.collection(_categoryRef).doc(category).set({
      _itemRef: {name: FieldValue.delete()}
    }, SetOptions(merge: true));
  }
}
