/// pre-defined drawing functions for tidy tree

/// process the input draw-node to a valid draw-node function
#let shortcut-draw-node(draw-node) = {
  let typ = type(draw-node)
  if typ == function {
    return draw-node
  } else if typ == arguments or typ == dictionary or typ == array {
    return (..) => draw-node
  } else {
    error("Invalid draw-node type: " + str(typ))
  }
}

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

/// draw a node with metadata matching
#let metadata-match-draw-node = ((name, label, pos), matches: (:), default: (:)) => {
  let collect-metadata(label) = {
    if type(label) != content {
      return ()
    }

    if not label.has("children") {
      if label.func() == metadata {
        return (label.value, )
      } else {
        return ()
      }
    }

    label.children
      .fold((), (acc, child) => acc + collect-metadata(child))
  }

  let ret = arguments()
  let matched = false
  let keys = matches.keys()
  // check whether any metadata in node labels matches
  for key in collect-metadata(label) {
    if keys.contains(key) {
      // support shortcut draw-node
      let draw-node = shortcut-draw-node(matches.at(key))
      ret = arguments(..ret, ..draw-node((name, label, pos)))
      matched = true
    }
  }
  // default case when no metadata matches
  if not matched {
    ret = arguments(..default)
  }
  
  ret
}

/// draw a node as a circle
#let circle-draw-node = ((name, label, pos)) => {
  default-draw-node((name, label, pos)) + (
    shape: circle
  )
}

/// process the input draw-edge to a valid draw-edge function
#let shortcut-draw-edge(draw-edge) = {
  let typ = type(draw-edge)
  if typ == function {
    return draw-edge
  } else if typ == array and draw-edge.all(x => type(x) == function) {
    return sequential-draw-edge(draw-edge)
  } else if typ == arguments or typ == dictionary or typ == array {
    return (..) => draw-edge
  } else {
    error("Invalid draw-edge type: " + str(typ))
  }
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

/// draw an edge with metadata matching
#let metadata-match-draw-edge = (from-node, to-node, edge-label, from-matches: (:), to-matches: (:), matches: (:), default: (:)) => {
  let collect-metadata(label) = {
    if type(label) != content {
      return ()
    }

    if not label.has("children") {
      if type(label) == content and label.func() == metadata {
        return (label.value, )
      } else {
        return ()
      }
    }

    label.children
      .fold((), (acc, child) => acc + collect-metadata(child))
  }

  let ret = arguments()
  let matched = false
  let keys = matches.keys()
  // check whether any metadata in edge labels matches
  for key in collect-metadata(edge-label) {
    if keys.contains(key) {
      let draw-edge = shortcut-draw-edge(matches.at(key))
      ret = arguments(..ret, ..draw-edge(from-node, to-node, edge-label))
      matched = true
    }
  }
  let keys = from-matches.keys()
  // check whether any metadata in from node labels matches
  for key in collect-metadata(from-node.label) {
    if keys.contains(key) {
      let draw-edge = shortcut-draw-edge(from-matches.at(key))
      ret = arguments(..ret, ..draw-edge(from-node, to-node, edge-label))
      matched = true
    }
  }
  let keys = to-matches.keys()
  // check whether any metadata in to node labels matches
  for key in collect-metadata(to-node.label) {
    if keys.contains(key) {
      let draw-edge = shortcut-draw-edge(to-matches.at(key))
      ret = arguments(..ret, ..draw-edge(from-node, to-node, edge-label))
      matched = true
    }
  }

  // default case when no metadata matches
  if not matched {
    ret = arguments(..default)
  }

  ret
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
