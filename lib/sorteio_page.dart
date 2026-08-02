import 'dart:math';
import 'package:flutter/material.dart';

class SorteioSimples extends StatefulWidget {
  final String titulo;
  final List<String> imagens;

  const SorteioSimples({
    super.key,
    required this.titulo,
    required this.imagens,
  });

  @override
  State<SorteioSimples> createState() => _SorteioSimplesState();
}

class _SorteioSimplesState extends State<SorteioSimples> {
  String? _imagemSorteada; // null = mostra interrogação

  void _sortear() {
    final random = Random();
    setState(() {
      _imagemSorteada = widget.imagens[random.nextInt(widget.imagens.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.titulo)),
      body: Stack(
        children: [
          Center(
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                height: 300,
                width: 300,
                padding: const EdgeInsets.all(16),
                child: _imagemSorteada == null
                    ? const Center(
                        child: Text(
                          '?',
                          style: TextStyle(
                            fontSize: 100,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : Image.asset(_imagemSorteada!, fit: BoxFit.contain),
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: FloatingActionButton(
                onPressed: _sortear,
                child: const Icon(Icons.casino, size: 32),
              ),
            ),
          ),
        ],
      ),
    );
  }
}