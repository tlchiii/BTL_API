import json
import random

import pyodbc
from flask import *
import  flask
from flask_cors import CORS
import json
import math
import difflib

app = flask.Flask(__name__)
CORS(app,supports_credentials=True,origins=["http://localhost:5106"])
server = 'MSI\\SQLEXPRESS'
database = 'QLVanPhongPham'

cn_str = f'DRIVER={'{SQL Server}'};SERVER={server};DATABASE={database};Trusted_Connection=yes'
conn = pyodbc.connect(cn_str)

#San Pham
@app.route("/Home", methods=['GET'])
def getHome():
    try:
        cursor = conn.cursor()
        cursor.execute("SELECT TOP 8 * FROM SanPham")
        results = []
        keys = []
        for i in cursor.description:
            keys.append(i[0])
        for val in cursor.fetchall():
            results.append(dict(zip(keys, val)))
            resp = flask.jsonify(results)
            resp.status_code = 200
        return resp
    except Exception as e:
        print(e)

#San Pham
@app.route("/home/noibat", methods=['GET'])
def getNoiBat():
    try:
        cursor = conn.cursor()
        cursor.execute("SELECT TOP 8 * FROM SanPham")
        results = []
        keys = []
        for i in cursor.description:
            keys.append(i[0])
        for val in cursor.fetchall():
            results.append(dict(zip(keys, val)))
            resp = flask.jsonify(results)
            resp.status_code = 200
        return resp
    except Exception as e:
        print(e)

#San Pham ganday
@app.route("/home/ganday", methods=['GET'])
def getGanDay():
    try:
        cursor = conn.cursor()
        cursor.execute("SELECT TOP 8 * FROM SanPham order by MaSanPham desc")
        results = []
        keys = []
        for i in cursor.description:
            keys.append(i[0])
        for val in cursor.fetchall():
            results.append(dict(zip(keys, val)))
            resp = flask.jsonify(results)
            resp.status_code = 200
        return resp
    except Exception as e:
        print(e)

#lay tất cả
@app.route("/all",methods=['GET'])
def getAll():
    try:
        cursor = conn.cursor()
        cursor.execute("select * from SanPham")
        result = []
        keys = []
        for i in cursor.description:
            keys.append(i[0])
        for val in cursor.fetchall():
            result.append(dict(zip(keys,val)))
        return flask.jsonify(result), 200
    except Exception as e:
        jsonify({"error": str(e)}), 500

# lấy danh mục sp
@app.route("/DanhMuc",methods=['GET'])
def getDanMuc():
    try:
        cursor = conn.cursor()
        cursor.execute("select * from LoaiHang")
        result = []
        keys = []
        for i in cursor.description:
            keys.append(i[0])
        for val in cursor.fetchall():
            result.append(dict(zip(keys,val)))
        return flask.jsonify(result), 200
    except Exception as e:
        jsonify({"error": str(e)}), 500

# 2. Lấy sản phẩm theo mã loại
@app.route('/api/sanpham/loai', methods=['GET'])
def get_sanpham_by_loai():
    maloai = request.args.get('maloai', '')
    try:
        with conn.cursor() as cursor:
            cursor.execute("""
                    select * from SanPham
                    where MaLoaiHang = ?
                """, maloai)

            keys = [column[0] for column in cursor.description]
            rows = cursor.fetchall()
            if not rows:
                return jsonify({'message': 'Không tìm thấy sản phẩm'}), 404

            results = [dict(zip(keys, row)) for row in rows]
        return jsonify(results), 200
    except Exception as e:
        # Có thể log lỗi ra console hoặc file để tiện debug
        print("Lỗi truy vấn:", e)
        return jsonify({'error': str(e)}), 500

# 2. Lấy sản phẩm theo mã loại
@app.route('/api/splq', methods=['GET'])
def get_splq():
    maloai = request.args.get('maloai', '')
    try:
        with conn.cursor() as cursor:
            cursor.execute("""
                    select top 4 * from SanPham
                    where MaLoaiHang = ?
                """, maloai)

            keys = [column[0] for column in cursor.description]
            rows = cursor.fetchall()
            if not rows:
                return jsonify({'message': 'Không tìm thấy sản phẩm'}), 404

            results = [dict(zip(keys, row)) for row in rows]
        return jsonify(results), 200
    except Exception as e:
        # Có thể log lỗi ra console hoặc file để tiện debug
        print("Lỗi truy vấn:", e)
        return jsonify({'error': str(e)}), 500

