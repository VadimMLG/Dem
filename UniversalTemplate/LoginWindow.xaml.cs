using UniversalTemplate;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace UniversalApp
{
    public partial class LoginWindow : Window
    {
        public LoginWindow()
        {
            InitializeComponent();
        }
        private void Login_Click(object sender, RoutedEventArgs e)
        {
            var login = LoginTextBox.Text.Trim();
            var password = PasswordTextBox.Password.Trim();
            if (string.IsNullOrWhiteSpace(login) ||
            string.IsNullOrWhiteSpace(password))
        {
                MessageBox.Show("Введите логин и пароль.", "Ошибка",
                MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }
            try
            {
                var user = DataService.Auth(login, password);
                if (user == null)
                {
                    MessageBox.Show("Неверный логин или пароль.", "Ошибка входа",
                    MessageBoxButton.OK, MessageBoxImage.Error);
                    return;
                }
                OpenMain(user);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "Ошибка подключения к БД",
                MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        private void Guest_Click(object sender, RoutedEventArgs e)
        {
            var guest = new UserInfo
            {
                UserId = null,
                FullName = "Гость",
                RoleName = "Гость"
            };
            OpenMain(guest);
        }
        private void OpenMain(UserInfo user)
        {
            var wnd = new MainWindow(user);
            wnd.Show();
            Close();
        }
    }
}

