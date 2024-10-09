import 'package:flutter/material.dart';
import 'package:minimsgapp_pantaleta/Pages/profile_pg.dart';
import 'package:minimsgapp_pantaleta/Services/Auth/auth_service.dart';
import 'package:minimsgapp_pantaleta/Pages/settings_pg.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  void logout() {
    final _auth = AuthService();
    _auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final _auth = AuthService();
    final currentUser = _auth.getCurrentUser();

    return Drawer(
        backgroundColor: Theme.of(context).colorScheme.background,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //Logo
            DrawerHeader(
              child: Icon(Icons.chat_bubble,
                  color: Theme.of(context).colorScheme.primary, size: 64),
            ),
            // User info
            FutureBuilder(
              future: _auth.getCurrentUserUsername(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: RichText(
                      text: TextSpan(
                        text: "Logged in as: ",
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        children: [
                          TextSpan(
                            text: snapshot.data ?? currentUser?.email,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return const Padding(
                    padding: EdgeInsets.only(left: 25.0),
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
            // Profile list tile
            Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: ListTile(
                title: const Text("P R O F I L E"),
                leading: const Icon(Icons.person_2),
                onTap: () {
                  Navigator.pop(context);

                  // Navigate to profile
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(),
                      ));
                },
              ),
            ),
            // Home list tile
            Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: ListTile(
                title: const Text("H O M E"),
                leading: const Icon(Icons.home),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            // Settings list tile
            Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: ListTile(
                title: const Text("S E T T I N G S"),
                leading: const Icon(Icons.settings),
                onTap: () {
                  Navigator.pop(context);

                  // Navigate to Settings
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingsPage(),
                      ));
                },
              ),
            ),
            // Logout tile
            Padding(
              padding: const EdgeInsets.only(left: 25.0, bottom: 25),
              child: ListTile(
                title: const Text("L O G O U T"),
                leading: const Icon(Icons.logout),
                onTap: logout,
              ),
            ),
          ],
        ));
  }
}
