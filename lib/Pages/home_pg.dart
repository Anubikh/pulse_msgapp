import 'package:flutter/material.dart';
import 'package:minimsgapp_pantaleta/Components/my_drawer.dart';
import 'package:minimsgapp_pantaleta/Components/user_tile.dart';
import 'package:minimsgapp_pantaleta/Pages/chat_pg.dart';
import 'package:minimsgapp_pantaleta/Services/Auth/auth_service.dart';
import 'package:minimsgapp_pantaleta/Services/Chat/chat_services.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ChatServices _chatServices = ChatServices();
  final AuthService _authService = AuthService();
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  List<Map<String, dynamic>> _users = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          "HOME",
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.secondary,
      ),
      drawer: MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Header
            Row(
              children: [
                Text(
                  "Chats",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const Spacer(),
                // Search Icon
                IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () {
                    setState(() {
                      _isSearching = !_isSearching;
                    });
                  },
                ),
              ],
            ),
            _isSearching
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Search',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                          },
                        ),
                      ),
                      onChanged: (text) {
                        setState(() {});
                      },
                    ),
                  )
                : const SizedBox(height: 16),

            // User List
            Expanded(
              child: _buildUserList(),
            ),
          ],
        ),
      ),
    );
  }

  // Builds a list of users except for the current logged in user
  Widget _buildUserList() {
    return StreamBuilder(
        stream: _chatServices.getUsersStream(),
        builder: (context, snapshot) {
          // Error Handling
          if (snapshot.hasError) {
            return const Text("Error");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data != null) {
            _users = snapshot.data!;
          }

          if (_isSearching && _searchController.text.isNotEmpty) {
            return ListView(
              children: _users
                  .where((userData) => userData["username"]
                      .toString()
                      .toLowerCase()
                      .contains(_searchController.text.toLowerCase()))
                  .map<Widget>(
                      (userData) => _buildUserListItem(userData, context))
                  .toList(),
            );
          } else {
            return ListView(
              children: _users
                  .map<Widget>(
                      (userData) => _buildUserListItem(userData, context))
                  .toList(),
            );
          }
        });
  }

  // Build individual list tile for user
  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    if (userData["email"] != _authService.getCurrentUser()!.email) {
      return UserTile(
        text: userData["username"] ??
            userData[
                "email"], // Display username if available, otherwise display email
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  recieverUsername: userData['username'],
                  recieverEmail: userData["email"],
                  recieverID: userData["uid"],
                ),
              ));
        },
      );
    } else {
      return Container();
    }
  }
}
