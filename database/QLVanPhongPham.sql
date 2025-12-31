--create database QLVanPhongPham
--use QLVanPhongPham
-- Bảng Loại Hàng
create TABLE LoaiHang(
    MaLoaiHang NVARCHAR(25) NOT NULL,
    TenLoaiHang NVARCHAR(100) NULL,
    CONSTRAINT [PK_LoaiHang] PRIMARY KEY CLUSTERED 
    (
        [MaLoaiHang] ASC
    )
) ON [PRIMARY];

-- Sản phẩm
CREATE TABLE SanPham (
    MaSanPham NVARCHAR(25) NOT NULL,
    TenSanPham NVARCHAR(100) NULL,
    GiaToiThieu MONEY NULL,
    GiaToiDa MONEY NULL,
    SoLuongTon INT NULL,
    HinhAnhSanPham CHAR(100) NULL,
    ChiTiet NVARCHAR(1000) NULL,
    MaLoaiHang NVARCHAR(25) NOT NULL,
    CONSTRAINT [PK_SanPham] PRIMARY KEY CLUSTERED 
    (
        [MaSanPham] ASC
    ),
    CONSTRAINT [FK_SanPham_LoaiHang] FOREIGN KEY([MaLoaiHang])
    REFERENCES LoaiHang ([MaLoaiHang])
) ON [PRIMARY];

-- Nhà cung cấp
CREATE TABLE NhaCungCap (
    MaNhaCungCap NVARCHAR(25) NOT NULL,
    TenNhaCungCap NVARCHAR(100) NOT NULL,
    SoDienThoai CHAR(15) NULL,
    Email VARCHAR(50) NULL,
    DiaChiNhaCungCap NVARCHAR(100) NULL,
    CONSTRAINT [PK_NhaCungCap] PRIMARY KEY CLUSTERED 
    (
        [MaNhaCungCap] ASC
    )
) ON [PRIMARY];

-- Hóa đơn nhập hàng

-- Chi tiết hóa đơn nhập

--drop table MauSac
-- Bảng màu sắc
CREATE TABLE MauSac (
    MaMau Char(25) PRIMARY KEY,
    TenMau NVARCHAR(100) NOT NULL
);

-- Tạo bảng chương trình khuyến mãi
CREATE TABLE ChuongTrinhKhuyenMai (
    MaCTKM INT IDENTITY(1,1) PRIMARY KEY,
    ChuDe NVARCHAR(255),
    NoiDung NVARCHAR(MAX),
    NgayBatDau DATE,
    NgayKetThuc DATE
);

 -- Bình luận 
 CREATE TABLE NguoiBinhLuan (
    MaNguoiDung INT IDENTITY(1,1) PRIMARY KEY,
    TenNguoiDung NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) UNIQUE NOT NULL
);

select * from NguoiBinhLuan

delete from NguoiBinhLuan
delete from DanhGiaSanPham


CREATE TABLE DanhGiaSanPham (
    MaDanhGia INT IDENTITY(1,1) PRIMARY KEY,
    MaSanPham NVARCHAR(25) NOT NULL,
    MaNguoiDung INT NOT NULL,
    SoSao INT CHECK (SoSao BETWEEN 1 AND 5),
    NoiDung NVARCHAR(MAX),
    ThoiGian DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_DanhGiaSanPham_SanPham FOREIGN KEY (MaSanPham) 
        REFERENCES SanPham(MaSanPham),
    CONSTRAINT FK_DanhGiaSanPham_NguoiDung FOREIGN KEY (MaNguoiDung)
        REFERENCES NguoiBinhLuan(MaNguoiDung)
);

-- Người dùng
CREATE TABLE NguoiDung (
    MaNguoiDung NVARCHAR(25) NOT NULL,
    TenNguoiDung NVARCHAR(100) NULL,
    TaiKhoan VARCHAR(50) NOT NULL,
    MatKhau VARCHAR(10) NOT NULL,
    NgaySinh DATETIME NULL,
    SoDienThoai CHAR(15) NULL,
    Email VARCHAR(50) NULL,
    DiaChi NVARCHAR(100) NULL,
    AnhDaiDien CHAR(100) NULL,
    LoaiNguoiDung INT CHECK (LoaiNguoiDung IN (1, 2, 3)) NULL,
    CONSTRAINT [PK_NguoiDung] PRIMARY KEY CLUSTERED 
    (
        [MaNguoiDung] ASC
    )
) ON [PRIMARY];

-- Hóa đơn bán hàng
CREATE TABLE HoaDonBan (
    MaHoaDonBan NVARCHAR(25) NOT NULL,
    NgayBan DATETIME NULL,
    TongTien MONEY NULL,
    MaNguoiDung NVARCHAR(25) NULL,
    CONSTRAINT [PK_HoaDonBan] PRIMARY KEY CLUSTERED 
    (
        [MaHoaDonBan] ASC
    ),
    CONSTRAINT [FK_HoaDonBan_NguoiDung] FOREIGN KEY([MaNguoiDung])
    REFERENCES NguoiDung ([MaNguoiDung])
) ON [PRIMARY];

-- Chi tiết hóa đơn bán
CREATE TABLE ChiTietHoaDonBan (
    MaHoaDonBan NVARCHAR(25) NOT NULL,
    MaChiTietSanPham NVARCHAR(25) NOT NULL,
    SoLuongBan INT NULL,
    GiaBan MONEY NULL,
    KhuyenMai FLOAT NULL,
    CONSTRAINT [PK_ChiTietHoaDonBan] PRIMARY KEY CLUSTERED 
    (
        [MaHoaDonBan] ASC,
        [MaChiTietSanPham] ASC
    ),
    CONSTRAINT [FK_ChiTietHoaDonBan_HoaDonBan] FOREIGN KEY([MaHoaDonBan])
    REFERENCES HoaDonBan ([MaHoaDonBan]),
    CONSTRAINT [FK_ChiTietHoaDonBan_SanPham] FOREIGN KEY([MaChiTietSanPham])
    REFERENCES ChiTietSanPham ([MaChiTietSanPham])
) ON [PRIMARY];

-- Hình ảnh sản phẩm
CREATE TABLE HinhAnhSanPham (
    MaSanPham NVARCHAR(25) NOT NULL,
    TenHinhAnh CHAR(100) NOT NULL,
    CONSTRAINT [PK_HinhAnhSanPham] PRIMARY KEY CLUSTERED 
    (
        [MaSanPham] ASC,
        [TenHinhAnh] ASC
    ),
    CONSTRAINT [FK_HinhAnhSanPham_SanPham] FOREIGN KEY([MaSanPham])
    REFERENCES SanPham ([MaSanPham])
) ON [PRIMARY];

