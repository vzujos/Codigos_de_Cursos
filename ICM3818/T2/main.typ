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
    
    #v(2em)

*Respuesta*

Las propiedades de cada material a la temperatura de derretimiento $T_m$ se incluyen en la @tab:props y @tab:props_2, donde se conservaron las propiedades entregadas de densidad, conductividad térmica y temperatura de derretimiento, y se agrega el resto *FALTA CITAR*. 

Las propiedades adicionales se obtienen de @Brandes1992Smithells e @Iida1988Physical y se resumen en la siguiente tabla:


#figure(
  table(
    columns: (auto, auto, auto, auto),
    inset: 6pt,
    align: horizon,
    table.header(
      [Propiedad (\@$T_m$)],
      [Acero 1040],
      [Aluminio 2024-T6],
      [Latón C26000],
    ),
    [Densidad de masa $rho$ \[kg/m³\]], [7850], [2780], [8530],
    [Conductividad térmica $k$ [W/mK]], [50.7], [151], [120],
    [Temperatura de derretimiento [°C]], [1521], [638], [965],

    
  ),
  caption: [Propiedades entregadas de metales a la temperatura de derretimiento $T_m$.],
)<tab:props>


#figure(
  table(
    columns: (auto, auto, auto, auto),
    inset: 6pt,
    align: horizon,
    table.header(
      [Propiedad (\@$T_m$)],
      [Acero 1040],
      [Aluminio 2024-T6],
      [Latón C26000],
    ),
    [Calor específico $C_p$ \[J/kgK\]], [], [], [],
    [Viscosidad dinámica $mu$ \[mPa·s\]], [], [], [],
    [Viscosidad cinemática $nu$ \[m²/s\]], [$8.60 times 10^(-7)$], [$5.00 times 10^(-7)$], [$4.43 times 10^(-7)$],
    [$partial sigma_s \/ partial T_s$ \[N(m·K)\]], [$-4.0 times 10^(-4)$], [$-1.5 times 10^(-4)$], [$-1.3 times 10^(-4)$],
    
  ),
  caption: [Propiedades buscadas de metales a la temperatura de derretimiento $T_m$ .],
)<tab:props_2>


#pagebreak()
= Formulación matemática

== Ecuaciones gobernantes

El flujo incompresible en 2D se describe con la función de corriente $psi$ y vorticidad $omega_z$, como:

$
v_x = 1/rho pdv(psi, y), quad v_y = -1/rho pdv(psi, x) \
 quad omega_z = pdv(v_y,x) - pdv(v_x,y) = - 1/rho nabla^2 psi
$<eq:def_psiomega>

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
rho C_p ( pdv(T, t) + (vb(v)dot grad) T ) = k laplacian T + dot(q)_c
$


$
rho C_p lr((pdv(T,t) + v_x pdv(T,x) + v_y pdv(T,y))) = k nabla^2 T + dot(q)_c
$<eq:calor>

== Condiciones de borde

En las paredes sólidas (borde inferior y laterales), hay velocidad nula, flujo de calor nulo (aislantes), y vorticidad constante:
$
v_x = lr(pdv(psi,y) mid(|))_(x=0,x=L_x, y=0) = v_y = lr(-pdv(psi,x) mid(|))_(x=0,x=L_x,y=0) = 0 \
lr(pdv(psi,y,2) mid(|))_(x=0,x=L_x, y=0) = lr(pdv(psi,x,2) mid(|))_(x=0,x=L_x,y=0) = 0 \
lr(pdv(T,x)|)_(x=0,x=L_x) = lr(pdv(T,y)|)_(y=0) = 0
$

En la superficie libre (borde superior), hay un esfuerzo de corte tangencial igual al gradiente de tensión superficial, que depende de la temperatura:
$
lr( pdv(v_x,y) |)_(y = L_y) = lr( pdv(psi,y,2) |)_(y = L_y) = lr( 1/mu pdv(sigma_s, T_s) pdv(T,x) |)_(y = L_y)
$<eq:bc2>

