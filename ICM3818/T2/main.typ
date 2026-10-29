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

A partir del código en Matlab visto en clases (Clase 11 Bloque I), para la Caja de Flujo Forzada en 2D, que resulta del rotor de la ecuación de Navier-Stokes y el uso de la función de corriente (solución implementada de manera #underline[implícita en el tiempo]). Considere una caja de 50 mm de largo y 20 mm de alto llena con un metal líquido justo a la temperatura de derretimiento ($T_m$) (si es necesario el espesor puede considerarse igual a 1 mm). Considere la densidad, conductividad térmica, capacidad calórica, viscosidad cinemática y tensión superficial del acero líquido a $T_m$ (realice una búsqueda bibliográfica de las propiedades faltantes). El dominio debe considerar 32x32 nodos reales más los nodos fantasmas y las condiciones de borde en las 4 paredes para resolver el problema de convección en la pileta de metal fundido, como se indica esquemáticamente en la @fig:1. Considere que una fuente de calor puntual se aplica justo en la mitad superior del dominio (simulando por ejemplo un arco-eléctrico). El gradiente térmico sobre la superficie libre, hacia la izquierda y derecha, producto de esta fuente de calor, evoluciona con el tiempo y permite calcular el gradiente de tensión superficial, el cual puede ser convertido en un gradiente de velocidad (variación de la cantidad de movimiento) que varía en el tiempo y actúa justo sobre la superficie libre, tomando como dato la variación de la tensión superficial con la temperatura: $pdv(sigma_s,T_s)$.

  #figure(
    image("assets/imagen_1.png", width:110%),
    caption: [Bordes con velocidad $vb(v)$ nula y vorticidad constante $omega_0$]
  )<fig:1>

    De la implementación numérica del problema se pide graficar en función del tiempo (50, 100, 150 y 200 iteraciones). Para cada material obtenga:
    
    + Campo de temperatura en el líquido $T(x,y)$ y campo vectorial de velocidades $(u, v)$, ambos superpuestos en el mismo gráfico (25 pts)
    
    + La función línea de corriente $psi(x,y)$ (10 pts)
    
    + La vorticidad $omega$ (15 pts)
    

#line(length:100%)
#v(2em)
*Respuesta*

Las propiedades de cada material a la temperatura de derretimiento $T_m$ (para la fase líqida) se incluyen en la @tab:props, donde se reemplazaron las propiedades entregadas de densidad, conductividad térmica y temperatura de derretimiento para mantener la consistencia con el resto de propiedades según las fuentes consultadas,

Las propiedades del acero se obtuvieron de @ou2018. as propiedades del Aluminio 2024-T6 corresponden a las de aluminio puro @leitner2017, y para el latón se utilizaron las propiedades del Latón C27200 a falta de datos @glucknardi2023, @gress2021.

#figure(
  table(
    columns: (auto, auto, auto, auto),
    inset: 6pt,
    align: horizon,
    table.header(
      [*Propiedad (\@$T_m$)*],
      [*Acero 1040*],
      [*Aluminio 2024-T6*],
      [*Latón C26000*],
    ),
    [Densidad de masa $rho$ \[kg/m³\]], [7290], [2391], [7800],
    [Conductividad térmica $k$ [W/(m·K)]], [34], [89.3], [68],
    [Temperatura de derretimiento $T_m$ [°C]], [1472], [660.32], [925],

    [Calor específico $C_p$ \[J/(kg·K)\]], [700.4], [1127], [480],
    [Viscosidad dinámica $mu$ \[Pa·s\]], [$6.4dot 10^(-3)$], [$1.3dot 10^(-3)$], [$approx 3.8 dot 10^(-3)$],
    [$partial sigma_s \/ partial T_s$ \[N/(m·K)\]], [$-4dot 10^(-4)$], [$-1.3dot 10^(-4)$], [$approx -3dot 10^(-4) *$],
    
  ),
  caption: [Propiedades buscadas de metales a la temperatura de derretimiento $T_m$ en fase líquida. ($"Nota"^*$: $partial sigma_s"/"partial T_s$ para el Latón corresponde al valor del cobre puro).],
)<tab:props>


*Ecuaciones gobernantes*

El flujo incompresible en 2D se describe con la función de corriente $psi$ y vorticidad $omega_z$, como:

$
v_x = 1/rho pdv(psi, y), quad v_y = -1/rho pdv(psi, x) \
 quad omega_z = pdv(v_y,x) - pdv(v_x,y) = - 1/rho nabla^2 psi
