import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const CircleAvatar(
                radius: 60,
                backgroundColor: Colors.white,
              ),
              const SizedBox(height: 20),
              const Text(
                'Kantinan',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                '@mxmhx',
                style: TextStyle(
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
              const ListTile(
                title: Text('Email'),
                subtitle: Text('kantinan2016@gmail.com'),
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
          ),
        ),
      ),
    );
  }
}
