import 'package:flutter/material.dart';

class QuestionWidget extends StatefulWidget {
  final Map<String, dynamic> question;
  final Function(String) onSubmit;

  const QuestionWidget({
    super.key,
    required this.question,
    required this.onSubmit,
  });

  @override
  State<QuestionWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final type = widget.question['type'];
    Widget answerInput;

    if (type == 'bool') {
      answerInput = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () => widget.onSubmit('sí'),
            child: const Text("Sí"),
          ),
          const SizedBox(width: 20),
          ElevatedButton(
            onPressed: () => widget.onSubmit('no'),
            child: const Text("No"),
          ),
        ],
      );
    } else {
      answerInput = Column(
        children: [
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Ingresa tu respuesta',
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              widget.onSubmit(_controller.text);
              _controller.clear();
            },
            child: const Text("Siguiente"),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cuestionario de Huella de Carbono"),
        backgroundColor: const Color(0xff368983),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.question['text'],
                style: const TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              answerInput,
            ],
          ),
        ),
      ),
    );
  }
}