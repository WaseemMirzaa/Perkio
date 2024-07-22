import 'package:flutter/material.dart';

class CustomBottomBarItem extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final Function onTap;
  final String path;

  CustomBottomBarItem({
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.path,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(path, scale: 3,),
          SizedBox(height: 2),
          isSelected ?
          Container(
            height: 6,
            width: 6,
            decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(100),
                                                      gradient: LinearGradient(
                                                      colors: [Colors.red, Colors.orange],
                                                      begin: Alignment.topLeft,
                                                      end: Alignment.bottomRight,
                                                    ),
                      
                                                    ),
          ) : SizedBox(height: 6, width: 6,)
        ],
      ),
    );
  }
}
