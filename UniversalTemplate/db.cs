using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MySql.Data.MySqlClient;
namespace UniversalApp
{
    internal static class Db
    {
        // =========================================================================
        // ВНИМАНИЕ НА ЭКЗАМЕНЕ:
        // Измените 'shoe2026_pu' на название базы данных из вашего варианта!
        // =========================================================================
        public const string ConnectionString = "Server=127.0.0.1;Port=3306;Database=shoe2026_pu;Uid=root;Pwd=;Charset=utf8mb4;Allow Zero Datetime=True;Convert Zero Datetime=True;";

        public static MySqlConnection GetConnection()
        {
            return new MySqlConnection(ConnectionString);
        }
    }
}