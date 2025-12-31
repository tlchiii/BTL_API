namespace BTL_API_VanPhongPham.Models
{
    public class SanPham
    {
        public string MaSanPham { get; set; } 
        public string? TenSanPham { get; set; }
        public decimal? GiaToiThieu { get; set; }
        public decimal? GiaToiDa { get; set; }
        public int? SoLuongTon { get; set; }
        public string? HinhAnhSanPham { get; set; }
        public string? ChiTiet { get; set; }
        public string MaLoaiHang { get; set; }

        public SanPham()
        {

        }

    }
}
