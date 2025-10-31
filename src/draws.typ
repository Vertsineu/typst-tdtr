/// pre-defined drawing functions for tidy tree

/*
  compose multiple draw-node functions sequentially
  - input:
    - `draw-nodes`: array of draw-node functions
      - see `tidy-tree-elements` for the format
  - output:
    - `ret`: a composed draw-node function
*/
#let sequential-draw-node(..draw-nodes) = {
  let func = (..) => arguments()
  for draw-node in draw-nodes.pos() {
    // make sure draw-node is a valid function
    draw-node = shortcut-draw-node(draw-node)
    func = (..info) => arguments(..func(..info), ..draw-node(..info))
  }
  return func
}

/// default function for drawing a node
#let default-draw-node = ((name, label, pos)) => {
  (
    pos: (pos.x, pos.i), 
    label: [#label], 
    name: name, 
    shape: rect
  )
}

/// draw a node as a circle
#let circle-draw-node = ((name, label, pos)) => {
  default-draw-node((name, label, pos)) + (
    shape: circle
  )
}

/*
  compose multiple draw-edge functions sequentially
  - input:
    - `draw-edges`: array of draw-edge functions
      - see `tidy-tree-elements` for the format
  - output:
    - `ret`: a composed draw-edge function
*/
#let sequential-draw-edge(..draw-edges) = {
  let func = (..) => arguments()
  for draw-edge in draw-edges.pos() {
    draw-edge = shortcut-draw-edge(draw-edge)
    func = (..info) => arguments(..func(..info), ..draw-edge(..info))
  }
  return func
}

/// default function for drawing an edge
#let default-draw-edge = (from-node, to-node, edge-label) => {
  (
    vertices: (from-node.name, to-node.name), 
    marks: "-|>"
  )
  if edge-label != none {
    (
      label: box(fill: white, inset: 2pt)[#edge-label], 
      label-sep: 0pt, 
      label-anchor: "center"
    )
  }
}

/// draw an edge in reversed direction
#let reversed-draw-edge = (from-node, to-node, edge-label) => {
  default-draw-edge(to-node, from-node, edge-label)
}

/// draw an edge with horizontal-vertical style
#let horizontal-vertical-draw-edge = (from-node, to-node, edge-label) => {
  let from-anchor = (name: from-node.name, anchor: "south")
  let to-anchor = (name: to-node.name, anchor: "north")
  let middle-anchor = (from-anchor, 50%, to-anchor)
  if from-node.pos.x == to-node.pos.x {
    (
      vertices: (from-anchor, to-anchor), 
      marks: "-|>",
      label: edge-label
    )
  } else {
    (
      vertices: (
        from-anchor,
        ((), "|-", middle-anchor),
        ((), "-|", to-anchor),
        to-anchor
      ),
      marks: "-|>",
      label: edge-label
    )
  }
}
