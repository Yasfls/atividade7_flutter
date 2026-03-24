import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lista de Tarefas',
      home: TodoPage(),
    );
  }
}

class Tarefa {
  String titulo;
  bool concluida;

  Tarefa({required this.titulo, this.concluida = false});
}

class TodoPage extends StatefulWidget {
  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  List<Tarefa> tarefas = [];
  final TextEditingController controller = TextEditingController();

  void adicionarTarefa() {
    if (controller.text.trim().isEmpty) return;

    setState(() {
      tarefas.add(Tarefa(titulo: controller.text.trim()));
    });

    controller.clear();
  }

  void toggleTarefa(int index, bool? valor) {
    setState(() {
      tarefas[index].concluida = valor ?? false;
    });
  }

  void removerTarefa(int index) {
    setState(() {
      tarefas.removeAt(index);
    });
  }

  int get totalTarefas => tarefas.length;

  int get tarefasConcluidas =>
      tarefas.where((t) => t.concluida).length;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tarefas'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: 'Insira uma tarefa',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: adicionarTarefa,
                )
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Total: $totalTarefas | Concluídas: $tarefasConcluidas',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Expanded(
            child: tarefas.isEmpty
                ? Center(
                    child: Text(
                      'Nenhuma tarefa adicionada',
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    itemCount: tarefas.length,
                    itemBuilder: (context, index) {
                      final tarefa = tarefas[index];

                      return Container(
                        color: tarefa.concluida
                            ? const Color.fromARGB(255, 51, 177, 55).withOpacity(0.1)
                            : Colors.transparent,
                        child: ListTile(
                          leading: Checkbox(
                            value: tarefa.concluida,
                            onChanged: (valor) =>
                                toggleTarefa(index, valor),
                          ),
                          title: Text(
                            tarefa.titulo,
                            style: TextStyle(
                              color: tarefa.concluida
                                  ? Colors.green
                                  : Colors.black,
                              decoration: tarefa.concluida
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () =>
                                removerTarefa(index),
                          ),
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