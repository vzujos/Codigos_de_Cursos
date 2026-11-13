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


+ Dado el siguiente dominio en 2D formado por 36 celdas cuadradas de igual dimensión que alberga un sistema bi-fásico (fluido de referencia y fluido original). En cada celda se indica la fracción de la fase de referencia $C_(i j)$. (1 = 100% fase de referencia y 0.0 = 100% fase original). La densidad de la fase original es igual a $rho_0 = 1.0$ y la densidad de la fase de referencia $rho_R = 2.0$. La viscosidad de la fase original es de $mu_0 = 0.01$ y la viscosidad de la fase de referencia es $mu_R = 0.02$. La tensión superficial entre ambas fases es $sigma = 10$.

  #figure(
    image("assets/canvas.png", width:50%),
  )

  #colbreak()
  + Sobre el dominio 2D, y en las celdas que corresponda, grafique el segmento rectilíneo según el método PLIC. Entregue la ecuación (pendiente $m_x$, $m_y$ e intercepto $alpha$) para cada segmento  ectilíneo con respecto del origen indicado (extremo inferior izquierdo). (20 pts)

    #figure(
      image("assets/canvas2.png", width:50%),
    )

  + A partir del mismo dominio 2D y las velocidades especificadas en el lado Oeste y Sur. Calcule el campo de velocidad $u$ y $v$ (malla escalonada) y la presión $P$ (malla colocada). Utilice el método de la corrección de la velocidad con la presión (proyección de presión de Chorin), considerando un promedio aritmético de la densidad y un promedio harmónico para la viscosidad en las celdas mixtas. Realice este cálculo para un solo paso de $Delta t = 0.01$ (20 pts)

    #figure(
      image("assets/canvas3.png", width:50%),
    )

  + A partir del resultado en b) proceda con la advección del frente (PLIC) que separa la fase original de la fase de referencia. Para lo cual, calcule las nuevas fracciones de volumen $C_(i j)$ en las celdas (considere que solo puede haber transferencia de masa desde una celda completamente llena con una de las 2 fases hacia las celdas vecinas que son mixtas). Con estos valores vuelva a calcular los segmentos rectilíneos en cada celda mixta y grafíquelos para ilustrar la advección del frente entre las 2 fases. (20 pts)

    #figure(
      image("assets/canvas4.png", width:50%),
    )

    $
      C_(i j)^(t+1) = C_(i j)^(t) - Delta t ( u_(i j) (C_(i+1, j)^(t) - C_(i-1, j)^(t)) / (2 Delta x) + v_(i j) (C_(i, j+1)^(t) - C_(i, j-1)^(t)) / (2 Delta y))
    $

  + A partir del resultado en a). Considere los puntos medios de cada segmento rectilíneo y genere un arreglo con las coordenadas $x$ e $y$ de cada punto. Luego interpole entre todos estos puntos un polinomio de Legendre de orden 3 (ver transparencias). Grafique esta función sobre el dominio 2D. (15 pts)

    #figure(
      image("assets/canvas5.png", width:50%),
    )

    #figure(
      image("assets/canvas6.png", width:50%),
    )

  + Agregue 2 puntos entre cada punto medio, ampliando el arreglo con las nuevas coordenadas $x$ e $y$. Advecte cada punto del arreglo según el campo de velocidad obtenido en b) integrando según el paso de tiempo $Delta t$. Genere el nuevo arreglo de puntos $x$ e $y$ graficándolos sobre el domino 2D. (15 pts)

    #figure(
      image("assets/canvas7.png", width:50%),
    )

    #figure(
      image("assets/canvas8.png", width:50%),
    )

  + Sobre este arreglo de puntos efectúe un balance de fuerzas por unidad de área entre la presión y la tensión superficial a lo largo de los ejes x e y en cada celda mixta de manera de encontrar las nuevas coordenadas de los puntos anteriormente añadidos. Grafíquelos una vez más. (10 pts)

    #figure(
      image("assets/canvas9.png", width:25%),
    )

    Hint: puede encontrar la tangente al polinomio de Legendre simplemente derivándolo con respecto del parámetro u y evaluándolo en el punto de interés.
#pagebreak()

#bibliography("bibliography.yml", style:"ieee")

#v(2em)
#set heading(numbering: none)
= Anexo<anexo>
