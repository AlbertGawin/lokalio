import 'package:flutter/material.dart';

class ImageListWidget extends StatefulWidget {
  final List<String> imageUrls;

  const ImageListWidget({super.key, required this.imageUrls});

  @override
  State<ImageListWidget> createState() => _ImageListWidgetState();
}

class _ImageListWidgetState extends State<ImageListWidget> {
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 250,
          width: double.infinity,
          child: PageView.builder(
            allowImplicitScrolling: true,
            scrollDirection: Axis.horizontal,
            itemCount: widget.imageUrls.length,
            onPageChanged: (index) => setState(() {
              _currentIndex = index + 1;
            }),
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {},
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      widget.imageUrls[index],
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color.fromARGB(120, 0, 0, 0),
                              Color.fromARGB(0, 0, 0, 0),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Positioned(
          bottom: 10,
          left: 10,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color.fromARGB(150, 255, 255, 255),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$_currentIndex/${widget.imageUrls.length}',
            ),
          ),
        ),
      ],
    );
  }
}
