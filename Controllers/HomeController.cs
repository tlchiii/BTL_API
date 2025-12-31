using System.Diagnostics;
using System.Runtime.InteropServices;
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

        public async Task<IActionResult> MuaNgay(string machitietsp, int sl)
        {
            List<ChiTietSP> sp = new List<ChiTietSP>();
            float tong = 0;
            ViewBag.sl = (sl == null) ? 1 : sl;
            try
            {
                var client = _clientFactory.CreateClient();
                var response = await client.GetAsync("http://127.0.0.1:5000/sp/chitietsp?machitiet=" + machitietsp);
                if (response.IsSuccessStatusCode)
                {
                    sp = await response.Content.ReadFromJsonAsync<List<ChiTietSP>>();

                    tong = (float)(Convert.ToInt32(sl) * sp[0].DonGiaBan);
                    ViewBag.tong = tong;
                }

               

                Console.WriteLine(tong);
                return View("BuyNow", sp[0]);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }

            
            return View("BuyNow", sp);
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

        //public async Task<IActionResult> CheckOut()
        //{
        //    return View() ;
        //}

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
