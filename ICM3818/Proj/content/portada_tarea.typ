#import "../config/variables.typ": *

#show title: set text(size: 1.2em, weight: "semibold")

#place(
  top + center,
  float: true,
  scope: "parent",
  )[
  #v(8em)
  #title()
  *#tema*\
  #author\
  #date
  #line(length: 100%)
  ]
