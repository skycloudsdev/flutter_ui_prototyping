# UI planning Prompt

Create an `MVP.md` file for a new ui feature in this Flutter ui prototyping project.

## Instructions

Based on an image that the user is gonna provide, generate a comprehensive implementation plan with the following sections:

### 1. Overview

- Brief description of the design (2-3 sentences)
- Core objective and purpose of the ui feature

### 2. Technical Approach

Describe the technical implementation using:

1. **State Management**: BLoC (`flutter_bloc`) pattern. (Only if needed)
2. **Rendering**: Flutter widgets for UI
3. **Performance**: Optimization strategies
4. **UI/UX**: Identify UI/UX patterns and analyze user painpoints.

### 3. MVP Features

List core features required for minimum viable product:

- Essential widgets
- Possible concerns
- Use dummy data where applicable

## Output Format

Generate the MVP.md file in Markdown format with clear section headers, code blocks for examples, and ASCII diagrams for UI layouts where helpful.

## Context

- This project uses `flutter_bloc: ^9.1.1` for state management
- Follow strict lint rules from `analysis_options.yaml`
- Use package imports (`package:flutter_ui_prototyping/...`)
- Prefer `const` constructors and immutable models
