namespace BTL_API_VanPhongPham.Models
{
    public class CartItem
    {
        //public ChiTietSP SanPham { get; set; }
        public string MaChiTietSanPham { get; set; }
        public string? TenSanPham { get; set; }
        public double? DonGiaBan { get; set; }
        public string? HinhAnhSanPham { get; set; }
        public string TenMau { get; set; } 
        public int SoLuong { get; set; }
        
        public CartItem() { }

         public CartItem(string maChiTietSanPham, string? tenSanPham, double? donGiaBan, string? hinhAnhSanPham, string tenMau, int soLuong)
        {
            MaChiTietSanPham = maChiTietSanPham;
            TenSanPham = tenSanPham;
            DonGiaBan = donGiaBan;
            HinhAnhSanPham = hinhAnhSanPham;
            TenMau = tenMau;
            SoLuong = soLuong;
        }
    }
}
