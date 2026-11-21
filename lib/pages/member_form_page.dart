import 'package:flutter/material.dart';
import '../services/api_service.dart';

class MemberFormPage extends StatefulWidget {
  final Map<String, dynamic>? membre;

  const MemberFormPage({super.key, this.membre});

  @override
  State<MemberFormPage> createState() => _MemberFormPageState();
}

class _MemberFormPageState extends State<MemberFormPage> {
  final _nom = TextEditingController();
  final _postnom = TextEditingController();
  final _prenom = TextEditingController();
  final _lieu = TextEditingController();
  final _parente = TextEditingController();
  DateTime? _date;
  bool _chargement = false;
  String? _erreur;

  @override
  void initState() {
    super.initState();
    final m = widget.membre;
    if (m != null) {
      _nom.text = m['nom'].toString();
      _postnom.text = m['postnom'].toString();
      _prenom.text = m['prenom'].toString();
      _lieu.text = m['lieu_naissance'].toString();
      _parente.text = m['parente'].toString();
      _date = DateTime.tryParse(m['date_naissance'].toString());
    }
  }

  String _formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<void> _choisirDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _date ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (d != null) setState(() => _date = d);
  }

  Future<void> _enregistrer() async {
    if (_nom.text.trim().isEmpty ||
        _postnom.text.trim().isEmpty ||
        _prenom.text.trim().isEmpty ||
        _lieu.text.trim().isEmpty ||
        _parente.text.trim().isEmpty ||
        _date == null) {
      setState(() => _erreur = 'Remplis tous les champs');
      return;
    }

    setState(() {
      _chargement = true;
      _erreur = null;
    });

    final data = {
      'nom': _nom.text.trim(),
      'postnom': _postnom.text.trim(),
      'prenom': _prenom.text.trim(),
      'lieu_naissance': _lieu.text.trim(),
      'date_naissance': _formatDate(_date!),
      'parente': _parente.text.trim(),
    };

    try {
      final res = widget.membre == null
          ? await ApiService.createMembre(data)
          : await ApiService.updateMembre(
              int.parse(widget.membre!['id'].toString()), data);

      if (!mounted) return;

      if (res['success'] == true) {
        Navigator.pop(context, true);
      } else {
        String msg = res['message']?.toString() ?? 'Erreur';
        if (res['errors'] is Map) {
          msg = (res['errors'] as Map).values.join('\n');
        }
        setState(() {
          _erreur = msg;
          _chargement = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _erreur = 'Impossible de joindre le serveur';
        _chargement = false;
      });
    }
  }

  Widget _champ(TextEditingController c, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: c,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nom.dispose();
    _postnom.dispose();
    _prenom.dispose();
    _lieu.dispose();
    _parente.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.membre == null
            ? 'Ajouter un membre'
            : 'Modifier le membre'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _champ(_nom, 'Nom'),
            _champ(_postnom, 'Postnom'),
            _champ(_prenom, 'Prénom'),
            _champ(_lieu, 'Lieu de naissance'),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _choisirDate,
                  icon: const Icon(Icons.calendar_today),
                  label: Text(_date == null
                      ? 'Date de naissance'
                      : _formatDate(_date!)),
                ),
              ),
            ),
            _champ(_parente, 'Parenté (père, mère, frère...)'),
            if (_erreur != null) ...[
              Text(_erreur!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 12),
            ],
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _chargement ? null : _enregistrer,
                child: _chargement
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Enregistrer'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}