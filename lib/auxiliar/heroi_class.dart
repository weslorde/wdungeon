class Heroi {
  final int indice;
  final String nome;

  const Heroi({required this.indice, required this.nome});
}

const List<Heroi> herois = [
  Heroi(indice: 0, nome: 'Alton'),
  Heroi(indice: 1, nome: 'Jorge'),
];
