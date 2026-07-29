import 'package:flutter/material.dart';
import 'package:wdungeon/auxiliar/heroi_class.dart';

class DetalheHeroi extends StatefulWidget {
  final Heroi heroi;

  const DetalheHeroi({super.key, required this.heroi});

  @override
  State<DetalheHeroi> createState() => _DetalheHeroiState();
}

class _DetalheHeroiState extends State<DetalheHeroi> {
  int _selecionado = 0; // 0 = nenhum, 1 = esquerda, 2 = direita

  void _clicouEsquerda() {
    setState(() {
      _selecionado = 1;
    });
  }

  void _clicouDireita() {
    setState(() {
      _selecionado = 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    final heroi = widget.heroi;

    return Scaffold(
      appBar: AppBar(title: Text(heroi.nome)),
      body: _selecionado == 0
          ?
            // _selecionado == 0
            Column(
              children: [
                Flexible(
                  child: Center(
                    child: GestureDetector(
                      onTap: _clicouEsquerda,
                      behavior: HitTestBehavior.opaque,
                      child: Image.asset(
                        'images/corteEsquerda/${heroi.nome}.png',
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: Center(
                    child: GestureDetector(
                      onTap: _clicouDireita,
                      behavior: HitTestBehavior.opaque,
                      child: Image.asset(
                        'images/corteDireita/${heroi.nome}.png',
                      ),
                    ),
                  ),
                ),
              ],
            )
          // Fim  _selecionado == 0
          : _selecionado == 1
          // _selecionado == 1
          ? LayoutBuilder(
              builder: (context, constraints) {
                final altura = constraints.maxHeight;

                return Stack(
                  children: [
                    // Imagem de baixo (30%, fica atrás, embaixo)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      height: altura * 0.45,
                      child: GestureDetector(
                        onTap: _clicouDireita,
                        behavior: HitTestBehavior.opaque,
                        child: Image.asset(
                          'images/corteDireita/${heroi.nome}.png',
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                    // Imagem de cima (70%, fica na frente, por cima)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: altura * 0.8,
                      child: GestureDetector(
                        onTap: _clicouEsquerda,
                        behavior: HitTestBehavior.opaque,
                        child: Image.asset(
                          'images/corteEsquerda/${heroi.nome}.png',
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                  ],
                );
              },
            )
          // Fim _selecionado == 1
          // _selecionado == 2
          : LayoutBuilder(
              builder: (context, constraints) {
                final altura = constraints.maxHeight;

                return Stack(
                  children: [
                    // Imagem de baixo (30%, fica atrás, embaixo)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: altura * 0.45,
                      child: GestureDetector(
                        onTap: _clicouEsquerda,
                        behavior: HitTestBehavior.opaque,
                        child: Image.asset(
                          'images/corteEsquerda/${heroi.nome}.png',
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                    // Imagem de cima (70%, fica na frente, por cima)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      height: altura * 0.8,
                      child: GestureDetector(
                        onTap: _clicouDireita,
                        behavior: HitTestBehavior.opaque,
                        child: Image.asset(
                          'images/corteDireita/${heroi.nome}.png',
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
