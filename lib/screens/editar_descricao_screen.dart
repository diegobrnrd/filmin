import 'package:flutter/material.dart';

class EditarDescricaoScreen extends StatefulWidget {
  const EditarDescricaoScreen({super.key});

  @override
  State<EditarDescricaoScreen> createState() => _EditarDescricaoScreenState();
}

class _EditarDescricaoScreenState extends State<EditarDescricaoScreen> {
  bool isBoldSelected = false;
  bool isItalicSelected = false;

  void _toggleBold() {
    setState(() {
      isBoldSelected = !isBoldSelected;
    });
  }

  void _toggleItalic() {
    setState(() {
      isItalicSelected = !isItalicSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    double alturaTela = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
            title: const Text(
              'Editar Descrição',
              style: TextStyle(color: Color(0xFFAEBBC9)),
            ),
            backgroundColor: const Color(0xFF161E27),
            leading: IconButton(
                color: const Color(0xFFAEBBC9),
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                })),
        body: Column(children: [
          const Expanded(
              child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: TextField(
                      style: TextStyle(color: Color(0xFFAEBBC9)),
                      cursorColor: Color(0xFFAEBBC9),
                      decoration: InputDecoration(
                          hintText: 'Adicionar Descrição...',
                          hintStyle: TextStyle(color: Color(0xFFAEBBC9)),
                          border: InputBorder.none)))),
          Container(
              height: alturaTela * 0.07,
              color: const Color(0xFF161E27),
              child: Row(children: [
                IconButton(
                    icon: Icon(Icons.format_bold,
                        color:
                            isBoldSelected ? Colors.white : const Color(0xFFAEBBC9)),
                    onPressed: () {
                      _toggleBold();
                    }),
                IconButton(
                    icon: Icon(Icons.format_italic,
                        color: isItalicSelected
                            ? Colors.white
                            : const Color(0xFFAEBBC9)),
                    onPressed: () {
                      _toggleItalic();
                    })
              ]))
        ]),
        backgroundColor: const Color(0xFF1E2936));
  }
}