$<eq:def_psiomega>

#pagebreak()

El transporte de vorticidad, que proviene del rotor de la ecuación de Navier-Stokes, queda como:
$
  pdv(vb(omega), t) + (vb(v) dot grad) vb(omega) = mu/rho laplacian vb(omega) \
  pdv(omega_z, t) + v_x pdv(omega_z,x) + v_y pdv(omega_z,y) = mu/rho nabla^2 omega_z
$

$
rho pdv(omega_z, t) + pdv(psi, y) pdv(omega_z,x) - pdv(psi, x) pdv(omega_z,y) = mu nabla^2 omega_z
$<eq:vorticity>

La ecuación de calor, que viene del balance de energía considerando una fuente, queda como:

$
rho C_p ( pdv(T, t) + (vb(v)dot grad) T ) = k laplacian T + dot(q)_c + mu  underbrace(2 dot(epsilon)_(x y)(pdv(v_x,y) + pdv(v_y,x)), approx 0) \

rho C_p lr((pdv(T,t) + v_x pdv(T,x) + v_y pdv(T,y))) = k nabla^2 T + dot(q)_c
$


$
rho C_p lr((pdv(T,t) + 1/rho pdv(psi, y) pdv(T,x) - 1/rho pdv(psi, x) pdv(T,y))) = k nabla^2 T + dot(q)_c
$<eq:calor>

*Condiciones de borde*

En las paredes sólidas (borde inferior y laterales), hay velocidad nula, vorticidad constante y flujo de calor nulo:
$
v_x = lr(pdv(psi,y) mid(|))_(x=0,x=L_x, y=0) = v_y = lr(-pdv(psi,x) mid(|))_(x=0,x=L_x,y=0) = 0 \
w_z |_(x=0) = - (2 psi |_(x=0^+)) / (Delta x^2), quad w_z |_(x=L_x) = - (2 psi |_(x=L_x^-)) / (Delta x^2), quad w_z |_(y=0) = - (2 psi |_(y=0^+)) / (Delta y^2)  \
lr(pdv(T,x)|)_(x=0,x=L_x) = lr(pdv(T,y)|)_(y=0) = 0
$<eq:bc1>

En la superficie libre (borde superior), hay un esfuerzo de corte tangencial igual al gradiente de tensión superficial, que depende de la temperatura, y no hay velocidad vertical ni flujo de calor:

$
  w_z |_(y=L_y) = - lr(pdv(v_x,y) |)_(y=L_y) = - lr(1/mu pdv(sigma_s, T_s) pdv(T,x) |)_(y=L_y)
$<eq:bc2>
$
v_y|_(y=L_y)=lr(-pdv(psi,x) mid(|))_(y=L_y) = 0, quad lr(pdv(T,y)|)_(y=L_y) = 0
$


#pagebreak()
*Discretización numérica*

Se usan $N_x = N_y = 32$ nodos reales más los nodos fantasmas en la frontera. El paso de tiempo es $Delta t = 0.005$ s y se realizan 200 iteraciones para la fuente de calor $dot(q)=200 "W"$. Tanto para la discretización de @eq:def_psiomega, @eq:vorticity como para @eq:calor  se emplea un esquema implícito centrado en espacio.

Función de corriente @eq:def_psiomega:

$
w_(i, j)^t = - ( psi_(i+1,j)^(t) - 2 psi_(i,j)^(t) + psi_(i-1,j)^(t) ) / (rho Delta x^2) - ( psi_(i,j+1)^(t) - 2 psi_(i,j)^(t) + psi_(i,j-1)^(t)) / (rho Delta y^2)
$

Vorticidad @eq:vorticity:

$
rho (omega_(i,j)^(t+1) - omega_(i,j)^t) / (Delta t) + (psi_(i,j+1)^(t+1) - psi_(i,j-1)^(t+1))/(2 Delta y) (omega_(i+1,j)^(t+1) - omega_(i-1,j)^(t+1))/(2 Delta x) - (psi_(i+1,j)^(t+1) - psi_(i-1,j)^(t+1))/(2 Delta x) (omega_(i,j+1)^(t+1) - omega_(i,j-1)^(t+1))/(2 Delta y) = \ mu/(Delta x^2) ( omega_(i+1,j)^(t+1) - 2omega_(i,j)^(t+1) + omega_(i-1,j)^(t+1)) + mu/(Delta y^2) ( omega_(i,j+1)^(t+1) - 2omega_(i,j)^(t+1) + omega_(i,j-1)^(t+1)) \
$

