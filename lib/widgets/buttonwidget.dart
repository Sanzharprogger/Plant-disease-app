import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({Key? key, required this.text, this.width = 200})
      : super(key: key);
  final String text;
  final double width;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: this.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.23),
            blurRadius: 30, // changes position of shadow
          ),
        ],
      ),
      child: TextButton(
          style: ButtonStyle(
              minimumSize:
                  MaterialStateProperty.all<Size>(Size(this.width, 50)),
              backgroundColor: MaterialStateProperty.all<Color>(
                  Theme.of(context).accentColor),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30))),
              shadowColor: MaterialStateProperty.all<Color>(
                  Colors.grey.withOpacity(0.23))),
          onPressed: () {},
          child: Text(
            this.text,
            style: TextStyle(color: Colors.white),
          )),
    );
  }
}
