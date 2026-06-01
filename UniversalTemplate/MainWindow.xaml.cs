using UniversalTemplate;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Windows;
namespace UniversalApp
{
    public partial class MainWindow : Window
    {
        private readonly UserInfo _currentUser;
        private List<ProductRow> _allProducts = new List<ProductRow>();
        private ProductFormWindow _openedEditor;
        private bool _uiReady;
        public MainWindow(UserInfo user)
        {
            InitializeComponent();
            _currentUser = user ?? new UserInfo
            {
                UserId = null,
                FullName = "Гость",
                RoleName = "Гость"
            };
            if (string.IsNullOrWhiteSpace(_currentUser.RoleName))
                _currentUser.RoleName = "Гость";
            if (string.IsNullOrWhiteSpace(_currentUser.FullName))
                _currentUser.FullName = "Гость";
            RoleTextBlock.Text = "Роль: " + GetRoleCaption(_currentUser.RoleName);
            UserTextBlock.Text = "Пользователь: " + _currentUser.FullName;
            OrdersButton.Visibility = IsManagerOrAdmin() ? Visibility.Visible :
           Visibility.Collapsed;
            var advancedAllowed = IsManagerOrAdmin();
            FilterPanel.Visibility = advancedAllowed ? Visibility.Visible :
           Visibility.Collapsed;
            AdminPanel.Visibility = IsAdmin() ? Visibility.Visible :
           Visibility.Collapsed;
            if (advancedAllowed)
                LoadSuppliersForFilter();
            _uiReady = true;
            LoadProducts();
        }
        private void LoadProducts()
        {
            try
            {
                _allProducts = DataService.GetProducts();
                ApplyFiltersAndSorting();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "Ошибка БД", MessageBoxButton.OK,
               MessageBoxImage.Error);
            }
        }
        private void LoadSuppliersForFilter()
        {
            SupplierComboBox.Items.Clear();
            SupplierComboBox.Items.Add("Все поставщики");
            foreach (var s in DataService.GetSupplierNames())
                SupplierComboBox.Items.Add(s);
            SupplierComboBox.SelectedIndex = 0;
        }
        private void ApplyFiltersAndSorting()
        {
            if (!_uiReady || ProductsGrid == null)
                return;
            IEnumerable<ProductRow> query = _allProducts;
            if (IsManagerOrAdmin())
        {
                var search = (SearchTextBox.Text ?? "").Trim().ToLowerInvariant();
                var supplier = SupplierComboBox.SelectedItem?.ToString() ?? "Все поставщики"; var sort = (SortComboBox.SelectedItem as System.Windows.Controls.ComboBoxItem)?.Content?.ToString() ?? "Без сортировки";
                if (supplier != "Все поставщики")
                    query = query.Where(x => string.Equals(x.Supplier, supplier,
                   StringComparison.OrdinalIgnoreCase));
                if (!string.IsNullOrWhiteSpace(search))
                {
                    query = query.Where(x =>
                    (x.Article ?? "").ToLowerInvariant().Contains(search) ||
                    (x.Name ?? "").ToLowerInvariant().Contains(search) ||
                    (x.Category ?? "").ToLowerInvariant().Contains(search) ||
                    (x.Description ?? "").ToLowerInvariant().Contains(search)
                   ||
                    (x.Manufacturer ??
                   "").ToLowerInvariant().Contains(search) ||
                    (x.Supplier ?? "").ToLowerInvariant().Contains(search) ||
                    (x.UnitName ?? "").ToLowerInvariant().Contains(search));
                }
                if (sort == "Остаток (по возрастанию)")
                    query = query.OrderBy(x => x.StockQuantity);
                else if (sort == "Остаток (по убыванию)")
                    query = query.OrderByDescending(x => x.StockQuantity);
            }
            ProductsGrid.ItemsSource = query.ToList();
        }
        private void SearchTextBox_TextChanged(object sender,
       System.Windows.Controls.TextChangedEventArgs e)
        {
            if (!_uiReady) return;
            ApplyFiltersAndSorting();
        }
        private void SupplierComboBox_SelectionChanged(object sender,
       System.Windows.Controls.SelectionChangedEventArgs e)
        {
            if (!_uiReady) return;
            ApplyFiltersAndSorting();
        }
 private void SortComboBox_SelectionChanged(object sender,
System.Windows.Controls.SelectionChangedEventArgs e)
        {
            if (!_uiReady) return;
            ApplyFiltersAndSorting();
        }
        private void Add_Click(object sender, RoutedEventArgs e)
        {
            OpenEditor(null);
        }
        private void Edit_Click(object sender, RoutedEventArgs e)
        {
            var selected = ProductsGrid.SelectedItem as ProductRow;
            if (selected == null)
            {
                MessageBox.Show("Выберите товар для редактирования.",
               "Информация", MessageBoxButton.OK, MessageBoxImage.Information);
                return;
            }
            OpenEditor(selected.ProductId);
        }
        private void ProductsGrid_MouseDoubleClick(object sender,
       System.Windows.Input.MouseButtonEventArgs e)
        {
            if (!IsAdmin()) return;
            var selected = ProductsGrid.SelectedItem as ProductRow;
            if (selected != null)
                OpenEditor(selected.ProductId);
        }
        private void OpenEditor(int? productId)
        {
            if (!IsAdmin())
            {
                MessageBox.Show("Добавлять и редактировать товары может только администратор.",
               
                "Доступ запрещен", MessageBoxButton.OK,
                MessageBoxImage.Warning);
                return;
            }
            // Блокируем открытие нескольких окон редактирования одновременно.
            if (_openedEditor != null && _openedEditor.IsVisible)
            {
                MessageBox.Show("Окно редактирования уже открыто.", "Информация",
                MessageBoxButton.OK, MessageBoxImage.Information);
            return;
            }
            _openedEditor = new ProductFormWindow(productId) { Owner = this };
            var result = _openedEditor.ShowDialog();
            _openedEditor = null;
            if (result == true)
            {
                LoadSuppliersForFilter();
                LoadProducts();
            }
        }
        private void Delete_Click(object sender, RoutedEventArgs e)
        {
            if (!IsAdmin())
            {
                MessageBox.Show("Удалять товары может только администратор.",
                "Доступ запрещен", MessageBoxButton.OK,
                MessageBoxImage.Warning);
                return;
            }
            var selected = ProductsGrid.SelectedItem as ProductRow;
            if (selected == null)
            {
                MessageBox.Show("Выберите товар для удаления.", "Информация",
                MessageBoxButton.OK, MessageBoxImage.Information);
                return;
            }
            var confirm = MessageBox.Show("Удалить выбранный товар?",
           "Подтверждение",
            MessageBoxButton.YesNo, MessageBoxImage.Question);
            if (confirm != MessageBoxResult.Yes) return;
            try
            {
                if (DataService.ProductExistsInOrders(selected.ProductId))
                {
                    MessageBox.Show("Товар присутствует в заказе. Удалениеневозможно.",
                   
                    "Удаление запрещено", MessageBoxButton.OK,
                    MessageBoxImage.Warning);
                    return;
                }
                DataService.DeleteProduct(selected.ProductId);
            LoadSuppliersForFilter();
                LoadProducts();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "Ошибка удаления",
                MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        private void Orders_Click(object sender, RoutedEventArgs e)
        {
            if (!IsManagerOrAdmin()) return;
            var wnd = new OrdersWindow(_currentUser) { Owner = this };
            wnd.ShowDialog();
        }
        private void Logout_Click(object sender, RoutedEventArgs e)
        {
            var loginWindow = new LoginWindow();
            loginWindow.Show();
            Close();
        }
        private bool IsAdmin()
        {
            return string.Equals(_currentUser?.RoleName, "Администратор",
           StringComparison.OrdinalIgnoreCase);
        }
        private bool IsManagerOrAdmin()
        {
            return string.Equals(_currentUser?.RoleName, "Менеджер",
           StringComparison.OrdinalIgnoreCase) ||
            string.Equals(_currentUser?.RoleName, "Администратор",
           StringComparison.OrdinalIgnoreCase);
        }
        private string GetRoleCaption(string role)
        {
            if (role == "Авторизированный клиент") return "Клиент";
            if (role == "Администратор") return "Администратор";
            if (role == "Менеджер") return "Менеджер";
            return "Гость";
        }
    }
}
