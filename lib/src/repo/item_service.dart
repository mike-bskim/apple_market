import 'package:apple_market/src/constants/data_keys.dart';
import 'package:apple_market/src/model/item_model.dart';
import 'package:apple_market/src/utils/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ItemService {
  static final ItemService _itemService = ItemService._internal();

  factory ItemService() => _itemService;

  ItemService._internal();

  Future createNewItem(ItemModel itemModel, String itemKey, String userKey) async {

    DocumentReference<Map<String, dynamic>> itemDocRef =
        FirebaseFirestore.instance.collection(COL_ITEMS).doc(itemKey);
    final DocumentSnapshot documentSnapshot = await itemDocRef.get();

    DocumentReference<Map<String, dynamic>> userItemDocRef =
    FirebaseFirestore.instance.collection(COL_USERS).doc(userKey).collection(COL_USER_ITEMS).doc(itemKey);

    if (!documentSnapshot.exists) {
      // await itemDocRef.set(json);
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(itemDocRef, itemModel.toJson());
        transaction.set(userItemDocRef, itemModel.toMinJson());
      });

    }
  }

  Future<ItemModel> getItem(String itemKey) async {
    if(itemKey[0] == ':') {
      String orgItemKey = itemKey;
      itemKey = itemKey.substring(1);
      logger.d('[${orgItemKey.substring(0,10)}...], ==>> [${itemKey.substring(0,9)}...]');
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
