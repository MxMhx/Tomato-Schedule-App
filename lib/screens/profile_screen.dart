import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tomato_schedule/configs/config.dart';
import 'package:tomato_schedule/model/user_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final storage = const FlutterSecureStorage();

  final dio = Dio();

  Future<User?> getUser() async {
    final jsonString = await storage.read(key: userKey);
    if (jsonString != null) {
      return userFromJson(jsonString);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Profile',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: FutureBuilder(
              future: getUser(),
              builder: (context, snapshot) {
                if (snapshot.data != null) {
                  User user = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        user.fullname,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '@${user.username}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'im mobile developer',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Divider(
                        thickness: 1,
                        color: Colors.grey[300],
                      ),
                      ListTile(
                        title: const Text('Email'),
                        subtitle: Text(user.email),
                      ),
                      Divider(
                        thickness: 1,
                        color: Colors.grey[300],
                      ),
                      const ListTile(
                        title: Text('All task'),
                        subtitle: Text('456'),
                      ),
                      Divider(
                        thickness: 1,
                        color: Colors.grey[300],
                      ),
                      const ListTile(
                        title: Text('Following'),
                        subtitle: Text('789'),
                      ),
                    ],
                  );
                }
                return Container();
              }),
        ),
      ),
    );
  }
}
