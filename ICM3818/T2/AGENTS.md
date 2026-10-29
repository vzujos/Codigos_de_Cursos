# AGENTS.md

## 1. Descripción del proyecto

Este proyecto utiliza Typst para elaborar un documento técnico que contiene el desarrollo de una tarea. El directorio incluye archivos de configuración de una plantilla Typst, contenido editable, recursos gráficos y códigos de MATLAB de una tarea anterior que pueden utilizarse como referencia.

El archivo `main.typ` es el documento principal que integra el contenido y se utiliza para compilar el documento final.

## 2. Estructura del proyecto

La estructura inicial del proyecto es la siguiente:

```text
.
├── assets/
├── config/
├── content/
├── parte-a/
├── parte-b/
├── AGENTS.md
├── bibliography.bib
└── main.typ
```

Cada directorio y archivo tiene el siguiente propósito:
- `assets/`: contiene fotografías y otros recursos gráficos que pueden incorporarse al documento. `fotos/` contiene las figuras obtenidas del código de MATLAB.
- `config/`: contiene los archivos de configuración y de la plantilla Typst. Estos archivos definen aspectos como el formato, los estilos y la presentación del documento. No debes modificarlos.
- `content/`: contiene los archivos Typst con el contenido del documento que puedes crear y editar.
- `parte-a/`: contiene los códigos de MATLAB de una tarea anterior. Puedes consultarlos para comprender los métodos utilizados, recuperar información relevante y utilizarlos como referencia para desarrollar la nueva tarea.
- `parte-b/`: contiene los códigos de MATLAB de esta tarea. El archivo `clase.m` es un código entregado por el curso que debes utilizar.
- `bibliography.bib`: contiene las referencias bibliográficas del proyecto. Consúltalo antes de agregar nuevas referencias y evita duplicar entradas existentes.
- `main.typ`: es el archivo principal de Typst que compila el documento. Integra la plantilla, el contenido y los demás recursos necesarios. 


## 3. Documentación

### Typst

Antes de implementar funcionalidades de Typst, consulta la documentación oficial disponible en:

https://typst.app/docs/

Esta regla es especialmente importante para las expresiones matemáticas del documento.

### Referencias

Si necesitas agregar referencias bibliográficas nuevas, utiliza información verificable.


