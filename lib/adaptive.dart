import "package:flutter/material.dart";

///Reusable method to adapt the UI based on screen width
double adaptive(double x, BuildContext context) =>
    x * MediaQuery.sizeOf(context).width / 428;
