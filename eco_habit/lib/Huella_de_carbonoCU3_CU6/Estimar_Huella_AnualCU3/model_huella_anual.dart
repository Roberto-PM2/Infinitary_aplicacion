import 'package:hive_ce/hive.dart';

class ModeloHuellaAnual {
  late Box cajaHuella;
  double huellaTotal = 0;

  ModeloHuellaAnual() {
    cajaHuella = Hive.box("Huella_anual");
    _getDatosAlmacenados();
  }

  void _getDatosAlmacenados() {
    final huellaAlmacenada = cajaHuella.get("resultado");
    if (huellaAlmacenada != null) {
      huellaTotal = huellaAlmacenada;
    }
  }

  void guardarResultado(double resultado) {
    huellaTotal = resultado;
    cajaHuella.put("resultado", resultado);
  }

  void limpiarDatos() {
    huellaTotal = 0;
    cajaHuella.delete("resultado");
  }

  double calcularHuella(Map<String, String> respuestas) {
    double kmAuto = double.tryParse(respuestas['km_auto'] ?? '0') ?? 0;
    double consumoAuto = double.tryParse(respuestas['consumo_auto'] ?? '0') ?? 0;
    double kmTransporte = double.tryParse(respuestas['km_transporte_publico'] ?? '0') ?? 0;
    double electricidad = double.tryParse(respuestas['electricidad'] ?? '0') ?? 0;
    double gas = double.tryParse(respuestas['gas'] ?? '0') ?? 0;
    double agua = double.tryParse(respuestas['agua'] ?? '0') ?? 0;
    int carne = int.tryParse(respuestas['carne'] ?? '0') ?? 0;
    int lacteos = int.tryParse(respuestas['lacteos'] ?? '0') ?? 0;
    bool vegano = (respuestas['vegano']?.toLowerCase() == 'sí' || respuestas['vegano']?.toLowerCase() == 's');
    int ropa = int.tryParse(respuestas['ropa'] ?? '0') ?? 0;
    int electronicos = int.tryParse(respuestas['electronicos'] ?? '0') ?? 0;
    int vuelos = int.tryParse(respuestas['viajes_avion'] ?? '0') ?? 0;

    double huellaAuto = (consumoAuto > 0) ? (kmAuto * 52 / consumoAuto) * 2.31 / 1000 : 0;
    double huellaTransporte = (kmTransporte * 52 * 0.1) / 1000;
    double huellaElectricidad = (electricidad * 12 * 0.4) / 1000;
    double huellaGas = (gas * 12 * 2) / 1000;
    double huellaAgua = (agua * 365 * 0.0003);
    double huellaCarne = (carne > 0) ? (carne * 52 * 0.05) : 0;
    double huellaLacteos = (lacteos > 0) ? (lacteos * 52 * 0.02) : 0;
    double huellaRopa = (ropa * 12 * 0.025);
    double huellaElectronicos = (electronicos * 0.5);
    double huellaVuelos = (vuelos * 1.1);

    double total = huellaAuto +
        huellaTransporte +
        huellaElectricidad +
        huellaGas +
        huellaAgua +
        huellaCarne +
        huellaLacteos +
        huellaRopa +
        huellaElectronicos +
        huellaVuelos;

    if (vegano) {
      total *= 0.8;
    }

    return total;
  }
}