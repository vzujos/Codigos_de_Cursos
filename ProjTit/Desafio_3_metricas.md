# Desafío 3: Fabricación y evaluación experimental de un acondicionador térmico de líquidos de sobremesa

## 1. Introducción y objetivo del desafío

En continuidad con el Desafío 2, cada equipo debe fabricar, ensamblar y validar experimentalmente el producto desarrollado durante el Desafío 2.

El sistema debe ser capaz de operar en 2 modos independientes:

- **Enfriamiento:** disminuir la temperatura de una bebida contenida en una lata comercial cerrada.
- **Calentamiento:** elevar la temperatura de un volumen de agua destinado a la preparación de una sopa instantánea.

Ambos procesos deben usar módulos termoeléctricos Peltier como tecnología principal de transferencia de calor, respetando las condiciones del Desafío 2.

El objetivo de esta evaluación no es solo comprobar el funcionamiento del prototipo, sino también determinar qué tan bien responde a las especificaciones antes definidas, considerando el desempeño térmico real, la precisión respecto de la temperatura objetivo, el tiempo de operación y el costo de fabricación.

Se premiarán diseños que logren un buen desempeño experimental, que sean capaces de cumplir sus propias metas de diseño y que alcancen estos resultados con un uso eficiente de sus recursos.

La evaluación combina dos enfoques:

1. **Desempeño experimental comparativo:** cada equipo será evaluado respecto del mejor desempeño térmico real obtenido en el curso.
2. **Cumplimiento de los objetivos comprometidos:** se evaluará la diferencia entre la temperatura objetivo declarada y la temperatura efectivamente alcanzada al finalizar el tiempo establecido.

De esta forma, la evaluación buscará reconocer tanto la exigencia del diseño como la capacidad del equipo para materializar las prestaciones comprometidas.

### 1.1 Notación y variables de desempeño

Para simplificar las expresiones se utilizarán los siguientes subíndices:

- $r$: valor real obtenido experimentalmente.
- $0$: valor objetivo comprometido.
- $f$: modo de enfriamiento.
- $h$: modo de calentamiento.
- $g$: grupo evaluado.

Las principales variables utilizadas serán:

| Símbolo | Descripción |
| :--- | :--- |
| $T_{in}$ | Temperatura inicial medida |
| $T_{o}$ | Temperatura objetivo |
| $T_{r}$ | Temperatura real al finalizar el ensayo |
| $V$ | Volumen de líquido |
| $\rho$ | Densidad del líquido |
| $c_{p}$ | Calor específico del líquido |
| $t_{o}$ | Tiempo comprometido |
| $R_{r}$ | Potencia térmica promedio reconocida |
| $P_{T}$ | Puntaje de cumplimiento térmico |
| $P_{f}$ | Puntaje experimental de enfriamiento |
| $P_{h}$ | Puntaje experimental de calentamiento |
| $P_{c}$ | Factor económico |
| $P_{E}$ | Puntaje experimental total |

## 2. Condiciones generales de evaluación

### 2.1. Especificaciones comprometidas

Cada equipo deberá declarar, antes de la evaluación experimental, las siguientes variables para ambos modos de operación:

| Variable | Descripción |
| :--- | :--- |
| $V_{o}$ | Volumen de líquido acondicionado |
| $T_{in}$ | Temperatura inicial de referencia |
| $T_{o}$ | Temperatura objetivo comprometida |
| $t_{o}$ | Tiempo comprometido para completar el proceso |

Estas especificaciones deberán ser coherentes con lo desarrollado durante el Desafío 2, o a modificaciones posteriores autorizadas por el equipo docente.

Las temperaturas objetivo deberán representar condiciones razonables para el consumo humano y ser coherentes con la función del producto.

Asimismo, los tiempos comprometidos deberán ser razonables, técnicamente justificables y consistentes con las capacidades del sistema desarrollado.

