import 'package:cbl/cbl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DatabaseService {
  late final Database _database;
  late final Collection _collection;
  String myDatabase = 'my_database';
  String userProfiles = 'userprofiles';

  // Initialize the database
  Future<void> init() async {
    // Open the database (creating it if it doesn’t exist).
    _database = await Database.openAsync(
      myDatabase,
      DatabaseConfiguration(),
    );
    _collection = await _database.createCollection(userProfiles);
    runTest();
  }

  // Create a document
  Future<void> showToast(String msg) async {
    debugPrint(msg);
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM_LEFT,
        timeInSecForIosWeb: 5,
        backgroundColor: Colors.white70,
        textColor: Colors.black,
        fontSize: 16.0);
  }

  // Create a document
  Future<void> createDocument(Map<String, dynamic> data) async {
    var document = MutableDocument.withId(data["id"].toString(), data);
    await _collection.saveDocument(document);
    showToast('Created document with id ${data["id"]}');
  }

  // Read a document by ID
  Future<Map<String, dynamic>?> readDocument(String id) async {
    final document = (await _collection.document(id));
    if (document == null) {
      showToast('No document found with id $id @ $userProfiles');
      return null;
    }
    showToast('Read document with id = $id => ${document.toString()}');
    return document.toPlainMap();
  }

  // replate a document
  Future<void> replateDocument(String id, Map<String, dynamic> data) async {
    var document = MutableDocument.withId(data["id"].toString(), data);
    await _collection.saveDocument(document);
    showToast('Replate document id = $id');
  }

  // Update a document
  Future<void> updateDocument(
      String id, Map<String, dynamic> updateData) async {
    var document = await readDocument(id);
    if (document == null) {
      updateData["id"] = id;
      final updateDocument = MutableDocument.withId(id, updateData);
      await _collection.saveDocument(updateDocument);
      showToast(
          'Update/Created document id = $id with ${updateData.toString()}');
      return;
    }
    MutableDocument? updateDocument = MutableDocument.withId(id, document);
    updateDocument.setData(updateData);
    await _collection.saveDocument(updateDocument);
    showToast('Update document id = $id with ${updateData.toString()}');
  }

  // Delete a document by ID
  Future<void> deleteDocument(String id) async {
    final document = (await _collection.document(id));
    if (document == null) {
      showToast('No document found with id $id @ $userProfiles');
    }
    if (document != null) {
      await _collection.deleteDocument(document);
      showToast('Delete a document with id $id');
    }
  }

  Future<List<Result>> _queryUserProfiles(String? id) async {
    // Create a query to fetch documents of type id.
    debugPrint('Querying Documents of id=$id');
    Query query;
    if (id != null || id!.isNotEmpty) {
      query = await _database.createQuery('''
      SELECT * FROM $userProfiles
      WHERE id = '$id'
      ''');
    } else {
      query = await _database.createQuery('''
      SELECT * FROM $userProfiles
      ''');
    }
    // Run the query.
    final result = await query.execute();
    final results = await result.allResults();
    showToast('Number of results: ${results.length}');
    return results;
  }

  // Get documents
  Future<List<Map<String, dynamic>>> getDocuments(String? id) async {
    final results = await _queryUserProfiles(id);
    if (results.isEmpty) {
      return [];
    }

    List<Map<String, dynamic>> documents = [];
    for (var e in results) {
      documents.add(e.toPlainMap());
    }
    return documents;
  }

  // Close the database
  Future<void> close() async {
    await _database.close();
  }

  /// run test
  Future<void> runTest() async {
    debugPrint("run test");
    // Open the database (creating it if it doesn’t exist).
    final database = await Database.openAsync('database');

    // Create a collection, or return it if it already exists.
    final collection = await database.createCollection('components');

    // Create a new document.
    final mutableDocument = MutableDocument({'type': 'SDK', 'majorVersion': 2});
    await collection.saveDocument(mutableDocument);

    debugPrint(
      'Created document with id ${mutableDocument.id} and '
      'type ${mutableDocument.string('type')}.',
    );

    // Update the document.
    mutableDocument.setString('Dart', key: 'language');
    await collection.saveDocument(mutableDocument);

    debugPrint(
      'Updated document with id ${mutableDocument.id}, '
      'adding language ${mutableDocument.string("language")!}.',
    );

    // Read the document.
    final document = (await collection.document(mutableDocument.id))!;

    debugPrint(
      'Read document with id ${document.id}, '
      'type ${document.string('type')} and '
      'language ${document.string('language')}.',
    );

    // Create a query to fetch documents of type SDK.
    debugPrint('Querying Documents of type=SDK.');
    final query = await database.createQuery('''
      SELECT * FROM components
      WHERE type = 'SDK'
      ''');

    // Run the query.
    final result = await query.execute();
    final results = await result.allResults();
    debugPrint('Number of results: ${results.length}');

    // delete a Document
    await collection.deleteDocument(mutableDocument);

    // Close the database.
    await database.close();
  }
}
