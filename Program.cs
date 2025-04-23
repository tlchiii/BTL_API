namespace BTL_API_VanPhongPham
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);

            // Add services to the container.
            builder.Services.AddControllersWithViews();

            builder.Services.AddHttpClient();

            // 1.Cấu hình chính sách CORS
            builder.Services.AddCors(options =>
            {
                options.AddPolicy("AllowOriginWithCredentials", policy =>
                {
                    policy.WithOrigins("http://localhost:7261") // địa chỉ frontend
                          .AllowCredentials()
                          .AllowAnyHeader()
                          .AllowAnyMethod();
                });
            });


            var app = builder.Build();

            // Configure the HTTP request pipeline.
            if (!app.Environment.IsDevelopment())
            {
                app.UseExceptionHandler("/Home/Error");
                // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
                app.UseHsts();
            }

            


            app.UseHttpsRedirection();
            app.UseStaticFiles();

            // 2. Áp dụng CORS
            app.UseCors("AllowOriginWithCredentials");

            app.UseRouting();

            app.UseAuthorization();

            app.MapControllerRoute(
                name: "default",
                pattern: "{controller=Home}/{action=Index}/{id?}");

            app.Run();
        }
    }
}