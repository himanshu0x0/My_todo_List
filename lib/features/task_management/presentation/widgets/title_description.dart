import 'package:flutter/material.dart';
import 'package:mytodoapp/utils/appstyles.dart';
import 'package:mytodoapp/utils/size_config.dart';

class TitleDescription extends StatelessWidget {
  const TitleDescription({
    super.key,
    required this.title,
    required this.prefixIcon,
    required this.hintText,
    required this.maxLines,
    required this.controller,
  });

  final String title;
  final IconData prefixIcon;
  final String hintText;
  final int maxLines;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(title, style: AppStyle.headingTextStyle.copyWith(fontSize: 10)),
        SizedBox(height: SizeConfig.getProportionateHeight(10)),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: Colors.grey,
            prefixIcon: Icon(prefixIcon),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
        ),
      ],
    );
  }
}
