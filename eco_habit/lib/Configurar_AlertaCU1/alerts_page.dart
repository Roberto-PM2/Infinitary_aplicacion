import 'package:flutter/material.dart';
import 'controlador_alerta.dart';
import 'modelo_alerta.dart';

class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  final _textController = TextEditingController();
  final _alertasController = AlertasController();
  TimeOfDay _selectedTime = TimeOfDay.now();
  List<Alerta> alertas_lista = [];

  @override
  void initState() {
    _cargarAlertas();
    super.initState();
  }

  Future<void> _cargarAlertas() async {
    final alertas = await _alertasController.obtenerAlertas();
    setState(() {
      alertas_lista = alertas;
    });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void abrirIngresoInfo() {
    _textController.clear();
    _selectedTime = TimeOfDay.now();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text("Agregar Alerta"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _textController,
                    decoration: const InputDecoration(labelText: 'Texto de la alerta'),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Text('Hora: '),
                      TextButton(
                        onPressed: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: _selectedTime,
                          );
                          if (picked != null) {
                            setState(() {
                              _selectedTime = picked;
                            });
                            setStateDialog(() {});
                          }
                        },
                        child: Text(
                          _selectedTime.format(context),
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancelar"),
                ),
                TextButton(
                  onPressed: () async {
                    await _alertasController.agregarAlerta(
                      texto: _textController.text,
                      hora: _selectedTime,
                      context: context,
                    );
                    if (mounted) {
                      Navigator.pop(context);
                      await _cargarAlertas();
                    }
                  },
                  child: const Text("Guardar"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void editarAlerta(int index) {
    final alerta = alertas_lista[index];
    _textController.text = alerta.texto;
    _selectedTime = alerta.hora;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text("Editar Alerta"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _textController,
                    decoration: const InputDecoration(labelText: 'Texto de la alerta'),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Text('Hora: '),
                      TextButton(
                        onPressed: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: _selectedTime,
                          );
                          if (picked != null) {
                            setState(() {
                              _selectedTime = picked;
                            });
                            setStateDialog(() {});
                          }
                        },
                        child: Text(
                          _selectedTime.format(context),
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancelar"),
                ),
                TextButton(
                  onPressed: () async {
                    await _alertasController.editarAlerta(
                      index: index,
                      texto: _textController.text,
                      hora: _selectedTime,
                      context: context,
                    );
                    if (mounted) {
                      Navigator.pop(context);
                      await _cargarAlertas();
                    }
                  },
                  child: const Text("Guardar"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> borrarAlerta(int index) async {
    await _alertasController.eliminarAlerta(index);
    await _cargarAlertas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Alertas"),
        backgroundColor: const Color(0xff368983),
      ),
      body: ListView.builder(
        itemCount: alertas_lista.length,
        itemBuilder: (context, index) {
          final alerta = alertas_lista[index];
          return ListTile(
            title: Text(alerta.texto),
            subtitle: Text(alerta.hora.format(context)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () => editarAlerta(index),
                  icon: const Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () => borrarAlerta(index),
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: Container(
        width: 150,
        height: 100,
        child: FloatingActionButton(
          onPressed: abrirIngresoInfo,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Icon(Icons.add),
              SizedBox(height: 5),
              Text(
                "Agregar nueva alerta",
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}