La pertinencia de estas especificaciones será evaluada por el equipo docente, quien podrá aplicar descuentos debidamente fundamentados en los apartados correspondientes a la documentación y justificación técnica.

### 2.2. Volúmenes de operación

Los volúmenes seleccionados deben estar dentro de los siguientes rangos:

| Modo de operación | Volumen permitido |
| :--- | :--- |
| Enfriamiento | 250 a 500 mL |
| Calentamiento | 200 a 500 m |

En el modo de enfriamiento se usarán latas comerciales cerradas, mientras que en el modo de calentamiento se usará agua.

Cada equipo debe justificar su elección de volúmenes en función de la arquitectura del producto y su contexto de uso.

### 2.3. Procedimiento general

Durante la evaluación experimental se realizará una prueba para cada modo de operación, siguiendo las siguientes etapas:

1. Verificar el estado general del prototipo y las condiciones necesarias para desarrollar el ensayo de manera segura.
2. Registrar el volumen y la temperatura inicial del líquido.
3. Iniciar la operación del prototipo y el registro del tiempo.
4. El sistema operará durante el tiempo previamente comprometido por el equipo.
5. Al finalizar dicho tiempo, se determinará la temperatura real alcanzada.
6. Los resultados registrados serán utilizados para calcular los indicadores de desempeño experimental.

La evaluación considerará la temperatura obtenida al finalizar el tiempo comprometido. No será necesario demostrar que el sistema puede mantener dicha temperatura.

El prototipo debe permitir efectuar su evaluación y cumplir las condiciones de seguridad correspondientes.

El procedimiento específico de medición y los instrumentos utilizados serán establecidos por el equipo docente.

## 3. Evaluación del desempeño térmico

La evaluación térmica se realizará de manera independiente para calentamiento y enfriamiento, utilizando la misma metodología de cálculo.

### 3.1. Cambio de temperatura comprometido

Para cada modo se define:

$$\Delta T_{o} = |T_{o} - T_{in}|$$

representa la magnitud del cambio térmico que el equipo se comprometió a alcanzar.

### 3.2. Cambio de temperatura reconocido

Para evitar que una desviación más allá de la temperatura objetivo sea interpretada como un mejor desempeño, solamente se reconocerá el cambio térmico producido en la dirección correcta y hasta la temperatura comprometida.

Se define:

$$\Delta T_{eval} = \min[\Delta T_{o}, \max(0, s(T_{r} - T_{in}))]$$

Donde:

- $s = +1$ para calentamiento
- $s = -1$ para enfriamiento

Por lo tanto, sobrepasar la temperatura objetivo no implica una ventaja.

### 3.3. Potencia térmica promedio reconocida

El desempeño físico real se representará mediante la potencia térmica promedio reconocida durante el tiempo de operación:

$$R_{r} = \frac{\rho V c_{p} \Delta T_{eval}}{t_{o}}$$

La variable $R_{r}$ deberá expresarse en watts ($\text{W}$), utilizando unidades consistentes.

Este indicador permite comparar prototipos que operan con distintos volúmenes, cambios de temperatura y tiempos de acondicionamiento. Un mayor valor representa una mayor cantidad de energía térmica efectivamente reconocida por unidad de tiempo.

### 3.4. Normalización del desempeño experimental

Para comparar los resultados de todos los grupos, la potencia térmica promedio reconocida se normalizará respecto del mejor desempeño experimental obtenido en el curso.

Para cada modo $i$:

$$R_{ref,i} = \max_{g}(R_{r,i,g})$$

El desempeño normalizado se calcula como:

$$\hat{R}_{i,g} = \min\left(1, \frac{R_{r,i,g}}{R_{ref,i}}\right)$$

Siempre que la referencia sea positiva, se cumple:

$$0 \le \hat{R}_{i,g} \le 1$$

El mejor desempeño real de cada modo obtendrá un valor normalizado igual a $1$, mientras que los demás equipos quedarán expresados como una fracción de dicha referencia. La normalización se realizará independientemente para calentamiento y enfriamiento.

