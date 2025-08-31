import 'package:flutter/material.dart';
import 'package:meetup/controllers/AuthController.dart';
import 'package:meetup/shared/custom_app_bar.dart';

class MesUsersPage extends StatefulWidget {
  const MesUsersPage({super.key});

  @override
  State<MesUsersPage> createState() => _MesUsersPageState();
}

class _MesUsersPageState extends State<MesUsersPage> {
  final authController = AuthController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LoveAppBar(title: 'test', showLogoutButton: true),
      body: StreamBuilder(stream: authController.stream, builder: (context, snapshot){
        if(!snapshot.hasData){
          return const Center(child: CircularProgressIndicator());
        }

        final users = snapshot.data!;

        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index){
            final user = users[index];
            return ListTile(
              title: Text(user.nom),
              trailing: Icon(Icons.add_home_work),
            );
          },
          );
      }
      ),
    );
  }
}