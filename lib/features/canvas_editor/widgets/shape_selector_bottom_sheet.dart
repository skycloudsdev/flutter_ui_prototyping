import 'package:flutter/material.dart';
import 'package:flutter_ui_prototyping/features/canvas_editor/models/shape_type.dart';

/// Bottom sheet widget for selecting a shape type.
class ShapeSelectorBottomSheet extends StatelessWidget {
  final void Function(ShapeType) onShapeSelected;

  const ShapeSelectorBottomSheet({
    required this.onShapeSelected,
    super.key,
  });

  /// Shows the bottom sheet and returns the selected shape type.
  static Future<ShapeType?> show(BuildContext context) {
    return showModalBottomSheet<ShapeType>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ShapeSelectorBottomSheet(
        onShapeSelected: (type) => Navigator.pop(context, type),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Add Shape',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Select a shape to add to the canvas',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ShapeOption(
                  shapeType: ShapeType.circle,
                  label: 'Circle',
                  icon: Icons.circle,
                  color: Colors.blue,
                  onTap: () => onShapeSelected(ShapeType.circle),
                ),
                _ShapeOption(
                  shapeType: ShapeType.square,
                  label: 'Square',
                  icon: Icons.square,
                  color: Colors.green,
                  onTap: () => onShapeSelected(ShapeType.square),
                ),
                _ShapeOption(
                  shapeType: ShapeType.triangle,
                  label: 'Triangle',
                  icon: Icons.change_history,
                  color: Colors.orange,
                  onTap: () => onShapeSelected(ShapeType.triangle),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _ShapeOption extends StatelessWidget {
  final ShapeType shapeType;
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ShapeOption({
    required this.shapeType,
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 90,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 40,
              color: color,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
