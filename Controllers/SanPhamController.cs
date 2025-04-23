using BTL_API_VanPhongPham.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.AspNetCore.WebUtilities;
using System.Text.Json;
using static System.Net.Mime.MediaTypeNames;

namespace BTL_API_VanPhongPham.Controllers
{
    public class SanPhamController : Controller
    {
        private readonly ILogger<HomeController> _logger;
        private readonly IHttpClientFactory _clientFactory;

        public SanPhamController(ILogger<HomeController> logger, IHttpClientFactory clientFactory)
        {
            _logger = logger;
            _clientFactory = clientFactory;

        }
        //public IActionResult Index()
        //{
        //    return View("Products");
        //}

        private int pageSize = 6;
        //public async Task<IActionResult> Index(string? maloai, string? tk,string? tenloai)
        //{
        //    List<SanPham> products = new();
        //    try
        //    {
        //        var client = _clientFactory.CreateClient();
        //        var response = await client.GetAsync("http://127.0.0.1:5000/all");
        //        var res_loai = await client.GetAsync("http://127.0.0.1:5000/api/sanpham/loai?maloai=" + maloai);
        //        var res_search = await client.GetAsync("http://127.0.0.1:5000/api/sanpham/search?tentk=" + tk);
        //        if (response.IsSuccessStatusCode)
        //        {
        //            products = await response.Content.ReadFromJsonAsync<List<SanPham>>();


        //        }

        //        if (maloai != null&& res_loai.IsSuccessStatusCode)
        //        {
        //            products  = await res_loai.Content.ReadFromJsonAsync<List<SanPham>>();
        //            ViewBag.maloai = maloai;
        //            ViewBag.tl = tenloai;
        //        }

        //        if(tk != null&& res_search.IsSuccessStatusCode)
        //        {
        //            products = await res_search.Content.ReadFromJsonAsync<List<SanPham>>();
        //            ViewBag.TenTK = tk;

        //        }


        //        Console.WriteLine("Tổng sản phẩm: " + products.Count);
        //        if (products.Count() > 0)
        //        {
        //            //tinh so trang
        //                int pageNum = (int)Math.Ceiling(products.Count() / (float)pageSize);
        //            //luu so trang bang viewbag
        //            ViewBag.pageNum = pageNum;
        //            //lay du lieu trang dau
        //            var page1 = products.Take(pageSize).ToList();

        //            return View("Products",page1); // truyền list vào view
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        return BadRequest(ex.Message);
        //    }
        //    return NotFound();
        //}

        public async Task<IActionResult> Index(string? maloai, string? tk, string? tenloai)
        {
            List<SanPham> products = new();
            
                try
                {
                    // Tạo query string
                    var queryParams = new Dictionary<string, string?>
                    {
                      { "maloai", maloai },
                       { "tentk", tk }
                    };


                    // Dùng QueryHelpers để gắn query string vào URL
                    var fullUrl = QueryHelpers.AddQueryString("http://127.0.0.1:5000/api/sanpham/loc", queryParams);

                    var client = _clientFactory.CreateClient();
                    // Gọi GET
                    var response = await client.GetAsync(fullUrl);
                    //var response = await client.GetAsync("http://127.0.0.1:5000/api/sanpham/loc");


                    if (response.IsSuccessStatusCode)
                    {
                        var data = await response.Content.ReadFromJsonAsync<phantrang>();
                        //luu lai bang viewbag
                        ViewBag.pageNum = data.pageNum;
                        products = data.products;

                    }

                    ViewBag.maloai = maloai;
                    ViewBag.TenTK = tk;
                    ViewBag.tl = tenloai;

                    return View("Products", products);
                }
            
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }

            return View("Products", products);
        }




        //public IActionResult Products(string? maloai)
        //{
        //    //var listSanPham = db.SanPhams.ToList();
        //    var listSanPham = (IQueryable<SanPham>)db.SanPhams.Include(m => m.MaLoaiHangNavigation);
        //    if (maloai != null)
        //    {
        //        listSanPham = (IQueryable<SanPham>)db.SanPhams.Where(m => m.MaLoaiHang == maloai).Include(l => l.MaLoaiHangNavigation);
        //    }


