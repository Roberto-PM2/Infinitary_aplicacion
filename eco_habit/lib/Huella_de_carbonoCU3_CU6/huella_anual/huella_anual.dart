import 'package:eco_habit/Huella_de_carbonoCU3_CU6/Estimar_Huella_AnualCU3/controlador_huella_anual.dart';
import 'package:eco_habit/Huella_de_carbonoCU3_CU6/Estimar_Huella_AnualCU3/widgets/question_widget.dart';
import 'package:eco_habit/Huella_de_carbonoCU3_CU6/Estimar_Huella_AnualCU3/widgets/result_widget.dart';
import 'package:flutter/material.dart';

class HuellaAnual extends StatefulWidget {
  const HuellaAnual({super.key});

  @override
  State<HuellaAnual> createState() => _EstadoHuellaAnual();
}


class _EstadoHuellaAnual extends State<HuellaAnual> {
  final ControladorHuellaAnual _controlador = ControladorHuellaAnual();

  @override
  void initState() {
    super.initState();
    verificarTieneResultadoAlmacenado();
    
  }

  verificarTieneResultadoAlmacenado(){
    if (_controlador.tieneResultadoAlmacenado) {
      _controlador.cuestionarioIniciado = true;
      _controlador.cuestionarioFinalizado = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_controlador.cuestionarioIniciado) {
      return _construirPantallaInicio();
    }

    if (_controlador.cuestionarioFinalizado) {
      return ResultWidget(
        huellaTotal: _controlador.modelo.huellaTotal,
        onRestart: () {
          setState(() {
            _controlador.reiniciarCuestionario();
          });
        },
      );
    }

    return Scaffold(
      body: QuestionWidget(
        question: _controlador.preguntas[_controlador.indicePreguntaActual],
        onSubmit: (respuesta) {
          setState(() {
            _controlador.enviarRespuesta(respuesta);
          });
        },
      ),
    );
  }

  Widget _construirPantallaInicio() {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Huella de Carbono"),
        backgroundColor: const Color(0xff368983),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Inicie nuestro cuestionario para calcular su huella de carbono anual.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _controlador.iniciarCuestionario();
                });
              },
              child: const Text("Comenzar cuestionario"),
            ),
          ],
        ),
      ),
    );
  }
}
