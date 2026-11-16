# Desafío 2 — Diseño, modelación, calibración y validación virtual de un acondicionador térmico de líquidos de sobremesa

## 1. Objetivo general

Desarrollar el diseño de un equipo de sobremesa capaz de enfriar y calentar líquidos, integrando diseño mecánico, transferencia de calor, selección de componentes, instrumentación y control mediante herramientas CAD y CAE, simulaciones y evidencia experimental.
El producto deberá utilizar módulos termoeléctricos Peltier como tecnología principal para transferir calor.
El equipo deberá desarrollar un producto potencialmente comercializable, seguro, fabricable y utilizable por usuarios reales, con especificaciones medibles y un diseño coherente con los resultados de los modelos y las validaciones iniciales.
La fabricación del producto completo, su ensamblaje y su validación final se realizarán durante el Desafío 3.

## 2. Descripción del producto

El equipo deberá diseñar un acondicionador térmico de líquidos con dos modos de operación:

* **Modo de enfriamiento:**  disminuir la temperatura de una bebida contenida en una lata cerrada, cuyo tipo y volumen nominal serán seleccionados y especificados por el equipo.
* **Modo de calentamiento:**  elevar la temperatura de un volumen de agua definido por el equipo, destinado a la preparación de una sopa instantánea tipo Maruchan.
El agua destinada al consumo solo podrá entrar en contacto con materiales y superficies compatibles con el uso alimentario.
Cada equipo deberá definir y justificar libremente el principio de funcionamiento y la arquitectura de su solución. No se prescribe una configuración térmica, mecánica o de transferencia de calor específica.

### 2.1. Recursos proporcionados

El equipo docente proporcionará a cada grupo un kit de módulos termoeléctricos Peltier para su caracterización e integración. La cantidad, el modelo, la ficha técnica y los límites eléctricos de los módulos se informarán al entregar el kit.
El uso de estos módulos es obligatorio y deberán constituir el medio principal de calentamiento y enfriamiento.
Los demás componentes deberán ser identificados por el equipo y coordinados con el cuerpo docente, considerando:

* Disponibilidad de componentes en el taller.
* Presupuesto.
* Seguridad.
* Factibilidad de fabricación.
* Límites de operación de los componentes.
Se recomienda diseñar la mayor parte de las estructuras, los soportes y las carcasas para fabricación mediante impresión 3D.
Desde el modelamiento CAD deberán considerarse la geometría, la división en piezas, la orientación de fabricación, las uniones, las tolerancias, el consumo de material, el tiempo de impresión y la calidad de las terminaciones.

## 3. Parte 1: Definición del producto y especificaciones de ingeniería

Cada equipo deberá definir el producto, identificar a sus usuarios y traducir sus necesidades en especificaciones de ingeniería trazables, medibles y verificables.
Las especificaciones deberán proponerse, justificarse y defenderse a partir del contexto de uso, los antecedentes técnicos, los productos de referencia y las pruebas preliminares.

### 3.1. Especificaciones mínimas de desempeño

Para ambos modos de operación, enfriamiento y calentamiento, se deberán definir como mínimo:

* Volumen de líquido que se acondicionará.
* Temperatura inicial.
* Temperatura objetivo.
* Tiempo requerido para completar el proceso.
El tipo y volumen de la lata de bebida, así como el volumen de agua que se calentará, deberán ser seleccionados y justificados por el equipo.

### 3.2. Objetivos de desempeño

Antes de fabricar el producto completo en el Desafío 3, cada equipo deberá declarar explícitamente el desempeño objetivo que espera alcanzar.
Las metas deberán ser coherentes con el diseño y estar respaldadas por modelos, simulaciones, calibración experimental y validaciones iniciales.
Se evaluará:

* La pertinencia y exigencia de las metas.
* La calidad de la evidencia inicial.
* La coherencia entre las predicciones y el diseño propuesto.
Los resultados de volumen, temperaturas y tiempo podrán utilizarse para construir indicadores normalizados que permitan comparar el desempeño térmico entre propuestas.
El cumplimiento definitivo de los objetivos se comprobará mediante la validación final del producto fabricado en el Desafío 3.

### 3.3. Especificaciones adicionales

El equipo podrá incorporar otras especificaciones pertinentes, tales como:

