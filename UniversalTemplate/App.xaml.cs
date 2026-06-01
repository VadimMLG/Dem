using UniversalApp;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Threading.Tasks;
using System.Windows;

namespace UniversalTemplate
{
    /// <summary>
    /// Логика взаимодействия для App.xaml
    /// </summary>
    public partial class App : Application
    {
        protected override void OnStartup(StartupEventArgs e)
        {
            base.OnStartup(e);

            try
            {
                using (var conn = Db.GetConnection())
                {
                    conn.Open();
                }
                MessageBox.Show("OK: подключение к MySQL успешно.", "Проверка БДшки",
                MessageBoxButton.OK, MessageBoxImage.Information);
            }
            catch (System.Exception ex)
            {
                MessageBox.Show("Ошибка подключения к MySQL:\n" + ex.Message,
                "Проверка БДшки",
                MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
    }
}
