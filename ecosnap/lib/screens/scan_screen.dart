import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../models/scan.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/eco_logo.dart';

class ScanScreen extends StatefulWidget {
  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  File? _image;
  Scan? _scanResult;
  bool isLoading = false;
  final ImagePicker _picker = ImagePicker();

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _scanResult = null;
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null) return;

    setState(() {
      isLoading = true;
      _scanResult = null;
    });

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    try {
      final scanId = await ApiService.uploadScan(_image!, token);
      if (scanId == null) {
        setState(() => isLoading = false);
        _showError('Erreur pendant le scan');
        return;
      }

      Scan? scanResult;
      int attempts = 0;
      const maxAttempts = 30;

      while (attempts < maxAttempts) {
        await Future.delayed(const Duration(seconds: 3));
        scanResult = await ApiService.getScanResult(token, scanId);

        if (scanResult != null &&
            scanResult.result != null &&
            scanResult.category != null &&
            scanResult.recyclable != null) {
          break;
        }
        attempts++;
      }

      setState(() {
        _scanResult = scanResult;
        isLoading = false;
      });

      if (_scanResult == null ||
          _scanResult!.result == null ||
          _scanResult!.category == null ||
          _scanResult!.recyclable == null) {
        _showError("Pas de résultat complet après plusieurs tentatives");
      }
    } catch (e) {
      setState(() => isLoading = false);
      _showError("Erreur de connexion");
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget _buildResultCard() {
    if (_scanResult == null) return const SizedBox.shrink();

    final isRecyclable = _scanResult!.recyclable == true;
    final recyclableColor =
        isRecyclable ? const Color(0xFF2E7D32) : const Color(0xFFC62828);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isRecyclable ? Icons.check_circle : Icons.cancel,
                  color: recyclableColor,
                  size: 30,
                ),
                const SizedBox(width: 10),
                Text(
                  isRecyclable ? 'RECYCLABLE' : 'NON RECYCLABLE',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: recyclableColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
                'Description', _scanResult!.result ?? "Non disponible"),
            const SizedBox(height: 12),
            _buildInfoRow('Catégorie', _scanResult!.category ?? "Inconnue"),
            const SizedBox(height: 12),
            _buildInfoRow(
                'Recyclabilité',
                isRecyclable
                    ? "Cet objet peut être recyclé"
                    : "Cet objet n'est pas recyclable"),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildImageSelection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Comment souhaitez-vous scanner?',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildSelectionButton(
              icon: Icons.camera_alt,
              label: 'Prendre une photo',
              onPressed: () => _getImage(ImageSource.camera),
            ),
            _buildSelectionButton(
              icon: Icons.photo_library,
              label: 'Choisir une image',
              onPressed: () => _getImage(ImageSource.gallery),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSelectionButton(
      {required IconData icon,
      required String label,
      required VoidCallback onPressed}) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Color(0xFFE8F5E9),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Color(0xFF2E7D32)),
          ),
          child: IconButton(
            icon: Icon(icon, size: 40, color: Color(0xFF2E7D32)),
            onPressed: onPressed,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style:
              TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      // Affichage de l'image ou des options de sélection
                      if (_image == null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 30, horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 8,
                                spreadRadius: 1,
                                offset: Offset(0, 2),
                              )
                            ],
                          ),
                          child: _buildImageSelection(),
                        ),
                      ] else ...[
                        Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.file(_image!,
                                height: 250, fit: BoxFit.cover),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],

                      // Bouton d'analyse
                      if (_image != null && !isLoading && _scanResult == null)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _uploadImage,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF2E7D32),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 3,
                            ),
                            child: const Text(
                              'ANALYSER L\'IMAGE',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),

                      // Chargement en cours
                      if (isLoading) ...[
                        const SizedBox(height: 30),
                        CircularProgressIndicator(color: Color(0xFF2E7D32)),
                        const SizedBox(height: 20),
                        const Text('Analyse en cours...',
                            style: TextStyle(fontSize: 16)),
                      ],

                      // Résultats
                      if (_scanResult != null) ...[
                        const SizedBox(height: 20),
                        _buildResultCard(),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _image = null;
                                _scanResult = null;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Color(0xFF2E7D32),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(color: Color(0xFF2E7D32)),
                              ),
                            ),
                            child: const Text(
                              'Nouveau scan',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              // EN-TÊTE EN BAS
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  children: [
                    const EcoLogo(size: 80),
                    const SizedBox(height: 20),
                    Text(
                      'Scanner un déchet',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Identifiez vos déchets et découvrez comment les recycler',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),

              // APPBAR EN BAS
              CustomAppBar(currentIndex: 1),
            ],
          ),
        ),
      ),
    );
  }
}
