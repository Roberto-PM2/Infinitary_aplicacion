class ModeloCalculadoraImpacto {
  final Map<String, _DatosResiduo> _datosResiduos = {
    'plástico': _DatosResiduo(6.0, 450),
    'papel': _DatosResiduo(1.8, 0.42),
    'vidrio': _DatosResiduo(0.9, 4000),
    'metal': _DatosResiduo(4.5, 150),
    'orgánico': _DatosResiduo(0.1, 0.5),
    'pilas': _DatosResiduo(25.0, 500),
    'electrónico': _DatosResiduo(10.0, 1000),
    'ropa': _DatosResiduo(2.5, 30),
  };

  Map<String, dynamic> calcularImpacto(double peso, String tipoResiduo) {
    final tipo = tipoResiduo.toLowerCase();
    if (!_datosResiduos.containsKey(tipo)) {
      throw ArgumentError('Tipo de residuo no válido');
    }
    
    final datos = _datosResiduos[tipo]!;
    final huellaCarbono = peso * datos.factorEmision;
    final tiempoDegradacion = _formatearTiempoDegradacion(datos.tiempoDegradacion);
    
    return {
      'huellaCarbono': huellaCarbono,
      'tiempoDegradacion': tiempoDegradacion,
      'tipoResiduo': tipo,
      'peso': peso,
    };
  }

  String _formatearTiempoDegradacion(double anos) {
    if (anos < 1) {
      final meses = anos * 12;
      if (meses < 1) {
        final dias = anos * 365;
        return '${dias.round()} días';
      }
      return '${meses.round()} meses';
    }
    return '${anos.round()} años';
  }

  List<String> obtenerTiposResiduos() => _datosResiduos.keys.toList();
}

class _DatosResiduo {
  final double factorEmision;
  final double tiempoDegradacion;

  _DatosResiduo(this.factorEmision, this.tiempoDegradacion);
}