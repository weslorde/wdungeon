import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

class TdHerois extends StatefulWidget {
  const TdHerois({super.key});

  @override
  State<TdHerois> createState() => _TdHeroisState();
}

class _TdHeroisState extends State<TdHerois> {
  // Cache estático: sobrevive entre aberturas da página, só corta uma vez
  static Uint8List? _cacheEsquerda;
  static Uint8List? _cacheDireita;

  Uint8List? _metadeEsquerda;
  Uint8List? _metadeDireita;

  double _fatorEsquerda = 0.5;
  double _fatorDireita = 0.7;

  @override
  void initState() {
    super.initState();
    if (_cacheEsquerda != null && _cacheDireita != null) {
      // Já tem em cache, usa direto sem recortar de novo
      _metadeEsquerda = _cacheEsquerda;
      _metadeDireita = _cacheDireita;
    } else {
      _cortarImagem();
    }
  }

  Future<void> _cortarImagem() async {
    final byteData = await rootBundle.load('images/Alton.png');
    final bytes = byteData.buffer.asUint8List();

    // Roda o corte pesado em outra isolate, sem travar a UI
    final resultado = await compute(_processarImagem, bytes);

    _cacheEsquerda = resultado[0];
    _cacheDireita = resultado[1];

    if (mounted) {
      setState(() {
        _metadeEsquerda = resultado[0];
        _metadeDireita = resultado[1];
      });
    }
  }

  void _clicouEsquerda() {
    setState(() {
      _fatorEsquerda = 0.6;
      _fatorDireita = 0.5;
    });
  }

  void _clicouDireita() {
    setState(() {
      _fatorDireita = 0.6;
      _fatorEsquerda = 0.5;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_metadeEsquerda == null || _metadeDireita == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final alturaPai = constraints.maxHeight;

        return Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: GestureDetector(
                onTap: _clicouEsquerda,
                behavior: HitTestBehavior.opaque,
                child: SizedBox(
                  height: alturaPai * _fatorEsquerda,
                  child: Image.memory(_metadeEsquerda!, fit: BoxFit.cover),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: _clicouDireita,
                behavior: HitTestBehavior.opaque,
                child: SizedBox(
                  height: alturaPai * _fatorDireita,
                  child: Image.memory(_metadeDireita!, fit: BoxFit.cover),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// Função top-level (necessária para usar com `compute`)
List<Uint8List> _processarImagem(Uint8List bytes) {
  final imagemOriginal = img.decodeImage(bytes)!;

  final largura = imagemOriginal.width;
  final altura = imagemOriginal.height;
  final metade = largura ~/ 2.2;

  final esquerda = img.copyCrop(
    imagemOriginal,
    x: 0,
    y: 0,
    width: metade,
    height: altura,
  );

  final direita = img.copyCrop(
    imagemOriginal,
    x: metade,
    y: 0,
    width: largura - metade,
    height: altura,
  );

  return [
    Uint8List.fromList(img.encodePng(esquerda)),
    Uint8List.fromList(img.encodePng(direita)),
  ];
}