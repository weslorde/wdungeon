class Heroi {
  final int indice;
  final String nome;
  final String skillVermelha;
  final String skillVerde;
  final List<String> classe;

  const Heroi({
    required this.indice,
    required this.nome,
    required this.skillVermelha,
    required this.skillVerde,
    required this.classe,
  });
}

const List<Heroi> herois = [
  Heroi(
    indice: 0,
    nome: 'Alton',
    skillVermelha: 'Repete',
    skillVerde: 'InstAgil',
    classe: ['Suporte'],
  ),
  Heroi(
    indice: 1,
    nome: 'Jorge',
    skillVermelha: 'Rebola',
    skillVerde: 'NuvemCura',
    classe: ['Suporte', 'Dano'],
  ),
  Heroi(
    indice: 2,
    nome: 'Alton',
    skillVermelha: 'Repete',
    skillVerde: 'InstAgil',
    classe: ['Suporte'],
  ),
  Heroi(
    indice: 3,
    nome: 'Jorge',
    skillVermelha: 'Rebola',
    skillVerde: 'NuvemCura',
    classe: ['Suporte', 'Dano'],
  ),
];
