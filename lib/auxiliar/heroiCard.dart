import 'package:flutter/material.dart';
import 'package:wdungeon/auxiliar/heroi_class.dart';
import 'package:wdungeon/detalheheroi_page.dart';

class HeroiCard extends StatelessWidget {
  final Heroi heroi;

  const HeroiCard({super.key, required this.heroi});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetalheHeroi(heroi: heroi)),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
            child: Stack(
              alignment: AlignmentGeometry.bottomCenter,
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'images/perfil/${heroi.nome}.png',
                    fit: BoxFit.fill,
                  ),
                ),
                Container(
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Container(
                          color: const Color.fromARGB(110, 178, 30, 20),
                          child: Center(
                            child: Image.asset(
                              'images/icons/${heroi.skillVermelha}.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Container(
                          color: const Color.fromARGB(110, 11, 208, 63),
                          child: Center(
                            child: Image.asset(
                              'images/icons/${heroi.skillVerde}.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Container(
                          color: const Color.fromARGB(110, 13, 119, 205),
                          child: Center(
                            child: Image.asset(
                              'images/icons/azul/${heroi.nome}.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
