/// pre-defined drawing functions for tidy tree

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