# ma sp
@app.route('/sp/search', methods=['GET'])
def search_sp():
    try:
        masp = request.args.get('masp', '')

        cursor = conn.cursor()
        query = """
        SELECT * from SanPham Where MaSanPham = ?
        """
        #

        params = (f'{masp}')
        cursor.execute(query, params)
        keys = [column[0] for column in cursor.description]
        results = [dict(zip(keys, row)) for row in cursor.fetchall()]
        return jsonify(results), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500


# lấy chi tiêt bằng mã sp
@app.route('/sp/chitiet', methods=['GET'])
def search_chitiet():
    try:
        masp = request.args.get('masp', '')

        cursor = conn.cursor()
        query = """
        select ct.MaChiTietSanPham,ct.MaSanPham, TenSanPham,
        MauSac.TenMau,ct.AnhDaiDien, ct.DonGiaBan
        from ChiTietSanPham ct left join MauSac
        on ct.MaMauSac = MauSac.MaMau
		join SanPham on ct.MaSanPham = SanPham.MaSanPham
        where ct.MaSanPham = ?

        """
        # select * from ChiTietSanPham
        #         Where MaSanPham = ?

        params = (f'{masp}')
        cursor.execute(query, params)
        keys = [column[0] for column in cursor.description]
        results = [dict(zip(keys, row)) for row in cursor.fetchall()]
        return jsonify(results), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# lấy chi tiét bằng mã chi tiet
@app.route('/sp/chitietsp', methods=['GET'])
def chitiet_from_machitiet():
    try:
        masp = request.args.get('machitiet', '')

        cursor = conn.cursor()
        query = """
        select ct.MaChiTietSanPham,ct.MaSanPham, TenSanPham,
        MauSac.TenMau,ct.AnhDaiDien, ct.DonGiaBan
        from ChiTietSanPham ct left join MauSac
        on ct.MaMauSac = MauSac.MaMau
		join SanPham on ct.MaSanPham = SanPham.MaSanPham
        where ct.MaChiTietSanPham = ?

        """
        # select * from ChiTietSanPham
        #         Where MaSanPham = ?

        params = (f'{masp}')
        cursor.execute(query, params)
        keys = [column[0] for column in cursor.description]
        results = [dict(zip(keys, row)) for row in cursor.fetchall()]
        return jsonify(results), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/sp/Image', methods=['GET'])
def anh_sp():
    try:
        masp = request.args.get('masp', '')

        cursor = conn.cursor()
        query = """
          select * from HinhAnhSanPham where MaSanPham = ?
        """
        params = (f'{masp}')
        cursor.execute(query, params)
        keys = [column[0] for column in cursor.description]
        results = [dict(zip(keys, row)) for row in cursor.fetchall()]
        return jsonify(results), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500


# 3. Tìm kiếm sản phẩm theo tên
@app.route('/api/sanpham/search', methods=['GET'])
def search_sanpham():
    try:
        keyword = request.args.get('tentk', '').strip()
        with conn.cursor() as cursor:
            cursor.execute("""
                SELECT *
                FROM SanPham 
                WHERE TenSanPham LIKE ? COLLATE Vietnamese_CI_AI
            """, (f'%{keyword}%',))
            keys = [column[0] for column in cursor.description]
            results = [dict(zip(keys, row)) for row in cursor.fetchall()]
        return jsonify(results), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500


# --- HÀM CHUYỂN KẾT QUẢ VỀ JSON ---
def fetch_all_json(cursor):
    columns = [column[0] for column in cursor.description]
    return [dict(zip(columns, row)) for row in cursor.fetchall()]

# --- API 1: Phân trang sản phẩm theo loại ---
@app.route("/api/sanpham/page", methods=["GET"])
def get_sanpham_theo_loai():
    cursor = conn.cursor()
    ma_loai = request.args.get("maloai")
    page = int(request.args.get("page", 1))
    page_size = int(request.args.get("pageSize", 6))
    offset = (page - 1) * page_size


    query = """
        SELECT * FROM SanPham
        WHERE MaLoaiHang = ?
        ORDER BY MaSanPham
        OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
    """
    cursor.execute(query, (ma_loai, offset, page_size))
    return jsonify(fetch_all_json(cursor))

