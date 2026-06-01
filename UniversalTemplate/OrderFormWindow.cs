using System;

namespace UniversalApp
{
    internal partial class OrdersFormWindow
    {
        private object value;

        public OrdersFormWindow(object value)
        {
            this.value = value;
        }

        public OrdersWindow Owner { get; set; }

        internal bool ShowDialog()
        {
            throw new NotImplementedException();
        }
    }
}