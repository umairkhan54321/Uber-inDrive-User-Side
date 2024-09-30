import 'package:flutter/material.dart';

class ProgressDialog extends StatelessWidget {
String? message;
ProgressDialog({this.message});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black54,
      child: Container(
        margin: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(6)
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const SizedBox(height: 6,),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.green
                ),
              ),
                            const SizedBox(height: 26,),
                Text(message!,style: const TextStyle(color: Colors.white
,                fontSize: 12),)
            ],
          ),
        ),
      ),
    );
  }
}