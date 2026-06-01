using UniversalTemplate;
using System;
using System.Windows;
namespace UniversalApp
{
    public partial class OrderFormWindow : Window
    {
        private readonly int? _orderId;
        private int _pickupCode;
        public OrderFormWindow(int? orderId = null)
        {
            InitializeComponent();
            _orderId = orderId;
            LoadLookups();
            if (_orderId.HasValue)
            {
                LoadOrder(_orderId.Value);
            }
            else
            {
                OrderNumberTextBox.Text = DataService.GetNextOrderNumber().ToString();
                _pickupCode = DataService.GetNextPickupCode();
                OrderDatePicker.SelectedDate = DateTime.Today;
                DeliveryDatePicker.SelectedDate = DateTime.Today.AddDays(1);
            }
        }
        private void LoadLookups()
        {
            StatusComboBox.DisplayMemberPath = "Name";
            StatusComboBox.SelectedValuePath = "Id";
            StatusComboBox.ItemsSource = DataService.GetStatuses();
            PickupComboBox.DisplayMemberPath = "Name";
            PickupComboBox.SelectedValuePath = "Id";
            PickupComboBox.ItemsSource = DataService.GetPickupPoints();
        }
        private void LoadOrder(int orderId)
        {
            var row = DataService.GetOrderById(orderId);
            if (row == null)
            {
                MessageBox.Show("Заказ не найден.", "Ошибка",
                MessageBoxButton.OK, MessageBoxImage.Warning);
                Close();
                return;
            }
            OrderNumberTextBox.Text = row.OrderNumber.ToString();
            ArticlesTextBox.Text = row.ArticlesText;
            StatusComboBox.SelectedValue = row.StatusId;
            PickupComboBox.SelectedValue = row.PickupPointId;
            OrderDatePicker.SelectedDate = row.OrderDate;
            DeliveryDatePicker.SelectedDate = row.DeliveryDate;
            _pickupCode = row.PickupCode;
        }
        private void Save_Click(object sender, RoutedEventArgs e)
        {
            var articles = ArticlesTextBox.Text.Trim();
            if (string.IsNullOrWhiteSpace(articles))
            {
                MessageBox.Show("Поле Артикул обязательно.", "Ошибка",
                MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }
            if (!(StatusComboBox.SelectedItem is LookupItem status) ||
            !(PickupComboBox.SelectedItem is LookupItem pickup))
            {
                MessageBox.Show("Выберите статус и пункт выдачи.", "Ошибка",
                MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }
            if (!OrderDatePicker.SelectedDate.HasValue || !
           DeliveryDatePicker.SelectedDate.HasValue)
            {
                MessageBox.Show("Укажите дату заказа и дату выдачи.", "Ошибка",
                MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }
            var model = new OrderEditModel
            {
                OrderId = _orderId,
                OrderNumber = int.Parse(OrderNumberTextBox.Text),
                ArticlesText = articles,
                StatusId = status.Id,
                PickupPointId = pickup.Id,
                OrderDate = OrderDatePicker.SelectedDate.Value.Date,
                DeliveryDate = DeliveryDatePicker.SelectedDate.Value.Date,
                PickupCode = _pickupCode
            };
            try
            {
                DataService.SaveOrder(model);
                DialogResult = true;
                Close();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "Ошибка сохранения",
                MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        private void Back_Click(object sender, RoutedEventArgs e)
        {
            DialogResult = false;
            Close();
        }
    }
}
