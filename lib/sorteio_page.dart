import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:wdungeon/auxiliar/heroiCard.dart';
import 'package:wdungeon/auxiliar/heroi_class.dart';

// ==================== MENU ====================

class MenuSorteio extends StatelessWidget {
  const MenuSorteio({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sorteios')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Expanded(
              child: _botaoSorteio(
                context,
                titulo: 'Sortear Herói',
                icone: Icons.person,
                destino: const SorteioHeroi(),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _botaoSorteio(
                context,
                titulo: 'Sortear Dado',
                icone: Icons.casino,
                destino: const SorteioSimples(
                  titulo: 'Sortear Dado',
                  imagens: [
                    'images/dados/Dado4Lados.png',
                    'images/dados/Dado6LadosBase.png',
                    'images/dados/Dado6LadosFloresta.png',
                    'images/dados/Dado8Lados.png',
                    'images/dados/Dados10Lados.png',
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _botaoSorteio(
                context,
                titulo: 'Sortear Tabuleiro',
                icone: Icons.grid_view,
                destino: const SorteioSimples(
                  titulo: 'Sortear Tabuleiro',
                  imagens: [
                    'images/tabuleiros/Tabuleiro1.png',
                    'images/tabuleiros/Tabuleiro2.png',
                    'images/tabuleiros/Tabuleiro3.png',
                    'images/tabuleiros/Tabuleiro4.png',
                    'images/tabuleiros/Tabuleiro5.png',
                    'images/tabuleiros/Tabuleiro6.png',
                    'images/tabuleiros/Tabuleiro7.png',
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _botaoSorteio(
    BuildContext context, {
    required String titulo,
    required IconData icone,
    required Widget destino,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => destino),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icone, size: 48),
            const SizedBox(height: 8),
            Text(titulo, style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}

// ==================== SORTEIO DE HERÓI ====================

class SorteioHeroi extends StatefulWidget {
  const SorteioHeroi({super.key});

  @override
  State<SorteioHeroi> createState() => _SorteioHeroiState();
}

class _SorteioHeroiState extends State<SorteioHeroi> {
  Heroi? _heroiSorteado; // null = mostra interrogação
  bool _sorteando = false;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _sortear() {
    if (_sorteando) return;

    setState(() {
      _sorteando = true;
    });

    final random = Random();
    int contagem = 0;
    const totalTrocas = 20;
    int intervaloAtual = 50;

    void proximaTroca() {
      setState(() {
        _heroiSorteado = herois[random.nextInt(herois.length)];
      });

      contagem++;

      if (contagem >= totalTrocas) {
        setState(() {
          _sorteando = false;
        });
        return;
      }

      intervaloAtual += 15;
      _timer = Timer(Duration(milliseconds: intervaloAtual), proximaTroca);
    }

    proximaTroca();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sorteio de Herói')),
      body: Stack(
        children: [
          Center(
            child: SizedBox(
              height: 350,
              width: 300,
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: _heroiSorteado == null
                    ? const Center(
                        child: Text(
                          '?',
                          style: TextStyle(
                            fontSize: 100,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : HeroiCard(heroi: _heroiSorteado!),
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: FloatingActionButton(
                onPressed: _sorteando ? null : _sortear,
                child: const Icon(Icons.casino, size: 32),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== SORTEIO SIMPLES (dado / tabuleiro) ====================

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
  bool _sorteando = false;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _sortear() {
    if (_sorteando) return;

    setState(() {
      _sorteando = true;
    });

    final random = Random();
    int contagem = 0;
    const totalTrocas = 20;
    int intervaloAtual = 50;

    void proximaTroca() {
      setState(() {
        _imagemSorteada = widget.imagens[random.nextInt(widget.imagens.length)];
      });

      contagem++;

      if (contagem >= totalTrocas) {
        setState(() {
          _sorteando = false;
        });
        return;
      }

      intervaloAtual += 15;
      _timer = Timer(Duration(milliseconds: intervaloAtual), proximaTroca);
    }

    proximaTroca();
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
                onPressed: _sorteando ? null : _sortear,
                child: const Icon(Icons.casino, size: 32),
              ),
            ),
          ),
        ],
      ),
    );
  }
}