#### Tratamiento de resultados atípicos

Si se detecta un resultado experimental excepcionalmente alto que pueda distorsionar significativamente la comparación, el equipo docente podrá reemplazar la referencia máxima por el percentil $90$ de los desempeños observados:

$$R_{ref,i} = Q_{90}(R_{r,i,g})$$

En este caso, los desempeños normalizados se limitarán a un máximo de $1$. La aplicación de este criterio no será automática y deberá encontrarse debidamente justificada por el equipo docente.

Si ningún grupo obtiene una potencia térmica reconocida positiva en un modo, el puntaje normalizado correspondiente será cero para todos los equipos.

## 4. Evaluación del cumplimiento de la temperatura objetivo

Además del desempeño térmico real, se evaluará la capacidad del prototipo para alcanzar la temperatura previamente comprometida.

Para ello, se define el error absoluto:

$$e_{T} = |T_{r} - T_{o}|$$

Este error se normaliza respecto del cambio de temperatura comprometido:

$$e_{T,rel} = \frac{|T_{r} - T_{o}|}{|T_{o} - T_{in}|}$$

El puntaje de cumplimiento térmico se calculará mediante:

$$P_{T} = [\max(0, 1 - e_{T,rel})]^{2} = \left[\max\left(0, 1 - \frac{|T_{r} - T_{o}|}{|T_{o} - T_{in}|}\right)\right]^{2}$$

Se cumple:

$$0 \le P_{T} \le 1$$

Esta formulación utiliza una penalización cuadrática, de manera que las desviaciones respecto de la temperatura objetivo reduzcan progresivamente el puntaje obtenido.

La penalización será simétrica:

- Alcanzar exactamente la temperatura objetivo permite obtener $P_{T} = 1$.
- No alcanzar la temperatura objetivo disminuye el puntaje.
- Sobrepasar la temperatura objetivo también disminuye el puntaje.
- Cuando el error relativo es igual o superior a $1$, el cumplimiento térmico será nulo.

De esta forma, no se premiará simplemente enfriar o calentar una mayor cantidad de grados, sino conseguir un desempeño térmico relevante y coherente con las especificaciones previamente comprometidas.

## 5. Puntaje experimental de cada modo

El puntaje correspondiente a cada modo de operación se obtiene multiplicando el desempeño térmico real normalizado por el factor de cumplimiento de temperatura:

$$P_{i} = \hat{R}_{i} P_{T,i}$$

Por lo tanto:
$$P_{f} = \hat{R}_{f} P_{T,f}$$
$$P_{h} = \hat{R}_{h} P_{T,h}$$

- Ambos puntajes estarán comprendidos entre $0$ y $1$.
- Este procedimiento permite premiar simultáneamente:
  1. La capacidad real de transferencia térmica del prototipo.
  2. El volumen acondicionado.
  3. La rapidez del proceso.
  4. La precisión respecto de la temperatura objetivo comprometida.

## 6. Combinación de calentamiento y enfriamiento

El puntaje físico global se calculará mediante el promedio geométrico:

$$P_{F} = \sqrt{P_{f} P_{h}}$$

El promedio geométrico busca evitar que un desempeño excepcional en un modo compense resultados deficientes en el otro.

En particular, si uno de los modos obtiene un puntaje nulo:

$$P_{f} = 0 \quad \text{o} \quad P_{h} = 0$$

Entonces:

$$P_{F} = 0$$

Por lo tanto, ambos modos tienen igual importancia y resultan necesarios para alcanzar un buen desempeño experimental global.

## 7. Evaluación económica

El desempeño físico se complementará con un factor económico que busca reconocer la utilización eficiente de los recursos durante la fabricación del prototipo.

### 7.1. Determinación del costo de referencia

A diferencia de establecer un presupuesto base fijo, el costo de referencia será determinado a partir de los presupuestos reportados por los grupos.

Se define:

$$C_{0} = \text{Mediana}(C_{1}, C_{2}, \dots, C_{n})$$

