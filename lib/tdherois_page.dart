import 'package:flutter/material.dart';
import 'package:wdungeon/auxiliar/heroi_class.dart';
import 'package:wdungeon/detalheheroi_page.dart';

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
          childAspectRatio: 0.85,
        ),
        itemBuilder: (context, index) {
          final heroi = herois[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => DetalheHeroi(heroi: heroi)),
              );
            },
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'images/perfil/${heroi.nome}.png',
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
