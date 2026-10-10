---
name: find-houdini
description: Call before creating, querying, or inspecting Houdini nodes and geometry.
---

# Find houdini

## Environment & Runtime
- **Executable:** Use `hython`, never bare `python3`. System Python lacks `hou` and license bindings.
- **Assertions**: Houdini Object Model natively support Python `assert`.
- **SOP Architecture**: When building using Python SOP, prefer small and modular SOP to make debugging easy.

## Documentation Querying
Query the local Bookish documentation engine using:
- **Search Paths**: `hhelp search "<term>"` (e.g. `hhelp search "polyextrude"` retuns `/nodes/sop/polyextrude`).
- **Read Formatted Text**: `hhelp textify -o <outfile> <path> && cat <outfile>`. 
  - Output directly to stdout fails with `TypeError`; `-o` writes safely to a binary file stream.
  - `hhelp html` dumps unrendered HTML boilerplate.
- **Serve Browser UI**: `hhelp serve -p 8080` and browse at `http://localhost:8080/<path>`.
- **Python Introspection**: Run `hython -c "import hou; help(hou.<Class>)"`.

## Geometry & Attributes
- **Access**: Cook before reading: `node.cook(force=True); geo = node.geometry()`.
- **Elements & Values**: Query with `geo.points()`, `geo.prims()`, `elem.attribValue("name")`, `pt.position()`.
- **In-Memory Snapshots**: Clone geometry for diffing/comparison: `snap = hou.Geometry(); snap.copy(geo)`.
- **Classes**: Houdini attributes exist across 4 classes: Detail, Primitive, Point, and Vertex.

## Scene Traversal, Parameters & Cooking via HOM
- **Graph Traversal**: List nodes via `node.children()` (immediate) or `node.allSubChildren()` (recursive); query connections with `node.inputs()` and `node.outputs()`.
- **Node Wiring**: Create nodes with `parent.createNode("type", "name")` and wire inputs with `target.setInput(input_idx, source_node, output_idx)`.
- **Parameters**: Set with `node.parm("name").set(val)` / `parmTuple("name").set(vals)`. Inspect with `parm.eval()`, `parm.isAtDefault()`, and `parm.expression()`.
- **Scene Files**: Manage scenes with `hou.hipFile.load(hip_path)` and `hou.hipFile.save(hip_path)`.