Donde $C_{1}, \dots, C_{n}$ corresponden a los presupuestos totales informados por los distintos equipos.

Este valor será determinado y comunicado por el equipo docente antes de la evaluación experimental y permanecerá fijo durante el proceso de calificación.

### 7.2. Costo total del prototipo

El costo total del grupo $C_{g}$ corresponderá al valor real documentado de los recursos empleados en la fabricación del prototipo.

Se deberán considerar los materiales, componentes y recursos de fabricación, incluyendo aquellos proporcionados por el curso, según criterios de valorización comunes definidos por el equipo docente.

Los tiempos de trabajo y fabricación deberán ser documentados, aunque no se incorporarán directamente en el factor económico.

### 7.3. Factor de penalización económica

Se define:

$$P_{C} = \min\left(1, \sqrt{\frac{C_{0}}{C_{g}}}\right)$$

Este factor cumple:

$$0 < P_{c} \le 1$$

Para costos totales positivos y una referencia económica positiva.

Los equipos cuyo costo sea menor o igual al costo de referencia obtendrán $P_{C} = 1$, mientras que aquellos que lo superen recibirán una penalización moderada mediante raíz cuadrada.

Esto permite que los equipos utilicen recursos adicionales cuando sus decisiones de diseño lo justifiquen, aunque deberán conseguir mejoras suficientes en su desempeño experimental para compensar el mayor costo.

## 8. Puntaje experimental final

El puntaje experimental se calculará multiplicando el desempeño físico global por el factor económico:

$$P_{E} = P_{F} P_{C}$$

Equivalentemente:

$$P_{E} = \sqrt{(\hat{R}_{f} P_{T,f})(\hat{R}_{h} P_{T,h})} \cdot \min\left(1, \sqrt{\frac{C_{0}}{C_{g}}}\right)$$

Por construcción:

$$0 \le P_{E} \le 1$$

El puntaje experimental será máximo cuando el equipo consiga un desempeño elevado respecto de los demás grupos, alcance con precisión las temperaturas comprometidas en ambos modos y mantenga un costo razonable.

## 9. Sistema de calificación final

La calificación final del Desafío 3 se calculará mediante:

$$N_{f,g} = \min(7.0, N_{D} B + 3.5 P_{E} + \text{bono})$$

Donde:

- $N_{D}$: nota correspondiente a documentación, fabricación y validación del producto, evaluada entre $1.0$ y $4.5$.
- $B$: variable binaria de participación experimental, cuyo valor será $1$ cuando el grupo se presente a la evaluación y $0$ cuando no se presente.
- $P_{E}$: puntaje experimental del grupo, calculado de acuerdo con las expresiones anteriores.
- $3.5 P_{E}$: aporte experimental a la calificación final, con un máximo de $3.5$ puntos.
- $\text{bono}$: Los profesores se reservan el derecho de otorgar una bonificación tanto por la demostración como por la calidad de las terminaciones del prototipo.

El puntaje experimental se calculará exclusivamente a partir de los resultados válidos obtenidos durante las pruebas.

### 9.1. Evaluación de documentación y fabricación

La componente documental y de fabricación considerará los siguientes criterios:

| Criterio | Puntaje máximo |
| :--- | :--- |
| Calidad de fabricación y ensamblaje | $1.0$ |
| Funcionamiento, seguridad y facilidad de uso | $1.0$ |
| Documentación de diseño y modificaciones | $0.8$ |
| Validación experimental y análisis de resultados | $0.8$ |
| Costos y recursos utilizados | $0.4$ |
| Presentación y terminaciones del producto | $0.5$ |
| **Total máximo** | **$4.5$** |

La asignación de los puntajes será realizada por el equipo docente considerando la calidad técnica, coherencia, integridad y respaldo de los antecedentes presentados. La nota documental tendrá un mínimo de $1.0$ y un máximo de $4.5$.

