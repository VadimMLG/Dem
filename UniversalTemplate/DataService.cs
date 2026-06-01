using MySql.Data.MySqlClient;
using UniversalTemplate;
using UniversalApp;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net.NetworkInformation;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Media.Imaging;
using System.Xml.Linq;

namespace UniversalApp
{
    internal static class DataService
    {
        public static UserInfo Auth(string login, string password)
        {
            using (var conn = Db.GetConnection())
            {
                conn.Open();
                using (var cmd = conn.CreateCommand())
                {
                    cmd.CommandText = @"
                     SELECT u.user_id, u.full_name, r.role_name
                     FROM users u
                     JOIN roles r ON r.role_id = u.role_id
                     WHERE u.login=@login AND u.password_plain=@password";
                    cmd.Parameters.AddWithValue("@login", login);
                    cmd.Parameters.AddWithValue("@password", password);
                    using (var rd = cmd.ExecuteReader())
                    {
                        if (!rd.Read()) return null;
                        return new UserInfo
                        {
                            UserId = rd.GetInt32("user_id"),
                            FullName = rd.GetString("full_name"),
                            RoleName = rd.GetString("role_name")
                        };
                    }
                }
            }
        }
        public static List<ProductRow> GetProducts()
        {
        var result = new List<ProductRow>();
            using (var conn = Db.GetConnection())
            {
                conn.Open();
                using (var cmd = conn.CreateCommand())
                {
                    cmd.CommandText = @"
                     SELECT
                     p.product_id,
                     p.article,
                     p.name,
                     c.name AS category_name,
                     p.description_text,
                     m.name AS manufacturer_name,
                     s.name AS supplier_name,
                     p.price,
                     p.discount_percent,
                     p.unit_name,
                     p.stock_quantity,
                     p.photo_file
                     FROM products p
                     JOIN categories c ON c.category_id = p.category_id
                     JOIN manufacturers m ON m.manufacturer_id =
                    p.manufacturer_id
                     JOIN suppliers s ON s.supplier_id = p.supplier_id
                     ORDER BY p.product_id";
                    using (var rd = cmd.ExecuteReader())
                    {
                        while (rd.Read())
                        {
                            var price = ParseDecimal(rd["price"]);
                            var discount = ParseDecimal(rd["discount_percent"]);
                            var finalPrice = Math.Round(price * (100m - discount) / 100m, 2);
                            var photoFile = rd["photo_file"] == DBNull.Value ? "" : rd["photo_file"].ToString();
                            result.Add(new ProductRow
                            {
                                ProductId = Convert.ToInt32(rd["product_id"]),
                                Article = rd["article"].ToString(),
                                Name = rd["name"].ToString(),
                                Category = rd["category_name"].ToString(),
                                Description = rd["description_text"] ==
                           DBNull.Value ? "" : rd["description_text"].ToString(),
                                Manufacturer =
                           rd["manufacturer_name"].ToString(),
                            Supplier = rd["supplier_name"].ToString(),
                                Price = price,
                                DiscountPercent = discount,
                                FinalPrice = finalPrice,
                                UnitName = rd["unit_name"].ToString(),
                                StockQuantity =
                           Convert.ToInt32(rd["stock_quantity"]),
                                HasDiscount = discount > 0m,
                                PhotoFile = photoFile,
                                PhotoImage = LoadPhoto(photoFile)
                            });
                        }
                    }
                }
            }
            return result;
        }
        public static List<string> GetSupplierNames()
        {
            var result = new List<string>();
            using (var conn = Db.GetConnection())
            {
                conn.Open();
                using (var cmd = conn.CreateCommand())
                {
                    cmd.CommandText = "SELECT name FROM suppliers ORDER BY name";
                    using (var rd = cmd.ExecuteReader())
                    {
                        while (rd.Read())
                            result.Add(rd.GetString("name"));
                    }
                }
            }
            return result;
        }
        public static List<LookupItem> GetCategories()
        {
            return GetLookup("SELECT category_id AS id, name FROM categories ORDER BY name");
        }
        public static List<LookupItem> GetManufacturers()
        {
            return GetLookup("SELECT manufacturer_id AS id, name FROM manufacturers ORDER BY name");
        }
        public static List<LookupItem> GetStatuses()
        {
            return GetLookup("SELECT status_id AS id, status_name AS name FROM order_statuses ORDER BY status_name");
        }
        public static List<LookupItem> GetPickupPoints()
        {
            var result = new List<LookupItem>();
            using (var conn = Db.GetConnection())
            {
                conn.Open();
                using (var cmd = conn.CreateCommand())
                {
                    cmd.CommandText = "SELECT pickup_point_id, address_text FROM pickup_points ORDER BY pickup_point_id";
                using (var rd = cmd.ExecuteReader())
                    {
                        while (rd.Read())
                        {
                            result.Add(new LookupItem
                            {
                                Id = Convert.ToInt32(rd["pickup_point_id"]),
                                Name = rd["pickup_point_id"] + ". " +
                           rd["address_text"]
                            });
                        }
                    }
                }
            }
            return result;
        }
        public static ProductEditModel GetProductById(int productId)
        {
            using (var conn = Db.GetConnection())
            {
                conn.Open();
                using (var cmd = conn.CreateCommand())
                {
                    cmd.CommandText = @"
                     SELECT
                     p.product_id,
                     p.article,
                     p.name,
                     p.category_id,
                     p.description_text,
                     p.manufacturer_id,
                     s.name AS supplier_name,
                     p.price,
                     p.unit_name,
                     p.stock_quantity,
                     p.discount_percent,
                     p.photo_file
                     FROM products p
                     JOIN suppliers s ON s.supplier_id = p.supplier_id
                     WHERE p.product_id = @id";
                    cmd.Parameters.AddWithValue("@id", productId);
                    using (var rd = cmd.ExecuteReader())
                    {
                        if (!rd.Read()) return null;
                        return new ProductEditModel
                        {
                            ProductId = Convert.ToInt32(rd["product_id"]),
                            Article = rd["article"].ToString(),
                            Name = rd["name"].ToString(),
                            CategoryId = Convert.ToInt32(rd["category_id"]),
                            Description = rd["description_text"] ==
                       DBNull.Value ? "" : rd["description_text"].ToString(),
                            ManufacturerId =
                       Convert.ToInt32(rd["manufacturer_id"]),
                            SupplierName = rd["supplier_name"].ToString(),
                            Price = ParseDecimal(rd["price"]),
                            UnitName = rd["unit_name"].ToString(),
                            StockQuantity =
                       Convert.ToInt32(rd["stock_quantity"]),
                            DiscountPercent =
                       ParseDecimal(rd["discount_percent"]),
                            PhotoFile = rd["photo_file"] == DBNull.Value ? "" :
                       rd["photo_file"].ToString()
                        };
                    }
                }
            }
        }
        public static void SaveProduct(ProductEditModel model)
        {
            using (var conn = Db.GetConnection())
            {
                conn.Open();
                using (var tx = conn.BeginTransaction())
                {
                    try
                    {
                        var supplierId = EnsureSupplier(conn, tx, model.SupplierName);
                        using (var cmd = conn.CreateCommand())
                        {
                            cmd.Transaction = tx;
                            if (model.ProductId.HasValue)
                            {
                                cmd.CommandText = @"
                                 UPDATE products
                                 SET
                                 article=@article,
                                 name=@name,
                                 category_id=@categoryId,
                                 description_text=@description,
                                 manufacturer_id=@manufacturerId,
                                 supplier_id=@supplierId,
                                 price=@price,
                                 unit_name=@unitName,
                                 stock_quantity=@stock,
                                 discount_percent=@discount,
                                 photo_file=@photo
                                 WHERE product_id=@id";
                                cmd.Parameters.AddWithValue("@id",
                               model.ProductId.Value);
                            }
                            else
                            {
                                cmd.CommandText = @"
                                 INSERT INTO products(
                                 article, name, category_id,
                                description_text, manufacturer_id,
                                 supplier_id, price, unit_name,
                                stock_quantity, discount_percent, photo_file
                                 )
                                 VALUES(
                                 @article, @name, @categoryId,
                                @description, @manufacturerId,
                                 @supplierId, @price, @unitName, @stock,
                                @discount, @photo
                                 )";
                            }
                            cmd.Parameters.AddWithValue("@article",model.Article);
                            cmd.Parameters.AddWithValue("@name", model.Name);
                            cmd.Parameters.AddWithValue("@categoryId",model.CategoryId);
                            cmd.Parameters.AddWithValue("@description", string.IsNullOrWhiteSpace(model.Description) ? (object)DBNull.Value :model.Description);
                            cmd.Parameters.AddWithValue("@manufacturerId", model.ManufacturerId);cmd.Parameters.AddWithValue("@supplierId", supplierId);
                            cmd.Parameters.AddWithValue("@price", model.Price);
                            cmd.Parameters.AddWithValue("@unitName", model.UnitName);
                            cmd.Parameters.AddWithValue("@stock", model.StockQuantity);
                            cmd.Parameters.AddWithValue("@discount", model.DiscountPercent);
                            cmd.Parameters.AddWithValue("@photo", string.IsNullOrWhiteSpace(model.PhotoFile) ? (object)DBNull.Value :  model.PhotoFile);
                            cmd.ExecuteNonQuery();
                        }
                        tx.Commit();
                    }
                    catch
                    {
                        tx.Rollback();
                        throw;
                    }
                }
            }
        }
        public static bool ProductExistsInOrders(int productId)
        {
            using (var conn = Db.GetConnection())
            {
                conn.Open();
                using (var cmd = conn.CreateCommand())
                {
                    cmd.CommandText = "SELECT COUNT(*) FROM order_items WHERE product_id = @id";
                cmd.Parameters.AddWithValue("@id", productId);
                    return Convert.ToInt32(cmd.ExecuteScalar()) > 0;
                }
            }
        }
        public static void DeleteProduct(int productId)
        {
            using (var conn = Db.GetConnection())
            {
                conn.Open();
                using (var cmd = conn.CreateCommand())
                {
                    cmd.CommandText = "DELETE FROM products WHERE product_id = @id";
                cmd.Parameters.AddWithValue("@id", productId);
                    cmd.ExecuteNonQuery();
                }
            }
        }
        public static List<OrderRow> GetOrders()
        {
            var result = new List<OrderRow>();
            using (var conn = Db.GetConnection())
            {
                conn.Open();
                using (var cmd = conn.CreateCommand())
                {
                    cmd.CommandText = @"
                     SELECT
                     o.order_id,
                     o.order_number,
                     o.article_text,
                     os.status_name,
                     pp.address_text,
                     DATE_FORMAT(NULLIF(o.order_date, '0000-00-00'), '%Y-
                    %m-%d') AS order_date_text,
                     DATE_FORMAT(NULLIF(o.delivery_date, '0000-00-00'),
                    '%Y-%m-%d') AS delivery_date_text
                     FROM orders o
                     JOIN order_statuses os ON os.status_id = o.status_id
                     JOIN pickup_points pp ON pp.pickup_point_id =
                    o.pickup_point_id
                     ORDER BY o.order_number";
                    using (var rd = cmd.ExecuteReader())
                    {
                        while (rd.Read())
                        {
                            result.Add(new OrderRow
                            {
                                OrderId = Convert.ToInt32(rd["order_id"]),
                                OrderNumber =
                           Convert.ToInt32(rd["order_number"]),
                                ArticlesText = rd["article_text"].ToString(),
                                StatusName = rd["status_name"].ToString(),
                                PickupAddress = rd["address_text"].ToString(),
                                OrderDate =
                           ParseNullableDate(rd["order_date_text"]),
                                DeliveryDate =
                           ParseNullableDate(rd["delivery_date_text"])
                            });
                        }
                    }
                }
            }
            return result;
        }
        public static OrderEditModel GetOrderById(int orderId)
        {
            using (var conn = Db.GetConnection())
            {
                conn.Open();
                using (var cmd = conn.CreateCommand())
                {
                    cmd.CommandText = @"
                     SELECT
                     order_id, order_number, article_text, status_id,
                     pickup_point_id,
                     DATE_FORMAT(NULLIF(order_date, '0000-00-00'), '%Y-%m-
                    %d') AS order_date_text,
                     DATE_FORMAT(NULLIF(delivery_date, '0000-00-00'), '%Y-
                    %m-%d') AS delivery_date_text,
                     pickup_code
                     FROM orders
                     WHERE order_id = @id";
                    cmd.Parameters.AddWithValue("@id", orderId);
                    using (var rd = cmd.ExecuteReader())
                    {
                        if (!rd.Read()) return null;
                        return new OrderEditModel
                        {
                            OrderId = Convert.ToInt32(rd["order_id"]),
                            OrderNumber = Convert.ToInt32(rd["order_number"]),
                            ArticlesText = rd["article_text"].ToString(),
                            StatusId = Convert.ToInt32(rd["status_id"]),
                            PickupPointId =
                       Convert.ToInt32(rd["pickup_point_id"]),
                            OrderDate =
                       ParseNullableDate(rd["order_date_text"]) ?? DateTime.Today,
                            DeliveryDate =
                       ParseNullableDate(rd["delivery_date_text"]) ?? DateTime.Today,
                            PickupCode = Convert.ToInt32(rd["pickup_code"])
                        };
                    }
                }
            }
        }
        public static int GetNextOrderNumber()
        {
        using (var conn = Db.GetConnection())
            {
                conn.Open();
                using (var cmd = conn.CreateCommand())
                {
                    cmd.CommandText = "SELECT COALESCE(MAX(order_number), 0) + 1 FROM orders";
                return Convert.ToInt32(cmd.ExecuteScalar());
                }
            }
        }
        public static int GetNextPickupCode()
        {
            using (var conn = Db.GetConnection())
            {
                conn.Open();
                using (var cmd = conn.CreateCommand())
                {
                    cmd.CommandText = "SELECT COALESCE(MAX(pickup_code), 900) + 1 FROM orders";
                return Convert.ToInt32(cmd.ExecuteScalar());
                }
            }
        }
        public static void SaveOrder(OrderEditModel model)
        {
            using (var conn = Db.GetConnection())
            {
                conn.Open();
                using (var tx = conn.BeginTransaction())
                {
                    try
                    {
                        var pairs = ParseOrderArticles(model.ArticlesText);
                        var articleMap = ResolveArticleMap(conn, tx, pairs);
                        int orderId = model.OrderId ?? 0;
                        using (var cmd = conn.CreateCommand())
                        {
                            cmd.Transaction = tx;
                            if (model.OrderId.HasValue)
                            {
                                cmd.CommandText = @"
                                 UPDATE orders
                                 SET
                                 article_text=@articles,
                                 status_id=@statusId,
                                 pickup_point_id=@pickupId,
                                 order_date=@orderDate,
                                 delivery_date=@deliveryDate
                                 WHERE order_id=@id";
                                cmd.Parameters.AddWithValue("@id",
                               model.OrderId.Value);
                            }
                            else
                            {
                                cmd.CommandText = @"
                                 INSERT INTO orders(
                                 order_number, article_text, order_date,
                                 delivery_date,
                                 pickup_point_id, client_user_id,
                                pickup_code, status_id
                                 )
                                 VALUES(
                                 @orderNumber, @articles, @orderDate,
                                 @deliveryDate,
                                 @pickupId, NULL, @pickupCode, @statusId
                                 )";
                                cmd.Parameters.AddWithValue("@orderNumber",
                               model.OrderNumber);
                                cmd.Parameters.AddWithValue("@pickupCode",
                               model.PickupCode);
                            }
                            cmd.Parameters.AddWithValue("@articles",
                           model.ArticlesText);
                            cmd.Parameters.AddWithValue("@statusId",
                           model.StatusId);
                            cmd.Parameters.AddWithValue("@pickupId",
                           model.PickupPointId);
                            cmd.Parameters.AddWithValue("@orderDate",
                           model.OrderDate.Date);
                            cmd.Parameters.AddWithValue("@deliveryDate",
                           model.DeliveryDate.Date);
                            cmd.ExecuteNonQuery();
                            if (!model.OrderId.HasValue)
                                orderId = (int)cmd.LastInsertedId;
                        }
                        using (var cmd = conn.CreateCommand())
                        {
                            cmd.Transaction = tx;
                            cmd.CommandText = "DELETE FROM order_items WHERE order_id = @orderId";
                        cmd.Parameters.AddWithValue("@orderId", orderId);
                        cmd.ExecuteNonQuery();
                        }
                        foreach (var p in pairs)
                        {
                            using (var cmd = conn.CreateCommand())
                            {
                                cmd.Transaction = tx;
                                cmd.CommandText = "INSERT INTO order_items(order_id, product_id, quantity) VALUES(@orderId, @productId, @qty)";
                            cmd.Parameters.AddWithValue("@orderId", orderId);
                                cmd.Parameters.AddWithValue("@productId",
                               articleMap[p.Article]);
                                cmd.Parameters.AddWithValue("@qty", p.Quantity);
                                cmd.ExecuteNonQuery();
                            }
                        }
                        tx.Commit();
                    }
                    catch
                    {
                        tx.Rollback();
                        throw;
                    }
                }
            }
        }
        public static void DeleteOrder(int orderId)
        {
            using (var conn = Db.GetConnection())
            {
                conn.Open();
                using (var cmd = conn.CreateCommand())
                {
                    cmd.CommandText = "DELETE FROM orders WHERE order_id=@id";
                    cmd.Parameters.AddWithValue("@id", orderId);
                    cmd.ExecuteNonQuery();
                }
            }
        }
        private static List<OrderArticlePair> ParseOrderArticles(string text)
        {
            var tokens = (text ?? "")
            .Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries)
            .Select(x => x.Trim())
            .Where(x => x.Length > 0)
            .ToList();

            if (tokens.Count < 2 || tokens.Count % 2 != 0)
                throw new Exception("Поле артикулов задается парами: артикул,количество.");
                var result = new List<OrderArticlePair>();
            for (int i = 0; i < tokens.Count; i += 2)
            {
                int qty;
                if (!int.TryParse(tokens[i + 1], out qty))
                    throw new Exception("Количество в паре артикулов должно быть целым числом.");
            if (qty <= 0)
                    throw new Exception("Количество в паре артикулов должно быть больше 0.");
                   
                    result.Add(new OrderArticlePair
                    {
                        Article = tokens[i],
                        Quantity = qty
                    });
            }
            return result;
        }
        private static Dictionary<string, int> ResolveArticleMap(MySqlConnection
       conn, MySqlTransaction tx, List<OrderArticlePair> pairs)
        {
            var uniqueArticles = pairs.Select(x =>
           x.Article).Distinct().ToList();
            var result = new Dictionary<string,
           int>(StringComparer.OrdinalIgnoreCase);
            using (var cmd = conn.CreateCommand())
            {
                cmd.Transaction = tx;
                var paramNames = new List<string>();
                for (int i = 0; i < uniqueArticles.Count; i++)
                {
                    var p = "@a" + i;
                    paramNames.Add(p);
                    cmd.Parameters.AddWithValue(p, uniqueArticles[i]);
                }
                cmd.CommandText = "SELECT article, product_id FROM products WHERE article IN(" + string.Join(",", paramNames) + ")";
            using (var rd = cmd.ExecuteReader())
                {
                    while (rd.Read())
                        result[rd["article"].ToString()] = Convert.ToInt32(rd["product_id"]);
                }
            }
            var missing = uniqueArticles.Where(x => !
           result.ContainsKey(x)).ToList();
            if (missing.Count > 0)
                throw new Exception("В таблице products не найдены артикулы: " +
               string.Join(", ", missing));
            return result;
        }
        private static int EnsureSupplier(MySqlConnection conn, MySqlTransaction
       tx, string supplierName)
        {
            using (var cmd = conn.CreateCommand())
            {
                cmd.Transaction = tx;
                cmd.CommandText = "SELECT supplier_id FROM suppliers WHERE name = @name";
            cmd.Parameters.AddWithValue("@name", supplierName);
                var exists = cmd.ExecuteScalar();
                if (exists != null && exists != DBNull.Value)
                    return Convert.ToInt32(exists);
            }
            using (var cmd = conn.CreateCommand())
            {
                cmd.Transaction = tx;
                cmd.CommandText = "INSERT INTO suppliers(name) VALUES(@name)";
                cmd.Parameters.AddWithValue("@name", supplierName);
                cmd.ExecuteNonQuery();
                return (int)cmd.LastInsertedId;
            }
        }
        private static List<LookupItem> GetLookup(string sql)
        {
            var result = new List<LookupItem>();
            using (var conn = Db.GetConnection())
            {
                conn.Open();
                using (var cmd = conn.CreateCommand())
                {
                    cmd.CommandText = sql;
                    using (var rd = cmd.ExecuteReader())
                    {
                    while (rd.Read())
                        {
                            result.Add(new LookupItem
                            {
                                Id = Convert.ToInt32(rd["id"]),
                                Name = rd["name"].ToString()
                            });
                        }
                    }
                }
            }
            return result;
        }
        private static decimal ParseDecimal(object value)
        {
            if (value == null || value == DBNull.Value) return 0m;
            return Convert.ToDecimal(value, CultureInfo.InvariantCulture);
        }
        private static DateTime? ParseNullableDate(object value)
        {
            if (value == null || value == DBNull.Value) return null;
            var text = value.ToString();
            if (string.IsNullOrWhiteSpace(text)) return null;
            DateTime date;
            if (DateTime.TryParse(text, out date))
                return date.Date;
            return null;
        }
        private static BitmapImage LoadPhoto(string fileName)
        {
            if (!string.IsNullOrWhiteSpace(fileName))
            {
                var cleanName = Path.GetFileName(fileName.Trim());
                var runtimePath =
               Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "resources", "photos",
               cleanName);
                if (File.Exists(runtimePath))
                {
                    return LoadBitmap(new Uri(runtimePath, UriKind.Absolute));
                }
                var packPhoto = $"pack://application:,,,/resources/photos/{ cleanName}";
            try
        
            {
                return LoadBitmap(new Uri(packPhoto, UriKind.Absolute));
            }
            catch
            {
            }
        }
            return LoadBitmap(new Uri("pack://application:,,,/resources/picture.png", UriKind.Absolute));
        }
        private static BitmapImage LoadBitmap(Uri uri)
        {
            var image = new BitmapImage();
            image.BeginInit();
            image.CacheOption = BitmapCacheOption.OnLoad;
            image.UriSource = uri;
            image.EndInit();
            image.Freeze();
            return image;
        }
        private class OrderArticlePair
        {
            public string Article { get; set; }
            public int Quantity { get; set; }
        }
    }
}