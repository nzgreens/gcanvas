import '../bin/dbconnection.dart';

main() {
  DBConnection conn = new DBConnection.create();

  //resetDB(conn);
  populateTables(conn);

}