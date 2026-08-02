import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wdungeon/auxiliar/heroi_class.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:io';

class DetalheHeroi extends StatefulWidget {
  final Heroi heroi;

  const DetalheHeroi({super.key, required this.heroi});

  @override
  State<DetalheHeroi> createState() => _DetalheHeroiState();
}

class _DetalheHeroiState extends State<DetalheHeroi> {
  late PageController _controller;
  late int _paginaAtual;
  bool _arrastarLiberado = true;

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

  void _atualizarArrasto(bool liberado) {
    if (!mounted) return;
    setState(() {
      _arrastarLiberado = liberado;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(herois[_paginaAtual].nome)),
      body: PageView.builder(
        controller: _controller,
        itemCount: herois.length,
        physics: _arrastarLiberado
            ? const PageScrollPhysics()
            : const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            _paginaAtual = index;
          });
        },
        itemBuilder: (context, index) {
          final heroi = herois[index];
          return _PaginaHeroi(heroi: heroi, onMudarArrasto: _atualizarArrasto);
        },
      ),
    );
  }
}

// Busca a carta auxiliar correspondente ao herói, se existir
HeroiAux? _buscarCartaAuxiliar(Heroi heroi) {
  if (heroi.cartaextra == 'nao') return null;
  for (final aux in heroisAux) {
    if (aux.cartaextra == heroi.nome) return aux;
  }
  return null;
}

class _PaginaHeroi extends StatefulWidget {
  final Heroi heroi;
  final ValueChanged<bool> onMudarArrasto;

  final AudioPlayer _player = AudioPlayer();

  _PaginaHeroi({required this.heroi, required this.onMudarArrasto});

  @override
  State<_PaginaHeroi> createState() => _PaginaHeroiState();
}

class _PaginaHeroiState extends State<_PaginaHeroi> {
  int _selecionado = 0;
  bool _mostrandoAux = false;
  final AudioPlayer _player = AudioPlayer();

  void _clicouEsquerda() => setState(() => _selecionado = 1);
  void _clicouDireita() => setState(() => _selecionado = 2);

  void _alternarCarta() {
    setState(() {
      _mostrandoAux = !_mostrandoAux;
      _selecionado = 0;
    });
    widget.onMudarArrasto(!_mostrandoAux);
  }

  Future<void> _tocarAudio() async {
    final nome = (_mostrandoAux && _buscarCartaAuxiliar(widget.heroi) != null)
        ? _buscarCartaAuxiliar(widget.heroi)!.nome
        : widget.heroi.nome;

    final asset = 'images/audios/$nome.mp3';

    try {
      // verifica se o asset existe
      await rootBundle.load(asset);

      await _player.stop();
      await _player.setAsset(asset);
      await _player.play();
    } catch (_) {
      // não existe o áudio
    }
  }

  @override
  void dispose() {
    _player.dispose();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onMudarArrasto(true);
    });

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auxCard = _buscarCartaAuxiliar(widget.heroi);
    final Heroi cartaAtual = (_mostrandoAux && auxCard != null)
        ? auxCard
        : widget.heroi;

    return Stack(
      children: [
        Positioned.fill(child: _conteudoCarta(cartaAtual)),
        if (auxCard != null)
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: _alternarCarta,
              child: Icon(_mostrandoAux ? Icons.person : Icons.swap_horiz),
            ),
          ),
        Positioned(
          top: 20,
          right: 20,
          child: FloatingActionButton(
            heroTag: 'audio_${widget.heroi.nome}',
            mini: true,
            onPressed: _tocarAudio,
            child: const Icon(Icons.volume_up),
          ),
        ),
      ],
    );
  }

  Widget _conteudoCarta(Heroi carta) {
    if (_selecionado == 0) {
      return Column(
        children: [
          Flexible(
            child: Center(
              child: GestureDetector(
                onTap: _clicouEsquerda,
                behavior: HitTestBehavior.opaque,
                child: Image.asset('images/corteEsquerda/${carta.nome}.png'),
              ),
            ),
          ),
          Flexible(
            child: Center(
              child: GestureDetector(
                onTap: _clicouDireita,
                behavior: HitTestBehavior.opaque,
                child: Image.asset('images/corteDireita/${carta.nome}.png'),
              ),
            ),
          ),
        ],
      );
    }

    final tamanhoEsquerda = _selecionado == 1 ? 0.8 : 0.45;
    final tamanhoDireita = _selecionado == 1 ? 0.45 : 0.8;

    return LayoutBuilder(
      builder: (context, constraints) {
        final altura = constraints.maxHeight;
        if (_selecionado == 1) {
          return Stack(
            children: [
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: altura * tamanhoDireita,
                child: GestureDetector(
                  onTap: _clicouDireita,
                  behavior: HitTestBehavior.opaque,
                  child: Image.asset(
                    'images/corteDireita/${carta.nome}.png',
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: altura * tamanhoEsquerda,
                child: GestureDetector(
                  onTap: _clicouEsquerda,
                  behavior: HitTestBehavior.opaque,
                  child: Image.asset(
                    'images/corteEsquerda/${carta.nome}.png',
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
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: altura * tamanhoEsquerda,
                child: GestureDetector(
                  onTap: _clicouEsquerda,
                  behavior: HitTestBehavior.opaque,
                  child: Image.asset(
                    'images/corteEsquerda/${carta.nome}.png',
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: altura * tamanhoDireita,
                child: GestureDetector(
                  onTap: _clicouDireita,
                  behavior: HitTestBehavior.opaque,
                  child: Image.asset(
                    'images/corteDireita/${carta.nome}.png',
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
            ],
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
