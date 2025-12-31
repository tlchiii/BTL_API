using BTL_API_VanPhongPham.Models;
using Microsoft.AspNetCore.Mvc;

namespace BTL_API_VanPhongPham.Controllers
{
    public class CartController : Controller
    {
        private readonly ILogger<HomeController> _logger;
        private readonly IHttpClientFactory _clientFactory;

        public CartController(ILogger<HomeController> logger, IHttpClientFactory clientFactory)
        {
            _logger = logger;
            _clientFactory = clientFactory;
        }

        public async Task<IActionResult> Index()
        {
            GioHang carts = new GioHang();

            return View("Cart");
        }

        public async Task<IActionResult> ThanhToan()
        {
            return View("CheckOut");
        }

    }
}
