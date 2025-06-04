import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'controlador_registro_diario.dart';

class RegistroDiarioView extends StatefulWidget {
  const RegistroDiarioView({super.key});

  @override
  State<RegistroDiarioView> createState() => _RegistroDiarioViewState();
}

class _RegistroDiarioViewState extends State<RegistroDiarioView> {
  final ControladorRegistroDiario _controller = ControladorRegistroDiario();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro Diario'),
        backgroundColor: const Color(0xff368983),
      ),
      body: Column(
        children: [
          _buildGrafica(),
          const Divider(),
          _buildListaRegistros(),
        ],
      ),
      bottomNavigationBar: _buildBottomButtons(),
    );
  }

  Widget _buildGrafica() {
    return SizedBox(
      height: 250,
      child: FutureBuilder<List<Map>>(
        future: _controller.obtenerRegistros(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final registros = snapshot.data ?? [];

          if (registros.isEmpty) {
            return const Center(child: Text('Sin datos para graficar'));
          }

          final sorted = registros.map((r) {
            final date = DateFormat('dd/MM/yyyy').parse(r['fecha']);
            return {'fecha': date, 'consumo_diario': r['consumo_diario']};
          }).toList()
            ..sort((a, b) => a['fecha'].compareTo(b['fecha']));

          final spots = sorted.asMap().entries.map((entry) {
            return FlSpot(
              entry.key.toDouble(),
              (entry.value['consumo_diario'] as num).toDouble(),
            );
          }).toList();

          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: LineChart(
              LineChartData(
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toStringAsFixed(3),
                          style: const TextStyle(fontSize: 10),
                        );
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= sorted.length) return const SizedBox();
                        final date = sorted[index]['fecha'] as DateTime;
                        return Text(
                          DateFormat('dd/MM').format(date),
                          style: const TextStyle(fontSize: 10),
                        );
                      },
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        return LineTooltipItem(
                          '${spot.y.toStringAsFixed(3)} kg CO₂',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
                gridData: FlGridData(show: true),
                borderData: FlBorderData(show: true),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: Colors.blue,
                    barWidth: 3,
                    dotData: FlDotData(show: true),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildListaRegistros() {
    return Expanded(
      child: FutureBuilder<List<Map>>(
        future: _controller.obtenerRegistros(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final registros = snapshot.data ?? [];

          if (registros.isEmpty) {
            return const Center(child: Text('No hay registros aún'));
          }

          return ListView.builder(
            itemCount: registros.length,
            itemBuilder: (context, index) {
              final r = registros[index];
              final double consumoActual = (r['consumo_diario'] as num).toDouble();

              Icon consumoIcon = _getConsumoIcon(index, registros, consumoActual);

              return ListTile(
                leading: consumoIcon,
                title: Text('Fecha: ${r['fecha']}'),
                subtitle: Text('Consumo: ${consumoActual.toStringAsFixed(3)} Ton CO₂'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await _controller.eliminarRegistro(index);
                    setState(() {}); // refresca la vista para cargar datos actualizados
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Icon _getConsumoIcon(int index, List<Map> registros, double consumoActual) {
    if (index == 0) {
      return const Icon(Icons.remove, color: Colors.grey);
    } else {
      final double consumoAnterior = (registros[index - 1]['consumo_diario'] as num).toDouble();
      if (consumoActual < consumoAnterior) {
        return const Icon(Icons.arrow_downward, color: Colors.green);
      } else if (consumoActual > consumoAnterior) {
        return const Icon(Icons.arrow_upward, color: Colors.red);
      } else {
        return const Icon(Icons.horizontal_rule, color: Colors.grey);
      }
    }
  }

  Widget _buildBottomButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton.icon(
            onPressed: _confirmarEliminarTodo,
            icon: const Icon(Icons.delete_forever),
            label: const Text('Eliminar todo'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
          ElevatedButton.icon(
            onPressed: _showRegistroPopup,
            icon: const Icon(Icons.add),
            label: const Text('Registro'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }

  void _showRegistroPopup() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStatePopup) {
            return AlertDialog(
              title: const Text('Nuevo registro de hábito'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var clave in _controller.respuestas.keys)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: [
                            Expanded(child: Text(_controller.obtenerPregunta(clave))),
                            DropdownButton<String>(
                              value: _controller.respuestas[clave],
                              items: _controller.opciones
                                  .map((e) => DropdownMenuItem(value: e, child: Text(e.toUpperCase())))
                                  .toList(),
                              onChanged: (v) {
                                if (v != null) {
                                  setStatePopup(() {
                                    _controller.actualizarRespuesta(clave, v);
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () async {
                        final dt = await showDatePicker(
                          context: context,
                          initialDate: _controller.selectedDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (dt != null) {
                          setStatePopup(() {
                            _controller.actualizarFecha(dt);
                          });
                        }
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 20),
                          const SizedBox(width: 8),
                          Text(DateFormat('dd/MM/yyyy').format(_controller.selectedDate)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _controller.agregarRegistro(context);
                    Navigator.of(context).pop();
                    setState(() {}); // refrescar lista tras agregar
                  },
                  child: const Text('Guardar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _confirmarEliminarTodo() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: const Text('¿Deseas eliminar todos los registros?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                _controller.eliminarTodosRegistros();
                Navigator.of(context).pop();
                setState(() {}); // refrescar vista tras eliminar todo
              },
              child: const Text('Eliminar todo'),
            ),
          ],
        );
      },
    );
  }
}
