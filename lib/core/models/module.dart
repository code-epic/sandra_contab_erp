import 'package:flutter/material.dart';


class Module {
  final String id;
  final String title;
  final IconData icon;
  final String route;
  final String description;

  const Module({
    required this.id,
    required this.title,
    required this.icon,
    required this.route,
    this.description = '',
  });
}