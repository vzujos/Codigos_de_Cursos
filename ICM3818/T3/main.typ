  // Initial template config
#import "config/template.typ" as template
#show: doc => template.config(doc, darkmode: false)

// Useful packages for maths, presentations and diagrams
#import "@preview/subpar:0.2.2"
#import "@preview/lilaq:0.6.0" as lq
#import "@preview/physica:0.9.8": grad, div, curl, laplacian, vb, vu, dv, pdv


#show ref: it => {
  let eq = math.equation
  let el = it.element
  // Skip all other references.
  if el == none or el.func() != eq { return it }
  // Override equation references.
  link(el.location(), numbering(
    el.numbering,
    ..counter(eq).at(el.location())
  ))
}
  
#show: body => context {
  let labels = query(math.equation.where(block: true))
    .filter(eq => eq.has("label"))
    .map(eq => eq.label)
    .dedup()
  if labels.len() == 0 {
    return body
  }
  show selector.or(..labels): set math.equation(numbering: "(1)")
  body
}


#include "content/portada_tarea.typ"

#pagebreak()

#bibliography("bibliography.yml", style:"ieee")

#v(2em)
#set heading(numbering: none)
= Anexo<anexo>
