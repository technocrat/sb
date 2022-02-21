# dag.R
# demonstration of directed a cyclic graphs, a tool for 
# causal inference by identifying variables that may
# require controlling for
# Version 1.0 Ready
# for later in the process
# author: Richard Careaga
# Date: 2022-02-21
require(bnlearn)
# https://rpubs.com/osazuwa/causaldag1
dag <- empty.graph(nodes = c("A","S","E","O","R","T"))
arc.set <- matrix(c("A", "E",
                    "S", "E",
                    "E", "O",
                    "E", "R",
                    "O", "T",
                    "R", "T"),
                  byrow = TRUE, ncol = 2,
                  dimnames = list(NULL, c("from", "to")))
arcs(dag) <- arc.set
nodes(dag)
arcs(dag)
plot(dag)
graphviz.plot(dag)
toy <- data.frame(
  A = c("adult", "adult", "adult", "adult", "adult","adult"), 
  R = c("big", "small", "big", "big", "big", "small"),
  E = c("high", "uni", "uni", "high", "high", "high"), 
  O = c("emp","emp", "emp", "emp", "emp", "emp"), 
  S = c("F", "M", "F","M", "M", "F"
  ), T = c("car", "car", "train", "car", "car", "train"))

