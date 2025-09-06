import "package:flutter/material.dart";

double adaptive(double x, BuildContext context) =>
    x * MediaQuery.of(context).size.width / 428;
