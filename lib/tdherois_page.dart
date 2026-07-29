import 'dart:ffi';

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
          childAspectRatio: 0.8,
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
                      //
                      //
                      //
                      Container(
                        height: 60,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Container(
                                color: const Color.fromARGB(110, 244, 67, 54),
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
                                color: const Color.fromARGB(110, 33, 149, 243),
                                child: Center(
                                  child: Image.asset(
                                    'images/icons/${heroi.skillVerde}.png',
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
        },
      ),
    );
  }
}
