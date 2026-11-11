import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

//Valores para la conexión a la base de datos
private static final String URL = "jdbc:mysql://localhost:3306/zapateria";
private static final String USER = "root";
private static final String PASSWORD = "root";

/**
 * Método main que invoca a los otros métodos para acceder a la base de datos.
 * Solo puede insertar o eliminar (por su CUIT) a la tabla proveedores, y consultar todos
 * los proveedores que la integran. Los parámetros para la inserción o eliminación se 
 * deben pasar como argumentos de este método.
 * @param args lista de argumentos, de tamaño mayor a 0, donde args[0] especifica el 
 * método a invocar y los siguientes indican los parámetros para su invocación
 * (si es que el método los necesita).
 * @throws IllegalArgumentException si args[0] no corresponde a un método ejecutable,
 * o si se enviaron más o menos argumentos de los necesarios.
 */
public static void main(String[] args) {
        try {
            //Establecer la conexión con la base de datos
            Connection conexion = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("Conexión exitosa a la base de datos.");
            
            //Si no hay argumentos, no hacer nada
            if (args.length == 0)
                System.out.println("No se especifico ningún método. Para una lista de métodos soportados, consultar README.");

            //Buscar metodo solicitado e invocarlo. Lanzar excepción si la cantidad de argumentos es incorrecta
            else if (args[0] == "InsertarDatosProveedor"){
                if (args.length != 5)  //Método, CUIT, razón social, dirección, tel fijo 
                    throw new IllegalArgumentException("Cantidad de parámetros incorrecta. InsertarDatosProveedor requiere 4 parámetros.");
                InsertarDatosProveedor(conexion, Integer.parseInt(args[1]), args[2], args[3], Integer.parseInt(args[4]));
            }

            else if(args[0] == "EliminarProveedor"){
                if (args.length != 2)  //Método, CUIT
                    throw new IllegalArgumentException("Cantidad de parámetros incorrecta. EliminarProveedor requiere 1 parámetro.");
                EliminarProveedor(conexion, Integer.parseInt(args[1]));
            }
            
            else if(args[0] =="RetornarProveedores"){
                if (args.length != 1)  //Solo el método
                    throw new IllegalArgumentException("Cantidad de parámetros incorrecta. RetornarProveedores no requiere parámetros.");
                RetornarProveedores(conexion);
            }
            
            //Si el primer argumento no coincide con ninguno de los 3 soportados, hay un error
            else
                throw new IllegalArgumentException("Método no soportado. Para una lista de métodos soportados, consultar README.");
        
            conexion.close(); //Cerrar la conexion una vez terminada la ejecución de métodos
        }

        //En caso de que haya excepciones al intentar la conexión
        catch (SQLException e) {
            System.out.println("Error al conectar con la base de datos:");
            e.printStackTrace();
        }
    }

/**
 * Inserta un nuevo proveedor a la tabla proveedores de la base de datos, con sus datos dados
 * @param conexion el objeto Connection que represente la conexión a la base de datos
 * @param CUIT el CUIT del proveedor
 * @param razon_social la razón social del proveedor
 * @param direccion la dirección del proveedor 
 * @param tel_fijo el telefono fijo del proveedor (como un int, sin "+" al principio)
 */
public static void InsertarDatosProveedor(Connection conexion, int CUIT, String razon_social, String direccion, int tel_fijo){
    
    //Statement en SQL a ejecutar para la inserción
    String statemeString = "INSERT INTO proveedor (CUIT, razon_social, direccion, tel_fijo) VALUES (?, ?, ?, ?)";
    
    try{
        PreparedStatement stmt = conexion.prepareStatement(statemeString);
        
        //Asignar parámetros a los valores de stmt para enviarlos a la base de datos
        stmt.setInt(1, CUIT);
        stmt.setString(2, razon_social);
        stmt.setString(3, direccion);
        stmt.setInt(4, tel_fijo);
        
        stmt.executeUpdate(); //Ejecutar la inserción
        System.out.println("Proveedor insertado correctamente.");
    } 

    catch (SQLException e) {
        e.printStackTrace();
    }
}

/**
 * Dado un CUIT, elimina de la tabla proveedores al proveedor que tenga dicho CUIT asignado.
 * @param conexion el objeto Connection que represente la conexión a la base de datos
 * @param CUIT el CUIT del proveedor que se desea eliminar
 */
public static void EliminarProveedor(Connection conexion, int CUIT){
    
    //Statement en SQL a ejecutar para la inserción
    String statementString = "DELETE FROM proveedor (CUIT, razon_social, direccion, tel_fijo) WHERE CUIT = ?";
        
    try {
        PreparedStatement stmt = conexion.prepareStatement(statementString);
    
        //Asignar parámetros al CUIT del proveedor que se quiere borrar
        stmt.setInt(1, CUIT);
    
        stmt.executeUpdate(); //Ejecutar la eliminación
        System.out.println("Proveedor eliminado correctamente.");
    }

    catch (SQLException e) {
        e.printStackTrace();
    }
}

/**
 * Retorna una lista de los todos proveedores guardados en la tabla proveedores de la base de datos.
 * La lista se imprime por consola de forma "proveedor x: CUIT, razon_social, direccion, tel_fijo",
 * con un proveedor por linea.
 * @param conexion el objeto Connection que represente la conexión a la base de datos
 */
public static void RetornarProveedores(Connection conexion){
    
    //Statement en SQL a ejecutar para la consulta
    String statementString = "SELECT * FROM proveedor";
    try {
        PreparedStatement stmt = conexion.prepareStatement(statementString);
        ResultSet rs = stmt.executeQuery(); //Ejecutar consulta

        //Iterar por rs, proveedor a proveedor, imprimiendo sus datos en consola
        int count = 1;
        while(rs.next()){
            System.out.println("proveedor " + count + ": " + rs.getInt("CUIT") + ", " + rs.getString("razon_social") + ", " + rs.getString("direccion") + ", " + rs.getInt("tel_fijo"));
            count++;
        }
        System.out.println("Fin de la lista. Todos los proveedores listados correctamente.");
    }

    catch (SQLException e) {
        e.printStackTrace();
    }
}