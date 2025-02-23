import 'package:flutter/material.dart';
import 'package:filmin/services/lists_service.dart';

class CriarListaScreen extends StatefulWidget {
  const CriarListaScreen({super.key});

  @override
  State<CriarListaScreen> createState() => _CriarListaScreenState();
}

class _CriarListaScreenState extends State<CriarListaScreen> {
  final _formKey = GlobalKey<FormState>(); // Chave do formulário
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();

  final ListsService _listsService = ListsService();

  Future<void> _salvarLista() async {
    if (_formKey.currentState!.validate()) {
      String nomeLista = _nomeController.text;
      String descricao = _descricaoController.text;

      // Aqui você pode processar os dados (salvar no banco, API, etc.)
      await _listsService.createList(nomeLista, descricao);

      if (!mounted) return;
      // Exemplo de feedback ao usuário
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('lista criada com sucesso',
                style: TextStyle(color: Color(0xFFF1F3F5))),
            backgroundColor: Color(0xFF208BFE)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
            title: Text(
              'Nova Lista',
              style: TextStyle(
                  color: const Color(0xFFAEBBC9),
                  fontSize: screenHeight * 0.025),
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
                    if (_nomeController.text.isEmpty &&
                        _descricaoController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'nome e descrição não podem ser vazios',
                            style: TextStyle(color: Color(0xFFF1F3F5)),
                          ),
                          backgroundColor: Color(0xFFF52958),
                        ),
                      );
                    } else if (_nomeController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                              'nome não pode ser vazio',
                              style: TextStyle(color: Color(0xFFF1F3F5)),
                            ),
                            backgroundColor: Color(0xFFF52958)),
                      );
                    } else if (_descricaoController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                              'descrição não pode ser vazia',
                              style: TextStyle(color: Color(0xFFF1F3F5)),
                            ),
                            backgroundColor: Color(0xFFF52958)),
                      );
                    } else {
                      await _salvarLista();
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                    }
                  })
            ]),
        body: Padding(
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: Form(
                key: _formKey,
                child: Column(children: [
                  TextFormField(
                    controller: _nomeController,
                    maxLength: 30,
                    decoration: InputDecoration(
                      labelText: 'Nome da Lista',
                      counterStyle: TextStyle(color: Color(0xFFAEBBC9)),
                      labelStyle: TextStyle(color: Color(0xFFAEBBC9)),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            width: screenWidth * 0.005,
                            color: Color(0xFFAEBBC9)),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Color(0xFFAEBBC9),
                            width: screenWidth * 0.005),
                      ),
                    ),
                    style: const TextStyle(color: Color(0xFFF1F3F5)),
                  ),
                  TextFormField(
                      controller: _descricaoController,
                      maxLength: 200,
                      keyboardType: TextInputType.multiline,
                      style: const TextStyle(color: Color(0xFFF1F3F5)),
                      decoration: const InputDecoration(
                          hintText: 'Descrição',
                          counterStyle: TextStyle(color: Color(0xFFAEBBC9)),
                          hintStyle: TextStyle(color: Color(0xFFAEBBC9)),
                          border: InputBorder.none))
                ]))));
  }
}
