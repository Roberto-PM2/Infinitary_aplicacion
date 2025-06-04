import 'package:flutter/material.dart';
import 'Estimar_Huella_AnualCU3/huella_anual.dart';
import 'Registrar_habitos_de_consumoCU6/registro_diario.dart'; 

class HuellaMenu extends StatefulWidget {
  const HuellaMenu({super.key});

  @override
  State<HuellaMenu> createState() => _HuellaMenuState();
}

class _HuellaMenuState extends State<HuellaMenu> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HuellaAnual(), //aqui
    RegistroDiarioView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Huella Anual',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.today),
            label: 'Registro Diario',
          ),
        ],
      ),
    );
  }
}
