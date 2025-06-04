import 'package:flutter/material.dart';
import 'controlador_calculadora_impacto.dart';

class CalculadoraImpactoPage extends StatefulWidget {
  @override
  _CalculadoraImpactoPageState createState() => _CalculadoraImpactoPageState();
}

class _CalculadoraImpactoPageState extends State<CalculadoraImpactoPage> {
  final _controlador = ControladorCalculadoraImpacto();
  final _controladorPeso = TextEditingController();
  String? _tipoResiduoSeleccionado;

  void _calcularImpacto() {
    if (_tipoResiduoSeleccionado == null || _controladorPeso.text.isEmpty) {
      setState(() {
        _controlador.calcularImpacto('0', '');
      });
      return;
    }

    setState(() {
      _controlador.calcularImpacto(
        _controladorPeso.text,
        _tipoResiduoSeleccionado!,
      );
    });
  }

  void _limpiarCampos() {
    setState(() {
      _controladorPeso.clear();
      _tipoResiduoSeleccionado = null;
      _controlador.limpiarResultados();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculadora de Impacto Ambiental'),
        backgroundColor: const Color(0xff368983),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Recuadro de entrada de datos
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: _tipoResiduoSeleccionado,
                      decoration: InputDecoration(
                        labelText: 'Tipo de residuo',
                        border: OutlineInputBorder(),
                      ),
                      items: _controlador.modelo.obtenerTiposResiduos().map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _tipoResiduoSeleccionado = newValue;
                        });
                      },
                      validator: (value) => value == null ? 'Seleccione un tipo' : null,
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _controladorPeso,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: 'Peso del residuo',
                        hintText: 'Ingrese el peso en kg',
                        border: OutlineInputBorder(),
                        suffixText: 'kg',
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _limpiarCampos,
                            child: Text('Cancelar'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 15),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _calcularImpacto,
                            child: Text('Calcular'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[700],
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 15),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            // Panel de resultados centrado
            if (_controlador.resultado != null)
              Center(
                child: Card(
                  elevation: 4,
                  color: Colors.green[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Impacto ambiental',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[800],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '${(_controlador.resultado!['huellaCarbono'] as double).toStringAsFixed(2)} kg CO₂e',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Tiempo de degradación',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[800],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          _controlador.resultado!['tiempoDegradacion'].toString(),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            if (_controlador.mensajeError != null)
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  _controlador.mensajeError!,
                  style: TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controladorPeso.dispose();
    super.dispose();
  }
}
