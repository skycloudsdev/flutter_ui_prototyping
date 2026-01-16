import 'package:flutter/material.dart';

@immutable
class Bill {
  final String id;
  final String title;
  final double totalAmount;
  final DateTime createdAt;

  const Bill({
    required this.id,
    required this.title,
    required this.totalAmount,
    required this.createdAt,
  });

  Bill copyWith({
    String? id,
    String? title,
    double? totalAmount,
    DateTime? createdAt,
  }) {
    return Bill(
      id: id ?? this.id,
      title: title ?? this.title,
      totalAmount: totalAmount ?? this.totalAmount,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
