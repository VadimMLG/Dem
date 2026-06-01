using UniversalTemplate;
using System;
using System.Linq;
using System.Windows;
namespace UniversalApp
{
    public partial class OrdersWindow : Window
    {
        private readonly UserInfo _currentUser;
        public OrdersWindow(UserInfo currentUser)
        {
            InitializeComponent();
            _currentUser = currentUser;
            var isAdmin = string.Equals(_currentUser.RoleName, "Администратор",
           StringComparison.OrdinalIgnoreCase);
            AddOrderButton.Visibility = isAdmin ? Visibility.Visible :
           Visibility.Collapsed;
            EditOrderButton.Visibility = isAdmin ? Visibility.Visible :
           Visibility.Collapsed;
            DeleteOrderButton.Visibility = isAdmin ? Visibility.Visible :
           Visibility.Collapsed;
            LoadOrders();
        }
        private void LoadOrders()
        {
            try
            {
                OrdersGrid.ItemsSource = DataService.GetOrders();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "Ошибка БД", MessageBoxButton.OK,MessageBoxImage.Error);
            }
        }
        private bool IsAdmin()
        {
            return string.Equals(_currentUser.RoleName, "Администратор",
            StringComparison.OrdinalIgnoreCase);
        }
        private void AddOrder_Click(object sender, RoutedEventArgs e)
        {
            if (!IsAdmin()) return;
            var wnd = new OrderFormWindow(null) { Owner = this };
            if (wnd.ShowDialog() == true)
                LoadOrders();
        }
        private void EditOrder_Click(object sender, RoutedEventArgs e)
        {
            if (!IsAdmin()) return;
            var row = OrdersGrid.SelectedItem as OrderRow;
            if (row == null)
            {
                MessageBox.Show("Выберите заказ для редактирования.", "Информация", MessageBoxButton.OK, MessageBoxImage.Information);
                return;
            }
            var wnd = new OrderFormWindow(row.OrderId) { Owner = this };
            if (wnd.ShowDialog() == true)
                LoadOrders();
        }
        private void OrdersGrid_MouseDoubleClick(object sender,
       System.Windows.Input.MouseButtonEventArgs e)
        {
            if (IsAdmin())
                EditOrder_Click(sender, e);
        }
        private void DeleteOrder_Click(object sender, RoutedEventArgs e)
        {
            if (!IsAdmin()) return;
            var row = OrdersGrid.SelectedItem as OrderRow;
            if (row == null)
            {
                MessageBox.Show("Выберите заказ для удаления.", "Информация",
                MessageBoxButton.OK, MessageBoxImage.Information);
                return;
            }
            var confirm = MessageBox.Show("Удалить выбранный заказ?", "Подтверждение",
            MessageBoxButton.YesNo, MessageBoxImage.Question);
            if (confirm != MessageBoxResult.Yes) return;
            try
            {
                DataService.DeleteOrder(row.OrderId);
                LoadOrders();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "Ошибка удаления",
                MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        private void Back_Click(object sender, RoutedEventArgs e)
        {
            Close();
        }
    }
}