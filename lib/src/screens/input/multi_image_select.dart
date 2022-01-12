import 'package:apple_market/src/constants/common_size.dart';
import 'package:flutter/material.dart';

class MultiImageSelect extends StatelessWidget {
  const MultiImageSelect({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        Size _size = MediaQuery.of(context).size;

        return SizedBox(
          height: _size.width / 3,
          // width: _size.width,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(padding_16),
                child: Container(
                  width: _size.width / 3 - padding_16 * 2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey, width: 1),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.camera_alt_rounded, color: Colors.grey),
                      Text('0/10', style: Theme.of(context).textTheme.subtitle2),
                    ],
                  ),
                ),
              ),
              Container(width: 100, color: Colors.black87),
              Container(width: 100, color: Colors.grey),
              Container(width: 100, color: Colors.amberAccent),
              Container(width: 100, color: Colors.black87),
              Container(width: 100, color: Colors.grey),
            ],
          ),
        );
      },
    );
  }
}
