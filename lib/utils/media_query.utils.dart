import 'package:flutter/material.dart';

double fullWidth(BuildContext context, {double percentage = 1.0}) {
  return MediaQuery.of(context).size.width * percentage;
}

double fullHeight(BuildContext context, {double percentage = 1.0}) {
  return MediaQuery.of(context).size.height * percentage;
}
