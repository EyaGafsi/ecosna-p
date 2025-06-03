import 'package:ecosnap/screens/MyScansScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import '../services/api_service.dart';
import '../models/user.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/eco_logo.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final fetchedUser = await ApiService.getProfile(token);
    setState(() {
      user = fetchedUser;
      isLoading = false;
    });
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    context.go('/');
  }

  Widget _buildStatCard(String title, String value) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
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
              // ✅ Entête personnalisée
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    Icon(Icons.person, size: 28, color: Color(0xFF2E7D32)),
                    SizedBox(width: 10),
                    Text(
                      'Mon Profil',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                  ],
                ),
              ),

              // ✅ Custom AppBar
              CustomAppBar(currentIndex: 3),

              // ✅ Contenu principal
              Expanded(
                child: isLoading
                    ? Center(
                        child:
                            CircularProgressIndicator(color: Color(0xFF2E7D32)),
                      )
                    : user == null
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                EcoLogo(size: 100),
                                SizedBox(height: 20),
                                Text(
                                  'Erreur de chargement du profil',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.red,
                                  ),
                                ),
                                SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: loadProfile,
                                  child: Text('Réessayer'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF2E7D32),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : SingleChildScrollView(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 60,
                                  backgroundColor:
                                      Color(0xFF2E7D32).withOpacity(0.1),
                                  child: Icon(
                                    Icons.person,
                                    size: 60,
                                    color: Color(0xFF2E7D32),
                                  ),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  user!.username,
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2E7D32),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  user!.email,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                SizedBox(height: 30),

                                // ✅ Boutons d'action
                                Card(
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                  child: Column(
                                    children: [
                                      ListTile(
                                        leading: Icon(Icons.history,
                                            color: Color(0xFF2E7D32)),
                                        title: Text('Mes scans'),
                                        trailing: Icon(Icons.arrow_forward_ios,
                                            size: 16),
                                        onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                MyScansScreen(),
                                          ),
                                        ),
                                      ),
                                      Divider(height: 0),
                                      ListTile(
                                        leading: Icon(Icons.settings,
                                            color: Color(0xFF2E7D32)),
                                        title: Text('Paramètres'),
                                        trailing: Icon(Icons.arrow_forward_ios,
                                            size: 16),
                                        onTap: () {},
                                      ),
                                      Divider(height: 0),
                                      ListTile(
                                        leading: Icon(Icons.help,
                                            color: Color(0xFF2E7D32)),
                                        title: Text('Aide & Support'),
                                        trailing: Icon(Icons.arrow_forward_ios,
                                            size: 16),
                                        onTap: () {},
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 30),

                                // ✅ Bouton de déconnexion
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: logout,
                                    icon: Icon(Icons.logout),
                                    label: Text('Se déconnecter'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.red,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        side: BorderSide(color: Colors.red),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                              ],
                            ),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
