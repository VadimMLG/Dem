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
        // Строка подключения к базе данных MySQL
        public const string ConnectionString = "Server=127.0.0.1;Port=3306;Database=exam_v5;Uid=root;Pwd=;Charset=utf8mb4;Allow Zero Datetime=True;Convert Zero Datetime=True;";

        public static MySqlConnection GetConnection()
        {
            return new MySqlConnection(ConnectionString);
        }
    }
}