-- Chi tiết sản phẩm
CREATE TABLE ChiTietSanPham (
    MaChiTietSanPham NVARCHAR(25) NOT NULL,
    MaSanPham NVARCHAR(25) NULL,
    MaMauSac CHAR(25) NULL,
    AnhDaiDien CHAR(100) NULL,
    Video CHAR(100) NULL,
    DonGiaBan FLOAT NULL,
    GiamGia FLOAT NULL,
    SoLuongTon INT NULL,
    CONSTRAINT [PK_ChiTietSanPham] PRIMARY KEY CLUSTERED 
    (
        [MaChiTietSanPham] ASC
    ),
    CONSTRAINT [FK_ChiTietSanPham_SanPham] FOREIGN KEY([MaSanPham])
    REFERENCES SanPham ([MaSanPham])
) ON [PRIMARY];

-- Thêm khóa ngoại cho bảng SanPham, tham chiếu đến LoaiHang
ALTER TABLE SanPham  
ADD CONSTRAINT [FK_SanPham_LoaiHang] FOREIGN KEY([MaLoaiHang])
REFERENCES LoaiHang ([MaLoaiHang]);

-- Thêm khóa ngoại cho bảng HoaDonNhap, tham chiếu đến NhaCungCap

-- Thêm khóa ngoại cho bảng HoaDonBan, tham chiếu đến NguoiDung
ALTER TABLE HoaDonBan  
ADD CONSTRAINT [FK_HoaDonBan_NguoiDung] FOREIGN KEY([MaNguoiDung])
REFERENCES NguoiDung ([MaNguoiDung]);

-- Thêm khóa ngoại cho bảng ChiTietHoaDonNhap, tham chiếu đến HoaDonNhap và SanPham

-- Thêm khóa ngoại cho bảng ChiTietHoaDonBan, tham chiếu đến HoaDonBan và SanPham
ALTER TABLE ChiTietHoaDonBan  
ADD CONSTRAINT [FK_ChiTietHoaDonBan_HoaDonBan] FOREIGN KEY([MaHoaDonBan])
REFERENCES HoaDonBan ([MaHoaDonBan]);

ALTER TABLE ChiTietHoaDonBan  
ADD CONSTRAINT [FK_ChiTietHoaDonBan_SanPham] FOREIGN KEY([MaSanPham])
REFERENCES SanPham ([MaSanPham]);

-- Thêm khóa ngoại cho bảng HinhAnhSanPham, tham chiếu đến SanPham
ALTER TABLE HinhAnhSanPham  
ADD CONSTRAINT [FK_HinhAnhSanPham_SanPham] FOREIGN KEY([MaSanPham])
REFERENCES SanPham ([MaSanPham]);

-- Thêm khóa ngoại cho bảng ChiTietSanPham, tham chiếu đến SanPham
ALTER TABLE ChiTietSanPham  
ADD CONSTRAINT [FK_ChiTietSanPham_SanPham] FOREIGN KEY([MaSanPham])
REFERENCES SanPham ([MaSanPham]);


INSERT INTO LoaiHang (MaLoaiHang, TenLoaiHang) VALUES
('PT001', N'Giấy'),
('PT002', N'Bút viết'),
('PT003', N'Bút chì'),
('PT004', N'Vở'),
('PT005', N'Dụng cụ văn phòng'),
('PT006', N'Dụng cụ đo lường'),
('PT007', N'Các vật dụng khác');


-- Thêm màu sắc
INSERT INTO MauSac(MaMau,TenMau) VALUES 
('do',N'Đỏ'),
('xd',N'Xanh dương'),
('xl',N'Xanh lá') ,
('den',N'Đen'),
('tr',N'Trắng'),
('va',N'Vàng'),
('hg',N'Hồng'),
('ca',N'Cam');

-- Giấy 
INSERT INTO SanPham (MaSanPham, TenSanPham, GiaToiThieu, GiaToiDa, SoLuongTon, HinhAnhSanPham, ChiTiet, MaLoaiHang) VALUES
('SP1001', N'Ream giấy A4 70 gsm IK Copy',		67000,	87000,	100,         N'giay_A4_70_gsm_IK_Copy_1.jpg',      N'Giấy A4 dùng trong in ấn', 'PT001'),
('SP1002', N'Ream giấy A5 70 gsm IK Copy',		44000,	49000,	50,          N'giay_A5_70_gsm_IK_Copy_1.jpg',      N'Giấy A5 kích thước nhỏ hơn A4', 'PT001'),
('SP1003', N'Giấy note',	3000,	8000,	200,		 N'giay-note-1.jpg',    N'Giấy note dán ghi chú', 'PT001'),
('SP1004', N'Số tay mini note book dễ thương size A7',		15000,	25000,	80,          N'giay-sotay-1.jpg',   N'Sổ tay ghi chép, số tay mini note book dễ thương size A7', 'PT001'),
('SP1005', N'Giấy màu',		8000,	18000,	120,		 N'giay-giaymau-1.jpg', N'Giấy màu trang trí', 'PT001'),
('SP1006', N'Giấy than',	6000,	12000,	60,          N'giay-than-1.jpg',    N'Giấy than in tài liệu, giấy truy tìm Giấy Carbon than chì có thể tái sử dụng', 'PT001'),
('SP1007', N'Giấy photo',	7000,	15000,	130,         N'giay-photo-1.jpg',   N'Giấy photo trắng mịn', 'PT001'),
('SP1008', N'Giấy bìa cứng',9000,	20000,	40,          N'giay-biacung-1.jpg', N'Giấy bìa dày để làm bìa hồ sơ', 'PT001'),
('SP1009', N'Giấy carton',	10000,	22000,	70,          N'giay-carton-1.jpg',  N'Giấy carton đóng gói', 'PT001'),
('SP1010', N'Giấy dán nhãn vở',5000,	12000,	90,          N'giay-danhan-1.jpg',  N'Giấy dán nhãn cho đồ vật', 'PT001');

