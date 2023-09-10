import 'package:flutter/material.dart';
import 'package:mvvm_provider_dio/constants/asset.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    Key? key,
  }) : super(key: key);

  UserAccountsDrawerHeader _buildProfile() => UserAccountsDrawerHeader(
        currentAccountPicture: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: const CircleAvatar(
            backgroundImage: AssetImage(Asset.logoImage),
          ),
        ),
        accountName: const Text('ITGenius'),
        accountEmail: const Text('contact@itgenius.co.th'),
      );

  Builder _buildLogoutButton() => Builder(
        builder: (context) => SafeArea(
          child: ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Log out'),
            onTap: () {},
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          _buildProfile(),
          ListTile(
            onTap: () {},
            title: const Text("BarCode"),
            leading:
                const Icon(Icons.barcode_reader, color: Colors.deepOrange),
          ),
          ListTile(
            onTap: () {},
            title: const Text("QRCode"),
            leading: const Icon(Icons.qr_code, color: Colors.green),
          ),
          ListTile(
            onTap: () {},
            title: const Text("Scanner"),
            leading: const Icon(Icons.qr_code_scanner, color: Colors.blueGrey),
          ),
          const Spacer(),
          _buildLogoutButton(),
        ],
      ),
    );
  }
}
