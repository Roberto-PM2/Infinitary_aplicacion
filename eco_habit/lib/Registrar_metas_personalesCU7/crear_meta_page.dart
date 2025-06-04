import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'controlador_meta.dart';
import 'modelo_meta.dart';

class CrearMetaPage extends StatefulWidget {
  final ModeloMeta? metaExistente;
  final int? index;

  const CrearMetaPage({Key? key, this.metaExistente,this.index}) : super(key: key);
  //const CrearMetaPage({super.key});
  @override
  _CrearMetaPageState createState() => _CrearMetaPageState();

  
}

class _CrearMetaPageState extends State<CrearMetaPage> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _valorObjetivoController = TextEditingController();
  final ControladorMeta _controladorMeta = ControladorMeta();

  String? _tipoSeleccionado;
  String? _unidadSeleccionada;
  DateTime? _fechaInicio;
  DateTime? _fechaFin;

  String _emojiSeleccionado = '✨';
  bool _emojiManual = false;

  @override
  void initState() {
    super.initState();
    if (widget.metaExistente != null) {
      final m = widget.metaExistente!;
      _tituloController.text = m.titulo ?? '';
      _valorObjetivoController.text = m.valor?.toString() ?? '';
      _tipoSeleccionado = m.tipo;
      _unidadSeleccionada = m.unidad;
      _fechaInicio = m.inicio;
      _fechaFin = m.fin;
      _emojiSeleccionado = m.emoji ?? '✨';
      _emojiManual = true;
    }
  }


  final Map<String, List<String>> unidadesPorTipo = {
    'Ahorrar agua': ['litros'],
    'Ahorrar luz': ['kWh', 'horas'],
    'Reciclaje': ['kg', 'piezas'],
    'Reducir residuos': ['kg'],
  };

  

  final Map<String, String> _sugerenciasEmoji = {
    'recicla': '♻️',
    'reciclaje': '♻️',
    'agua': '💧',
    'luz': '💡',
    'dormir': '😴',
    'caminar': '🚶',
    'leer': '📚',
    'plantar': '🌱',
  };

  final List<String> _emojiOpciones = [
    '♻️', '💧', '💡', '😴', '📚', '🏃', '🍎', '🧘', '🚴', '☀️',
    '🎯', '📅', '✅', '🎓', '🛌', '🧹', '🧼', '🪴', '🌍', '❤️',
  ];

  List<String> unidadesDisponibles = [];

  void _actualizarEmojiSugerido(String texto) {
    if (_emojiManual) return;
    final textoLower = texto.toLowerCase();
    for (final entrada in _sugerenciasEmoji.entries) {
      if (textoLower.contains(entrada.key)) {
        setState(() {
          _emojiSeleccionado = entrada.value;
        });
        return;
      }
    }
    setState(() {
      _emojiSeleccionado = '✨';
    });
  }

  void _mostrarSelectorEmojis() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SizedBox(
          height: 300,
          child: GridView.count(
            crossAxisCount: 6,
            padding: EdgeInsets.all(16),
            children: _emojiOpciones.map((emoji) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _emojiSeleccionado = emoji;
                    _emojiManual = true;
                  });
                  Navigator.pop(context);
                },
                child: Center(
                  child: Text(emoji, style: TextStyle(fontSize: 28)),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Future<void> _seleccionarFechaInicio() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2101),
    );
    if (picked != null) setState(() => _fechaInicio = picked);
  }

  Future<void> _seleccionarFechaFin() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _fechaInicio ?? DateTime.now(),
      firstDate: _fechaInicio ?? DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) setState(() => _fechaFin = picked);
  }

  void _crearMeta() {
    if (_formKey.currentState!.validate()) {
      if (_fechaInicio == null || _fechaFin == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Debe seleccionar ambas fechas')),
        );
        return;
      }
      if (_fechaInicio!.isAfter(_fechaFin!)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('La fecha de inicio no puede ser posterior a la fecha de fin')),
        );
        return;
      }
      if (_tipoSeleccionado == null || _unidadSeleccionada == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Debe seleccionar un tipo y una unidad')),
        );
        return;
      }

      _controladorMeta.agregarMeta(
        titulo: _tituloController.text,
        tipo: _tipoSeleccionado!,
        valor: double.parse(_valorObjetivoController.text),
        unidad: _unidadSeleccionada!,
        inicio: _fechaInicio!,
        fin: _fechaFin!,
        emoji: _emojiSeleccionado,
        progreso: 0,
        context: context,
      );

      Navigator.pop(context, true);
    }
  }

  void _actualizarMeta(dynamic metaExistente) {
    if (_formKey.currentState!.validate()) {
      if (_fechaInicio == null || _fechaFin == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Debe seleccionar ambas fechas')),
        );
        return;
      }
      if (_fechaInicio!.isAfter(_fechaFin!)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('La fecha de inicio no puede ser posterior a la fecha de fin')),
        );
        return;
      }
      if (_tipoSeleccionado == null || _unidadSeleccionada == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Debe seleccionar un tipo y una unidad')),
        );
        return;
      }

      _controladorMeta.actualizarMeta(
        index: widget.index!,
        titulo: _tituloController.text,
        tipo: _tipoSeleccionado!,
        valor: double.parse(_valorObjetivoController.text),
        unidad: _unidadSeleccionada!,
        inicio: _fechaInicio!,
        fin: _fechaFin!,
        emoji: _emojiSeleccionado,
        progreso: 0,
        context: context,
      );

      Navigator.pop(context, true);
    }
  }


  @override
  void dispose() {
    _tituloController.dispose();
    _valorObjetivoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: Text(widget.metaExistente != null ? 'Editar Meta' : 'Nueva Meta'),
        backgroundColor: const Color(0xff368983),
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              if (widget.metaExistente != null) {
                _actualizarMeta(widget.metaExistente!);
              } else {
                _crearMeta();
              }
            },
            child: Text(
              widget.metaExistente != null ? 'Actualizar' : 'Crear',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],

      ),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: _mostrarSelectorEmojis,
                child: Center(
                  child: Text(
                    _emojiSeleccionado,
                    style: TextStyle(fontSize: 48),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _tituloController,
                onChanged: _actualizarEmojiSugerido,
                maxLength: 50,
                decoration: InputDecoration(
                  labelText: 'Título de la meta',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Campo obligatorio' : null,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _tipoSeleccionado,
                decoration: InputDecoration(
                  labelText: 'Tipo de meta',
                  border: OutlineInputBorder(),
                ),
                items: unidadesPorTipo.keys.map((tipo) {
                  return DropdownMenuItem(value: tipo, child: Text(tipo));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _tipoSeleccionado = value!;
                    unidadesDisponibles = unidadesPorTipo[value] ?? [];
                    _unidadSeleccionada = null;
                  });
                },
                validator: (value) =>
                    value == null ? 'Seleccione un tipo' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _valorObjetivoController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Valor objetivo',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Campo obligatorio' : null,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _unidadSeleccionada,
                decoration: InputDecoration(
                  labelText: 'Unidad de medida',
                  border: OutlineInputBorder(),
                ),
                items: unidadesDisponibles.map((unidad) {
                  return DropdownMenuItem(value: unidad, child: Text(unidad));
                }).toList(),
                onChanged: (value) =>
                    setState(() => _unidadSeleccionada = value),
                validator: (value) =>
                    value == null ? 'Seleccione una unidad válida' : null,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _seleccionarFechaInicio,
                child: Text(_fechaInicio == null
                    ? 'Seleccionar fecha de inicio'
                    : 'Inicio: ${DateFormat('dd/MM/yyyy').format(_fechaInicio!)}'),
              ),
              ElevatedButton(
                onPressed: _seleccionarFechaFin,
                child: Text(_fechaFin == null
                    ? 'Seleccionar fecha de fin'
                    : 'Fin: ${DateFormat('dd/MM/yyyy').format(_fechaFin!)}'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
