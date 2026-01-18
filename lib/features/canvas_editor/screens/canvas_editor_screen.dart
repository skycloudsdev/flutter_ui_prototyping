import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_prototyping/features/canvas_editor/bloc/canvas_bloc.dart';
import 'package:flutter_ui_prototyping/features/canvas_editor/bloc/canvas_event.dart';
import 'package:flutter_ui_prototyping/features/canvas_editor/bloc/canvas_state.dart';
import 'package:flutter_ui_prototyping/features/canvas_editor/models/shape_model.dart';
import 'package:flutter_ui_prototyping/features/canvas_editor/widgets/canvas_painter.dart';
import 'package:flutter_ui_prototyping/features/canvas_editor/widgets/shape_context_menu.dart';
import 'package:flutter_ui_prototyping/features/canvas_editor/widgets/shape_selector_bottom_sheet.dart';

/// Main screen for the canvas shape editor.
class CanvasEditorScreen extends StatelessWidget {
  static const id = '/canvas-editor';

  const CanvasEditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CanvasBloc(),
      child: const _CanvasEditorView(),
    );
  }
}

class _CanvasEditorView extends StatefulWidget {
  const _CanvasEditorView();

  @override
  State<_CanvasEditorView> createState() => _CanvasEditorViewState();
}

class _CanvasEditorViewState extends State<_CanvasEditorView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  Offset? _dragStartPosition;
  Offset? _shapeStartPosition;
  Size? _initialShapeSize;
  bool _isPinching = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _onAddShape(BuildContext context) async {
    final selectedType = await ShapeSelectorBottomSheet.show(context);
    if (selectedType == null || !context.mounted) return;

    final screenSize = MediaQuery.of(context).size;
    final centerPosition = Offset(
      screenSize.width / 2,
      screenSize.height / 2,
    );

    context.read<CanvasBloc>().add(
      AddShapeEvent(
        shapeType: selectedType,
        position: centerPosition,
      ),
    );

    _animationController.forward(from: 0);
  }

  ShapeModel? _findShapeAtPosition(List<ShapeModel> shapes, Offset position) {
    // Check shapes in reverse order (top-most first)
    for (var i = shapes.length - 1; i >= 0; i--) {
      if (shapes[i].containsPoint(position)) {
        return shapes[i];
      }
    }
    return null;
  }

  void _onTapDown(TapDownDetails details, CanvasState state) {
    final tappedShape = _findShapeAtPosition(
      state.shapes,
      details.localPosition,
    );
    context.read<CanvasBloc>().add(SelectShapeEvent(shapeId: tappedShape?.id));
  }

  Future<void> _onLongPress(
    LongPressStartDetails details,
    CanvasState state,
  ) async {
    final tappedShape = _findShapeAtPosition(
      state.shapes,
      details.localPosition,
    );
    if (tappedShape == null) return;

    // Select the shape first
    context.read<CanvasBloc>().add(SelectShapeEvent(shapeId: tappedShape.id));

    final action = await ShapeContextMenu.show(
      context: context,
      position: details.globalPosition,
    );

    if (action == null || !mounted) return;

    final bloc = context.read<CanvasBloc>();
    switch (action) {
      case ShapeContextMenuAction.rotate90:
        bloc.add(RotateShape90Event(shapeId: tappedShape.id));
      case ShapeContextMenuAction.flipHorizontal:
        bloc.add(FlipShapeHorizontalEvent(shapeId: tappedShape.id));
      case ShapeContextMenuAction.flipVertical:
        bloc.add(FlipShapeVerticalEvent(shapeId: tappedShape.id));
      case ShapeContextMenuAction.delete:
        bloc.add(DeleteShapeEvent(shapeId: tappedShape.id));
    }
  }

  void _onScaleStart(ScaleStartDetails details, CanvasState state) {
    final selectedShape = state.selectedShape;
    if (selectedShape == null) return;

    _isPinching = details.pointerCount > 1;
    _initialShapeSize = selectedShape.size;

    if (selectedShape.containsPoint(details.localFocalPoint)) {
      _dragStartPosition = details.localFocalPoint;
      _shapeStartPosition = selectedShape.position;
    } else {
      _dragStartPosition = null;
      _shapeStartPosition = null;
    }
  }

  void _onScaleUpdate(ScaleUpdateDetails details, CanvasState state) {
    final selectedShape = state.selectedShape;
    if (selectedShape == null) return;

    // Check if this is a pinch gesture
    if (details.pointerCount > 1 || _isPinching) {
      _isPinching = true;
      if (details.scale != 1.0 && _initialShapeSize != null) {
        final newSize = Size(
          _initialShapeSize!.width * details.scale,
          _initialShapeSize!.height * details.scale,
        );

        context.read<CanvasBloc>().add(
          UpdateShapeScaleEvent(
            shapeId: selectedShape.id,
            newSize: newSize,
          ),
        );
      }
    } else if (_dragStartPosition != null && _shapeStartPosition != null) {
      // Single finger drag
      final delta = details.localFocalPoint - _dragStartPosition!;
      final newPosition = _shapeStartPosition! + delta;

      context.read<CanvasBloc>().add(
        UpdateShapePositionEvent(
          shapeId: selectedShape.id,
          position: newPosition,
        ),
      );
    }
  }

  void _onScaleEnd(ScaleEndDetails details, CanvasState state) {
    if (_isPinching) {
      context.read<CanvasBloc>().add(const SaveScaleToHistoryEvent());
    } else if (_dragStartPosition != null) {
      context.read<CanvasBloc>().add(const SavePositionToHistoryEvent());
    }
    _dragStartPosition = null;
    _shapeStartPosition = null;
    _initialShapeSize = null;
    _isPinching = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Canvas Editor'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
        actions: [
          BlocBuilder<CanvasBloc, CanvasState>(
            buildWhen: (prev, curr) =>
                prev.canUndo != curr.canUndo || prev.canRedo != curr.canRedo,
            builder: (context, state) {
              return Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.undo),
                    onPressed: state.canUndo
                        ? () =>
                              context.read<CanvasBloc>().add(const UndoEvent())
                        : null,
                    tooltip: 'Undo',
                  ),
                  IconButton(
                    icon: const Icon(Icons.redo),
                    onPressed: state.canRedo
                        ? () =>
                              context.read<CanvasBloc>().add(const RedoEvent())
                        : null,
                    tooltip: 'Redo',
                  ),
                ],
              );
            },
          ),
          BlocBuilder<CanvasBloc, CanvasState>(
            buildWhen: (prev, curr) =>
                prev.shapes.isNotEmpty != curr.shapes.isNotEmpty,
            builder: (context, state) {
              return IconButton(
                icon: const Icon(Icons.delete_sweep),
                onPressed: state.shapes.isNotEmpty
                    ? () => context.read<CanvasBloc>().add(
                        const ClearCanvasEvent(),
                      )
                    : null,
                tooltip: 'Clear All',
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<CanvasBloc, CanvasState>(
        listenWhen: (prev, curr) =>
            prev.animatingShapeId != curr.animatingShapeId,
        listener: (context, state) {
          if (state.animatingShapeId != null) {
            _animationController.forward(from: 0).then((_) {
              if (mounted) {
                context.read<CanvasBloc>().add(
                  const ClearAnimatingShapeEvent(),
                );
              }
            });
          }
        },
        builder: (context, state) {
          return GestureDetector(
            onTapDown: (details) => _onTapDown(details, state),
            onLongPressStart: (details) => _onLongPress(details, state),
            onScaleStart: (details) => _onScaleStart(details, state),
            onScaleUpdate: (details) => _onScaleUpdate(details, state),
            onScaleEnd: (details) => _onScaleEnd(details, state),
            child: AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return CustomPaint(
                  painter: CanvasPainter(
                    shapes: state.shapes,
                    selectedShapeId: state.selectedShapeId,
                    animatingShapeId: state.animatingShapeId,
                    animationValue: _scaleAnimation.value,
                  ),
                  size: Size.infinite,
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onAddShape(context),
        tooltip: 'Add Shape',
        child: const Icon(Icons.add),
      ),
    );
  }
}