""" phan trang  """
PAGE_SIZE = 6 # Giống bên ASP.NET

@app.route("/api/sanpham/loc", methods=["GET"])
def loc_san_pham():
    try:
        # Lấy các tham số query
        maloai = request.args.get("maloai")
        tentk = request.args.get("tentk", "").lower()
        loaisx = request.args.get("loaisx")
        pageindex = int(request.args.get("pageindex", 1))

        # Lọc dữ liệu
        cursor = conn.cursor()
        cursor.execute("select * from SanPham")
        result = []
        keys = []
        for i in cursor.description:
            keys.append(i[0])
        for val in cursor.fetchall():
            result.append(dict(zip(keys, val)))

        if maloai:
            result = [sp for sp in result if sp["MaLoaiHang"] == maloai]

        if tentk:
            # result = [sp for sp in result if tentk in sp["TenSanPham"].lower()]
            tentk = tentk.lower()
            result = [sp for sp in result if
                      difflib.SequenceMatcher(None, tentk, sp["TenSanPham"].lower()).ratio() >= 0.7]

        # Sắp xếp
        if loaisx == "AZ":
            result.sort(key=lambda x: x["TenSanPham"])
        elif loaisx == "ZA":
            result.sort(key=lambda x: x["TenSanPham"], reverse=True)
        elif loaisx == "giatang":
            result.sort(key=lambda x: x["GiaToiThieu"])
        elif loaisx == "giagiam":
            result.sort(key=lambda x: x["GiaToiThieu"], reverse=True)

        # Phân trang
        total_items = len(result)
        total_pages = math.ceil(total_items / PAGE_SIZE)
        start = (pageindex - 1) * PAGE_SIZE
        end = start + PAGE_SIZE
        paged_data = result[start:end]

        return jsonify({
            "products": paged_data,
            "pageIndex": pageindex,
            "pageNum": total_pages,
            "totalItems": total_items
        }), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

""" sắp xép"""

# gia giam
# @app.route('/api/sx/giagiam', methods=['GET'])
# def sx_giagiam():
#     try:
#         with conn.cursor() as cursor:
#             cursor.execute("""
#                 select * from SanPham
#                 order by GiaToiThieu desc
#             """)
#             keys = [column[0] for column in cursor.description]
#             results = [dict(zip(keys, row)) for row in cursor.fetchall()]
#         return jsonify(results), 200
#     except Exception as e:
#         return jsonify({'error': str(e)}), 500

# gia tang
# @app.route('/api/sx/giatang', methods=['GET'])
# def sx_giatang():
#     try:
#         keyword = request.args.get('sx', '').strip()
#         with conn.cursor() as cursor:
#             cursor.execute("""
#                 select * from SanPham
#                 order by GiaToiThieu asc
#             """)
#             keys = [column[0] for column in cursor.description]
#             results = [dict(zip(keys, row)) for row in cursor.fetchall()]
#         return jsonify(results), 200
#     except Exception as e:
#         return jsonify({'error': str(e)}), 500



""" Phần giỏ hàng """
def getPById(machitietsp):
    cursor = conn.cursor()
    query = """
                              select MaChiTietSanPham, TenSanPham, DonGiaBan, TenMau, AnhDaiDien
                    from ChiTietSanPham join SanPham on ChiTietSanPham.MaSanPham = SanPham.MaSanPham
                    left join MauSac on ChiTietSanPham.MaMauSac = MauSac.MaMau
                    where MaChiTietSanPham = ?
                            """
    cursor.execute(query, machitietsp)
    result = []
    keys = []
    for i in cursor.description:
        keys.append(i[0])
    for val in cursor.fetchall():
        result.append(dict(zip(keys, val)))
    return result



# API: Xem giỏ hàng
@app.route('/cartSL',methods = ['GET'])
def get_cart_sl():
    cart_cookie = request.cookies.get('cart')
    items = []
    if cart_cookie:
        try:
            items = json.loads(cart_cookie)
            sl = 0
            for item in items:
                sl += int(item['sl'])

            return jsonify({'soluong' : sl})
        except json.JSONDecodeError:
            return jsonify({"error": 'Lỗi dữ liệu cookie'}), 500

    return  jsonify({'soluong' : len(items)})

