import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
                Center(
          child: Text(
            'Étudiant en informatique appliquée à la gestion des entreprises',
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 12),
        Center(
          child: Text(
                        'Michel Civarara',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        Center(child: Text('Étudiant en informatique - Développeur mobile')),
        SizedBox(height: 16),
                         Section('Formation', [
          '2026 : Licence 3 (L3), Informatique appliquée à la gestion des entreprises, ISG Goma',
          'Secondaire : Institut Mwanga, Uvira',
        ]),       
                Section('Expériences', [
          'Stage : AIRD',
          'Stage : Sabuni Dawa',
          'Projet : création d\'un site web',
        ]),
        Section('Compétences techniques', [
          'Dart / Flutter',
          'Python, Java',
          'HTML, CSS, JavaScript',
          'Git et GitHub',
        ]),
                Section('Langues', [
          'Français',
          'Lingala',
          'Swahili',
          'Anglais',
        ]),
        Section('Centres d\'intérêt', [
          'Football',
          'Lecture',
          'Nouvelles technologies',
        ]),
      ],
    );
  }
}

class Section extends StatelessWidget {
  final String titre;
  final List<String> lignes;
  const Section(this.titre, this.lignes, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titre,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            for (final l in lignes)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Text('• $l'),
              ),
          ],
        ),
      ),
    );
  }
}