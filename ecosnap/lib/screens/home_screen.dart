import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../models/feed.dart';
import '../widgets/feed_card.dart';
import '../widgets/custom_appbar.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Feed>> feeds;

  @override
  void initState() {
    super.initState();
    feeds = fetchFeeds();
  }

  Future<List<Feed>> fetchFeeds() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return await ApiService.fetchFeeds(token ?? '');
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
        child: Column(
          children: [
            // Header with app name and logo
            Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 20,
                left: 24,
                right: 24,
                bottom: 20,
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/logo.png',
                    width: 40,
                    height: 40,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(width: 12),
                  Text(
                    'EcoSnap',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                  Spacer(),
                  Text(
                    'Actualités',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Feed>>(
                future: feeds,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF2E7D32),
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.grey[600],
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Erreur lors du chargement.',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/logo.png',
                            width: 120,
                            height: 120,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Aucun contenu disponible.',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2E7D32),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Revenez plus tard pour découvrir\nles dernières actualités éco-responsables',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return ListView.builder(
                      padding: EdgeInsets.only(bottom: 20),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) =>
                          FeedCard(feed: snapshot.data![index]),
                    );
                  }
                },
              ),
            ),
            // Votre CustomAppBar sera positionné en bas ici
            CustomAppBar(currentIndex: 0),
          ],
        ),
      ),
    );
  }
}
