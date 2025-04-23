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
        //public IActionResult Index()
        //{
        //    return View();
        //}

        public async Task<IActionResult> Index()
        {
            GioHang carts = new GioHang();
            try
            {
                var client = _clientFactory.CreateClient();
                var response = await client.GetAsync("http://127.0.0.1:5000/cart");
                if (response.IsSuccessStatusCode)
                {
                    carts = await response.Content.ReadFromJsonAsync<GioHang>();
                }

                //        if (products.Count() > 0)
                //        {
                //            return View(products); // truyền list vào view
                //        }
                return View("Cart");
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
            return View("Cart", carts);
        }


    }
}
