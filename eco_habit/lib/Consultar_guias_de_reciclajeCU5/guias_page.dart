import 'package:flutter/material.dart';
import 'model_guias.dart';
import 'infomacion_guia.dart';
import 'controlador_guias.dart';

class GuiasPage extends StatefulWidget {
  const GuiasPage({super.key});

  @override
  State<GuiasPage> createState() => _GuiasPageState();
}

class _GuiasPageState extends State<GuiasPage> {
  final List<String> categorias = ['organico', 'inorganico', 'otros'];
  final List<String> subcategorias = ['papel', 'plastico', 'alimentos', 'otros'];

  late ControladorGuias _controlador;

  @override
  void initState() {
    super.initState();
    _controlador = ControladorGuias();
    _controlador.addListener(_actualizarEstado);
    solicitarGuias(); 
  }

  Future<void> solicitarGuias() async {
    await _controlador.cargarGuias();
  }

  @override
  void dispose() {
    _controlador.removeListener(_actualizarEstado);
    _controlador.dispose();
    super.dispose();
  }

  void _actualizarEstado() {
    if (mounted) {
      setState(() {});
    }
  }

  void Navegar(Guia guia) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InformacionGuia(guia: guia),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guías de Reciclaje'),
        backgroundColor: const Color(0xff368983),
      ),
      body: Column(
        children: [
          // Filtro de categorías
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categorias.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final cat = categorias[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: _controlador.categoriaFiltro == cat,
                    onSelected: (selected) {
                      _controlador.aplicarFiltros(
                        categoria: selected ? cat : null,
                        subcategoria: _controlador.subcategoriaFiltro,
                      );
                    },
                    selectedColor: Colors.green.shade300,
                    backgroundColor: Colors.grey.shade200,
                  ),
                );
              },
            ),
          ),

          // Filtro de subcategorías
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: subcategorias.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final subcat = subcategorias[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  child: ChoiceChip(
                    label: Text(subcat),
                    selected: _controlador.subcategoriaFiltro == subcat,
                    onSelected: (selected) {
                      _controlador.aplicarFiltros(
                        categoria: _controlador.categoriaFiltro,
                        subcategoria: selected ? subcat : null,
                      );
                    },
                    selectedColor: Colors.blue.shade300,
                    backgroundColor: Colors.grey.shade200,
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 10),

          // Botones para limpiar filtros
          if (_controlador.categoriaFiltro != null || _controlador.subcategoriaFiltro != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Wrap(
                spacing: 10,
                runSpacing: 5,
                alignment: WrapAlignment.center,
                children: [
                  if (_controlador.categoriaFiltro != null)
                    TextButton(
                      onPressed: () {
                        _controlador.aplicarFiltros(
                          categoria: null,
                          subcategoria: _controlador.subcategoriaFiltro,
                        );
                      },
                      child: const Text('Limpiar categoría'),
                    ),
                  if (_controlador.subcategoriaFiltro != null)
                    TextButton(
                      onPressed: () {
                        _controlador.aplicarFiltros(
                          categoria: _controlador.categoriaFiltro,
                          subcategoria: null,
                        );
                      },
                      child: const Text('Limpiar subcategoría'),
                    ),
                  TextButton(
                    onPressed: _controlador.limpiarFiltros,
                    child: const Text('Limpiar todos'),
                  ),
                ],
              ),
            ),

          // Contenido principal
          Expanded(
            child: _controlador.cargando
                ? const Center(child: CircularProgressIndicator())
                : _controlador.guiasFiltradas.isEmpty
                    ? const Center(child: Text('No se encontraron guías'))
                    : ListView.builder(
                        itemCount: _controlador.guiasFiltradas.length,
                        itemBuilder: (context, index) {
                          final guia = _controlador.guiasFiltradas[index];
                          return Card(
                            margin: const EdgeInsets.all(12),
                            child: ListTile(
                              leading: Image.asset(
                                guia.imagenUrl,
                                width: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.image);
                                },
                              ),
                              title: Text(guia.titulo),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(guia.descripcion),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Chip(
                                        label: Text(guia.categoria),
                                        backgroundColor: Colors.green.shade100,
                                      ),
                                      const SizedBox(width: 4),
                                      Chip(
                                        label: Text(guia.subcategoria),
                                        backgroundColor: Colors.blue.shade100,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              onTap: () {
                                Navegar(guia); 
                              },
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