* Consumo y potencia eléctrica.
* Estabilidad del control.
* Dimensiones.
* Masa.
* Ruido.
Independientemente de las especificaciones adicionales elegidas, el diseño y su evaluación deberán considerar como mínimo:
* Seguridad.
* Ergonomía.
* Facilidad de uso.
* Limpieza.
* Manufacturabilidad.
* Calidad de las terminaciones.
* Costo total del producto.

### 3.4. Restricciones obligatorias

El diseño deberá cumplir con las siguientes restricciones:

1. Funcionar como equipo de sobremesa y ser transportable por una o dos personas.
2. Operar en modos de enfriamiento y calentamiento mediante módulos Peltier.
3. Funcionar con una lata de bebida cerrada del tipo y volumen seleccionados por el equipo.
4. Proteger al usuario frente a superficies calientes, elementos móviles, humedad, condensación y riesgos eléctricos.
5. Emplear materiales aptos para contacto alimentario cuando exista contacto con agua destinada al consumo.
6. Permitir medir las variables necesarias para controlar y validar el desempeño.
7. Concebir la mayor parte de las estructuras, los soportes y las carcasas para fabricación mediante impresión 3D.
8. Considerar la eficiencia en costos, materiales, tiempo de impresión y tiempo de trabajo.
9. Quedar preparado para su fabricación, ensamblaje y validación final durante el Desafío 3.
Estas restricciones no determinan una solución particular. Cada grupo deberá explorar alternativas, aplicar un filtro de factibilidad y justificar la selección del concepto que desarrollará.

## 4. Parte 2: Modelación del sistema

El problema deberá separarse explícitamente en subsistemas y modelos. No se aceptará una descripción general del producto sin un desglose técnico que permita relacionar las decisiones de diseño con el desempeño esperado.
Se deberán desarrollar los siguientes modelos:

### 4.1. Modelo térmico

Deberá representar el calentamiento y enfriamiento de la carga, así como los fenómenos térmicos relevantes para la arquitectura seleccionada.
El modelo deberá explicitar:

* Supuestos.
* Condiciones de borde.
* Propiedades de los materiales.
* Intercambios de energía.

### 4.2. Modelo termoeléctrico y energético

Deberá relacionar:

* Tensión eléctrica.
* Corriente eléctrica.
* Potencia eléctrica.
* Diferencia de temperatura.
* Desempeño térmico de los módulos Peltier.
Se deberá analizar el balance de energía y estimar el consumo para ambos modos de operación, considerando las limitaciones reales del kit.

### 4.3. Modelo mecánico y estructural

Deberá representar los apoyos, las sujeciones, los cierres, las uniones y los componentes relevantes del producto.
Se deberán considerar:

* Cargas de uso.
* Manipulación.
* Dilatación térmica.
* Selección de materiales.
* Condiciones de fabricación mediante impresión 3D.

### 4.4. Modelo de instrumentación y control

Deberá definir:

* Variables que se medirán.
* Ubicación de los sensores.
* Estrategia de control de temperatura.
* Medidas para impedir condiciones inseguras.
La complejidad del control deberá ser coherente con los objetivos y con su futura implementación física.

### 4.5. Modelo de integración

Deberá explicar cómo se articulan los subsistemas térmico, energético, mecánico y de control dentro de una arquitectura completa.
Se deberán considerar:

* Secuencia de uso.
* Ensamblaje.
* Mantenibilidad.
* Limpieza.
* Manufactura.
* Gestión de condensación y derrames.

## 5. Parte 3: Simulación y justificación del modelo

Cada equipo deberá justificar la estrategia de modelación empleada. No será suficiente presentar imágenes o resultados de software sin explicar la base física del análisis, la construcción del modelo y su relación con el producto real.

### 5.1. Información que debe documentarse

Para cada modelo o simulación se deberá indicar:

1. Fenómeno físico que se desea representar.
2. Ecuaciones, balances o principios que gobiernan el problema.
3. Supuestos y simplificaciones adoptados, junto con su justificación.
4. Propiedades, parámetros y fuentes utilizadas.
5. Condiciones iniciales y de borde.
6. Técnica analítica o numérica empleada.
7. Análisis de sensibilidad de los parámetros relevantes.
8. Interpretación física de los resultados y su influencia sobre las decisiones de diseño.

### 5.2. Simulaciones mínimas

Se espera contar con:

