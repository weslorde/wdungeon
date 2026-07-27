import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

class TdHerois extends StatefulWidget {
  const TdHerois({super.key});

  @override
  State<TdHerois> createState() => _TdHeroisState();
}

class _TdHeroisState extends State<TdHerois> {
  Uint8List? _metadeEsquerda;
  Uint8List? _metadeDireita;

  // Fatores de altura controláveis
  double _fatorCima = 0.5;
  double _fatorBaixo = 0.6;

  @override
  void initState() {
    super.initState();
    _cortarImagem();
  }

  Future<void> _cortarImagem() async {
    // Carrega o asset como bytes
    final byteData = await rootBundle.load('images/Alton.png');
    final bytes = byteData.buffer.asUint8List();

    // Decodifica a imagem
    final imagemOriginal = img.decodeImage(bytes)!;

    final largura = imagemOriginal.width;
    final altura = imagemOriginal.height;
    final metade = largura ~/ 2.2;

    // Corta a metade esquerda
    final esquerda = img.copyCrop(
      imagemOriginal,
      x: 0,
      y: 0,
      width: metade,
      height: altura,
    );

    // Corta a metade direita
    final direita = img.copyCrop(
      imagemOriginal,
      x: metade,
      y: 0,
      width: largura - metade,
      height: altura,
    );

    setState(() {
      _metadeEsquerda = Uint8List.fromList(img.encodePng(esquerda));
      _metadeDireita = Uint8List.fromList(img.encodePng(direita));
    });
  }

  void _clicouCima() {
    setState(() {
      _fatorCima = 0.7;
      _fatorBaixo = 0.3;
    });
  }

  void _clicouBaixo() {
    setState(() {
      _fatorCima = 0.5;
      _fatorBaixo = 0.7;
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
                onTap: _clicouCima,
                behavior: HitTestBehavior.opaque,
                child: SizedBox(
                  height: alturaPai * _fatorCima,
                  child: Image.memory(_metadeEsquerda!, fit: BoxFit.cover),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: _clicouBaixo,
                behavior: HitTestBehavior.opaque,
                child: SizedBox(
                  height: alturaPai * _fatorBaixo,
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