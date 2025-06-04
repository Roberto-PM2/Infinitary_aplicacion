import 'modelo_calculadora_impacto.dart';

class ControladorCalculadoraImpacto {
  final ModeloCalculadoraImpacto _modelo = ModeloCalculadoraImpacto();
  String? _mensajeError;
  Map<String, dynamic>? _resultado;

  // Getter público para el modelo
  ModeloCalculadoraImpacto get modelo => _modelo;

  void calcularImpacto(String pesoStr, String tipoResiduo) {
    try {
      final peso = double.parse(pesoStr);
      if (peso <= 0) throw FormatException('El peso debe ser mayor que cero');
      
      _resultado = _modelo.calcularImpacto(peso, tipoResiduo);
      _mensajeError = null;
    } on FormatException catch (e) {
      _mensajeError = 'Error: ${e.message ?? "Ingrese un peso válido (número mayor que 0)"}';
      _resultado = null;
    } on ArgumentError catch (e) {
      _mensajeError = 'Error: ${e.message}\nTipos válidos:\n${_modelo.obtenerTiposResiduos().join(', ')}';
      _resultado = null;
    }
  }

  void limpiarResultados() {
    _resultado = null;
    _mensajeError = null;
  }

  // Getters públicos para acceder a los valores
  String? get mensajeError => _mensajeError;
  Map<String, dynamic>? get resultado => _resultado;
}