import 'package:flutter/material.dart';
import 'package:wdungeon/auxiliar/heroiCard.dart';
import 'package:wdungeon/auxiliar/heroi_class.dart';

class PesquisaHerois extends StatefulWidget {
  const PesquisaHerois({super.key});

  @override
  State<PesquisaHerois> createState() => _PesquisaHeroisState();
}

class _PesquisaHeroisState extends State<PesquisaHerois> {
  final TextEditingController _searchController = TextEditingController();

  String _busca = '';
  String? _skillVermelha;
  String? _skillVerde;
  String? _classe;
  String? _caixa;
  String? _dificuldade;

  // Extrai valores únicos de um campo da lista de heróis
  List<String> _opcoes(
    Iterable<String> valores, {
    List<String> ignorar = const ['Fobia', 'InstSuperior', 'CuraErrado', 'Vortice', 'Samata', 'Virya'],
  }) {
    final unicos = valores.where((v) => !ignorar.contains(v)).toSet().toList();
    unicos.sort();
    return unicos;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final opcoesSkillVermelha = _opcoes(herois.map((h) => h.skillVermelha));
    final opcoesSkillVerde = _opcoes(herois.map((h) => h.skillVerde));
    final opcoesClasse = _opcoes(herois.expand((h) => h.classe));
    final opcoesCaixa = _opcoes(herois.map((h) => h.caixa));
    final opcoesDificuldade = _opcoes(herois.map((h) => h.dificuldade));

    final resultado = herois.where((h) {
      final buscaOk = h.nomeCompleto.toLowerCase().contains(
        _busca.toLowerCase(),
      );
      final skillVermelhaOk =
          _skillVermelha == null || h.skillVermelha == _skillVermelha;
      final skillVerdeOk = _skillVerde == null || h.skillVerde == _skillVerde;
      final classeOk = _classe == null || h.classe.contains(_classe);
      final caixaOk = _caixa == null || h.caixa == _caixa;
      final dificuldadeOk =
          _dificuldade == null || h.dificuldade == _dificuldade;

      return buscaOk &&
          skillVermelhaOk &&
          skillVerdeOk &&
          classeOk &&
          caixaOk &&
          dificuldadeOk;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Pesquisar Heróis')),
      body: Column(
        children: [
          // ==== CAIXA DE PESQUISA (sempre aberta) ====
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _busca = value),
              decoration: InputDecoration(
                hintText: 'Buscar herói pelo nome...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _busca.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _busca = '');
                        },
                      ),
                filled: true,
                fillColor: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),

          const Divider(height: 1, thickness: 1),

          // ==== DROPDOWNS DE FILTRO ====
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _dropdownFiltro(
                        label: 'Skill Vermelha',
                        valor: _skillVermelha,
                        opcoes: opcoesSkillVermelha,
                        onChanged: (v) => setState(() => _skillVermelha = v),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _dropdownFiltro(
                        label: 'Skill Verde',
                        valor: _skillVerde,
                        opcoes: opcoesSkillVerde,
                        onChanged: (v) => setState(() => _skillVerde = v),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _dropdownFiltro(
                        label: 'Classe',
                        valor: _classe,
                        opcoes: opcoesClasse,
                        onChanged: (v) => setState(() => _classe = v),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _dropdownFiltro(
                        label: 'Caixa',
                        valor: _caixa,
                        opcoes: opcoesCaixa,
                        onChanged: (v) => setState(() => _caixa = v),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _dropdownFiltro(
                        label: 'Dificuldade',
                        valor: _dificuldade,
                        opcoes: opcoesDificuldade,
                        onChanged: (v) => setState(() => _dificuldade = v),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(height: 1, thickness: 1),

          // ==== RESULTADO ====
          Expanded(
            child: resultado.isEmpty
                ? const Center(child: Text('Nenhum herói encontrado'))
                : GridView.builder(
                    padding: const EdgeInsets.all(5),
                    itemCount: resultado.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.8,
                        ),
                    itemBuilder: (context, index) {
                      final heroi = resultado[index];
                      return HeroiCard(heroi: heroi);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _dropdownFiltro({
    required String label,
    required String? valor,
    required List<String> opcoes,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: valor,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      items: [
        const DropdownMenuItem<String>(value: null, child: Text('Todos')),
        ...opcoes.map(
          (o) => DropdownMenuItem<String>(value: o, child: Text(o)),
        ),
      ],
      onChanged: onChanged,
    );
  }
}
