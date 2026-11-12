# Proyecto de Bases de Datos

Este repositorio incluye el trabajo hecho por Marabotto Nehemias, Stroppa Ignacio, Dominguez Danilo y Burgueño Camila para el proyecto de Bases de Datos 1 en el segundo cuatrimestre de 2026.

El proyecto finalizado contiene 4 archivos/scripts ejecutables:
1. "ZAPATERIA.sql" contiene el script en SQL para la creación del esquema Zapateria, representando el problema dado en la consigna. Este archivo corresponde al punto 3 de las tareas.
2. "cargadedatos.sql" contiene el script en SQL para cargar datos de ejemplo a la base de datos (para las posteriores consultas), correspondiente al punto 4 de las tareas.
3. "consultas.sql" contiene código en SQL para realizar consultas correspondientes a la consigna 6.
4. "programa.class" contiene el código java para la consigna número 5, y debe ser ejecutada precedida por [ -cp ".;mysql-connector-j-26.10.0.jar ] (el classpath para el driver) y seguida por un argumento que especifique qué método invocar. Los métodos aceptados (con sus parámetros en orden) son:
   * "InsertarDatosProveedor [CUIT] [razon_social] [direccion] [tel_fijo]", donde CUIT y tel fijo son numeros, y razon social y direccion son cadenas de texto sin espacios. Inserta un proveedor a la base de datos.
   * "EliminarProveedor [CUIT]", donde CUIT es un numero. Elimina a un proveedor de la base de datos dado su numero de CUIT.
   * "ListarProveedores", sin argumentos. Imprime una lista de todos los proveedores.
   de forma que el comando para su ejecución se lea java -cp ".;mysql-connector-j-26.10.0.jar" programa [método] [argumentos]

Ademas de un archivo de imagen ("diagramaER.jpeg") que incluye un modelo E/R que representa al problema, cumpliendo con la tarea 1; un archivo pdf ("informe.pdf") que contiene el informe del trabajo y la tarea 2; un archivo de texto ("zapateriatxt.txt") que incluye el código sql de "ZAPATERIA.sql", "cargadedatos.sql" y "consultas.sql" en un solo bloque de texto; y un archivo java ("programa.java") que incluye el código fuente de "programa.class".
