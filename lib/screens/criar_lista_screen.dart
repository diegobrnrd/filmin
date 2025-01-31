import 'package:flutter/material.dart';


class CriarListaScreen extends StatefulWidget {
  const CriarListaScreen({super.key});

  @override
  State<CriarListaScreen> createState() => _CriarListaScreenState();
}

class _CriarListaScreenState extends State<CriarListaScreen> {
  

  @override
  Widget build(BuildContext context) {
    
    double alturaTela = MediaQuery.of(context).size.height;
    double larguraTela =  MediaQuery.of(context).size.width;
    
    return Scaffold(
    appBar: AppBar(
      title: const Text('Nova Lista',
        style: TextStyle(color: Color(0xFFAEBBC9)),),
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
        icon: const Icon(Icons.check, color: Color(0xFFAEBBC9)), // Ícone de confirmar
        onPressed: () {
          Navigator.pop(context);
      },
      )]),
    body: Column(children: [const Padding(
      padding: EdgeInsets.all(15),
      child:  
  
            TextField(
              decoration: InputDecoration(
                
                labelText: 'Nome da Lista', 
                labelStyle: TextStyle(color: Color(0xFFAEBBC9)),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(width: 2.0, color: Color(0xFFAEBBC9))),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFAEBBC9), width: 2)),
              ))
            ),
          SizedBox(
            height: alturaTela * 0.11,
            width: larguraTela,
            child:
              TextButton(
                style: TextButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,  // Sem arredondamento
                  ),
                ),
                onPressed:(){}, 
                child: const Align(
                  alignment: Alignment.topLeft, 
                  child: Padding(
                    padding: EdgeInsets.all(15), 
                    child: Text(
                      'Adicionar Descrição...', 
                      style: TextStyle(
                        color: Color(0xFFAEBBC9))))))),
            Expanded(
              child:
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(width: 0.7, color: Color(0xFFAEBBC9)), // Borda superior
                  bottom: BorderSide(width: 0.7, color: Color(0xFFAEBBC9)), // Borda inferior
                ),
              ),
              child:TextButton(
                style: TextButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,  // Sem arredondamento
                  ),
                ),
                onPressed:(){}, 
                child: const Align(
                  alignment: Alignment.topLeft, 
                  child: Padding(
                    padding: EdgeInsets.all(15), 
                    child: Text(
                      'Adicionar Filmes...', 
                      style: TextStyle(
                        color: Color(0xFFAEBBC9))))))))
                           ]));}}
                           