        //    //tinh so trang
        //    int pageNum = (int)Math.Ceiling(listSanPham.Count() / (float)pageSize);
        //    //luu so trang bang viewbag
        //    ViewBag.pageNum = pageNum;
        //    //lay du lieu trang dau
        //    var page1 = listSanPham.Take(pageSize).ToList();

        //    return View("Products", page1);


        public async Task<IActionResult> ChiTiet(string masp)
        {
            // Sử dụng masp để truy vấn DB hoặc xử lý logic
            //ViewBag.MaSanPham = masp;
            //return View("ProductDetail");

            List<ChiTietSP> spChiTiet = new();
            List<SanPham> sp = new();
            List<Anh> img = new();
            ViewBag.masp = masp;
            
            try
            {
                var client = _clientFactory.CreateClient();
                var response = await client.GetAsync(" http://127.0.0.1:5000/sp/search?masp=" + masp);
                var response_img = await client.GetAsync("http://127.0.0.1:5000/sp/Image?masp=" + masp);
                var response_ChiTiet = await client.GetAsync("http://127.0.0.1:5000/sp/chitiet?masp=" + masp);


                if (response.IsSuccessStatusCode)
                {
                    sp = await response.Content.ReadFromJsonAsync<List<SanPham>>();
                    spChiTiet = await response_ChiTiet.Content.ReadFromJsonAsync<List<ChiTietSP>>();
                    img = await response_img.Content.ReadFromJsonAsync<List<Anh>>();

                }

                if (img != null && img.Count > 0)
                {
                    ViewBag.AnhSP = img;
                }
                else
                {
                    ViewBag.AnhSP = new List<Anh>(); // tránh null
                }
                Console.WriteLine(img);
                Console.WriteLine("Tổng sản phẩm: " + spChiTiet.Count);
                if (sp.Count() > 0)
                {
                    ViewBag.TenSP = sp[0].TenSanPham;
                    ViewBag.GiaToiDa = sp[0].GiaToiDa;
                    ViewBag.GiaToiThieu = sp[0].GiaToiThieu;
                    ViewBag.ChiTiet = sp[0].ChiTiet;
                    ViewBag.Maloai = sp[0].MaLoaiHang;
                    return View("ProductDetail", spChiTiet); // truyền list vào view
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }

            return View("ProductDetail", spChiTiet);
        }

        public async Task<IActionResult> SPLienQuan(string maloai)
        {
            List<SanPham> sp = new();

            try
            {
                var client = _clientFactory.CreateClient();
                var response = await client.GetAsync("http://127.0.0.1:5000/api/splq?maloai=" + maloai);


                if (response.IsSuccessStatusCode)
                {
                    sp = await response.Content.ReadFromJsonAsync<List<SanPham>>();

                    //Console.WriteLine("Tổng sản phẩm: " + sp.Count);
                    if (sp.Count() > 0)
                    {
                        //ViewBag.TenSP = sp[0].TenSanPham;
                        //ViewBag.GiaToiDa = sp[0].GiaToiDa;
                        //ViewBag.GiaToiThieu = sp[0].GiaToiThieu;
                        //ViewBag.ChiTiet = sp[0].ChiTiet;
                        //ViewBag.Maloai = sp[0].MaLoaiHang;

                        return PartialView("PartialSanPham", sp);
                    }

                }

                
            }
            catch (Exception ex)
            {
               Console.WriteLine($"Could not find {ex.Message}");
            }

            return PartialView("PartialSanPham", new List<SanPham>()); // Tránh lỗi view nếu rỗng
        }

        //public async Task<IActionResult> LocSP(string? maloai, string? tentk, int? pageindex, string? loaisx)
        //{
        //    //lay toan bo san pham
        //    List<SanPham> products = new();

        //    //lay so trang , neu null thi gan = 1
        //    int page = (int)(pageindex == null || pageindex <= 0 ? 1 : pageindex);
            
        //    try
        //    {
        //        var client = _clientFactory.CreateClient();
        //        var response = await client.GetAsync("http://127.0.0.1:5000/all");
        //        //var res_loai = await client.GetAsync("http://127.0.0.1:5000/api/sanpham/loai?maloai=" + maloai);
        //        var res_tk = await client.GetAsync("http://127.0.0.1:5000/api/sanpham/search?tentk=" + tentk);
        //        var sxTenAZ = await client.GetAsync("http://127.0.0.1:5000/api/sx/tenAZ");
        //        var sxTenZA = await client.GetAsync("http://127.0.0.1:5000/api/sx/tenZA");
        //        var sxGiaGiam = await client.GetAsync("http://127.0.0.1:5000/api/sx/giagiam");
        //        var sxGiaTang = await client.GetAsync("http://127.0.0.1:5000/api/sx/giatang");

        //        if (response.IsSuccessStatusCode)
        //        {
        //            products = await response.Content.ReadFromJsonAsync<List<SanPham>>();
        //        }

        //        //neu co ma loai thi loc theo ma loai
        //        if (maloai != null)
        //        {
        //            products = products.Where(x => x.MaLoaiHang == maloai).ToList();
        //            ViewBag.maloai = maloai;
        //        }

        //        //neu co tu khoa tim kiem theo ten
        //        if (tentk != null)
        //        {
        //            //tim kiem
        //            products = await res_tk.Content.ReadFromJsonAsync<List<SanPham>>();
        //            //string json = await res_tk.Content.ReadAsString
        //            //luu tu khoa tim kie bang viwbag
        //            ViewBag.TenTK = tentk;
        //        }

        //        if(loaisx != null)
        //        {
        //            switch(loaisx)
        //            {
        //                case "AZ":
        //                    products = (List<SanPham>?)products.OrderBy(p => p.TenSanPham);
        //                    break;
        //                case "ZA":
        //                    products = (List<SanPham>?)products.OrderByDescending(p => p.TenSanPham);
        //                    break;
        //                case "giagiam":
        //                    products = (List<SanPham>?)products.OrderByDescending(p => p.GiaToiThieu);
        //                    break;
        //                case "giatang":
        //                    products = (List<SanPham>?)products.OrderBy(p => p.GiaToiThieu);
        //                    break;

        //            }
        //            ViewBag.loaisx = loaisx;  
                    
        //        }

        //        //tinh so trang
        //        int pageNum = (int)Math.Ceiling(products.Count() / (float)pageSize);
        //        //luu lai bang viewbag
        //        ViewBag.pageNum = pageNum;
        //        ViewBag.pageIndex = page ;

        //        //chọn dữ liệu hiên thi cho trang hien tại
        //        var ketqua = products.Skip(pageSize * (page - 1))
        //                     .Take(pageSize);

        //        return PartialView("dsSanPham", ketqua);
        //    }
        //    catch (Exception ex)
        //    {
        //        return BadRequest(ex.Message);
        //    }
        //    return NotFound();
        //}

        public async Task<IActionResult> Loc(string? maloai, string? tentk, int? pageindex, string? loaisx)
        {
            //lay toan bo san pham
            List<SanPham> products = new();
           
            try
            {
                // Tạo query string
                var queryParams = new Dictionary<string, string?>
                {
                     { "maloai", maloai },
                     { "tentk", tentk },
                     { "pageindex", pageindex?.ToString() },
                     { "loaisx", loaisx }
                };
                 
                
                // Dùng QueryHelpers để gắn query string vào URL
                 var fullUrl = QueryHelpers.AddQueryString("http://127.0.0.1:5000/api/sanpham/loc", queryParams);

                var client = _clientFactory.CreateClient();
                // Gọi GET
                var response = await client.GetAsync(fullUrl);
                //var response = await client.GetAsync("http://127.0.0.1:5000/api/sanpham/loc");
              

                if (response.IsSuccessStatusCode)
                {
                    var data = await response.Content.ReadFromJsonAsync<phantrang>();
                    //luu lai bang viewbag
                    ViewBag.pageNum = data.pageNum;
                    products = data.products;

                }

                ViewBag.maloai = maloai;
                ViewBag.TenTK = tentk;
                ViewBag.loaisx = loaisx;
                ViewBag.pageIndex = pageindex <= 0 ? 1 : pageindex;

                return PartialView("dsSanPham", products);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }

            return PartialView("dsSanPham", products);
        }



    }
}
