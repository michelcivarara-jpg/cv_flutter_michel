import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'main_shell.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailCtrl = TextEditingController();
  final _pwdCtrl = TextEditingController();
  String? _erreur;
  String? _info;
  bool _chargement = false;

  Future<void> _envoyer(bool creer) async {
    final email = _emailCtrl.text.trim();
    final pwd = _pwdCtrl.text;

    if (email.isEmpty || pwd.isEmpty) {
      setState(() {
        _erreur = 'Remplis l\'e-mail et le mot de passe';
        _info = null;
      });
      return;
    }

    setState(() {
      _chargement = true;
      _erreur = null;
      _info = null;
    });

    try {
      final rep = creer
          ? await ApiService.register(email, pwd)
          : await ApiService.login(email, pwd);
      if (!mounted) return;

      if (rep['success'] == true) {
        if (creer) {
          setState(() => _info = 'Compte créé. Tu peux te connecter.');
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const MainShell()),
          );
        }
      } else {
        String msg = rep['message']?.toString() ?? 'Erreur';
        final errs = rep['errors'];
        if (errs is Map && errs.isNotEmpty) {
          msg = errs.values.join('\n');
        }
        setState(() => _erreur = msg);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _erreur =
          'Impossible de joindre l\'API. XAMPP est-il démarré ?');
    } finally {
      if (mounted) setState(() => _chargement = false);
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _pwdCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Icon(Icons.account_circle, size: 96, color: Colors.indigo),
              const SizedBox(height: 16),
              const Text('Connexion', style: TextStyle(fontSize: 28)),
              const SizedBox(height: 32),
              TextField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _pwdCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Mot de passe',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
              ),
              if (_erreur != null) ...[
                const SizedBox(height: 12),
                Text(_erreur!, style: const TextStyle(color: Colors.red)),
              ],
              if (_info != null) ...[
                const SizedBox(height: 12),
                Text(_info!, style: const TextStyle(color: Colors.green)),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _chargement ? null : () => _envoyer(false),
                  child: _chargement
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Se connecter'),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: _chargement ? null : () => _envoyer(true),
                child: const Text('Créer un compte'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}