Y no hay velocidad vertical: $v_y=0$. Con eso, se tiene que
$
  w_z |_(y=L_y) = - lr(pdv(v_x,y) |)_(y=L_y) = - lr(1/mu pdv(sigma_s, T_s) pdv(T,x) |)_(y=L_y)
$<eq:bc_vorticity_top>
===


Para las tres paredes sólidas restantes (con $v_x = v_y = 0$), la condición de vorticidad de Thom es:

$
omega|_"pared" = - 2 psi_"interior" / h^2
$<eq:bc_vorticity_wall>

En las cuatro paredes se impone aislación térmica ($partial T \/ partial n = 0$), implementada con nodos fantasmas: $T_0 = T_1$.

La fuente de calor puntual $dot(q)=200 "W"$  se aplica en el centro horizontal de la superficie libre (esquemáticamente, como indica la @fig:1).


== Discretización numérica
(esta parte creo que esta lista)

Se emplean $N_x = N_y = 32$ nodos reales más los nodos fantasmas en la frontera. El paso de tiempo es $Delta t = 0.005$ s y se realizan 200 iteraciones. Tanto para la discretización de @eq:def_psiomega, @eq:vorticity como para @eq:calor  se emplea un esquema implícito centrado en espacio.

*Temperatura*:

$
rho C_p ((T_(i,j)^(t+1)-T_(i,j)^t)/(Delta t) +  u_(i, j)^(t+1)(T_(i+1,j)^(t+1) - T_(i-1,j)^(t+1))/(2 Delta x) + v_(i, j)^(t+1) (T_(i,j+1)^(t+1) - T_(i,j-1)^(t+1))/(2 Delta y)) = \ k/(Delta x^2) ( T_(i+1,j)^(t+1) - 2T_(i,j)^(t+1) + T_(i-1,j)^(t+1)) + k/(Delta y^2) ( T_(i,j+1)^(t+1) - 2T_(i,j)^(t+1) + T_(i,j-1)^(t+1)) + dot(q)_(i,j)
$

*Vorticidad*:

$
rho (omega_(i,j)^(t+1) - omega_(i,j)^t) / (Delta t) + (psi_(i,j+1)^(t+1) - psi_(i,j-1)^(t+1))/(2 Delta y) (omega_(i+1,j)^(t+1) - omega_(i-1,j)^(t+1))/(2 Delta x) - (psi_(i+1,j)^(t+1) - psi_(i-1,j)^(t+1))/(2 Delta x) (omega_(i,j+1)^(t+1) - omega_(i,j-1)^(t+1))/(2 Delta y) = \ mu/(Delta x^2) ( omega_(i+1,j)^(t+1) - 2omega_(i,j)^(t+1) + omega_(i-1,j)^(t+1)) + mu/(Delta y^2) ( omega_(i,j+1)^(t+1) - 2omega_(i,j)^(t+1) + omega_(i,j-1)^(t+1)) \
$

*Función de corriente*:

$
w_(i, j)^t = - ( psi_(i+1,j)^(t) - 2 psi_(i,j)^(t) + psi_(i-1,j)^(t) ) / (rho Delta x^2) - ( psi_(i,j+1)^(t) - 2 psi_(i,j)^(t) + psi_(i,j-1)^(t)) / (rho Delta y^2)
$

== Resultados

Los campos de temperatura $T(x,y)$ con el campo de velocidades $(v_x,v_y)$, la función de corriente $psi(x,y)$ y la vorticidad $omega_z(x,y)$ se obtienen para los tres materiales en los pasos de tiempo 50, 100, 150 y 200, ejecutando el código MATLAB de la Parte b) (`parte-b/main.m`) seguido de `parte-b/guardar-fotos.m`.

Los gráficos se incluirán una vez generados los archivos de imagen. A modo de referencia, se describen los fenómenos esperados:

