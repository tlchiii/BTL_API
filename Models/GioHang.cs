namespace BTL_API_VanPhongPham.Models
{
    public class GioHang
    {
        public List<CartItem> items {  get; set; }

        public GioHang()
        {
            items = new List<CartItem>();
        }

        

        public CartItem getCartItemById(string maChiTietSP)
        {
            foreach(CartItem i in items)
            {
                if(i.MaChiTietSanPham== maChiTietSP)
                {
                    return i;
                }
            }

            return null;
        }
        public decimal total()
        {
            decimal sum = 0;
            foreach(CartItem i in items)
            {
                sum += (decimal)(i.SoLuong* i.DonGiaBan);
            }

            return sum;
        }
    }
}
