import 'package:cloud_firestore/cloud_firestore.dart';

class DataModel {
  final String? name;
  final String? cause;
  final String? affirmation;

  DataModel({this.name, this.cause, this.affirmation});

  //Create a method to convert QuerySnapshot from Cloud Firestore to a list of objects of this DataModel
  //This function in essential to the working of FirestoreSearchScaffold
  List<DataModel> dataListFromSnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((snapshot) {
      final Map<String, dynamic> dataMap =
      snapshot.data() as Map<String, dynamic>;

      return DataModel(
          name: dataMap['name'],
          cause: dataMap['cause'],
          affirmation: dataMap['affirmation']);
    }).toList();
  }
}