- El gradiente térmico generado por la fuente puntual central induce, a través del efecto Marangoni (@eq:bc2), un flujo superficial _desde_ el centro _hacia_ los bordes (dado que $partial sigma_s \/ partial T_s < 0$ para los tres materiales: zona caliente → menor $sigma_s$ → flujo hacia zona fría).
- La vorticidad $omega$ alcanza sus valores máximos en la superficie libre, donde actúa el esfuerzo de Marangoni, y se difunde hacia el interior según la @eq:vorticity.
- La función de corriente $psi$ muestra dos celdas convectivas simétricas respecto al eje central $x = L_x\/2$, con sentidos de giro opuestos.
- El acero 1040, con mayor viscosidad ($nu approx 8.6 times 10^(-7)$ m²/s) y mayor $|partial sigma_s\/partial T_s|$, presenta convección más intensa que el aluminio y el latón.

*1. Campos de temperatura y velocidad*

#subpar.grid(
  columns: 2,
  rows: 2,
  [#image(
      "assets/fotos/T_vel_m1_t50.png",
      width: 100%,)
  ],[#image(
      "assets/fotos/T_vel_m1_t100.png",
      width: 100%,)
  ],[#image(
      "assets/fotos/T_vel_m1_t150.png",
      width: 100%,)
  ],[#image(
      "assets/fotos/T_vel_m1_t200.png",
      width: 100%,)
  ],
  caption: [Temperatura $T$ y velocidad $vb(v)$ para el Acero 1040 en las iteraciones [50, 100, 150 y 200].],
)

#subpar.grid(
  columns: 2,
  rows: 2,
  [#image(
      "assets/fotos/T_vel_m2_t50.png",
      width: 100%,)
  ],[#image(
      "assets/fotos/T_vel_m2_t100.png",
      width: 100%,)
  ],[#image(
      "assets/fotos/T_vel_m2_t150.png",
      width: 100%,)
  ],[#image(
      "assets/fotos/T_vel_m2_t200.png",
      width: 100%,)
  ],
  caption: [Temperatura $T$ y velocidad $vb(v)$ para el Aluminio 2024-T6 en las iteraciones [50, 100, 150 y 200].],
)

#subpar.grid(
  columns: 2,
  rows: 2,
  [#image(
      "assets/fotos/T_vel_m3_t50.png",
      width: 100%,)
  ],[#image(
      "assets/fotos/T_vel_m3_t100.png",
      width: 100%,)
  ],[#image(
      "assets/fotos/T_vel_m3_t150.png",
      width: 100%,)
  ],[#image(
      "assets/fotos/T_vel_m3_t200.png",
      width: 100%,)
  ],
  caption: [Temperatura $T$ y velocidad $vb(v)$ para el Latón C26000 en las iteraciones [50, 100, 150 y 200].],
)

*2. Función de corriente*


#subpar.grid(
  columns: 2,
  rows: 2,
  [#image(
      "assets/fotos/psi_m1_t50.png",
      width: 100%,)
  ],[#image(
      "assets/fotos/psi_m1_t100.png",
      width: 100%,)
  ],[#image(
      "assets/fotos/psi_m1_t150.png",
      width: 100%,)
  ],[#image(
      "assets/fotos/psi_m1_t200.png",
      width: 100%,)
  ],
  caption: [Función de corriente $psi$ para el Acero 1040 en las iteraciones [50, 100, 150 y 200].],
)


#subpar.grid(
  columns: 2,
  rows: 2,
  [#image(
      "assets/fotos/psi_m2_t50.png",
      width: 100%,)
  ],[#image(
      "assets/fotos/psi_m2_t100.png",
      width: 100%,)
  ],[#image(
      "assets/fotos/psi_m2_t150.png",
      width: 100%,)
  ],[#image(
      "assets/fotos/psi_m2_t200.png",
      width: 100%,)
  ],
  caption: [Función de corriente $psi$ para el Aluminio 2024-T6 en las iteraciones [50, 100, 150 y 200].],
)

