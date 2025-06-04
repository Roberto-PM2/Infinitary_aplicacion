import 'package:flutter/material.dart';
import 'crear_meta_page.dart';
import 'modelo_meta.dart';
import 'controlador_meta.dart';

class MetasPage extends StatefulWidget {
  @override
  _MetasPageState createState() => _MetasPageState();
}

class _MetasPageState extends State<MetasPage> {
  final ControladorMeta _controlador = ControladorMeta();
  List<ModeloMeta> _metas = [];
  DateTime selectedDate = DateTime.now();
  int weekOffset = 0;

  @override
  void initState() {
    super.initState();
    _cargarMetas();
  }

  Future<void> _cargarMetas() async {
    final metas = await _controlador.obtenerMetas();
    setState(() {
      _metas = metas;
    });
  }

  List<DateTime> _getWeekDays(DateTime baseDate) {
    final monday = baseDate.subtract(Duration(days: baseDate.weekday - 1));
    return List.generate(7, (i) => monday.add(Duration(days: i)));
  }

  List<ModeloMeta> get _metasFiltradas {
    return _metas.where((m) {
      final inicio = m.inicio;
      final fin = m.fin;
      return selectedDate.isAfter(inicio.subtract(Duration(days: 1))) &&
          selectedDate.isBefore(fin.add(Duration(days: 1)));
    }).toList();
  }

  List<DateTime> get _fechasFin {
    return _metas.map((m) => m.fin).toList();
  }

  void _crearMeta() async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CrearMetaPage()),
    );
    if (resultado == true) {
      _cargarMetas(); // Recarga la lista después de crear
    }
  }

  // NUEVO: Editar meta existente
  void _editarMeta(ModeloMeta existente, int index) async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CrearMetaPage(metaExistente: existente, index: index,),
      ),
    );
    if (resultado == true) {
      _cargarMetas(); // Recarga la lista después de editar
    }
  }

  void _agregarProgreso(ModeloMeta meta, int index) async {
    TextEditingController controller = TextEditingController();
    String? errorMensaje;

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setStateDialog) => AlertDialog(
            title: Text("Agregar progreso"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "¿Cuánto avanzaste hoy?",
                    errorText: errorMensaje,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                child: Text("Cancelar"),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: Text("Guardar"),
                onPressed: () async {
                  final avance = double.tryParse(controller.text);
                  if (avance == null) {
                    setStateDialog(() {
                      errorMensaje = "Por favor ingresa un número válido.";
                    });
                  } else if (avance <= 0) {
                    setStateDialog(() {
                      errorMensaje = "El valor debe ser mayor a cero.";
                    });
                  } else {
                    final nuevoProgreso = (meta.progreso ?? 0.0) + avance;
                    meta.progreso = nuevoProgreso > meta.valor ? meta.valor : nuevoProgreso;
                    await _controlador.actualizarMeta(
                      index: index,
                      titulo: meta.titulo,
                      tipo: meta.tipo,
                      valor: meta.valor,
                      unidad: meta.unidad,
                      inicio: meta.inicio,
                      fin: meta.fin,
                      emoji: meta.emoji,
                      progreso: meta.progreso ?? 0.0,
                      context: context,
                    );

                    setState(() {
                      _metas[index] = meta;
                    });

                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatearFecha(DateTime fecha) {
    return '${fecha.day}/${fecha.month}/${fecha.year}';
  }

  @override
  Widget build(BuildContext context) {
    final semanaBase = DateTime.now().add(Duration(days: weekOffset * 7));
    final dias = _getWeekDays(semanaBase);

    return Scaffold(
      backgroundColor: Color(0xFFF5ECFF),
      appBar: AppBar(
        title: Text('Mis Metas'),
        backgroundColor: const Color(0xff368983),
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(onPressed: () => setState(() => weekOffset--), icon: Icon(Icons.arrow_back_ios)),
              Text('Semana de ${_formatearFecha(dias.first)}', style: TextStyle(fontWeight: FontWeight.bold)),
              IconButton(onPressed: () => setState(() => weekOffset++), icon: Icon(Icons.arrow_forward_ios)),
            ],
          ),
          SizedBox(
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: dias.length,
              itemBuilder: (context, index) {
                final dia = dias[index];
                final seleccionado = dia.day == selectedDate.day &&
                    dia.month == selectedDate.month &&
                    dia.year == selectedDate.year;
                final esFinMeta = _fechasFin.any((f) =>
                    f.day == dia.day && f.month == dia.month && f.year == dia.year);

                return GestureDetector(
                  onTap: () => setState(() => selectedDate = dia),
                  child: Container(
                    width: 65,
                    margin: EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                      color: seleccionado ? Colors.purple[200] : Colors.transparent,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          ['Dom', 'Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb'][dia.weekday % 7],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: seleccionado ? Colors.white : Colors.black,
                          ),
                        ),
                        SizedBox(height: 4),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: seleccionado ? Colors.white : Colors.grey.shade200,
                              child: Text(
                                dia.day.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: seleccionado ? Colors.purple : Colors.black,
                                ),
                              ),
                            ),
                            if (esFinMeta)
                              Positioned(
                                bottom: 2,
                                right: 4,
                                child: Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: Colors.redAccent,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 8),
          Expanded(
            child: _metasFiltradas.isEmpty
                ? Center(child: Text('No hay metas para este día'))
                : ListView.builder(
                    itemCount: _metasFiltradas.length,
                    itemBuilder: (context, index) {
                      final meta = _metasFiltradas[index];
                      final realIndex = _metas.indexOf(meta);
                      final progreso = meta.progreso ?? 0.0;
                      final valor = meta.valor;
                      final porcentaje = progreso / valor;
                      final completada = progreso >= valor;

                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        color: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                //aqui
                                onTap: () => _editarMeta(meta, realIndex), 
                                leading: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Text(meta.emoji ?? '🎯', style: TextStyle(fontSize: 24)),
                                ),
                                title: Row(
                                  children: [
                                    Expanded(
                                      child: Text(meta.titulo ?? '',
                                          style: TextStyle(fontWeight: FontWeight.bold)),
                                    ),
                                    if (!completada)
                                      Container(
                                        margin: EdgeInsets.only(left: 8),
                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.green[100],
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          'Meta en curso',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.green[800],
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    if (completada)
                                      Container(
                                        margin: EdgeInsets.only(left: 8),
                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.teal[100],
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          'Completada',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.teal[800],
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${meta.valor} ${meta.unidad}'),
                                    Text('Del ${_formatearFecha(meta.inicio)} al ${_formatearFecha(meta.fin)}'),
                                  ],
                                ),
                                trailing: Icon(Icons.edit),
                              ),
                              SizedBox(height: 6),
                              LinearProgressIndicator(
                                value: porcentaje > 1 ? 1 : porcentaje,
                                backgroundColor: Colors.grey[300],
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                                minHeight: 6,
                              ),
                              SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${progreso.toStringAsFixed(2)} / ${valor.toStringAsFixed(2)} ${meta.unidad}',
                                      style: TextStyle(fontSize: 12)),
                                  if (!completada)
                                    TextButton(
                                      onPressed: () => _agregarProgreso(meta, realIndex),
                                      child: Text("Agregar progreso"),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _crearMeta,
        backgroundColor: Colors.purple,
        child: Icon(Icons.add),
      ),
    );
  }
}
