import 'package:flutter/material.dart';

class SelectPictureDialog extends StatefulWidget {
  @override
  _SelectPictureDialogState createState() => _SelectPictureDialogState();
}

class _SelectPictureDialogState extends State<SelectPictureDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        height: 200.0,
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ListTile(
              title: Text(
                '사진 촬영',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                
              },
            ),
            SizedBox(height: 20),
            ListTile(
              title: Text(
                '앨범에서 선택',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
              
              },
            ),
          ],
        ),
      ),
    );
  }
}