Temperatura @eq:calor:

$
rho C_p ((T_(i,j)^(t+1)-T_(i,j)^t)/(Delta t) +  (psi_(i,j+1)^(t+1) - psi_(i,j-1)^(t+1))/(rho 2 Delta y)(T_(i+1,j)^(t+1) - T_(i-1,j)^(t+1))/(2 Delta x) - (psi_(i+1,j)^(t+1) - psi_(i-1,j)^(t+1))/(rho 2 Delta x) (T_(i,j+1)^(t+1) - T_(i,j-1)^(t+1))/(2 Delta y)) = \ k/(Delta x^2) ( T_(i+1,j)^(t+1) - 2T_(i,j)^(t+1) + T_(i-1,j)^(t+1)) + k/(Delta y^2) ( T_(i,j+1)^(t+1) - 2T_(i,j)^(t+1) + T_(i,j-1)^(t+1)) + dot(q)_(i,j)
$




== Resultados

Los campos de temperatura $T(x,y)$ con el campo de velocidades $(v_x,v_y)$, la función de corriente $psi(x,y)$ y la vorticidad $omega_z (x,y)$ se obtienen para los tres materiales en las iteraciones {50, 100, 150 y 200}

Los mapas de temperatura acoplados al campo vectorial (Figuras 2, 3 y 4) muestran la correcta formación de corrientes superficiales divergentes. Como se esperaba, el fluido se desplaza desde el centro caliente (donde actúa el arco eléctrico) hacia las paredes frías, impulsado por un gradiente térmico lateral $partial T"/"partial x$. Esto sucede porque los tres metales poseen un coeficiente de tensión superficial térmico negativo ($partial sigma_s"/"partial T_s < 0$), lo que induce una tracción hacia las zonas de mayor tensión superficial (menor temperatura)

Los contornos de la función de corriente $psi$ (Figuras 5, 6 y 7) evidencian la consolidación de dos macro-celdas de recirculación (vórtices convectivos) simétricas pero con giro opuesto, que abarcan todo el dominio. El acero presenta gradientes espaciales de $psi$ más densos debido a que desarrolla las mayores velocidades macroscópicas.

#pagebreak()
*1. Campos de temperatura y velocidad*

#subpar.grid(
  columns: 1,
  rows: 4,
  [#image(
      "assets/fotos/T_vel_m1_t50.png",
      width: 73%,)
  ],[#image(
      "assets/fotos/T_vel_m1_t100.png",
      width: 73%,)
  ],[#image(
      "assets/fotos/T_vel_m1_t150.png",
      width: 73%,)
  ],[#image(
      "assets/fotos/T_vel_m1_t200.png",
      width: 73%,)
  ],
  caption: [Temperatura $T$ y velocidad $vb(v)$ para el Acero 1040 en las iteraciones [50, 100, 150 y 200].],
)<fig:Tm1>

#subpar.grid(
  columns: 1,
  rows: 4,
  [#image(
      "assets/fotos/T_vel_m2_t50.png",
      width: 73%,)
  ],[#image(
      "assets/fotos/T_vel_m2_t100.png",
      width: 73%,)
  ],[#image(
      "assets/fotos/T_vel_m2_t150.png",
      width: 73%,)
  ],[#image(
      "assets/fotos/T_vel_m2_t200.png",
      width: 73%,)
  ],
  caption: [Temperatura $T$ y velocidad $vb(v)$ para el Aluminio 2024 en las iteraciones [50, 100, 150 y 200].],
)<fig:Tm2>

#subpar.grid(
  columns: 1,
  rows: 4,
  [#image(
      "assets/fotos/T_vel_m3_t50.png",
      width: 73%,)
  ],[#image(
      "assets/fotos/T_vel_m3_t100.png",
      width: 73%,)
  ],[#image(
      "assets/fotos/T_vel_m3_t150.png",
      width: 73%,)
  ],[#image(
      "assets/fotos/T_vel_m3_t200.png",
      width: 73%,)
  ],
  caption: [Temperatura $T$ y velocidad $vb(v)$ para el Latón C26000 en las iteraciones [50, 100, 150 y 200].],
)<fig:Tm3>

#pagebreak()
*2. Función de corriente*