Los equipos deberán documentar y justificar las modificaciones realizadas respecto del diseño desarrollado en el Desafío 2, explicando su motivación, implementación y consecuencias sobre el comportamiento del sistema.

Se considerará especialmente la capacidad para interpretar críticamente los resultados experimentales, reconocer limitaciones del prototipo y establecer conclusiones fundamentadas.

## 10. Condiciones de seguridad e inocuidad

El equipo docente se reserva el derecho de impedir el inicio, interrumpir o suspender definitivamente cualquier ensayo experimental cuando, durante la revisión previa o en cualquier momento de su ejecución, se detecten condiciones que puedan representar un riesgo para la seguridad de las personas, la integridad de los equipos e instalaciones o la inocuidad de los líquidos destinados al consumo.

Estas condiciones podrán incluir, entre otras:

- Riesgos eléctricos asociados a alimentación, conexiones o componentes.
- Exposición a superficies o fluidos a temperaturas peligrosas.
- Fallas mecánicas, estructurales o de sujeción.
- Fugas de líquidos o condiciones de humedad que puedan comprometer la seguridad.
- Materiales o superficies incompatibles con aplicaciones alimentarias.
- Cualquier otra condición que el equipo docente considere potencialmente riesgosa.

En caso de suspensión, el equipo docente determinará si corresponde autorizar una nueva ejecución del ensayo una vez corregidas las condiciones observadas.

Si el ensayo no puede desarrollarse o completarse de manera segura, se considerará no válido para efectos de la evaluación experimental correspondiente.

La seguridad y la inocuidad serán condiciones obligatorias para autorizar la ejecución de las pruebas y no podrán compensarse mediante mejores resultados de desempeño térmico.

## 11. Consideraciones generales y atribuciones del equipo docente

La evaluación experimental buscará mantener criterios objetivos y comparables para todos los participantes. Sin embargo, el equipo docente conservará la facultad de evaluar la pertinencia técnica de las especificaciones comprometidas, la calidad de las decisiones de diseño y la validez de la evidencia presentada.

En particular, podrá aplicar descuentos debidamente fundamentados en la evaluación documental cuando se identifiquen:

- Objetivos de temperatura o tiempo poco razonables o insuficientemente justificados.
- Decisiones de diseño inconsistentes con la función prevista del producto.
- Modificaciones relevantes respecto del Desafío 2 que no hayan sido documentadas.
- Presupuestos incompletos o costos insuficientemente respaldados.
- Deficiencias en fabricación, ensamblaje, seguridad, terminaciones o comunicación técnica.
- Análisis experimentales incompletos o conclusiones que no se encuentren respaldadas por los resultados.

Estas observaciones se reflejarán principalmente en la evaluación de documentación y fabricación, sin alterar arbitrariamente las expresiones matemáticas del puntaje experimental.

Los objetivos comprometidos deberán quedar registrados antes de la evaluación y no podrán modificarse durante los ensayos.

## 12. Interpretación pedagógica de la métrica

La evaluación propuesta busca que el estudiante comprenda que la calidad de una solución de ingeniería no depende únicamente de su desempeño máximo, sino de su capacidad para responder a especificaciones previamente establecidas mediante una solución funcional, fabricable y económicamente razonable.

La métrica puede interpretarse como el producto del desempeño físico equilibrado y la eficiencia económica:

$$P_{E} = \sqrt{P_{f} P_{h}} \cdot P_{C}$$

Cada puntaje de modo incorpora tanto el desempeño térmico real como la precisión respecto de la temperatura objetivo comprometida.

Por lo tanto, un equipo obtendrá un puntaje elevado solamente si logra simultáneamente:

1. Conseguir un buen desempeño térmico real respecto de los demás grupos.
2. Acercarse a las temperaturas objetivo comprometidas en los tiempos establecidos.
3. Demostrar un comportamiento satisfactorio tanto en calentamiento como en enfriamiento.
4. Conseguir estos resultados mediante un costo de fabricación razonable.
