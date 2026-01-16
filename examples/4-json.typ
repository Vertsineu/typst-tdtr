#import "@preview/tdtr:0.4.4": *

#set page(height: auto, width: auto, margin: 1em)
#show: scale.with(125%, reflow: true)

#tidy-tree-graph(json("trees/test.json"))
