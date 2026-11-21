import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'member_form_page.dart';

class FamilyPage extends StatefulWidget {
  const FamilyPage({super.key});

  @override
  State<FamilyPage> createState() => _FamilyPageState();
}

class _FamilyPageState extends State<FamilyPage> {
  late Future<List<dynamic>> _membres;

  @override
  void initState() {
    super.initState();
    _membres = ApiService.getMembres();
  }

  void _recharger() {
    setState(() {
      _membres = ApiService.getMembres();
    });
  }

  Future<void> _ajouter() async {
    final ok = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const MemberFormPage()),
    );
    if (ok == true) _recharger();
  }

  Future<void> _modifier(Map<String, dynamic> m) async {
    final ok = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => MemberFormPage(membre: m)),
    );
    if (ok == true) _recharger();
  }

  Future<void> _supprimer(Map<String, dynamic> m) async {
    final confirme = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer ce membre ?'),
        content: Text('${m['prenom']} ${m['nom']} sera supprimé.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
    if (confirme != true) return;

    try {
      final res =
          await ApiService.deleteMembre(int.parse(m['id'].toString()));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res['message']?.toString() ?? 'Terminé')),
      );
      _recharger();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Impossible de joindre le serveur')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _ajouter,
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _membres,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Impossible de charger les membres'),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: _recharger,
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            );
          }

          final membres = snapshot.data!;
          if (membres.isEmpty) {
            return const Center(child: Text('Aucun membre pour le moment'));
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 80),
            itemCount: membres.length,
            itemBuilder: (context, i) {
              final m = membres[i] as Map<String, dynamic>;
              final imageUrl = m['image_url'];
              return Card(
                child: ListTile(
                  onTap: () => _modifier(m),
                  leading: CircleAvatar(
                    radius: 28,
                    backgroundImage:
                        imageUrl != null ? NetworkImage(imageUrl) : null,
                    child: imageUrl == null ? const Icon(Icons.person) : null,
                  ),
                  title: Text(
                    '${m['prenom']} ${m['nom']} ${m['postnom']}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${m['parente']} • ${m['lieu_naissance']} • ${m['date_naissance']}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _supprimer(m),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}