--BUT 
INSERT INTO SanPham (MaSanPham, TenSanPham, GiaToiThieu, GiaToiDa, SoLuongTon, HinhAnhSanPham, ChiTiet, MaLoaiHang) VALUES
('SP2001', N'Bút bi',		                           3000,	8000,	500,        N'butbi1.jpg',         N'Bút bi Thiên Long TL-025 ngòi 0.8mm mực/xanh/đỏ', 'PT002'),
('SP2002', N'(Butgiasi) Bút Bi Bút Gel 0.5Mm Cao Cấp',		10000,	25000,	200,	N'butmuc1.jpg',        N'(Butgiasi) Bút Bi Bút Gel 0.5Mm Cao Cấp', 'PT002'),
('SP2003', N'Bút dạ quang FlexOffice FO-HL02', 7000,	15000,	100,	             N'daquang1.jpg',	   N'Bút dạ quang các màu', 'PT002'),
('SP2004', N'Bút xóa',		5000,	12000,	150,		                             N'butxoa1.jpg',        N'Bút xóa nước', 'PT002'),
('SP2005', N'Bút Mực Gel Văn Phòng 3 Màu Đen Xanh Đỏ A-Nan Books Ngòi 0.5mm',		5000,	15000,	250,		N'butgel1.jpg',        N'Bút Mực Gel Văn Phòng 3 Màu Đen Xanh Đỏ A-Nan Books Ngòi 0.5mm', 'PT002'),
('SP2006', N'Bút dạ quang Thiên Long HL-03',		6000,	18000,	80,			N'But_da-quang_Thien_Long_HL-03_1.jpg',         N'Bút dạ quang Thiên Long HL-03, 3 Màu Đen Xanh Đỏ', 'PT002'),
('SP2007', N'Hộp 20 Bút Bi Thên Long TL-027',		25000,	30000,	80,			N'Hop_20_But_Bi_Thien_Long_TL-027_1.jpg',         N'Hộp 20 Bút Bi Thên Long TL-027', 'PT002'),
('SP2008', N'Bút bi Maxxie TP-05',		4000,	6000,	80,			N'But_bi_Maxxie_Thien_Long_TP-05_1.jpg',         N'Bút bi Maxxie Thiên Long TP-05', 'PT002'),
('SP2009', N'Bút dạ quang Flex Office FO-HL05',		10000,	18000,	80,			N'But_da_quang_FlexOffice _FO-HL05_1.jpg',
N'Bút dạ quang Flex Office FO-HL05. Kiểu dáng thon gọn, trẻ trung Màu dạ quang mạnh, không làm lem nét chữ của mực khi viết chồng lên và không để lại vết khi qua photocopy đây là đặt điểm vượt trội của bút dạ quang HL05.', 'PT002'),
('SP2010', N'Bút dạ quang Flex Office FO-HL07',		12000,	20000,	80,			N'But_da_quang_Thien_Long_HL-07_1.jpg',         
N'Bút dạ quang HL07 có những đặc điểm nổi bật. Bút dạ quang HL07 có 2 đầu bút: Một đầu nhỏ và một đầu lớn, giúp đa dạng nét viết, thuận tiện khi sử dụng. Sản phẩm được sản xuất theo công nghệ hiện đại, đạt tiêu chuẩn chất lượng quốc tế.', 'PT002');

