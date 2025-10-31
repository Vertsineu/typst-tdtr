/// some pre-defined variants for tidy-tree-graph
#import "core.typ" : tidy-tree-graph, tidy-tree-draws
#import "utils.typ" : list-from-content

/// convert content into a tree graph
/// suitable for debugging or visualizing the content structure
#let content-tree-graph(body, ..args) = tidy-tree-graph(list-from-content(body), ..args)

/// suitable for the trees whose nodes and edges have simple and short content, e.g., a binary tree
/// use #metadata("nil") to mark nil nodes which only affect layout but do not be drawn
#let binary-tree-graph(..args) = tidy-tree-graph(
  node-inset: 4pt,
  spacing: (15pt, 15pt),
  draw-node: (
    tidy-tree-draws.circle-draw-node,
    tidy-tree-draws.metadata-match-draw-node.with(
      matches: (
        nil: (post: x => none)
      )
    ),
    (stroke: .5pt)
  ),
  draw-edge: (
    tidy-tree-draws.default-draw-edge,
    tidy-tree-draws.metadata-match-draw-edge.with(
      to-matches: (
        nil: (post: x => none),
      )
    ),
    (marks: "-", stroke: .5pt),
  ),
  ..args
)

/// specialized for red-black trees, with color-coded nodes and hidden nil edges
/// use #metadata("red") to mark red nodes whose fill color is red and #metadata("nil") to mark nil nodes which only affect layout but do not be drawn
#let red-black-tree-graph(..args) = tidy-tree-graph(
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
  ),
  ..args
)
