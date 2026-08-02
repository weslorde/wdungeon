import 'package:flutter/material.dart';
import 'package:wdungeon/auxiliar/heroiCard.dart';
import 'package:wdungeon/auxiliar/heroi_class.dart';

class TdHerois extends StatelessWidget {
  const TdHerois({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Galeria de Heróis')),
      body: GridView.builder(
        padding: EdgeInsets.all(5),
        itemCount: herois.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
        ),
        itemBuilder: (context, index) {
          final heroi = herois[index];
          return HeroiCard(heroi: heroi);
        },
      ),
    );
  }
}
