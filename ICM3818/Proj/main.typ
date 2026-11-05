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

Se considera el flujo de aire a través de un bronquiolo que presenta un alvéolo pulmonar en su pared lateral, de geometría aproximadamente circular. El dominio de simulación corresponde a un canal bidimensional de sección rectangular, con una cavidad circular conectada a una de sus paredes laterales, como se indica en la @fig:1. Se considera que el aire circula a través del bronquiolo, ingresando por uno de sus extremos con velocidad uniforme prescrita y saliendo por el extremo opuesto a una presión de referencia. Las paredes del bronquiolo, el tejido que rodea al alvéolo y el resto del dominio exterior se consideran sólidos rígidos.
Se busca estudiar el comportamiento del flujo de aire en el alveolo, considerando los posibles cambios en la distribución de velocidades, presión y vorticidad, así como la formación de zonas de recirculación en el interior del alvéolo.

#figure(
  image("assets/im1.jpeg", width: 70%),
  caption: "Esquema del bronquiolo con 0cavidad alveolar lateral.",
)<fig:1>



Se considera el aire como un fluido newtoniano incompresible y se usan las ecuaciones de Navier-Stokes para describir el comportamiento del flujo.El dominio se discretiza con una malla cartesiana bidimensional, usando el método de diferencias finitas. Para las celdas del dominio sólido, se consideran condiciones de velocidad y presión nulas, evitando que participen en la resolución del campo de velocidades del fluido. 

Calcular: Campo de presión en el dominio fluido $p(x,y)$, campo vectorial de velocidades $(u, v)$ superpuesto al campo de presión, líneas de corriente del flujo de aire $psi(x,y)$, campo de vorticidad $omega(x,y)$

#pagebreak()

El profe recomendó usar el método de chorin para Navier-Stokes. Partir con un sólido rígido, y luego cuando funcione, tratar de hacerlo elástico, y viscoelástico.
/*
#pagebreak()

#bibliography("bibliography.yml", style:"ieee")

#v(2em)
#set heading(numbering: none)
= Anexo<anexo>
*/