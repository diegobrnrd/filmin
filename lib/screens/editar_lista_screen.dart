import 'package:flutter/material.dart';
import 'package:filmin/services/lists_service.dart';

class EditarListaScreen extends StatefulWidget {
  final String nomeAtual;
  final String descAtual;
  const EditarListaScreen({super.key, required this.nomeAtual, required this.descAtual});

  @override
  State<EditarListaScreen> createState() => _EditarListaScreenState();
}

class _EditarListaScreenState extends State<EditarListaScreen> {
  final _formKey = GlobalKey<FormState>(); // Chave do formulário
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();

  final ListsService _listsService = ListsService();

   @override
     void initState() {
    super.initState();
    _nomeController.text = widget.nomeAtual; 
    _descricaoController.text = widget.descAtual;
  }

  Future<void> _salvarAlteracao() async {
    if (_formKey.currentState!.validate()) {
      String nomeLista = _nomeController.text;
      String descricao = _descricaoController.text;

      // Aqui você pode processar os dados (salvar no banco, API, etc.)
      await _listsService.updateList(widget.nomeAtual, nomeLista, descricao);

      if (!mounted) return;
      // Exemplo de feedback ao usuário
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Alterações salvas com sucesso!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text(
              'Edição de lista',
              style: TextStyle(color: Color(0xFFAEBBC9)),
            ),
            backgroundColor: const Color(0xFF161E27),
            leading: IconButton(
              color: const Color(0xFFAEBBC9),
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.check,
                    color: Color(0xFFAEBBC9)), // Ícone de confirmar
                onPressed: () async {
                  await _salvarAlteracao();
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                },
              )
            ]),
        body: Padding(
            padding: const EdgeInsets.all(15),
            child: Form(
                key: _formKey,
                child: Column(children: [
                  TextFormField(
                    controller: _nomeController,
                    decoration: const InputDecoration(
                      labelText: 'Nome da Lista',
                      labelStyle: TextStyle(color: Color(0xFFAEBBC9)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(width: 2.0, color: Color(0xFFAEBBC9))),
                      enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFAEBBC9), width: 2)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Digite um nome para a lista';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                      controller: _descricaoController,
                      maxLines: 20,
                      keyboardType: TextInputType.multiline,
                      style: const TextStyle(color: Color(0xFFAEBBC9)),
                      cursorColor: const Color(0xFFAEBBC9),
                      decoration: const InputDecoration(
                          hintText: 'Nova Descrição...',
                          hintStyle: TextStyle(color: Color(0xFFAEBBC9)),
                          border: InputBorder.none))
                        ]
                      )
                    )
                  )
                );
              }
            }
