import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Context menu options for shape manipulation.
enum ShapeContextMenuAction {
  rotate90,
  flipHorizontal,
  flipVertical,
  delete,
}

/// Displays a context menu for shape operations.
class ShapeContextMenu {
  /// Shows a popup menu at the given position.
  static Future<ShapeContextMenuAction?> show({
    required BuildContext context,
    required Offset position,
  }) async {
    final overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox?;
    if (overlay == null) return null;

    return showMenu<ShapeContextMenuAction>(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromLTWH(position.dx, position.dy, 0, 0),
        Offset.zero & overlay.size,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 8,
      items: [
        _buildMenuItem(
          value: ShapeContextMenuAction.rotate90,
          icon: Icons.rotate_right,
          label: 'Rotate 90°',
        ),
        _buildMenuItem(
          value: ShapeContextMenuAction.flipHorizontal,
          icon: Icons.flip,
          label: 'Flip Horizontal',
        ),
        _buildMenuItem(
          value: ShapeContextMenuAction.flipVertical,
          icon: Icons.flip,
          label: 'Flip Vertical',
          iconRotation: 90,
        ),
        const PopupMenuDivider(),
        _buildMenuItem(
          value: ShapeContextMenuAction.delete,
          icon: Icons.delete_outline,
          label: 'Delete',
          isDestructive: true,
        ),
      ],
    );
  }

  static PopupMenuItem<ShapeContextMenuAction> _buildMenuItem({
    required ShapeContextMenuAction value,
    required IconData icon,
    required String label,
    bool isDestructive = false,
    double iconRotation = 0,
  }) {
    final color = isDestructive ? Colors.red : null;

    return PopupMenuItem<ShapeContextMenuAction>(
      value: value,
      child: Row(
        children: [
          Transform.rotate(
            angle: iconRotation * math.pi / 180,
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(color: color),
          ),
        ],
      ),
    );
  }
}
