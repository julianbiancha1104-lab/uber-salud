import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _rutController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _login() async {
    setState(() => _isLoading = true);
    try {
      final email = _rutController.text.trim();
      final authEmail = email.contains('@') ? email : '$email@ubersalud.cl';
      await Supabase.instance.client.auth.signInWithPassword(email: authEmail, password: _passwordController.text);
      if (mounted) Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.health_and_safety, size: 80, color: Color(0xFF00BFA5)),
            const SizedBox(height: 32),
            TextField(controller: _rutController, decoration: const InputDecoration(labelText: 'Email o RUT', border: OutlineInputBorder())),
            const SizedBox(height: 16),
            TextField(controller: _passwordController, obscureText: true, decoration: const InputDecoration(labelText: 'Contraseña', border: OutlineInputBorder())),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _login,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00BFA5), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16)),
              child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Iniciar Sesión'),
            ),
            TextButton(onPressed: () => Navigator.pushNamed(context, '/register_provider'), child: const Text('¿Eres profesional? Regístrate aquí')),
          ],
        ),
      ),
    );
  }
}
