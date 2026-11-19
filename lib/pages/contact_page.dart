import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  Future<void> _ouvrir(BuildContext context, String url) async {
    final ok = await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Impossible d\'ouvrir ce lien')),
      );
    }
  }

  Widget _tuile(BuildContext context, IconData icone, String titre,
      String valeur, String? url) {
    return Card(
      child: ListTile(
        leading: Icon(icone, color: Colors.indigo),
        title: Text(titre),
        subtitle: Text(valeur),
        trailing: url == null ? null : const Icon(Icons.open_in_new),
        onTap: url == null ? null : () => _ouvrir(context, url),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        _tuile(context, Icons.phone, 'Téléphone', '+243 980 042 542',
            'tel:+243980042542'),
        _tuile(context, Icons.email, 'E-mail', 'michelcivarara@gmail.com',
            'mailto:michelcivarara@gmail.com'),
        _tuile(context, Icons.location_on, 'Adresse', 'Goma, RDC', null),
        _tuile(context, Icons.link, 'LinkedIn', 'linkedin.com/in/ton-profil',
            'https://linkedin.com/in/ton-profil'),
        _tuile(context, Icons.code, 'GitHub', 'github.com/michelcivarara-jpg',
            'https://github.com/michelcivarara-jpg'),
      ],
    );
  }
}