import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart'; 
import 'package:latlong2/latlong.dart'; 
import 'screens/auth/login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_config.dart';
import 'models/provider.dart'; 

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: SupabaseConfig.url, anonKey: SupabaseConfig.anonKey);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Salud a Domicilio',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00BFA5)), useMaterial3: true),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register_provider': (context) => const ProviderRegistrationScreen(),
        '/home': (context) => const PatientHomeScreen(),
      },
    );
  }
}

class PatientHomeScreen extends StatefulWidget {
  const PatientHomeScreen({super.key});
  @override
  State<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  List<Provider> _providers = [];

  @override
  void initState() {
    super.initState();
    _fetchProviders();
  }

  Future<void> _fetchProviders() async {
    try {
      final response = await Supabase.instance.client.from('providers').select().eq('is_online', true);
      final data = response as List<dynamic>;
      setState(() {
        _providers = data.map((json) => Provider.fromJson(json)).toList();
      });
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Salud a Domicilio')),
      body: FlutterMap(
        options: const MapOptions(initialCenter: LatLng(-33.4372, -70.6506), initialZoom: 14.0),
        children: [
          TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'),
          MarkerLayer(
            markers: _providers.map((p) => Marker(
              point: LatLng(p.latitude, p.longitude),
              width: 40, height: 40,
              child: Icon(Icons.location_on, color: Theme.of(context).primaryColor, size: 40),
            )).toList(),
          ),
        ],
      ),
    );
  }
}

class ProviderRegistrationScreen extends StatelessWidget {
  const ProviderRegistrationScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Registro')), body: const Center(child: Text('Pantalla de Registro')));
  }
}