@app.route('/cart', methods=['GET'])
def get_cart():
    cart_cookie = request.cookies.get('cart')
    items = []
    cart_item = []
    if cart_cookie:
        # nếu cookie tồn tại
        try:
            cart_item = json.loads(cart_cookie)

            sum = 0
            thanhtien =0
            for item in cart_item:
                sp = getPById(item['machitietsp'])
                print(str(item['machitietsp']))
                print(str(sp))
                if sp:  # kiểm tra sản phẩm có tồn tại không
                    sum += float(sp[0]['DonGiaBan']) * int(item['sl'])
                    thanhtien = float(sp[0]['DonGiaBan']) * int(item['sl'])
                    items.append({
                        "MaChiTietSanPham": sp[0]['MaChiTietSanPham'],
                        "TenSanPham": sp[0]['TenSanPham'],
                        "DonGiaBan": float(sp[0]['DonGiaBan']),
                        "TenMau": sp[0]['TenMau'],
                        "HinhAnhSanPham": sp[0]['AnhDaiDien'],
                        "sl": float(item['sl']),
                        "thanhtien" : float(thanhtien)
                    })

            return jsonify({'cart' : items, 'tong' : sum})
        except json.JSONDecodeError:
            return jsonify({"error": 'Lỗi dữ liệu cookie'}), 500
    else:
        # cart cookie không tồn tại
        # response = make_response("add cookie")
        # response.set_cookie('cart', 'lisa', max_age=30 * 60)

        return jsonify({"cart": '1'})

# cart : [{'mactsp' : , 'sl' :}}
# API: Thêm sản phẩm vào giỏ hàng
@app.route('/add-to-cart', methods=['POST'])
def add_to_cart():
    data = request.get_json()
    machitietsp = data.get('machitietsp')
    sl = int(data.get('sl',1))
    # if not data or machitietsp not in data or sl not in data:
    #     return jsonify({'error': 'Invalid data'}), 400

    # lấy giỏ hàng
    cart_cookie = request.cookies.get('cart')
    cart_items = []
    if cart_cookie:
        try:
            cart_items = json.loads(cart_cookie)
        except json.JSONDecodeError:
            return jsonify({"error": 'Lỗi dữ liệu cookie'}), 500


    # Kiểm tra sản phẩm đã có trong giỏ chưa, nếu có thì cộng số lượng
    for item in cart_items:
        if item['machitietsp'] == machitietsp:
            item['sl'] += sl
            break
    else:
        cart_items.append({
            'machitietsp': machitietsp,
            'sl': sl
        })


    # Lưu lại cookie
    response = make_response(jsonify({'message': 'Item added to cart', 'cart': cart_items}))
    response.set_cookie('cart', json.dumps(cart_items),samesite='None',secure=True ,max_age=30*60)  # Cookie sống trong 30 phút
    return response

# tăng lên 1
@app.route('/api/cart/increase', methods=['POST'])
def increase_quantity():
    data = request.get_json()
    machitietsp = data.get('machitietsp')

    if not machitietsp:
        return jsonify({'error': 'Thiếu mã sản phẩm'}), 400

    cart_cookie = request.cookies.get('cart')
    cart_items = []
    if cart_cookie:
        try:
            cart_items = json.loads(cart_cookie)
        except json.JSONDecodeError:
            return jsonify({"error": 'Lỗi dữ liệu cookie'}), 500

    for item in cart_items:
        if item['machitietsp'] == machitietsp:
            item['sl'] += 1
            break

    response = make_response(jsonify({'message': 'Tăng số lượng thành công', 'cart': cart_items}))
    response.set_cookie('cart', json.dumps(cart_items), samesite='None', secure=True, max_age=30*60)
    return response

#giảm
@app.route('/api/cart/decrease', methods=['POST'])
def decrease_quantity():
    data = request.get_json()
    machitietsp = data.get('machitietsp')

    if not machitietsp:
        return jsonify({'error': 'Thiếu mã sản phẩm'}), 400

    cart_cookie = request.cookies.get('cart')
    cart_items = []
    if cart_cookie:
        try:
            cart_items = json.loads(cart_cookie)
        except json.JSONDecodeError:
            return jsonify({"error": 'Lỗi dữ liệu cookie'}), 500

    for item in cart_items:
        if item['machitietsp'] == machitietsp:
            if item['sl'] > 1:
                item['sl'] -= 1
            else:
                cart_items.remove(item)
            break

    response = make_response(jsonify({'message': 'Giảm số lượng thành công', 'cart': cart_items}))
    response.set_cookie('cart', json.dumps(cart_items), samesite='None', secure=True, max_age=30*60)
    return response


