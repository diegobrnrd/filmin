import 'package:flutter/material.dart';


class CriarListaScreen extends StatefulWidget {
  const CriarListaScreen({super.key});

  @override
  State<CriarListaScreen> createState() => _CriarListaScreenState();
}

class _CriarListaScreenState extends State<CriarListaScreen> {
  

  @override
  Widget build(BuildContext context) {
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
                
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFAEBBC9)),),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFAEBBC9)))
              )
            ))
         ,
          SizedBox(
            height: 110,
            width: MediaQuery.of(context).size.width,
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
                        color: Color(0xFFAEBBC9)
                        )
                      )
                      )
                    )
                  )
                )
              ]
            )
          );
        }
      }