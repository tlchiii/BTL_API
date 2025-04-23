using Microsoft.AspNetCore.Mvc;

namespace BTL_API_VanPhongPham.Models
{
    public class Anh : Controller
    {
        public string MaSanPham { get; set; }
        public string? TenHinhAnh { get; set; }
    }
}