* Al menos un modelo transitorio capaz de predecir la evolución temporal de la temperatura.
* Una evaluación mecánica o estructural de los elementos relevantes.
Podrán utilizarse modelos concentrados, redes de resistencias térmicas, FEM, CFD u otras técnicas pertinentes.
El uso de CFD no será obligatorio si la arquitectura seleccionada no lo justifica.
De forma complementaria, podrán incorporarse simulaciones de Monte Carlo o análisis paramétricos para estudiar incertidumbre, variabilidad o sensibilidad.

## 6. Parte 4: Calibración y validación inicial

La calibración y la validación deberán distinguirse explícitamente.
Los datos utilizados para ajustar los parámetros del modelo no deberán ser los mismos que se utilicen para evaluar su capacidad predictiva.
En el Desafío 2 se realizará una validación inicial de los modelos y las configuraciones experimentales disponibles. La validación final del producto completo se efectuará en el Desafío 3, una vez fabricado y ensamblado el prototipo.

### 6.1. Caracterización del kit Peltier

El equipo deberá diseñar y ejecutar una experiencia acotada que permita caracterizar el comportamiento de uno o más módulos Peltier en condiciones representativas.
Como mínimo, se deberán registrar:

* Evolución temporal de las temperaturas.
* Tensión eléctrica.
* Corriente eléctrica.
* Condiciones ambientales.
* Configuración experimental utilizada.

### 6.2. Calibración del modelo térmico

Los resultados experimentales deberán utilizarse para ajustar parámetros que no puedan conocerse con suficiente certeza.
Entre ellos pueden incluirse:

* Resistencias de contacto.
* Coeficientes efectivos de transferencia de calor.
* Pérdidas al ambiente.
* Desempeño térmico efectivo del conjunto.
El procedimiento de ajuste deberá ser reproducible y estar técnicamente justificado.

### 6.3. Validación inicial

El modelo calibrado deberá evaluarse utilizando una condición experimental diferente de la empleada durante el ajuste.
La comparación deberá incluir:

* Curvas de temperatura en función del tiempo.
* Indicadores de error.
* Discusión del nivel de acuerdo entre las predicciones y los datos experimentales.
* Fuentes de incertidumbre.
* Rango dentro del cual el modelo puede considerarse confiable.

### 6.4. Validaciones complementarias

Cuando la solución dependa de circulación forzada, mecanismos móviles, cierres, soportes u otros elementos críticos, el equipo deberá proponer pruebas complementarias coherentes con los riesgos de dichos elementos.
No se exige repetir un ensayo estructural estándar si este no aporta evidencia relevante para la solución seleccionada.

## 7. Parte 5: Desarrollo del producto final

A partir de las etapas anteriores, cada equipo deberá presentar el diseño digital detallado del acondicionador térmico de líquidos como un producto potencialmente comercializable y utilizable por usuarios reales.
El producto deberá ser coherente con:

* Las especificaciones definidas.
* Los modelos desarrollados.
* Los resultados experimentales iniciales.
* Las condiciones de fabricación y validación del Desafío 3.

### 7.1. Documentación del producto

La documentación deberá mostrar:

1. Arquitectura general del sistema y sus modos de operación.
2. Disposición de los módulos Peltier, sensores, actuadores y demás componentes.
3. Interacción con la lata seleccionada y con el recipiente o circuito utilizado para el agua.
4. Criterios de seguridad, limpieza, condensación y protección eléctrica.
5. Estrategia de ensamblaje y fabricación, principalmente mediante impresión 3D.
6. Acceso a los componentes y estrategia de mantenimiento.
7. Estimación de costos, materiales y tiempos de fabricación.
8. Coherencia dimensional y funcional con el prototipo físico que se desarrollará en el Desafío 3.
Se deberá incluir al menos un render del producto final y suficientes vistas técnicas para comprender su configuración y funcionamiento.

## 8. Consideraciones finales

La calidad del diseño no se evaluará únicamente por su apariencia o complejidad geométrica, sino por la consistencia entre las necesidades, las especificaciones, el concepto, los modelos, las simulaciones, la calibración, la validación inicial y el desarrollo del producto.
Se espera que el equipo proyecte un producto utilizable por usuarios reales, seguro, fabricable principalmente mediante impresión 3D y con potencial de comercialización.
La fabricación, integración y validación final del producto completo se realizarán en el Desafío 3.