# xóa 1 sản phẩm
@app.route('/remove-from-cart', methods=['POST'])
def remove_from_cart():
    data = request.get_json()
    machitietsp = data.get('machitietsp')

    if not machitietsp:
        return jsonify({'error': 'Thiếu mã chi tiết sản phẩm'}), 400

    # lấy giỏ hàng
    cart_cookie = request.cookies.get('cart')
    cart_items = []
    if cart_cookie:
        try:
            cart_items = json.loads(cart_cookie)
        except json.JSONDecodeError:
            return jsonify({"error": 'Lỗi dữ liệu cookie'}), 500

    # Lọc bỏ sản phẩm cần xoá
    cart_items = [item for item in cart_items if item['machitietsp'] != machitietsp]

    # Cập nhật lại cookie
    response = make_response(jsonify({'message': 'Đã xoá sản phẩm', 'cart': cart_items}))
    response.set_cookie('cart', json.dumps(cart_items),samesite='none',secure=True,max_age=1800)  # Cookie sống 30 phút
    return response

# API: Xóa giỏ hàng
@app.route('/clear_cart', methods=['POST'])
def clear_cart():
    response = make_response(jsonify({'message': 'Cart cleared'}))
    response.set_cookie('cart', '', expires=0,samesite='None', secure=True)  # Xóa cookie
    return response


@app.route('/set_cookie')
def set_cookie():
    resp = make_response("Cookie đã được set!")
    resp.set_cookie('cookie 1', 'cookie',samesite='Lax', max_age=60*30)  # cookie tồn tại 30 phút
    return resp

from datetime import datetime
# tạo hóa đơn
def sinhma():
    today = datetime.now().strftime('%Y%m%d')  # ví dụ: 20250424
    rand = random.randint(1000, 9999)  # số ngẫu nhiên 4 chữ số
    return f"HD{today}{rand}"

# thêm hóa đơn mua từ giỏ hàng
@app.route('/them_hoadon', methods=['PUT'])
def them_hoadon():
    try:
        mahd = sinhma()
        ngayban = datetime.now().strftime('%Y%m%d')

        tongtien = flask.request.json.get("tongtien")
        hovaten =flask.request.json.get("hovaten")
        email =flask.request.json.get("email")
        sdt =flask.request.json.get("sdt")
        dcct =flask.request.json.get("dcct")
        tinh =flask.request.json.get("tinh")
        huyen =flask.request.json.get("huyen")
        xa =flask.request.json.get("xa")
        pttt =flask.request.json.get("pttt")

        # lấy giỏ hàng từ cooke
        cart_cookie = flask.request.cookies.get('cart')
        if not cart_cookie:
            return jsonify({"error": "Không có giỏ hàng"}), 400

        try:
            cart_items = json.loads(cart_cookie)
        except json.JSONDecodeError:
            return jsonify({"error": "Cookie giỏ hàng không hợp lệ"}), 500

        if not cart_items:
            return jsonify({"error": "Giỏ hàng trống"}), 400

        # thêm vào hóa đơn bàn
        cursor = conn.cursor()
        sql = """
        insert into HoaDonBan(MaHoaDonBan, NgayBan, TongTien,HoVaTen, Email,SDT, DiaChiCuThe,Tinh,
        Huyen, Xa, PhuongThucThanhToan)
        Values (?,?,?,?,?,?,?,?,?,?,?)
        """
        data = ( mahd,ngayban, tongtien,hovaten,email,sdt,dcct,tinh,huyen,xa,pttt)
        cursor.execute(sql, data)
        # conn.commit()
        # resp = flask.jsonify({"mess": "thành công"})
        # resp.status_code = 200
        # return resp

    #     thêm vào chi tiết
        for item in cart_items:
            machitietsp = item['machitietsp']
            sl = item['sl']

            # Lấy đơn giá từ CSDL hoặc đặt cố định nếu có
            cursor.execute(" SELECT DonGiaBan FROM ChiTietSanPham WHERE MaChiTietSanPham = ?", (machitietsp,))
            row = cursor.fetchone()
            if not row:
                continue  # sản phẩm không tồn tại thì bỏ qua

            dongia = row[0]
            cursor.execute("""
                INSERT INTO ChiTietHoaDonBan(MaHoaDonBan,MaChiTietSanPham,SoLuongBan,GiaBan)
                VALUES (?, ?, ?, ?)
            """, (mahd, machitietsp, sl, dongia))

        conn.commit()
        resp = flask.jsonify({"mess": "thêm hóa đơn thành công"})
        resp.set_cookie('cart', '', expires=0,samesite='None', secure=True)  # Xóa cookie
        resp.status_code = 200
        return resp

    except Exception as e:
        print(e)
        return jsonify({"error": str(e)}), 500

