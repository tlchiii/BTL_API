namespace BTL_API_VanPhongPham.Models
{
    public class ChiTietSP
    {
        public string MaChiTietSanPham { get; set; } = null!;
        public string? MaSanPham { get; set; }
        public string? TenSanPham { get; set; }
        public string? TenMau { get; set; }
        public string? AnhDaiDien { get; set; }
        public double? DonGiaBan { get; set; }
    }
}
