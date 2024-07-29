import 'package:flutter/material.dart';

import '../../data/database/database_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseService _databaseService = DatabaseService();

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    await _databaseService.init();
  }

  Future<void> _createSampleDocument() async {
    await _databaseService.createDocument({
      'id': 'user:001',
      'name': 'John Doe',
      'email': 'john.doe@example.com',
    });
  }

  Future<void> _readSampleDocument() async {
    final doc = await _databaseService.readDocument('user:001');
    if (doc != null) {
      debugPrint('Document Data: ${doc.toString()}');
    }
  }

  Future<void> _updateSampleDocument() async {
    await _databaseService.updateDocument('user:001', {
      'name': 'Jane Doe',
      'email': 'jane.doe@example.com',
    });
  }

  Future<void> _deleteSampleDocument() async {
    await _databaseService.deleteDocument('user:001');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Couchbase with Flutter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _createSampleDocument,
              child: Text('Create Document'),
            ),
            ElevatedButton(
              onPressed: _readSampleDocument,
              child: Text('Read Document'),
            ),
            ElevatedButton(
              onPressed: _updateSampleDocument,
              child: Text('Update Document'),
            ),
            ElevatedButton(
              onPressed: _deleteSampleDocument,
              child: Text('Delete Document'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _databaseService.close();
    super.dispose();
  }
}
