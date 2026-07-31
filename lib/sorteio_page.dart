import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:wdungeon/auxiliar/heroiCard.dart';
import 'package:wdungeon/auxiliar/heroi_class.dart';

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
    if (_sorteando) return; // evita clicar de novo enquanto já está sorteando

    setState(() {
      _sorteando = true;
    });

    final random = Random();
    int contagem = 0;
    const totalTrocas = 20; // quantas trocas até parar
    int intervaloAtual = 50; // ms entre trocas (começa rápido)

    void proximaTroca() {
      setState(() {
        _heroiSorteado = herois[random.nextInt(herois.length)];
      });

      contagem++;

      if (contagem >= totalTrocas) {
        // Parou: garante que o último seja realmente aleatório e final
        setState(() {
          _sorteando = false;
        });
        return;
      }

      // Desacelera progressivamente conforme se aproxima do final
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
            child: Container(
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
          // Botão flutuante de dado, fixo na parte de baixo
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
