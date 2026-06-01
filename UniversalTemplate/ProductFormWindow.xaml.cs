using Microsoft.Win32;
using UniversalTemplate;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net.NetworkInformation;
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
    public partial class ProductFormWindow : Window
    {
        private const string PackPhotosPrefix = "pack://application:,,,/resources/photos/";
        private readonly int? _productId;
        private string _oldPhotoFile = "";
        private string _selectedPhotoPath = "";

        public ProductFormWindow(int? productId = null)
        {
            InitializeComponent();
            _productId = productId;
            LoadLookups();

            if (_productId.HasValue)
            {
                LoadProduct(_productId.Value, PackPhotosPrefix);
            }
            else
            {
                IdLabel.Visibility = Visibility.Collapsed;
                IdTextBox.Visibility = Visibility.Collapsed;
                SetPreviewFromPack("pack://application:,,,/resources/picture.png");
            }
        }
        private void LoadLookups()
        {
            CategoryComboBox.DisplayMemberPath = "Name";
            CategoryComboBox.SelectedValuePath = "Id";
            CategoryComboBox.ItemsSource = DataService.GetCategories();
            ManufacturerComboBox.DisplayMemberPath = "Name";
            ManufacturerComboBox.SelectedValuePath = "Id";
            ManufacturerComboBox.ItemsSource = DataService.GetManufacturers();
        }
        private void LoadProduct(int productId, string packUri)
        {
            var row = DataService.GetProductById(productId);
            if (row == null)
            {
                MessageBox.Show("Товар не найден.", "Ошибка",
               MessageBoxButton.OK, MessageBoxImage.Warning);
                Close();
                return;
            }
            IdTextBox.Text = row.ProductId.Value.ToString();
            ArticleTextBox.Text = row.Article;
            NameTextBox.Text = row.Name;
            DescriptionTextBox.Text = row.Description;
            SupplierTextBox.Text = row.SupplierName;
            PriceTextBox.Text = row.Price.ToString("0.##",CultureInfo.InvariantCulture);
        UnitTextBox.Text = row.UnitName;
            StockTextBox.Text = row.StockQuantity.ToString();
            DiscountTextBox.Text = row.DiscountPercent.ToString("0.##",CultureInfo.InvariantCulture);
            CategoryComboBox.SelectedValue = row.CategoryId;
            ManufacturerComboBox.SelectedValue = row.ManufacturerId;
            _oldPhotoFile = row.PhotoFile ?? "";
            if (!string.IsNullOrWhiteSpace(_oldPhotoFile))
            {
                var f = System.IO.Path.GetFileName(_oldPhotoFile);
                var runtimePath = System.IO.Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "resources", "photos", f);
                if (File.Exists(runtimePath))
                {
                    var runtimeImage = LoadBitmap(runtimePath);
                    PhotoImage.Source = runtimeImage;
                }
                else
                {
                    SetPreviewFromPack(packUri + f);
                }
            }
            else
            {
                SetPreviewFromPack("pack://application:,,,/resources/picture.png");
            }
        }
        private void ChoosePhoto_Click(object sender, RoutedEventArgs e)
        {
            var dialog = new OpenFileDialog
            {
                Filter = "Image files|*.png;*.jpg;*.jpeg;*.bmp"
            };
            if (dialog.ShowDialog() != true) return;
            var bitmap = LoadBitmap(dialog.FileName);
            if (bitmap == null)
            {
                MessageBox.Show("Не удалось прочитать изображение.", "Ошибка",
               MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }
            if (bitmap.PixelWidth > 300 || bitmap.PixelHeight > 200)
            {
                MessageBox.Show("Размер фото не должен превышать 300x200 пикселей.", "Ограничение", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }
            _selectedPhotoPath = dialog.FileName;
            PhotoImage.Source = bitmap;
        }
        private void Save_Click(object sender, RoutedEventArgs e)
        {
            var article = ArticleTextBox.Text.Trim();
            var name = NameTextBox.Text.Trim();
            var supplier = SupplierTextBox.Text.Trim();
            var unit = UnitTextBox.Text.Trim();
            var description = DescriptionTextBox.Text.Trim();
            if (string.IsNullOrWhiteSpace(article) ||
            string.IsNullOrWhiteSpace(name) ||
            string.IsNullOrWhiteSpace(supplier) ||
            string.IsNullOrWhiteSpace(unit))
            {
                MessageBox.Show("Заполните обязательные поля: артикул,наименование, поставщик, единица измерения.",
               
                "Ошибка", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }
            if (!(CategoryComboBox.SelectedItem is LookupItem category) ||
            !(ManufacturerComboBox.SelectedItem is LookupItem manufacturer))
            {
                MessageBox.Show("Выберите категорию и производителя.", "Ошибка",
               MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }
            if (!TryParseDecimal(PriceTextBox.Text, out var price) ||
            !TryParseDecimal(DiscountTextBox.Text, out var discount))
            {
                MessageBox.Show("Проверьте формат цены и скидки.", "Ошибка",
               MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }
            if (!int.TryParse(StockTextBox.Text.Trim(), out var stock))
            {
                MessageBox.Show("Количество на складе должно быть целым числом.",
               "Ошибка", MessageBoxButton.OK, MessageBoxImage.Warning);
            return;
            }
            if (price < 0 || discount < 0 || stock < 0)
            {
                MessageBox.Show("Цена, скидка и количество не могут быть отрицательными.",
               
                "Ошибка", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }
            var photoFile = _oldPhotoFile;
            if (!string.IsNullOrWhiteSpace(_selectedPhotoPath))
            {
                var copied = CopyPhotoToProject(_selectedPhotoPath);
                if (string.IsNullOrWhiteSpace(copied))
                {
                    MessageBox.Show("Не удалось сохранить изображение.",
                   "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
                    return;
                }
                if (!string.IsNullOrWhiteSpace(_oldPhotoFile))
                {
                    DeleteOldPhoto(_oldPhotoFile);
                }
                photoFile = copied;
            }
            var model = new ProductEditModel
            {
                ProductId = _productId,
                Article = article,
                Name = name,
                CategoryId = category.Id,
                Description = description,
                ManufacturerId = manufacturer.Id,
                SupplierName = supplier,
                Price = price,
                UnitName = unit,
                StockQuantity = stock,
                DiscountPercent = discount,
                PhotoFile = photoFile
            };
            try
            {
                DataService.SaveProduct(model);
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
        private bool TryParseDecimal(string text, out decimal value)
        {
            text = (text ?? "").Trim().Replace(',', '.');
            return decimal.TryParse(text, NumberStyles.Any,
           CultureInfo.InvariantCulture, out value);
        }
        private string CopyPhotoToProject(string sourcePath)
        {
            try
            {
                var ext = System.IO.Path.GetExtension(sourcePath);
                if (string.IsNullOrWhiteSpace(ext)) ext = ".png";
                var fileName = "uploaded_" + DateTime.Now.Ticks +
               ext.ToLowerInvariant();
                var baseDir = AppDomain.CurrentDomain.BaseDirectory;
                var targetDir = System.IO.Path.Combine(baseDir, "resources", "photos");
                if (!Directory.Exists(targetDir))
                    Directory.CreateDirectory(targetDir);
                var targetPath = System.IO.Path.Combine(targetDir, fileName);
                File.Copy(sourcePath, targetPath, true);
                return "resources/photos/" + fileName;
            }
            catch
            {
                return "";
            }
        }
        private void DeleteOldPhoto(string oldPhotoFile)
        {
            try
            {
                var name = System.IO.Path.GetFileName(oldPhotoFile);
                if (string.IsNullOrWhiteSpace(name)) return;
                var baseDir = AppDomain.CurrentDomain.BaseDirectory;
                var path = System.IO.Path.Combine(baseDir, "resources", "photos", name);
                if (File.Exists(path))
                    File.Delete(path);
            }
            catch
            {
            }
        }
        private void SetPreviewFromPack(string packUri)
        {
            try
            {
                PhotoImage.Source = new BitmapImage(new Uri(packUri,
               UriKind.Absolute));
            }
            catch
            {
                PhotoImage.Source = null;
            }
        }
        private BitmapImage LoadBitmap(string filePath)
        {
            try
            {
                var image = new BitmapImage();
                image.BeginInit();
                image.CacheOption = BitmapCacheOption.OnLoad;
                image.UriSource = new Uri(filePath, UriKind.Absolute);
                image.EndInit();
                image.Freeze();
                return image;
            }
            catch
            {
                return null;
            }
        }
    }
}