#subpar.grid(
  columns: 1,
  rows: 4,
  [#image(
      "assets/fotos/psi_m1_t50.png",
      width: 73%,)
  ],[#image(
      "assets/fotos/psi_m1_t100.png",
      width: 73%,)
  ],[#image(
      "assets/fotos/psi_m1_t150.png",
      width: 73%,)
  ],[#image(
      "assets/fotos/psi_m1_t200.png",
      width: 73%,)
  ],
  caption: [Función de corriente $psi$ para el Acero 1040 en las iteraciones [50, 100, 150 y 200].],
)<fig:psi1>


#subpar.grid(
  columns: 1,
  rows: 4,
  [#image(
      "assets/fotos/psi_m2_t50.png",
      width: 73%,)
  ],[#image(
      "assets/fotos/psi_m2_t100.png",
      width: 73%,)
  ],[#image(
      "assets/fotos/psi_m2_t150.png",
      width: 73%,)
  ],[#image(
      "assets/fotos/psi_m2_t200.png",
      width: 73%,)
  ],
  caption: [Función de corriente $psi$ para el Aluminio 2024-T6 en las iteraciones [50, 100, 150 y 200].],
)<fig:psi2>

#subpar.grid(
  columns: 1,
  rows: 4,
  [#image(
      "assets/fotos/psi_m3_t50.png",
      width: 73%,)
  ],[#image(
      "assets/fotos/psi_m3_t100.png",
      width: 73%,)
  ],[#image(
      "assets/fotos/psi_m3_t150.png",
      width: 73%,)
  ],[#image(
      "assets/fotos/psi_m3_t200.png",
      width: 73%,)
  ],
  caption: [Función de corriente $psi$ para el Latón C26000 en las iteraciones [50, 100, 150 y 200].],
)<fig:psi3>

#pagebreak()
*3. Vorticidad*

#subpar.grid(
  columns: 1,
  rows: 4,
  [#image(
      "assets/fotos/omega_m1_t50.png",
      width: 73%,)
  ],[#image(
      "assets/fotos/omega_m1_t100.png",
      width: 73%,)
  ],[#image(
      "assets/fotos/omega_m1_t150.png",
      width: 73%,)
  ],[#image(
      "assets/fotos/omega_m1_t200.png",
      width: 73%,)
  ],
  caption: [Vorticidad $omega_z$ para el Acero 1040 en las iteraciones [50, 100, 150 y 200].],
)<fig:w1>

#subpar.grid(
  columns: 1,
  rows: 4,
  [#image(
      "assets/fotos/omega_m2_t50.png",
      width: 73%,)
  ],[#image(
      "assets/fotos/omega_m2_t100.png",
      width: 73%,)
  ],[#image(
      "assets/fotos/omega_m2_t150.png",
      width: 73%,)
  ],[#image(
      "assets/fotos/omega_m2_t200.png",
      width: 73%,)
  ],
  caption: [Vorticidad $omega_z$ para el Aluminio 2024-T6 en las iteraciones [50, 100, 150 y 200].],
)<fig:w2>

#subpar.grid(
  columns: 1,
  rows: 4,
  [#image(
      "assets/fotos/omega_m3_t50.png",
      width: 73%,)
  ],[#image(
      "assets/fotos/omega_m3_t100.png",
      width: 73%,)
  ],[#image(
      "assets/fotos/omega_m3_t150.png",
      width: 73%,)
  ],[#image(
      "assets/fotos/omega_m3_t200.png",
      width: 73%,)
  ],
  caption: [Vorticidad $omega_z$ para el Latón C26000 en las iteraciones [50, 100, 150 y 200].],
)<fig:w3>
  
#pagebreak()

#bibliography("bibliography.yml", style:"ieee")

#v(2em)
#set heading(numbering: none)
= Anexo<anexo>

== Utilización de herramientas de IA

Se debe declarar el uso indicando la versión de la herramienta, y el link al chat. Alternativamente si su uso es acotado, declarar el prompt y la respuesta.

#pagebreak()

== Código Matlab entregado (Clase 11 Bloque 1)

#show raw: set text(size: 8pt)
#raw(read("parte-b/clase.m"), lang: "Matlab")

#pagebreak()

== Código MATLAB

El código completo de la simulación se divide en un archivo  `main.m` que resuelve las ecuaciones discretizadas sobre el dominio, y el archivo `guardar-fotos.m` que genera y guarda los gráficos.

#raw(read("parte-b/main.m"), lang: "Matlab")