# theem hoa đơn mua ngay
@app.route('/muangay', methods=['PUT'])
def hoadon_muangay():
    try:
        mahd = sinhma()
        ngayban = datetime.now().strftime('%Y%m%d')

        tongtien = flask.request.json.get("tongtien")
        hovaten =flask.request.json.get("hovaten")
        email =flask.request.json.get("email")
        sdt =flask.request.json.get("sdt")
        dcct =flask.request.json.get("dcct")
        tinh =flask.request.json.get("tinh")
        huyen =flask.request.json.get("huyen")
        xa =flask.request.json.get("xa")
        pttt =flask.request.json.get("pttt")
        machitiet = flask.request.json.get("machitiet")
        sl = flask.request.json.get("sl")



        # thêm vào hóa đơn bàn
        cursor = conn.cursor()
        sql = """
        insert into HoaDonBan(MaHoaDonBan, NgayBan, TongTien,HoVaTen, Email,SDT, DiaChiCuThe,Tinh,
        Huyen, Xa, PhuongThucThanhToan)
        Values (?,?,?,?,?,?,?,?,?,?,?)
        """
        data = ( mahd,ngayban, tongtien,hovaten,email,sdt,dcct,tinh,huyen,xa,pttt)
        cursor.execute(sql, data)
        # conn.commit()
        # resp = flask.jsonify({"mess": "thành công"})
        # resp.status_code = 200
        # return resp

    #     thêm vào chi tiết
        # Lấy đơn giá từ CSDL hoặc đặt cố định nếu có
        cursor.execute(" SELECT DonGiaBan FROM ChiTietSanPham WHERE MaChiTietSanPham = ?", (machitiet,))
        row = cursor.fetchone()
        dongia = row[0]
        cursor.execute("""
                        INSERT INTO ChiTietHoaDonBan(MaHoaDonBan,MaChiTietSanPham,SoLuongBan,GiaBan)
                        VALUES (?, ?, ?, ?)
                    """, (mahd, machitiet, sl, dongia))


        conn.commit()
        resp = flask.jsonify({"mess": "thêm hóa đơn thành công"})
        resp.set_cookie('cart', '', expires=0,samesite='None', secure=True)  # Xóa cookie
        resp.status_code = 200
        return resp

    except Exception as e:
        print(e)
        return jsonify({"error": str(e)}), 500

#tìm kiếm loại sản phẩm cho chat bot
@app.route('/api/loaisanpham/search', methods=['GET'])
def search_loai_san_pham():
    keyword = request.args.get('keyword', '').lower()
    try:
        cursor = conn.cursor()
        query = """
            SELECT MaLoaiHang, TenLoaiHang FROM LoaiHang
            WHERE LOWER(TenLoaiHang) LIKE ?
        """
        cursor.execute(query, (f'%{keyword}%',))
        rows = cursor.fetchall()
        if rows:
            result = [{"MaLoaiHang": row[0], "TenLoaiHang": row[1]} for row in rows]
            return jsonify({"status": "success", "data": result}), 200
        else:
            return jsonify({"status": "notfound"}), 404
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500

