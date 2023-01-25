import 'package:flutter/material.dart';
import 'package:google_maps_webservice/src/places.dart';

class MapsDetailScreen extends StatelessWidget {
  final PlacesSearchResult result;
  const MapsDetailScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // title:
          ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.network(
                  result.icon ?? "",
                  scale: 3.0,
                ),
                const SizedBox(
                  width: 8.0,
                ),
                Expanded(
                    child: Text(
                  result.name,
                  style: Theme.of(context).textTheme.bodyLarge,
                )),
              ],
            ),
            Text('Open Now : ${result.openingHours!.openNow}'),
            Text('Ratings : ${result.rating}'),
            const Text('Types : '),
            Wrap(
                children: result.types
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          color: Colors.blue,
                          height: 50,
                          child: Center(
                            child: Text(
                              e,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList())
          ],
        ),
      ),
    );
  }
}
