import 'package:flutter/material.dart';

class Membre {
  final String nom;
  final String lien;
  final String photo;
  const Membre(this.nom, this.lien, this.photo);
}

class FamilyPage extends StatelessWidget {
  const FamilyPage({super.key});

  static const membres = [
    Membre('Bienaimé', 'Père', 'assets/images/bienaime.png'),
    Membre('Emmanuella', 'Sœur', 'assets/images/emmanuella.png'),
    Membre('Narval Civa', 'Frère', 'assets/images/narval.png'),
    Membre('Wivine', 'Sœur', 'assets/images/wivine.png'),
    Membre('Ange', 'Sœur', 'assets/images/ange.png'),
    Membre('Jules', 'Frère', 'assets/images/jules.png'),
    Membre('Véro', 'Sœur', 'assets/images/vero.png'),
    Membre('Amani', 'Sœur', 'assets/images/amani.png'),
    Membre('Anselme', 'Frère', 'assets/images/anselme.png'),
    Membre('Prince', 'Frère', 'assets/images/prince.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: membres.length,
      itemBuilder: (context, i) {
        final m = membres[i];
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              radius: 28,
              backgroundImage: AssetImage(m.photo),
            ),
            title: Text(
              m.nom,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(m.lien),
          ),
        );
      },
    );
  }
}