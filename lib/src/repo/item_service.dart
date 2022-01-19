import 'package:apple_market/src/constants/data_keys.dart';
import 'package:apple_market/src/model/item_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ItemService {
  static final ItemService _itemService = ItemService._internal();

  factory ItemService() => _itemService;

  ItemService._internal();

  Future createNewItem(Map<String, dynamic> json, String itemKey) async {
    DocumentReference<Map<String, dynamic>> docRef =
        FirebaseFirestore.instance.collection(COL_ITEMS).doc(itemKey);
    final DocumentSnapshot documentSnapshot = await docRef.get();

    if (!documentSnapshot.exists) {
      await docRef.set(json);
    }
  }

  Future<ItemModel> getItem(String itemKey) async {
    if(itemKey[0] == ':') {
      itemKey = itemKey.substring(1);
    }
    DocumentReference<Map<String, dynamic>> docRef =
        FirebaseFirestore.instance.collection(COL_ITEMS).doc(itemKey);
    final DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await docRef.get();

    ItemModel itemModel = ItemModel.fromSnapshot(documentSnapshot);

    return itemModel;
  }

  Future<List<ItemModel>> getItems() async {
    CollectionReference<Map<String, dynamic>> collectionReference =
        FirebaseFirestore.instance.collection(COL_ITEMS);
    QuerySnapshot<Map<String, dynamic>> snapshots = await collectionReference.get();
    List<ItemModel> items = [];

    for (var snapshot in snapshots.docs) {
      ItemModel itemModel = ItemModel.fromQuerySnapshot(snapshot);
      items.add(itemModel);
    }

    return items;
  }
}