#subpar.grid(
  columns: 2,
  rows: 2,
  [#image(
      "assets/fotos/psi_m3_t50.png",
      width: 100%,)
  ],[#image(
      "assets/fotos/psi_m3_t100.png",
      width: 100%,)
  ],[#image(
      "assets/fotos/psi_m3_t150.png",
      width: 100%,)
  ],[#image(
      "assets/fotos/psi_m3_t200.png",
      width: 100%,)
  ],
  caption: [Función de corriente $psi$ para el Latón C26000 en las iteraciones [50, 100, 150 y 200].],
)

*3. Vorticidad*

#subpar.grid(
  columns: 2,
  rows: 2,
  [#image(
      "assets/fotos/omega_m1_t50.png",
      width: 100%,)
  ],[#image(
      "assets/fotos/omega_m1_t100.png",
      width: 100%,)
  ],[#image(
      "assets/fotos/omega_m1_t150.png",
      width: 100%,)
  ],[#image(
      "assets/fotos/omega_m1_t200.png",
      width: 100%,)
  ],
  caption: [Vorticidad $omega_z$ para el Acero 1040 en las iteraciones [50, 100, 150 y 200].],
)

#subpar.grid(
  columns: 2,
  rows: 2,
  [#image(
      "assets/fotos/omega_m2_t50.png",
      width: 100%,)
  ],[#image(
      "assets/fotos/omega_m2_t100.png",
      width: 100%,)
  ],[#image(
      "assets/fotos/omega_m2_t150.png",
      width: 100%,)
  ],[#image(
      "assets/fotos/omega_m2_t200.png",
      width: 100%,)
  ],
  caption: [Vorticidad $omega_z$ para el Aluminio 2024-T6 en las iteraciones [50, 100, 150 y 200].],
)

#subpar.grid(
  columns: 2,
  rows: 2,
  [#image(
      "assets/fotos/omega_m3_t50.png",
      width: 100%,)
  ],[#image(
      "assets/fotos/omega_m3_t100.png",
      width: 100%,)
  ],[#image(
      "assets/fotos/omega_m3_t150.png",
      width: 100%,)
  ],[#image(
      "assets/fotos/omega_m3_t200.png",
      width: 100%,)
  ],
  caption: [Vorticidad $omega_z$ para el Latón C26000 en las iteraciones [50, 100, 150 y 200].],
)


== Código MATLAB

El código completo de la simulación se encuentra en `parte-b/main.m` y el código de generación de gráficos en `parte-b/guardar-fotos.m`.

#show raw: set text(size: 7.5pt)

=== `parte-b/main.m`

```Matlab
% Ver archivo parte-b/main.m (incluido en el directorio del proyecto)
```

#colbreak()


  
#pagebreak()

#bibliography("bibliography.bib")

#v(2em)
#set heading(numbering: none)
= Anexo<anexo>

== Utilización de herramientas de IA

Se debe declarar el uso indicando la versión de la herramienta, y el link al chat. Alternativamente si su uso es acotado, declarar el prompt y la respuesta.

Método de Chorin:
Se discretiza N-S, y se separa en 2 ecuaciones
$
i)& quad (u^* -u^t)/(Delta t) = - (grad u^t) u^t + nu laplacian u^t, quad div u^* != 0 \
i i)& quad (u^(t+1) -u^*)/(Delta t) = - 1/rho grad p \
i i i) & quad (cancel(grad u^(t+1)) -grad u^*)/(Delta t) = - 1/rho laplacian p quad -> quad laplacian p = rho/(Delta t) grad u^* \
$
Ahora se actualiza i)

$u^* = u^t + Delta t (- (grad u^t) u^t + nu laplacian u^t), t=0$

Ahora se actualiza iii)

$p$

Ahora se actualiza ii)

$u^(t+1) = u^*  - (Delta t)/rho grad p$
#pagebreak()

== Código Matlab (Clase 11 Bloque 1)

#show raw: set text(size: 8pt)

#raw(read("parte-b/clase.m"), lang: "Matlab")