#chuongtrinhkhuyenmai
@app.route('/khuyenmai', methods=['GET'])
def get_khuyen_mai():
    try:
        cursor = conn.cursor()
        cursor.execute("""
            SELECT ChuDe, NoiDung, NgayBatDau, NgayKetThuc 
            FROM ChuongTrinhKhuyenMai
            WHERE NgayBatDau BETWEEN GETDATE() AND DATEADD(MONTH, 3, GETDATE())
        """)
        rows = cursor.fetchall()
        keys = [desc[0] for desc in cursor.description]

        def format_date(d):
            if isinstance(d, datetime):
                return d.strftime('%Y-%m-%d')
            return str(d)

        result = []
        for row in rows:
            row_dict = dict(zip(keys, row))
            row_dict['NgayBatDau'] = format_date(row_dict['NgayBatDau'])
            row_dict['NgayKetThuc'] = format_date(row_dict['NgayKetThuc'])
            result.append(row_dict)

        return jsonify({"status": "success", "data": result}), 200
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500

# Lấy danh sách đánh giá của 1 sản phẩm
@app.route('/api/danhgia/<ma_san_pham>', methods=['GET'])
def lay_danh_gia(ma_san_pham):
    # Mở kết nối với cơ sở dữ liệu
    cursor = conn.cursor()

    # Thực thi truy vấn SQL để lấy các đánh giá của sản phẩm
    cursor.execute("""
        SELECT N.TenNguoiDung, N.Email, D.SoSao, D.NoiDung, D.ThoiGian
        FROM DanhGiaSanPham D
        JOIN NguoiBinhLuan N ON D.MaNguoiDung = N.MaNguoiDung
        WHERE D.MaSanPham = ?
        ORDER BY D.ThoiGian DESC
    """, (ma_san_pham,))

    # Lấy kết quả trả về
    rows = cursor.fetchall()
    cursor.close()

    # Chuyển đổi kết quả thành dạng JSON
    danh_gia_list = [{
        "TenNguoiDung": row[0],
        "Email": row[1],
        "SoSao": row[2],
        "NoiDung": row[3],
        "ThoiGian": row[4].strftime("%Y-%m-%d %H:%M:%S")  # Định dạng thời gian
    } for row in rows]

    # Trả về danh sách các đánh giá dưới dạng JSON
    return jsonify(danh_gia_list)

# Gửi đánh giá mới
@app.route('/api/danhgia', methods=['POST'])
def gui_danh_gia():
    try:
        data = request.json

        ma_chi_tiet = data.get('MaSanPham')  # Tên đúng theo bảng
        ten = data.get('TenNguoiDung')
        email = data.get('Email')
        sosao = int(data.get('SoSao'))
        noidung = data.get('NoiDung')

        cursor = conn.cursor()

        # 1. Kiểm tra người dùng đã tồn tại hay chưa
        cursor.execute("SELECT MaNguoiDung FROM NguoiBinhLuan WHERE Email = ?", (email,))
        row = cursor.fetchone()

        if row:
            ma_nguoi_dung = row[0]
        else:
            # Thêm người dùng mới
            cursor.execute(
                "INSERT INTO NguoiBinhLuan (TenNguoiDung, Email) "
                " OUTPUT INSERTED.MaNguoiDung  "
                "VALUES (?, ?)",
                (ten, email)
            )
            ma_nguoi_dung = cursor.fetchone()[0]

        # 2. Chèn đánh giá vào bảng DanhGiaSanPham
        cursor.execute("""
            INSERT INTO DanhGiaSanPham (MaSanPham, MaNguoiDung, SoSao, NoiDung)
            VALUES (?, ?, ?, ?)
        """, (ma_chi_tiet, ma_nguoi_dung, sosao, noidung))

        conn.commit()
        return jsonify({"message": "Đánh giá đã được gửi thành công!"}), 201

    except Exception as e:
        print("Lỗi khi gửi đánh giá:", e)
        return jsonify({"error": str(e)}), 500


#đếm số lượng đánh giá
@app.route('/api/danhgia/soluong/<ma_san_pham>', methods=['GET'])
def dem_so_luong_danh_gia(ma_san_pham):
    try:
        cursor = conn.cursor()
        cursor.execute("""
            SELECT COUNT(*) FROM DanhGiaSanPham
            WHERE MaSanPham = ?
        """, (ma_san_pham,))
        count = cursor.fetchone()[0]
        return jsonify({"soLuong": count})
    except Exception as e:
        print("Lỗi truy vấn:", str(e))  # ✅ In ra lỗi
    return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True)