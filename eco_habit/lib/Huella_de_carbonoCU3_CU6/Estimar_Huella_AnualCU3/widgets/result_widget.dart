import 'package:flutter/material.dart';

class ResultWidget extends StatelessWidget {
  final double huellaTotal;
  final VoidCallback onRestart;

  const ResultWidget({
    super.key,
    required this.huellaTotal,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Resultado"),
        backgroundColor: const Color(0xff368983),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Tu huella de carbono anual estimada es de aproximadamente:",
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                "${huellaTotal.toStringAsFixed(2)} toneladas de CO₂",
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: onRestart,
                child: const Text("Reiniciar cuestionario"),
              )
            ],
          ),
        ),
      ),
    );
  }
}