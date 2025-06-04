import 'package:eco_habit/Huella_de_carbonoCU3_CU6/Estimar_Huella_AnualCU3/huella_anual.dart';
import 'package:eco_habit/Consultar_Centros_de_ReciclajeCU2_CU4/lista_centros.dart';
import 'package:eco_habit/Consultar_Centros_de_ReciclajeCU2_CU4/mapa_page.dart';
import 'package:eco_habit/Registrar_metas_personalesCU7/metas_page.dart';
import 'package:flutter/material.dart';
import 'Configurar_AlertaCU1/alerts_page.dart';
import 'Configurar_AlertaCU1/notifications_service.dart';
import 'politica.dart';
import 'package:geolocator/geolocator.dart';
import 'Consultar_guias_de_reciclajeCU5/guias_page.dart';
import 'Huella_de_carbonoCU3_CU6/huella_menu.dart';
import 'Calcular_impacto_ambiental_por_residuoCU8/calculadora_impacto_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<Position> determinePosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('error');
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  void getCurrentLocation() async {
    Position position = await determinePosition();
    print(position.latitude);
    print(position.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _buildHeader(),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildButton(Icons.notifications_active, 'Alertas', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AlertsPage()),
                      );
                    }),
                    const SizedBox(height: 20),
                    _buildButton(Icons.recycling, 'Centros de reciclaje', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CentrosReciclaje()),
                      );
                    }),
                    const SizedBox(height: 20),
                    _buildButton(Icons.eco, 'Huella de carbono', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HuellaMenu()),
                      );
                    }),
                    const SizedBox(height: 20),
                    _buildButton(Icons.menu_book, 'Guías', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const GuiasPage()),
                      );
                    }),
                    const SizedBox(height: 20),
                    // Nuevo botón de Metas
                    _buildButton(Icons.flag, 'Metas', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                MetasPage()), 
                      );
                    }),
                    const SizedBox(height: 20),
                    // Nuevo botón de Calculadora
                    _buildButton(Icons.calculate, 'Calculadora de impacto ambiental', 
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CalculadoraImpactoPage()), 
                      );
                    }),
                    const SizedBox(height: 40),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PoliticaPage()),
                        );
                      },
                      child: const Text(
                        'Política y acuerdos de uso',
                        style: TextStyle(fontSize: 16, color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 200,
          decoration: const BoxDecoration(
            color: Color(0xff368983),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: const Center(
            child: Text(
              'Bienvenido a EcoHabit',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButton(IconData icon, String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 30),
        label: Text(text, style: const TextStyle(fontSize: 20)),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
