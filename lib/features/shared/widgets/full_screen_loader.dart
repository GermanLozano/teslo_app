// clase o widget para el cargador de la pantalla conpleta 

import 'package:flutter/material.dart';

class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.expand(
      child: Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }
} 