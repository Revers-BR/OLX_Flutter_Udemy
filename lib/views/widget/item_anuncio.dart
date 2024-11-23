import 'package:flutter/material.dart';
import 'package:olx_flutter/models/anuncio.dart';

class ItemAnuncio extends StatelessWidget {

  final ModelAnuncio anuncio;
  final VoidCallback? onTap;
  final VoidCallback? onPressedRemover;

  const ItemAnuncio({
    super.key,
    required this.anuncio,
    this.onTap,
    this.onPressedRemover
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [

              SizedBox(
                width: 120,
                height: 120,
                child: Container(color: Colors.orange),
              ),

              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        anuncio.titulo!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      Text(anuncio.preco!)
                    ],
                  ) 
                )
              ),

              if(onPressedRemover != null ) Expanded(
                flex: 1,
                child: IconButton(
                  onPressed: onPressedRemover,
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.red)
                  ),
                  icon : const Icon(Icons.delete, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}