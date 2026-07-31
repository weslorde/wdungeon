import 'package:flutter/material.dart';
import 'package:wdungeon/auxiliar/heroi_class.dart';

class DetalheHeroi extends StatefulWidget {
  final Heroi heroi;

  const DetalheHeroi({super.key, required this.heroi});

  @override
  State<DetalheHeroi> createState() => _DetalheHeroiState();
}

class _DetalheHeroiState extends State<DetalheHeroi> {
  late PageController _controller;
  late int _paginaAtual;

  @override
  void initState() {
    super.initState();
    _paginaAtual = widget.heroi.indice;
    _controller = PageController(initialPage: _paginaAtual);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(herois[_paginaAtual].nome)),
      body: PageView.builder(
        controller: _controller,
        itemCount: herois.length,
        onPageChanged: (index) {
          setState(() {
            _paginaAtual = index;
          });
        },
        itemBuilder: (context, index) {
          final heroi = herois[index];
          return _PaginaHeroi(heroi: heroi);
        },
      ),
    );
  }
}

class _PaginaHeroi extends StatefulWidget {
  final Heroi heroi;

  const _PaginaHeroi({required this.heroi});

  @override
  State<_PaginaHeroi> createState() => _PaginaHeroiState();
}

class _PaginaHeroiState extends State<_PaginaHeroi> {
  int _selecionado = 0;

  void _clicouEsquerda() => setState(() => _selecionado = 1);
  void _clicouDireita() => setState(() => _selecionado = 2);

  @override
  Widget build(BuildContext context) {
    final heroi = widget.heroi;

    if (_selecionado == 0) {
      return Column(
        children: [
          Flexible(
            child: Center(
              child: GestureDetector(
                onTap: _clicouEsquerda,
                behavior: HitTestBehavior.opaque,
                child: Image.asset('images/corteEsquerda/${heroi.nome}.png'),
              ),
            ),
          ),
          Flexible(
            child: Center(
              child: GestureDetector(
                onTap: _clicouDireita,
                behavior: HitTestBehavior.opaque,
                child: Image.asset('images/corteDireita/${heroi.nome}.png'),
              ),
            ),
          ),
        ],
      );
    }

    // esquerda: 0.8 se selecionado==1, senão 0.45
    // direita: 0.45 se selecionado==1, senão 0.8
    final tamanhoEsquerda = _selecionado == 1 ? 0.8 : 0.45;
    final tamanhoDireita = _selecionado == 1 ? 0.45 : 0.8;

    return LayoutBuilder(
      builder: (context, constraints) {
        final altura = constraints.maxHeight;
        if (_selecionado == 1) {
          return Stack(
            children: [
              // Direita sempre embaixo
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: altura * tamanhoDireita,
                child: GestureDetector(
                  onTap: _clicouDireita,
                  behavior: HitTestBehavior.opaque,
                  child: Image.asset(
                    'images/corteDireita/${heroi.nome}.png',
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              // Esquerda sempre em cima
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: altura * tamanhoEsquerda,
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
        }
        if (_selecionado == 2) {
          return Stack(
            children: [
              // Esquerda sempre em cima
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: altura * tamanhoEsquerda,
                child: GestureDetector(
                  onTap: _clicouEsquerda,
                  behavior: HitTestBehavior.opaque,
                  child: Image.asset(
                    'images/corteEsquerda/${heroi.nome}.png',
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              // Direita sempre embaixo
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: altura * tamanhoDireita,
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
        } else {
          return SizedBox();
        }
      },
    );
  }
}
