import 'package:filmin/services/auth_service.dart';
import 'package:flutter/material.dart';

class PasswordResetModal extends StatefulWidget {
  const PasswordResetModal({Key? key}) : super(key: key);

  @override
  _PasswordResetModalState createState() => _PasswordResetModalState();
}

class _PasswordResetModalState extends State<PasswordResetModal> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Recuperar senha'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'E-mail',
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Por favor, insira um e-mail';
            }
            return null;
          },
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              bool success =
                  await authService.resetPassword(_emailController.text);
              Navigator.of(context).pop();
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content:
                          Text('E-mail de recuperação enviado com sucesso!')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Erro ao enviar e-mail de recuperação.')),
                );
              }
            }
          },
          child: const Text('Recuperar a Senha'),
        ),
      ],
    );
  }
}
