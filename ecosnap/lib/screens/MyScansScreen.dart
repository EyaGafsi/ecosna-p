import 'package:ecosnap/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/scan.dart';
import '../services/api_service.dart';
import '../widgets/custom_appbar.dart';

class MyScansScreen extends StatefulWidget {
  @override
  _MyScansScreenState createState() => _MyScansScreenState();
}

class _MyScansScreenState extends State<MyScansScreen> {
  List<Scan> _scans = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchScans();
  }

  Future<void> fetchScans() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    try {
      final scans = await ApiService.getMyScans(token);
      setState(() {
        _scans = scans;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Gérer l'erreur si besoin
    }
  }

  Widget _buildScanCard(Scan scan) {
    final isRecyclable = scan.recyclable == true;
    final recyclableColor =
        isRecyclable ? Color(0xFF2E7D32) : Color(0xFFC62828);

    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[100],
                  ),
                  child: scan.imageUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            '$baseUrl${scan.imageUrl}',
                            fit: BoxFit.cover,
                          ),
                        )
                      : Center(
                          child:
                              Icon(Icons.photo, size: 40, color: Colors.grey),
                        ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            isRecyclable ? Icons.check_circle : Icons.cancel,
                            color: recyclableColor,
                            size: 20,
                          ),
                          SizedBox(width: 6),
                          Text(
                            isRecyclable ? 'Recyclable' : 'Non recyclable',
                            style: TextStyle(
                              color: recyclableColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      if (scan.category != null) ...[
                        Text(
                          scan.category!,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                      ],
                      Text(
                        scan.result ?? 'Analyse en cours...',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ID: ${scan.id}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  '${scan.createdAt.toLocal().toString().split(' ')[0]}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Suppression de l'appBar en haut
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE8F5E9),
              Color(0xFFC8E6C9),
            ],
          ),
        ),
        child: Column(
          children: [
            // Ajout de l'en-tête personnalisé en haut
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.blue[50],
              child: Center(
                child: Text(
                  'Mes Scans',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
            Expanded(
              child: isLoading
                  ? Center(
                      child:
                          CircularProgressIndicator(color: Color(0xFF2E7D32)),
                    )
                  : _scans.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Remplacement par logo.png
                              Image.asset(
                                'assets/logo.png', // Chemin vers votre logo
                                width: 120,
                                height: 120,
                                fit: BoxFit.contain,
                              ),
                              SizedBox(height: 20),
                              Text(
                                'Aucun scan enregistré',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2E7D32),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Commencez par scanner vos premiers déchets',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[700],
                                ),
                              ),
                              SizedBox(height: 30),
                              ElevatedButton(
                                onPressed: () =>
                                    Navigator.pushNamed(context, '/scan'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF2E7D32),
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 32, vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: Text(
                                  'Scanner un déchet',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          itemCount: _scans.length,
                          itemBuilder: (context, index) {
                            return _buildScanCard(_scans[index]);
                          },
                        ),
            ),
          ],
        ),
      ),
      // Ajout de l'appBar personnalisée en bas
      bottomNavigationBar: CustomAppBar(
        currentIndex: 2, // Index pour indiquer la page active
      ),
    );
  }
}
