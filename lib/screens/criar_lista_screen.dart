import 'package:flutter/material.dart';

class CriarListaScreen extends StatefulWidget {
  const CriarListaScreen({super.key});

  @override
  State<CriarListaScreen> createState() => _CriarListaScreenState();
}

class _CriarListaScreenState extends State<CriarListaScreen> {
  final _formKey = GlobalKey<FormState>(); // Chave do formulário
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  String desc = 'Adicionar descrição...';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text(
              'Nova Lista',
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
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ]),
        body: 
          Padding(
              padding: const EdgeInsets.all(15),
              child: Form(key: _formKey,
          child: Column(children: [TextFormField(controller: _nomeController,
                  decoration: const InputDecoration(
                labelText: 'Nome da Lista',
                labelStyle: TextStyle(color: Color(0xFFAEBBC9)),
                focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(width: 2.0, color: Color(0xFFAEBBC9))),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFAEBBC9), width: 2)),
              )), TextFormField(
                      controller: _descricaoController,
                      maxLines: 20, 
                      keyboardType: TextInputType.multiline, 
                      style: const TextStyle(color: Color(0xFFAEBBC9)),
                      cursorColor: const Color(0xFFAEBBC9),
                      decoration: const InputDecoration(
                          hintText: 'Adicionar Descrição...',
                          hintStyle: TextStyle(color: Color(0xFFAEBBC9)),
                          border: InputBorder.none))
                          ])
                        )
                      )
                      );
                    }
                  }
  


                    
                  