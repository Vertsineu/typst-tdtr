/// some pre-defined variants for tidy-tree-graph
#import "core.typ" : tidy-tree-graph, tidy-tree-draws

#let red-black-tree-graph = tidy-tree-graph.with(
  node-inset: 4pt,
  spacing: (15pt, 15pt),
  draw-node: (
    tidy-tree-draws.circle-draw-node,
    tidy-tree-draws.metadata-match-draw-node.with(
      matches: (
        red: (fill: color.rgb("#bb3e03")),
        nil: (post: x => none)
      ),
      default: (fill: color.rgb("#001219"))
    ),
    ((label, )) => (label: text(color.white)[#label], stroke: none),
  ),
  draw-edge: (
    tidy-tree-draws.default-draw-edge,
    tidy-tree-draws.metadata-match-draw-edge.with(
      to-matches: (
        nil: (post: x => none),
      )
    ),
    (marks: "-", stroke: .6pt),
  )
)
