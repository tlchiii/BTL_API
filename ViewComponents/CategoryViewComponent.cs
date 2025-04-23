using BTL_API_VanPhongPham.Models;
using Microsoft.AspNetCore.Mvc;

namespace VanPhongPham.ViewComponents
{
    public class CategoryViewComponent : ViewComponent
    {
        
        private readonly IHttpClientFactory _clientFactory;
        public CategoryViewComponent(IHttpClientFactory clientFactory)
        {
            _clientFactory = clientFactory;
        }

        public async Task<IViewComponentResult> InvokeAsync()
        {

            List<LoaiHang> category = new();
            try
            {
                var client = _clientFactory.CreateClient();
                var response = await client.GetAsync("http://127.0.0.1:5000/DanhMuc");

                if (response.IsSuccessStatusCode)
                {
                    category = await response.Content.ReadFromJsonAsync<List<LoaiHang>>();
                }

                Console.WriteLine("Tổng loai hang: " + category.Count);
                if (category.Count() > 0)
                {

                    return View(category); // truyền list vào view
                }
            }
            catch (Exception ex)
            {
                return View(category);
            }

            return View(category);
        }

        //public IViewComponentResult Invoke()
        //{
        //}
    }
}
