using System.Diagnostics;
using BTL_API_VanPhongPham.Models;
using Microsoft.AspNetCore.Mvc;

namespace BTL_API_VanPhongPham.Controllers
{
    public class HomeController : Controller
    {
        private readonly ILogger<HomeController> _logger;
        private readonly IHttpClientFactory _clientFactory;

        public HomeController(ILogger<HomeController> logger,IHttpClientFactory clientFactory)
        {
            _logger = logger;
            _clientFactory = clientFactory;

        }

        public async Task<IActionResult> Index()
        {
            List<SanPham> products = new();
            try
            {
                var client = _clientFactory.CreateClient();
                var res_noibat = await client.GetAsync("http://127.0.0.1:5000/home/noibat");
                var res_ganday = await client.GetAsync("http://127.0.0.1:5000/Home/ganday");

                if (res_noibat.IsSuccessStatusCode)
                {
                    products = await res_noibat.Content.ReadFromJsonAsync<List<SanPham>>();
                }

                Console.WriteLine("Tổng sản phẩm: " + products.Count);
                if (products.Count() > 0)
                {

                    return View(products); // truyền list vào view
                }
            }
            catch (Exception ex)
            {
                //return BadRequest(ex.Message);
                Console.WriteLine(ex.Message);
            }

            return View(products);
        }

        public async Task<IActionResult> DanhMucSP()
        {
            return View("Products");
        }

        public async Task<IActionResult> MuaNgay()
        {
            return View("CheckOut");
        }


        public async Task<IActionResult> Cart()
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

        public async Task<IActionResult> CheckOut()
        {
            return View() ;
        }

        public IActionResult Privacy()
        {
            return View();
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}