--But chi
INSERT INTO SanPham (MaSanPham, TenSanPham, GiaToiThieu, GiaToiDa, SoLuongTon, HinhAnhSanPham, ChiTiet, MaLoaiHang) VALUES
('SP3001', N'Bút chì kèm tẩy ít gãy nét đậm Heena',		2000,	5000,	300,		N'butchi1.jpg',        N'Bút chì loại 2B', 'PT003'),
('SP3002', N'But_chi_go_2B_FO-GP06_1',		7000,	10000,	300,		N'But_chi_go_2B_FO-GP06_1.jpg',        N'Bút chì gỗ 2B Flexoffice FO-GP06/VN thích hợp cho các hoạt động như ghi chép, vẽ nháp, học tập, Bút chì thân gỗ có sẵn gôm, thân dạng hình lục giác, dễ cầm nắm khi viết. Thân có thiết kế đơn giản, sơn màu xanh
,Ruột chì loại 2B, cứng và đen. Chì ra đều mịn, cho cảm giác viết và vẽ êm ái,Thích hợp cho các hoạt động như viết , vẽ phác thảo và vẽ fine -art', 'PT003'),
('SP3003', N'Bút chì kim bấm màu pastel đầu ngòi 0.5mm 0.7mm GelPen dành cho học sinh',		8000,	20000,	100,		N'butkim1.jpg',        N'Bút chì kim bấm màu pastel đầu ngòi 0.5mm 0.7mm GelPen dành cho học sinh', 'PT003');

--('PT004', N'Vở')
INSERT INTO SanPham (MaSanPham, TenSanPham, GiaToiThieu, GiaToiDa, SoLuongTon, HinhAnhSanPham, ChiTiet, MaLoaiHang) VALUES
('SP4001', N'Tập học sinh 96 trang 4 ô ly vuông 2mm Thiên Long TP-NB061/AK',					10000,	20000,	150,			N'vo_TP-NB061_1.jpg',N'Tập học sinh 96 trang 4 ô ly vuông 2mm 100gsm Thiên Long TP-NB061/AK - Akooland thế giới học cụ thần kỳ', 'PT004'),
('SP4002', N'Tập học sinh 96 trang 5 ô ly vuông Điểm 10 TP-NB075 (hình ngẫu nhiên)',					10000,	20000,	150,			N'vo_TP-NB075_1.jpg',
N'Combo 5 Tập học sinh 96 trang 5 ô ly vuông 100 gsm Điểm 10 TP-NB075 (hình ngẫu nhiên)(loai: 10 cuốn, 1 cuốn, 5 cuốn)', 'PT004');

--('PT005', N'Dụng cụ văn phòng')
INSERT INTO SanPham (MaSanPham, TenSanPham, GiaToiThieu, GiaToiDa, SoLuongTon, HinhAnhSanPham, ChiTiet, MaLoaiHang) VALUES
('SP5001', N'Kéo',					10000,	20000,	150,			N'keo1.jpg',					N'Kéo văn phòng sắc bén', 'PT005'),
('SP5002', N'Dập ghim',				12000,	25000,	100,			N'dapghim1.jpg',				N'Dập ghim 10 tờ', 'PT005'),
('SP5003', N'Ghim kẹp giấy',		5000,	10000,	300,			N'ghimkepgiay1.jpg',			N'Ghim kẹp giấy thép không gỉ', 'PT005'),
('SP5004', N'Bấm lỗ',				15000,	30000,	50,				N'bamlo1.jpg',					N'Bấm lỗ 2 đầu', 'PT005'),
('SP5005', N'Khay đựng tài liệu',	25000,	50000,	80,				N'khaydungtailieu1.jpg',		N'Khay đựng tài liệu 3 tầng', 'PT005'),
('SP5006', N'Băng keo',				4000,	10000,	200,			N'bang-dinh-trong-suot1.jpg',	N'Băng keo trong suốt', 'PT005'),
('SP5007', N'Tẩy giấy',				2000,	5000,	500,			N'taygiay1.jpg',				N'Cục tẩy giấy trắng mềm', 'PT005'),
('SP5008', N'Hộp đựng bút',			15000,	30000,	60,				N'hopdungbut1.jpg',				N'Hộp đựng bút nhựa', 'PT005'),
('SP5009', N'Kẹp file',				12000,	25000,	120,			N'kepfile1.jpg',				N'Kẹp file nhựa nhiều màu', 'PT005');

--('PT006', N'Dụng cụ đo lường'),
INSERT INTO SanPham (MaSanPham, TenSanPham, GiaToiThieu, GiaToiDa, SoLuongTon, HinhAnhSanPham, ChiTiet, MaLoaiHang) VALUES
('SP6001', N'Thước Lá Thép Đủ Các Size 15cm, 20cm, 30cm',		3000,	8000,		100,		N'thuocke15_1.jpg',			N'Thước Lá Thép,
Thước Kẻ Thép Inox 100% Chính Xác Đủ Các Size 15cm, 20cm, 30cm, 40cm, 50cm, 60cm', 'PT006'),
('SP6002', N'Thước kẻ MIKA TRONG - [Tuỳ chọn L15/20/30cm]',		5000,	12000,		80,			N'Thuoc-ke-30cm1.jpg',		N'Thước kẻ nhựa dài 30cm, thước kẻ MIKA TRONG - [Tuỳ chọn L15/20/30cm]', 'PT006'),
('SP6003', N'Compa',				12000,	25000,		70,			N'compa1.jpg',				N'Dụng cụ vẽ compa', 'PT006'),
('SP6004', N'Thước dây 3m',			15000,	30000,		40,			N'thuoc-day3m1.jpg',		N'Thước dây đo dài 3m', 'PT006'),
('SP6005', N'Thước dây 5m',			20000,	40000,		30,			N'Thuoc-keo-5M1.jpg',		N'Thước dây đo dài 5m', 'PT006'),
('SP6006', N'Bộ 4 dụng cụ eke học sinh Deli - 1 bộ eke thước kẻ đo góc tam giác vuông - 71988',	20000, 35000,	20,			N'boeke1.jpg',				N'Bộ dụng cụ e ke', 'PT006');

--('PT007', N'Các vật dụng khác');
INSERT INTO SanPham (MaSanPham, TenSanPham, GiaToiThieu, GiaToiDa, SoLuongTon, HinhAnhSanPham, ChiTiet, MaLoaiHang) VALUES
('SP7001', N'Băng dính hai mặt',	7000,	15000,	100,		N'bangkeo1.jpg',				N'Băng dính hai mặt tiện lợi cho dán giấy và vật dụng', 'PT007'),
('SP7002', N'Dây thừng',			12000,	25000,	60,			N'daythung1.jpg',				N'Dây thừng đa năng dùng cho các mục đích buộc đồ, dây thừng 4mm,5mm,6mm,8mm,10mm, dây thừng trang trí, dây đay, làm handmade, decor, trang trí, cào móng mèo', 'PT007'),
('SP7003', N'Kẹp gỗ',				5000,	10000,	150,		N'kepgo1.jpg',					N'Kẹp gỗ trang trí và đính ảnh', 'PT007'),
('SP7004', N'Khung ảnh',			20000,	50000,	30,			N'kich-thuoc-khung-anh-1.jpg',	N'Khung ảnh gỗ để bàn', 'PT007'),
('SP7005', N'Bọc sách',				5000,	12000,	90,			N'bocsach2.jpg',				N'Bọc nhựa để bảo vệ sách vở', 'PT007'),
('SP7006', N'Dây đeo thẻ',			8000,	20000,	100,		N'daydeothe2.jpg',				N'Dây đeo thẻ nhựa cho nhân viên', 'PT007'),
('SP7007', N'Khăn lau bảng',		10000,	25000,	50,			N'mieng-lau-bang-2.jpg',		N'Khăn lau bảng trắng', 'PT007'),
('SP7008', N'Máy tính Casio FX 580VNX',		450000,	520000,	40,			N'maytinhbotui1.jpg',		N'Máy tính cầm tay dùng cho văn phòng', 'PT007'),
('SP7009', N'Bìa nút Pazto màu Pastel F4 Thiên Long Flexoffice FO-CBF010',		15000,	20000,	40,			N'Bia_nua_Pazto Flexoffice FO-CBF010_1.jpg',
N'Bìa nút Pazto màu Pastel F4 Thiên Long Flexoffice FO-CBF010. Sản phẩm bìa lá màu Pastel được sản xuất từ nhựa PP chất lượng cao, an toàn với người sử dụng, màu sắc nhiều người yêu thích.
. Màu sắc Pastel được nhiều người lựa chọn không chỉ có màu sắc trẻ trung mà còn mang lại cảm giác chuyên nghiệp, đẹp mắt cho không gian văn phòng.
. Bề mặt trơn láng, hạn chế trầy xước và bám bẩn.', 'PT007');


-- giay to 
insert into HinhAnhSanPham(MaSanPham,TenHinhAnh) values 
('SP1001',		N'giay_A4_70_gsm_IK_Copy_1.jpg'),
('SP1001',		N'giay_A4_70_gsm_IK_Copy_2.jpg'),
('SP1001',		N'giay_A4_70_gsm_IK_Copy_3.jpg');
insert into HinhAnhSanPham(MaSanPham,TenHinhAnh) values 
('SP1002',		N'giay_A5_70_gsm_IK_Copy_1.jpg'),
('SP1002',		N'giay_A5_70_gsm_IK_Copy_2.jpg'),
('SP1002',		N'giay_A5_70_gsm_IK_Copy_3.jpg');
insert into HinhAnhSanPham(MaSanPham,TenHinhAnh) values 
('SP1003',		N'giay-note-1.jpg'),
('SP1003',		N'giay-note-2.jpg'),
('SP1003',		N'giay-note-3.jpg');
insert into HinhAnhSanPham(MaSanPham,TenHinhAnh) values 
('SP1004',		N'giay-sotay-1.jpg'),
('SP1004',		N'giay-sotay-2.jpg'),
('SP1004',		N'giay-sotay-3.jpg');
insert into HinhAnhSanPham(MaSanPham,TenHinhAnh) values 
('SP1005',		N'giay-giaymau-1.jpg'),
('SP1005',		N'giay-giaymau-2.jpg'),
('SP1005',		N'giay-giaymau-3.jpg');
insert into HinhAnhSanPham(MaSanPham,TenHinhAnh) values 
('SP1006',		N'giay-than-1.jpg'),
('SP1006',		N'giay-than-2.jpg'),
('SP1006',		N'giay-than-3.jpg');
insert into HinhAnhSanPham(MaSanPham,TenHinhAnh) values 
('SP1007',		N'giay-photo-1.jpg'),
('SP1007',		N'giay-photo-2.jpg'),
('SP1007',		N'giay-photo-3.jpg');
insert into HinhAnhSanPham(MaSanPham,TenHinhAnh) values 
('SP1008',		N'giay-biacung-1.jpg'),
('SP1008',		N'giay-biacung-2.jpg'),
('SP1008',		N'giay-biacung-3.jpg');
insert into HinhAnhSanPham(MaSanPham,TenHinhAnh) values 
('SP1009',		N'giay-carton-1.jpg'),
('SP1009',		N'giay-carton-2.jpg'),
('SP1009',		N'giay-carton-3.jpg');
insert into HinhAnhSanPham(MaSanPham,TenHinhAnh) values 
('SP1010',		N'giay-danhan-1.jpg'),
('SP1010',		N'giay-danhan-2.jpg'),
('SP1010',		N'giay-danhan-3.jpg');

--but bi 
insert into HinhAnhSanPham(MaSanPham,TenHinhAnh) values 
('SP2001',		N'butbi1.jpg'),
('SP2001',		N'butbi2.jpg'),
('SP2001',		N'butbi3.jpg');
insert into HinhAnhSanPham(MaSanPham,TenHinhAnh) values 
('SP2002',		N'butmuc1.jpg'),
('SP2002',		N'butmuc2.jpg'),
('SP2002',		N'butmuc3.jpg');
insert into HinhAnhSanPham(MaSanPham,TenHinhAnh) values 
('SP2003',		N'daquang1.jpg'),
('SP2003',		N'daquang2.jpg'),
('SP2003',		N'daquang3.jpg');
insert into HinhAnhSanPham(MaSanPham,TenHinhAnh) values 
('SP2004',		N'butxoa1.jpg'),
('SP2004',		N'butxoa2.jpg'),
('SP2004',		N'butxoa3.jpg');
insert into HinhAnhSanPham(MaSanPham,TenHinhAnh) values 
('SP2005',		N'butgel1.jpg'),
('SP2005',		N'butgel2.jpg'),
('SP2005',		N'butgel3.jpg');
insert into HinhAnhSanPham(MaSanPham,TenHinhAnh) values 
('SP2006',		N'But_da-quang_Thien_Long_HL-03_1.jpg'),
('SP2006',		N'But_da-quang_Thien_Long_HL-03_2.jpg'),
('SP2006',		N'But_da-quang_Thien_Long_HL-03_3.jpg');

insert into HinhAnhSanPham(MaSanPham,TenHinhAnh) values 
('SP2007',		N'Hop_20_But_Bi_Thien_Long_TL-027_1.jpg'),
('SP2007',		N'Hop_20_But_Bi_Thien_Long_TL-027_2.jpg'),
('SP2007',		N'Hop_20_But_Bi_Thien_Long_TL-027_3.jpg'),
('SP2007',		N'Hop_20_But_Bi_Thien_Long_TL-027_4.jpg');
insert into HinhAnhSanPham(MaSanPham,TenHinhAnh) values 
('SP2008',		N'But_bi_Maxxie_Thien_Long_TP-05_1.jpg'),
('SP2008',		N'But_bi_Maxxie_Thien_Long_TP-05_2.jpg'),
('SP2008',		N'But_bi_Maxxie_Thien_Long_TP-05_3.jpg'),
('SP2008',		N'But_bi_Maxxie_Thien_Long_TP-05_4.jpg');
insert into HinhAnhSanPham(MaSanPham,TenHinhAnh) values 
('SP2009',		N'But_da_quang_FlexOffice _FO-HL05_1.jpg'),
('SP2009',		N'But_da_quang_FlexOffice _FO-HL05_2.jpg'),
('SP2009',		N'But_da_quang_FlexOffice _FO-HL05_3.jpg'),
('SP2009',		N'But_da_quang_FlexOffice _FO-HL05_4.jpg'),
('SP2009',		N'But_da_quang_FlexOffice _FO-HL05_5.jpg'),
('SP2009',		N'But_da_quang_FlexOffice _FO-HL05_6.jpg');
insert into HinhAnhSanPham(MaSanPham,TenHinhAnh) values 
('SP2010',		N'But_da_quang_Thien_Long_HL-07_1.jpg'),
('SP2010',		N'But_da_quang_Thien_Long_HL-07_2.jpg'),
('SP2010',		N'But_da_quang_Thien_Long_HL-07_3.jpg'),
('SP2010',		N'But_da_quang_Thien_Long_HL-07_4.jpg'),
('SP2010',		N'But_da-quang_Thien_Long_HL-07_5.jpg'),
('SP2010',		N'But_da-quang_Thien_Long_HL-07_6.jpg');



--but chi PT003
insert into HinhAnhSanPham(MaSanPham,TenHinhAnh) values 
('SP3001',		N'butchi1.jpg'),
('SP3001',		N'butchi2.jpg'),
('SP3001',		N'butchi3.jpg');
insert into HinhAnhSanPham(MaSanPham,TenHinhAnh) values 
('SP3002',		N'But_chi_go_2B_FO-GP06_1.jpg'),
('SP3002',		N'But_chi_go_2B_FO-GP06_2.jpg'),
('SP3002',		N'But_chi_go_2B_FO-GP06_3.jpg');
insert into HinhAnhSanPham(MaSanPham,TenHinhAnh) values 
('SP3003',		N'butkim1.jpg'),
('SP3003',		N'butkim2.jpg'),
('SP3003',		N'butkim3.jpg');

--'PT004', N'Vở')
insert into HinhAnhSanPham(MaSanPham,TenHinhAnh) values 
('SP4001',		N'vo_TP-NB061_1.jpg'),
('SP4001',		N'vo_TP-NB061_2.jpg'),
('SP4001',		N'vo_TP-NB061_3.jpg'),
('SP4001',		N'vo_TP-NB061_4.jpg');
insert into HinhAnhSanPham(MaSanPham,TenHinhAnh) values 
('SP4002',		N'vo_TP-NB075_1.jpg'),
('SP4002',		N'vo_TP-NB075_2.jpg'),
('SP4002',		N'Bvo_TP-NB075_3.jpg');

--PT005
insert into HinhAnhSanPham(MaSanPham,TenHinhAnh) values 
('SP5001',		N'keo1.jpg'),
('SP5001',		N'keo2.jpg'),
('SP5001',		N'keo3.jpg');
insert into HinhAnhSanPham(MaSanPham,TenHinhAnh) values 
('SP5002',		N'dapghim1.jpg'),
('SP5002',		N'dapghim2.jpg'),
('SP5002',		N'dapghim3.jpg');
insert into HinhAnhSanPham(MaSanPham,TenHinhAnh) values 
('SP5003',		N'ghimkepgiay1.jpg'),
('SP5003',		N'ghimkepgiay2.jpg'),
('SP5003',		N'ghimkepgiay3.jpg');
insert into HinhAnhSanPham(MaSanPham,TenHinhAnh) values 
('SP5004',		N'bamlo1.jpg'),
('SP5004',		N'bamlo2.jpg'),
('SP5004',		N'bamlo3.jpg');
insert into HinhAnhSanPham(MaSanPham,TenHinhAnh) values 
('SP5005',		N'khaydungtailieu1.jpg'),
('SP5005',		N'khaydungtailieu2.jpg'),
('SP5005',		N'khaydungtailieu3.jpg');
insert into HinhAnhSanPham(MaSanPham,TenHinhAnh) values 
('SP5006',		N'bang-dinh-trong-suot1.jpg'),
('SP5006',		N'bang-dinh-trong-suot2.jpg'),
('SP5006',		N'bang-dinh-trong-suot3.jpg');
insert into HinhAnhSanPham(MaSanPham,TenHinhAnh) values 
('SP5007',		N'taygiay1.jpg'),
('SP5007',		N'taygiay2.jpg'),
('SP5007',		N'taygiay3.jpg');
insert into HinhAnhSanPham(MaSanPham,TenHinhAnh) values 
('SP5008',		N'hopdungbut1.jpg'),
('SP5008',		N'hopdungbut2.jpg'),
('SP5008',		N'hopdungbut3.jpg');
insert into HinhAnhSanPham(MaSanPham,TenHinhAnh) values 
('SP5009',		N'kepfile1.jpg'),
('SP5009',		N'kepfile2.jpg'),
('SP5009',		N'kepfile3.jpg');


insert into HinhAnhSanPham(MaSanPham,TenHinhAnh) values 
('SP6001',		N'thuocke15_1.jpg'),
('SP6001',		N'thuocke15_2.jpg'),
('SP6001',		N'thuocke15_3.jpg');
insert into HinhAnhSanPham(MaSanPham,TenHinhAnh) values 
('SP6002',		N'Thuoc-ke-30cm1.jpg'),
('SP6002',		N'Thuoc-ke-30cm2.jpg'),
('SP6002',		N'Thuoc-ke-30cm3.jpg');
insert into HinhAnhSanPham(MaSanPham,TenHinhAnh) values 
('SP6003',		N'compa1.jpg'),
('SP6003',		N'compa2.jpg'),
('SP6003',		N'compa3.jpg');
insert into HinhAnhSanPham(MaSanPham,TenHinhAnh) values 
('SP6004',		N'thuoc-day3m1.jpg'),
('SP6004',		N'thuoc-day3m2.jpg'),
('SP6004',		N'thuoc-day3m3.jpg');
insert into HinhAnhSanPham(MaSanPham,TenHinhAnh) values 
('SP6005',		N'Thuoc-keo-5M1.jpg'),
('SP6005',		N'Thuoc-keo-5M2.jpg'),
('SP6005',		N'Thuoc-keo-5M3.jpg');
insert into HinhAnhSanPham(MaSanPham,TenHinhAnh) values 
('SP6006',		N'boeke1.jpg'),
('SP6006',		N'boeke2.jpg'),
('SP6006',		N'boeke3.jpg'),
('SP6006',		N'boeke4.jpg');



insert into HinhAnhSanPham(MaSanPham,TenHinhAnh) values 
('SP7001',		N'bangkeo1.jpg'),
('SP7001',		N'bangkeo2.jpg'),
('SP7001',		N'bangkeo3.jpg');
insert into HinhAnhSanPham(MaSanPham,TenHinhAnh) values 
('SP7002',		N'daythung1.jpg'),
('SP7002',		N'daythung2.jpg'),
('SP7002',		N'daythung3.jpg');
insert into HinhAnhSanPham(MaSanPham,TenHinhAnh) values 
('SP7003',		N'kepgo1.jpg'),
('SP7003',		N'kepgo2.jpg'),
('SP7003',		N'kepgo3.jpg');
insert into HinhAnhSanPham(MaSanPham,TenHinhAnh) values 
('SP7004',		N'kich-thuoc-khung-anh-1.jpg'),
('SP7004',		N'kich-thuoc-khung-anh-2.jpg'),
('SP7004',		N'kich-thuoc-khung-anh-3.jpg');
insert into HinhAnhSanPham(MaSanPham,TenHinhAnh) values 
('SP7005',		N'bocsach1.jpg'),
('SP7005',		N'bocsach2.jpg'),
('SP7005',		N'bocsach3.jpg');
insert into HinhAnhSanPham(MaSanPham,TenHinhAnh) values 
('SP7006',		N'daydeothe1.jpg'),
('SP7006',		N'daydeothe2.jpg'),
('SP7006',		N'daydeothe3.jpg');
insert into HinhAnhSanPham(MaSanPham,TenHinhAnh) values 
('SP7007',		N'mieng-lau-bang-1.jpg'),
('SP7007',		N'mieng-lau-bang-2.jpg'),
('SP7007',		N'mieng-lau-bang-3.jpg');
insert into HinhAnhSanPham(MaSanPham,TenHinhAnh) values 
('SP7008',		N'maytinhbotui1.jpg'),
('SP7008',		N'maytinhbotui2.jpg'),
('SP7008',		N'maytinhbotui3.jpg');
insert into HinhAnhSanPham(MaSanPham,TenHinhAnh) values 
('SP7009',		N'Bia_nua_Pazto Flexoffice FO-CBF010_1.jpg'),
('SP7009',		N'Bia_nua_Pazto Flexoffice FO-CBF010_2.jpg'),
('SP7009',		N'Bia_nua_Pazto Flexoffice FO-CBF010_3.jpg');

--MAU sac 
/*
insert into SanPham_Mau(MaSanPham,MaMau) values
('SP2001',1),('SP2001',2),('SP2001',4);
insert into SanPham_Mau(MaSanPham,MaMau) values
('SP2002',1),('SP2002',2),('SP2002',4);
insert into SanPham_Mau(MaSanPham,MaMau) values 
('SP2005',1),('SP2005',2),('SP2005',4);
insert into SanPham_Mau(MaSanPham,MaMau) values 
('SP2006',1),('SP2006',2),('SP2006',4);
insert into SanPham_Mau(MaSanPham,MaMau) values 
('SP2008',1),('SP2008',2),('SP2008',4);

--but da
insert into SanPham_Mau(MaSanPham,MaMau) values
('SP2003',2),('SP2003',3),('SP2003',6),('SP2003',7),('SP2003',8);
insert into SanPham_Mau(MaSanPham,MaMau) values
('SP2009',2),('SP2009',3),('SP2009',6),('SP2009',7),('SP2009',8);
insert into SanPham_Mau(MaSanPham,MaMau) values
('SP2010',2),('SP2010',3),('SP2010',6),('SP2010',7),('SP2010',8);
*/

/*
INSERT INTO NguoiDung (MaNguoiDung, TenNguoiDung, TaiKhoan, MatKhau, NgaySinh, SoDienThoai, Email, DiaChi, AnhDaiDien, LoaiNguoiDung)
VALUES 
('ND001', 'Hoàng Thị Nhiệu',	'userNhieu',	'pass1234', '2004-12-26', '0378953906', 'nhieuhoang592@gmail.com',	N'Số 99, Đường Nguyễn Chí Thanh, Quận Đống Đa, Hà Nội', NULL, 1),
('ND002', 'Nguyễn Văn An',		'userAn',		'pass1234', '2003-05-15', '0123456789', 'annguyen@gmail.com',		N'Số 50, Đường Lê Duẩn, Quận Hoàn Kiếm, Hà Nội',		NULL, 1),
('ND003', 'Trần Thị Hương',		'userHuong',	'pass1234', '2002-11-10', '0987654321', 'huongtran@gmail.com',		N'Số 75, Đường Bà Triệu, Quận Hai Bà Trưng, Hà Nội',	NULL, 2),
('ND004', 'Lê Văn Hòa',			'userHoa',		'pass1234', '2001-07-20', '0912345678', 'hoale@gmail.com',			N'Số 10, Đường Trần Hưng Đạo, Quận Hoàn Kiếm, Hà Nội',	NULL, 3),
('ND005', 'Phạm Minh Tú',		'userTu',		'pass1234', '2000-03-30', '0981234567', 'tupham@gmail.com',			N'Số 20, Đường Lê Văn Lương, Quận Thanh Xuân, Hà Nội',	NULL, 1),
('ND006', 'Đỗ Thị Tâm',			'userTam',		'pass1234', '1999-08-18', '0909876543', 'tamdo@gmail.com',			N'Số 30, Đường Nguyễn Trãi, Quận Thanh Xuân, Hà Nội',	NULL, 2),
('ND007', 'Nguyễn Đình Tài',	'userTai',		'pass1234', '2004-01-01', '0378123456', 'tainguyen@gmail.com',		N'Số 40, Đường Láng, Quận Đống Đa, Hà Nội',				NULL, 1),
('ND008', 'Trần Minh Tuấn',		'userTuan',		'pass1234', '2003-09-09', '0123765432', 'tuantran@gmail.com',		N'Số 80, Đường Trương Định, Quận Hai Bà Trưng, Hà Nội', NULL, 2),
('ND009', 'Lê Thị Thanh',		'userThanh',	'pass1234', '2002-06-15', '0965432101', 'thanhle@gmail.com',		N'Số 90, Đường Thái Hà, Quận Đống Đa, Hà Nội',			NULL, 3),
('ND010', 'Phạm Minh Khôi',		'userKhoi',		'pass1234', '2001-10-05', '0376985432', 'khoipham@gmail.com',		N'Số 60, Đường Trần Phú, Quận Ba Đình, Hà Nội',			NULL, 1);

INSERT INTO ChiTietHoaDonBan (MaHoaDonBan, MaSanPham, SoLuongBan, GiaBan, KhuyenMai, PhuongThucThanhToan) VALUES 
('HDB001', 'SP2001', 5, 3000, 0.1, 1),
('HDB001', 'SP1001', 20, 500, 0.05, 2),
('HDB002', 'SP3003', 3, 5000, 0.0, 3);
*/

INSERT INTO ChiTietSanPham (MaChiTietSanPham, MaSanPham, MaMauSac,AnhDaiDien, Video, DonGiaBan, GiamGia, SoLuongTon) VALUES
('CTSP2001_do', 'SP2001', 'do','butbi1.jpg', NULL, 3000, 0.0, 100),
('CTSP2001_xd', 'SP2001',  'xd','butbi2.jpg', NULL, 3000, 0.0, 50),
('CTSP2001_den', 'SP2001','den','butbi3.jpg', NULL, 3000, 0.0, 200),

('CTSP2002_do', 'SP2002', 'do','butmuc1.jpg', NULL, 10000, 0.0, 100),
('CTSP2002_xd', 'SP2002',  'xd','butmuc1.jpg', NULL, 10000, 0.0, 50),
('CTSP2002_den', 'SP2002','den','butmuc1.jpg', NULL, 10000, 0.0, 200),

('CTSP2005_do', 'SP2005', 'do','butgel1.jpg', NULL, 5000, 0.0, 100),
('CTSP2005_xd', 'SP2005',  'xd','butgel1.jpg', NULL, 5000, 0.0, 50),
('CTSP2005_den', 'SP2005','den' ,'butgel1.jpg', NULL, 5000, 0.0, 200),

('CTSP2006_do', 'SP2006', 'do','But_da-quang_Thien_Long_HL-03_3.jpg', NULL, 6000, 0.0, 100),
('CTSP2006_xd', 'SP2006', 'xd','But_da-quang_Thien_Long_HL-03_1.jpg', NULL, 6000, 0.0, 50),
('CTSP2006_den', 'SP2006','den','But_da-quang_Thien_Long_HL-03_1.jpg', NULL, 6000, 0.0, 200),

('CTSP2007_do', 'SP2007', 'do','Hop_20_But_Bi_Thien_Long_TL-027_3.jpg', NULL, 25000, 0.0, 100),
('CTSP2007_xd', 'SP2007',  'xd','Hop_20_But_Bi_Thien_Long_TL-027_3.jpg', NULL, 25000, 0.0, 50),
('CTSP2007_den', 'SP2007','den','Hop_20_But_Bi_Thien_Long_TL-027_3.jpg', NULL, 25000, 0.0, 200),

('CTSP2008_do', 'SP2008', 'do','But_bi_Maxxie_Thien_Long_TP-05_4.jpg', NULL, 4000, 0.0, 100),
('CTSP2008_xd', 'SP2008',  'xd','But_bi_Maxxie_Thien_Long_TP-05_2.jpg', NULL,4000, 0.0, 50),
('CTSP2008_den', 'SP2008','den','But_bi_Maxxie_Thien_Long_TP-05_2.jpg', NULL, 4000, 0.0, 200);

--but da
INSERT INTO ChiTietSanPham (MaChiTietSanPham, MaSanPham, MaMauSac,AnhDaiDien, Video, DonGiaBan, GiamGia, SoLuongTon) VALUES
('CTSP2003_xd', 'SP2003', 'xd','daquang1.jpg', NULL, 7000, 0.0, 100),
('CTSP2003_xl', 'SP2003',  'xl','daquang2.jpg', NULL, 7000, 0.0, 50),
('CTSP2003_va', 'SP2003','va','daquang1.jpg', NULL, 7000, 0.0, 200),
('CTSP2003_hg', 'SP2003', 'hg','daquang3.jpg', NULL, 7000, 0.0, 100),
('CTSP2003_ca', 'SP2003',  'ca','daquang1.jpg', NULL, 7000, 0.0, 50),

('CTSP2009_xd', 'SP2009', 'xd','But_da_quang_FlexOffice _FO-HL05_4.jpg', NULL, 10000, 0.0, 100),
('CTSP2009_xl', 'SP2009',  'xl','But_da_quang_FlexOffice _FO-HL05_3.jpg', NULL, 10000, 0.0, 50),
('CTSP2009_va', 'SP2009','va','But_da_quang_FlexOffice _FO-HL05_6.jpg', NULL, 10000, 0.0, 200),
('CTSP2009_hg', 'SP2009', 'hg','But_da_quang_FlexOffice _FO-HL05_5.jpg', NULL, 10000, 0.0, 100),
('CTSP2009_ca', 'SP2009',  'ca','But_da_quang_FlexOffice _FO-HL05_2.jpg', NULL, 10000, 0.0, 50),

('CTSP2010_xd', 'SP2010', 'xd','But_da_quang_Thien_Long_HL-07_2.jpg', NULL, 12000, 0.0, 100),
('CTSP2010_xl', 'SP2010',  'xl','But_da_quang_Thien_Long_HL-07_5.jpg', NULL, 12000, 0.0, 50),
('CTSP2010_va', 'SP2010','va','But_da_quang_Thien_Long_HL-07_6.jpg', NULL, 12000, 0.0, 200),
('CTSP2010_hg', 'SP2010', 'hg','But_da_quang_Thien_Long_HL-07_5.jpg', NULL, 12000, 0.0, 100),
('CTSP2010_ca', 'SP2010',  'ca','But_da_quang_Thien_Long_HL-07_3.jpg', NULL, 12000, 0.0, 50);


-- giay
INSERT INTO ChiTietSanPham (MaChiTietSanPham, MaSanPham, MaMauSac,AnhDaiDien, Video, DonGiaBan, GiamGia, SoLuongTon) VALUES
('CTSP1001','SP1001', NULL,'giay_A4_70_gsm_IK_Copy_1.jpg',	NULL,67000,	0.0, 100),
('CTSP1002','SP1002', NULL,'giay_A5_70_gsm_IK_Copy_1.jpg',	NULL,44000,	0.0, 100),
('CTSP1003','SP1003', NULL,'giay-note-1.jpg',	NULL,3000,	0.0, 100),
('CTSP1004','SP1004', NULL,'giay-sotay-1.jpg',	NULL,15000,	0.0, 100),
('CTSP1005','SP1005', NULL,'giay-giaymau-1.jpg',	NULL,8000,	0.0, 100),
('CTSP1006','SP1006', NULL,'giay-than-1.jpg',	NULL,6000,	0.0, 100),
('CTSP1007','SP1007', NULL,'giay-photo-1.jpg',	NULL,7000,	0.0, 100),
('CTSP1008','SP1008', NULL,'giay-biacung-1.jpg',	NULL,9000,	0.0, 100),
('CTSP1009','SP1009', NULL,'giay-carton-1.jpg',	NULL,10000,	0.0, 100),
('CTSP1010','SP1010', NULL,'giay-danhan-1.jpg',NULL,5000,	0.0, 100);

--But chi

INSERT INTO ChiTietSanPham (MaChiTietSanPham, MaSanPham, MaMauSac,AnhDaiDien, Video, DonGiaBan, GiamGia, SoLuongTon) VALUES
('CTSP3001','SP3001', NULL,'butchi1.jpg',	NULL,2000,	0.0, 300),
('CTSP3002','SP3002', NULL,'But_chi_go_2B_FO-GP06_1.jpg',	NULL,7000,	0.0, 300),
('CTSP3003','SP3003', NULL,'butkim1.jpg',NULL,8000,	0.0, 100);

--('PT004', N'Vở')
INSERT INTO ChiTietSanPham (MaChiTietSanPham, MaSanPham, MaMauSac,AnhDaiDien, Video, DonGiaBan, GiamGia, SoLuongTon) VALUES
('CTSP4001','SP4001',NULL,	 'vo_TP-NB061_3.jpg',NULL,10000,	0.0, 100),
('CTSP4002','SP4002',NULL,	 'vo_TP-NB075_2.jpg',NULL,10000,	0.0, 100);

--('PT005', N'Dụng cụ văn phòng')
INSERT INTO ChiTietSanPham (MaChiTietSanPham, MaSanPham, MaMauSac,AnhDaiDien, Video, DonGiaBan, GiamGia, SoLuongTon) VALUES
('CTSP5001','SP5001', NULL,'keo1.jpg',	NULL,10000,	0.0, 150),
('CTSP5002','SP5002', NULL,'dapghim1.jpg',	NULL,12000,	0.0, 100),
('CTSP5003','SP5003', NULL,'ghimkepgiay1.jpg',	NULL,5000,	0.0, 300),
('CTSP5004','SP5004', NULL,'bamlo1.jpg',	NULL,15000,	0.0, 50),
('CTSP5005','SP5005', NULL,'khaydungtailieu1.jpg',	NULL,25000,	0.0, 80),
('CTSP5006','SP5006', NULL,'bang-dinh-trong-suot1.jpg',	NULL,4000,	0.0, 200),
('CTSP5007','SP5007', NULL,'taygiay1.jpg',	NULL,2000,	0.0, 500),
('CTSP5008','SP5008', NULL,'hopdungbut1.jpg',	NULL,15000,	0.0, 300),
('CTSP5009','SP5009', NULL,'kepfile1.jpg',	NULL,12000,	0.0, 100);

--('PT006', N'Dụng cụ đo lường'),
INSERT INTO ChiTietSanPham (MaChiTietSanPham, MaSanPham, MaMauSac,AnhDaiDien, Video, DonGiaBan, GiamGia, SoLuongTon) VALUES
('CTSP6001','SP6001', NULL,'thuocke15_1.jpg',	NULL,3000,	0.0, 150),
('CTSP6002','SP6002', NULL,'Thuoc-ke-30cm1.jpg',	NULL,5000,	0.0, 100),
('CTSP6003','SP6003', NULL,'compa1.jpg',	NULL,12000,	0.0, 300),
('CTSP6004','SP6004', NULL,'compa1.jpg',	NULL,15000,	0.0, 50),
('CTSP6005','SP6005', NULL,'thuoc-day3m1.jpg',	NULL,20000,	0.0, 80),
('CTSP6006','SP6006', NULL,'Thuoc-keo-5M1.jpg',	NULL,20000,	0.0, 200);



--('PT007', N'Các vật dụng khác');
INSERT INTO ChiTietSanPham (MaChiTietSanPham, MaSanPham, MaMauSac,AnhDaiDien, Video, DonGiaBan, GiamGia, SoLuongTon) VALUES
('CTSP7001','SP7001', NULL,'bangkeo3.jpg',	NULL,7000,	0.0, 150),
('CTSP7002','SP7002', NULL,'daythung2.jpg',	NULL,12000,	0.0, 100),
('CTSP7003','SP7003', NULL,'kepgo2.jpg',	NULL,5000,	0.0, 300),
('CTSP7004','SP7004', NULL,'kich-thuoc-khung-anh-1.jpg',	NULL,20000,	0.0, 50),
('CTSP7005','SP7005', NULL,'bocsach1.jpg',	NULL,5000,	0.0, 80),
('CTSP7006','SP7006', NULL,'daydeothe1.jpg',	NULL,8000,	0.0, 80),
('CTSP7007','SP7007', NULL,'mieng-lau-bang-1.jpg',	NULL,10000,	0.0, 100),
('CTSP7008','SP7008', NULL,'maytinhbotui1.jpg',	NULL,450000,0.0, 80),
('CTSP7009','SP7009', NULL,'Bia_nua_Pazto Flexoffice FO-CBF010_1.jpg',	NULL,15000,	0.0, 200);

-- Thêm dữ liệu cho các dịp lễ
INSERT INTO ChuongTrinhKhuyenMai (ChuDe, NoiDung, NgayBatDau, NgayKetThuc)
VALUES 
(N'Mừng đại lễ – Giá sốc tưng bừng!', 
 N'Từ ngày 29/4 - 1/5, chúng tôi sẽ giảm 5-10% tuỳ vào giá trị đơn hàng của bạn.', 
 '2025-04-29', '2025-05-01'),

(N'Ưu đãi thiếu nhi – Đồ dùng học tập cực cool!', 
 N'Hãy mua sắm cùng chúng tôi vào ngày 1/6 để không bỏ lỡ cơ hội nhaaa.', 
 '2025-06-01', '2025-06-01'),

(N'Back to school – Siêu ưu đãi học đường!', 
 N'Còn chần chờ gì nữa hãy nhanh tay đặt hàng từ 15-20/8.', 
 '2025-08-15', '2025-08-20'),

(N'Ngàn lời cảm ơn – Vạn ưu đãi tri ân!', 
 N'Chào đón 20/11 với tràn ngập ưu đãi.', 
 '2025-11-20', '2025-11-20');
