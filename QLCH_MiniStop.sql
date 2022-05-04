CREATE DATABASE aa -- tạo CSDL quản lý bán hàng

USE aa -- sử dụng CSDL quản lý bán hàng

--tạo bảng Khách Hàng

CREATE TABLE KhachHang
(
	MaKH		nchar (4) constraint PK_KhachHang primary key ,
	TenKH		nvarchar (30)	not null,
	DiachiKH	nvarchar (50),
	NgaySinhKH	datetime,
	SoDtKH		nvarchar (15)
)

--tạo bảng Nhân Viên

CREATE TABLE NhanVien
(
	MaNV		nchar (4) constraint PK_NhanVien primary key ,
	HoTenNV		nvarchar (30)		not null,
	GioiTinh	nvarchar (20)		not null
	constraint Ck_NhanVien_Gioitinh check (GioiTinh in (N'Nữ', N'Nam', N'Khác')),
	DiaChiNV	nvarchar (50)		not null,
	NgaySinhNV		datetime		not null,
	DienThoaiNV		nvarchar (15),
	Email			ntext,
	NoiSinh			nvarchar (20)	not null,
	NgayVaolam		datetime ,
	MaNQL			nchar (4)
	constraint FK_NhanVien_MaNQL references NhanVien (MaNV)
)

--tạo bảng Nhà cung cấp

CREATE TABLE NhaCC
(
	MaNCC		nchar (5) constraint PK_NhaCC primary key ,
	TenNCC		nvarchar (50)	not null,
	DiaChiNCC	nvarchar (50)		not null,
	DienThoaiNCC		nvarchar (15)	not null,
	EmailNCC			nvarchar (30)  not null, 

)

--tạo bảng Loại Sản Phẩm

CREATE TABLE LoaiSP
(
	MaLoaiSP		nchar (4) constraint PK_LoaiSP primary key ,
	TenLoaiSP		nvarchar (30)	not null,
	Ghichu			nvarchar (100)		not null
	
)

--tạo bảng Sản Phẩm

CREATE TABLE SanPham
(
	MaSP		nchar (4) constraint PK_SanPham primary key ,
	MaLoaiSP	nchar (4)	not null,
	TenSP		nchar (50)		not null,
	DonViTinh		nvarchar (10)	not null,
	
	constraint FK_SanPham_MaLoaiSP foreign key (MaLoaiSP) references LoaiSP (MaLoaiSP)
)

--tạo bảng Kho Hàng

create table KhoHang
(
	MaSP nchar(4)
	constraint PK_KhoHang primary key,

	SoLuongTon int
	constraint Ck_KhoHang_SoLuongTon check (SoLuongTon >=0)
	constraint FK_KhoHang_MaSP foreign key (MaSP) references SanPham (MaSP)
)

--tạo bảng Phiếu Nhập
CREATE TABLE PhieuNhap
(
	SoPN		nchar (5) constraint PK_PhieuNhap primary key ,
	MaNV		nchar (4)	not null,
	MaNCC		nchar (5)	not null,
	NgayNhap	datetime	not null,
	

	constraint FK_PhieuNhap_MaNV foreign key (MaNV) references NhanVien (MaNV),
	constraint FK_PhieuNhap_MaNCC foreign key (MaNCC) references NhaCC (MaNCC)
)

--tạo bảng Chi tiet Phiếu Nhập

CREATE TABLE CTPhieuNhap
(
	SoPN		nchar (5),
	MaSP		nchar (4),
	SoLuongNhap	smallint not null
	constraint Ck_CTPN_Soluongnhap check (SoLuongNhap >=0),
	GiaNhap		decimal	not null
	constraint Ck_CTPN_GiaNhap check (GiaNhap >=0)

	constraint PK_CTPhieuNhap primary key (SoPN, MaSP)
	constraint FK_CTPhieuNhap_SoPN foreign key (SoPN) references PhieuNhap (SoPN),
	constraint FK_CTPhieuNhap_MaSP foreign key (MaSP) references SanPham (MaSP)
)

--tạo bảng Phiếu Xuất

CREATE TABLE HoaDon
(
	MaHD		nchar (5) constraint PK_MaHD primary key ,
	MaNV		nchar (4)	not null,
	MaKH		nchar (4)		not null,
	NgayBan		datetime	not null,
	

	constraint FK_HD_MaNV foreign key (MaNV) references NhanVien (MaNV),
	constraint FK_HD_MaKH foreign key (MaKH) references KhachHang (MaKH)
)

--tạo bảng Chi tiet Phiếu Xuat

CREATE TABLE CTHoaDon
(
	MaHD		nchar (5),
	MaSP		nchar (4),
	SoLuongBan	smallint not null
	constraint Ck_CTPX_SoLuongBan check (SoLuongBan >=0),
	GiaBan		decimal	not null
	constraint Ck_CTPX_Giaban check (GiaBan >=0)
	constraint PK_CTPhieuXuat primary key (MaHD, MaSP)
	constraint FK_CTPhieuXuat_MaHD foreign key (MaHD) references HoaDon (MaHD),
	constraint FK_CTPhieuXuat_MaSP foreign key (MaSP) references SanPham (MaSP)
)


--1 Thêm dữ liệu vào bảng Nhân Viên

INSERT INTO NhanVien
VALUES ('V001', N'Trần Thành', 'Nam', N'Quận 1', convert (datetime, '1988-2-21'), '0915007523', 'thanh@gmail.com', N'Quận 7', convert (datetime, '2010-2-21'), Null)

INSERT INTO NhanVien
VALUES   ('V002', N'Trần Thành Giang', 'Nam', N'Quận 12', convert (datetime, '1988-6-21'), '0915007593', 'thanhgiang@gmail.com', N'Quận 8', convert (datetime, '2010-2-21'), 'V001'),
         ('V003', N'Trần Hương Giang', N'Nữ', N'Quận 10', convert (datetime, '1998-6-21'), '0915097593', 'giang@gmail.com', N'Quận 9', convert (datetime, '2016-2-21'), 'V001'), 
         ('V004', N'Ngô Hương Hòa', N'Nữ', N'Quận 10', convert (datetime, '1987-6-29'), '0915091593', 'hoa@gmail.com', N'Quận 10', convert (datetime, '2014-2-21'), 'V001'),
         ('V005', N'Ngô Thành Hòa', N'Nữ', N'Quận Bình Thạnh', convert (datetime, '1986-6-29'), '0935091593', 'thanhhoa@gmail.com', N'Quận 10', convert (datetime, '2017-2-21'), Null),
         ('V006', N'Nguyễn Thành Giang', 'Nam', N'Quận 12', convert (datetime, '1960-6-25'), '0915007599', 'nguyenthanhgiang@gmail.com', N'Quận 12', null, null),
         ('V007', N'Trần Như Ý', N'Nữ', N'Quận 2', convert (datetime, '1965-6-21'), '0915807593', 'nhuy@gmail.com', N'Quận 8', null, null)

--2 Thêm dữ liệu vào bảng Khách Hàng

INSERT INTO KhachHang
VALUES ('KH01', N'Khách hàng vãng lai', null, null, null)

INSERT INTO KhachHang
VALUES ('KH02', N'Nguyễn Hằng', N'Quận 11', convert (datetime, '1986-7-29'), '0978111333'),
	   ('KH03', N'Nguyễn Minh Tuấn', N'Quận 12', convert (datetime, '1981-11-29'), '0988111333'),
	   ('KH04', N'Nguyễn Minh Anh', N'Quận 2', convert (datetime, '1983-11-24'), '0988111332'),
	   ('KH05', N'Trần Minh Tuấn', N'Quận 6', convert (datetime, '1980-10-21'), '0988111336')

INSERT INTO KhachHang
VALUES ('KH06', N'Nguyễn Hải', N'Quận Tân Bình', convert (datetime, '1986-8-20'), '0978333333'),
	   ('KH07', N'Nguyễn Tuấn Tú', N'Quận 1', convert (datetime, '1985-10-29'), '0988111222'),
	   ('KH08', N'Nguyễn Anh Dũng', N'Quận 4', convert (datetime, '1983-10-24'), '0977211332'),
	   ('KH09', N'Trần Quốc', N'Quận 6', convert (datetime, '1980-10-06'), '0988111156')
--3 Thêm dữ liệu vào bảng Nhà Cung Cấp

INSERT INTO NhaCC
VALUES ('CC001', N'Công ty XMN', N'Quận 11', '0928111333', 'xmn@xmn.com', null),
	   ('CC002', N'Công ty VVMN', N'Quận Bình Tân', '0928111223', 'vnn@nn.com', null), 
	   ('CC003', N'Công ty XLUK', N'Quận 12', '0928111443', 'xluk@xluk.com', null),
	   ('CC004', N'Công ty LGMN', N'Quận 8', '0988111444', 'xLG@xln.com', null),
	   ('CC005', N'Công ty PGU', N'Quận 9', '0988111111', 'PLn@pln.com', null)

--4 Thêm dữ liệu vào bảng Loại Sản Phẩm

INSERT INTO LoaiSP
VALUES ('L001', N'Bột giặt, nước xả', N'Hàng tiêu dùng'),
	   ('L002', N'Quần áo', N'Hàng thời trang'), 
	   ('L003', N'Chăm sóc da', N'Hóa mỹ phẩm'), 
	   ('L004', N'Chăm sóc tóc', N'Hóa mỹ phẩm'),
       ('L005', N'Giày dép', N'Hàng thời trang'),
	   ('L006', N'Gia vị', N'Hàng tiêu dùng'),
	   ('L007', N'Thực phẩm', N'Hàng tiêu dùng')

--5 Thêm dữ liệu vào bảng Sản Phẩm

INSERT INTO SanPham
VALUES ('SP01', 'L001', N'Nước xả vải comfort', N'Chai'),
	   ('SP02', 'L001', N'Nước rửa chén sunlight', N'Chai'),
	   ('SP03', 'L003', N'Sửa rửa mặt some by mi', N'Chai'), 
	   ('SP04', 'L003', N'Kem ngăn ngừa lão hóa', N'Hộp'), 
	   ('SP05', 'L003', N'Dưỡng chất phục hồi da', N'Chai'), 
	   ('SP06', 'L002', N'Váy trắng công sở', N'Cái'), 
	   ('SP07', 'L002', N'Sơ mi công sở', N'Cái'), 
	   ('SP08', 'L006', N'Tiêu', N'Gói'),
		('SP09', 'L005', N'Sandal nữ', N'Đôi'),
		('SP10', 'L004', N'Dầu gội thảo dược', N'Chai')

INSERT INTO SanPham
VALUES ('SP11', 'L007', N'Bánh Oreo', N'Cái'),
	   ('SP12', 'L004', N'Wax vuốt tóc', N'Chai'),
	   ('SP13', 'L005', N'Giày bitis', N'Đôi'), 
	   ('SP14', 'L006', N'Bột ngọt', N'Gói'), 
	   ('SP15', 'L006', N'Đường', N'Gói'), 
	   ('SP16', 'L007', N'Bánh giò', N'Cái'), 
	   ('SP17', 'L004', N'Thuốc nhuộm tóc', N'Hộp'), 
	   ('SP18', 'L006', N'Nước tương', N'Chai'),
		('SP19', 'L005', N'Dép kẹp', N'Đôi'),
		('SP20', 'L004', N'Keo xịt tóc', N'Chai')

--6 Them du lieu vao bang KhoHang
insert into KhoHang
values ('SP01',0)
insert into KhoHang
values 
('SP02',1000)
insert into KhoHang
values 
('SP03',500),
('SP04',700)
insert into KhoHang
values 
('SP05',100),
('SP06',100),
('SP07',200),
('SP08',400),
('SP09',800),
('SP10',100),
('SP11',300),
('SP12',400),
('SP13',900),
('SP14',400),
('SP15',500),
('SP16',200),
('SP17',400),
('SP18',100),
('SP19',600),
('SP20',90)
 

--7 Thêm dữ liệu vào bảng Phiếu Nhập

INSERT INTO PhieuNhap
VALUES 
       ('PN01', 'V001', 'CC001', convert (datetime, '2018-6-29')),
	   ('PN02', 'V002', 'CC001', convert (datetime, '2018-6-30')),
	   ('PN03', 'V002', 'CC003', convert (datetime, '2018-5-20')),
	   ('PN04', 'V003', 'CC002', convert (datetime, '2018-2-21')),
	   ('PN05', 'V004', 'CC004', convert (datetime, '2019-7-30')),
	   ('PN06', 'V004', 'CC005', convert (datetime, '2019-11-30')),
	   ('PN07', 'V004', 'CC005', convert (datetime, '2020-11-30'))

INSERT INTO PhieuNhap
VALUES 
       ('PN08', 'V005', 'CC001', convert (datetime, '2018-6-29')),
	   ('PN09', 'V006', 'CC001', convert (datetime, '2018-6-30')),
	   ('PN10', 'V006', 'CC003', convert (datetime, '2018-5-20')),
	   ('PN11', 'V007', 'CC002', convert (datetime, '2018-2-21')),
	   ('PN12', 'V007', 'CC004', convert (datetime, '2019-7-30')),
	   ('PN13', 'V005', 'CC005', convert (datetime, '2019-11-30')),
	   ('PN14', 'V005', 'CC005', convert (datetime, '2020-11-30'))

--8 Thêm dữ liệu vào bảng Chi tiết Phiếu Nhập

INSERT INTO CTPhieuNhap
VALUES 	    
	   ('PN01', 'SP01',100, 73300),
	   ('PN01', 'SP02',200, 38300),
	   ('PN02', 'SP03',100, 243000),
	   ('PN02', 'SP04',50, 380000),
	   ('PN02', 'SP05',50, 900000),
	   ('PN03', 'SP06',300, 543000), 
	   ('PN04', 'SP02',100, 38300),
	   ('PN05', 'SP03',100, 243000),
	   ('PN05', 'SP07',50, 250000),
	   ('PN05', 'SP15',100, 603000), 
	   ('PN06', 'SP03',100, 243000),
	   ('PN06', 'SP07',50, 250000),
	   ('PN06', 'SP06',400, 543000),
	   ('PN06','SP16',50,520000),
	   ('PN07','SP02',100, 38300), ('PN07','SP17',100, 423000), ('PN07','SP20',100, 83300),
	   ('PN08','SP08',100, 75000), ('PN08','SP18',50, 520000),
	('PN09', 'SP09',200, 40300), ('PN10', 'SP10',100, 250000),
	 ('PN11', 'SP11',50, 390000), ('PN12','SP12',50, 800000),  ('PN13','SP13',300, 603000),
	  ('PN14','SP14',100, 50300)


--9 Thêm dữ liệu vào bảng Phiếu Xuất

INSERT INTO PhieuXuat
VALUES 
       ('PX01', 'V001', 'KH01', convert (datetime, '2018-3-12')),
	   ('PX02', 'V002', 'KH03', convert (datetime, '2018-4-15')),
	   ('PX03', 'V002', 'KH03', convert (datetime, '2018-5-10')),
	   ('PX04', 'V003', 'KH02', convert (datetime, '2018-5-15')),
	   ('PX05', 'V004', 'KH04', convert (datetime, '2018-6-10')),
	   ('PX06', 'V004', 'KH01', convert (datetime, '2018-6-30')),
	   ('PX07', 'V004', 'KH03', convert (datetime, '2019-1-30')),
	   ('PX08', 'V001', 'KH04', convert (datetime, '2019-1-30'))


--10 Thêm dữ liệu vào bảng Chi tiết Phiếu Xuất

INSERT INTO CTPhieuXuat
VALUES 	    
	   ('PX01', 'SP01', 5, 85000), ('PX01', 'SP02',50, 45000),
	   ('PX02', 'SP03', 5, 300000), ('PX02', 'SP01',3, 85000), ('PX02', 'SP05', 1, 900000),
	   ('PX03', 'SP01', 3, 85000), 
	   ('PX04', 'SP02', 30,45000),
	   ('PX05', 'SP04', 10, 450000), ('PX05', 'SP07',2, 300000), 
	   ('PX06', 'SP03', 1, 300000), ('PX06', 'SP07',1, 300000),   ('PX06', 'SP06', 1, 650000), 
	   ('PX07', 'SP05', 2, 900000),
	   ('PX08', 'SP05', 2, 900000) 

	 

--Synonym:
--Tạo tên đồng nghĩa cho truy xuất vào bảng cơ sở dữ liệu của hệ thống do người dùng sys làm chủ sở hữu.
create synonym abc for sys.databases
select * from abc

--Tạo tên đồng nghĩa cho truy xuất vào bảng Khách hàng do người dùng dbo làm chủ sỡ hữu.
create synonym xyz for dbo.KhachHang
select * from xyz
---------------------------------------------------------------------------------------------------------------------
--Index

create index index_diachi on nhanvien(diachinv)
select MaNV, HoTenNV, DiaChiNV
from NhanVien
with (index(index_diachi))

create unique index index_Sdt on NhanVien(DienThoaiNV)
select MaNV, HoTenNV, DienThoaiNV
from NhanVien
with (index(index_Sdt))


exec sp_helpindex 'NhanVien';
---------------------------------------------------------------------------------------------------------------------
--view gom nhóm (Liệt kê các hóa đơn mua hàng theo từng khách hàng,
--gồm các thông tin: số phiếu xuất, ngày bán, mã khách hàng, tên khách hàng, trị giá)
create view vw_Gomnhom as
SELECT PhieuXuat.SoPX, PhieuXuat.MaKH, NgayBan, TenKH, Sum(SoLuongBan*GiaBan) AS TriGia
FROM PhieuXuat INNER JOIN CTPhieuXuat ON PhieuXuat.SoPX=CTPhieuXuat.SoPX INNER JOIN KhachHang ON PhieuXuat.MaKH=KhachHang.MaKH
GROUP BY PhieuXuat.SoPX, PhieuXuat.MaKH, NgayBan, TenKH

select *
from vw_Gomnhom

--view thống kê (Liệt kê danh sách nhân viên nam)
create view vw_thongke as
select MaNV, HoTenNV, GioiTinh
from NhanVien
where GioiTinh = N'Nam'

select *
from vw_thongke

--view lồng (Liệt kê các sản phẩm chưa bán được trong 6 tháng đầu năm 2018,
--thông tin gồm: mã sản phẩm, tênsản phẩm, loại sản phẩm, đơn vị tính.)
create view vw_long as
SELECT MaSP, TenSP, TenLoaiSP, DonViTinh
FROM SanPham INNER JOIN LoaiSP ON SanPham.MaLoaiSP=LoaiSP.MaLoaiSP
WHERE MaSP NOT IN 
                      ( SELECT MaSP
                       FROM PhieuXuat INNER JOIN CTPhieuXuat ON PhieuXuat.SoPX=CTPhieuXuat.SoPX
                       WHERE YEAR(NgayBan)=2018 AND MONTH (NgayBan) IN (1,2,3,4,5,6)
					   )

select *
from vw_long

--view cơ bản (Liệt kê danh sách Khách hàng)
create view vw_coban as
select *
from KhachHang

select *
from vw_coban

---------------------------------------------------------------------------------------------------------------------
--function
--FC1: Viết hàm cho biết số lượng đơn bán với tham số truyền vào là mã nhân viên
create function fc1 (@manv nchar(10))
returns int
as
begin
	declare @soluong int;
	set @soluong =0;
	select @soluong = count(PhieuXuat.SoPX)
	from PhieuXuat inner join PhieuNhap on PhieuXuat.MaNV=PhieuNhap.MaNV
	where PhieuNhap.MaNV = @manv
	group by PhieuNhap.SoPN
	return @soluong
end
go

select dbo.fc1 ('V002')

--FC2: (Viết hàm tính lãi cho từng sản phẩm (giá bán – giá mua)* số lượng đặt cho từng mặt hàng)
create function fc2()
returns table
as
return
select SanPham.MaSP,SanPham.TenSP,sum((GiaBan-GiaNhap)*SoLuongBan) as N'Lãi'
from PhieuNhap inner join CTPhieuNhap on PhieuNhap.SoPN = CTPhieuNhap.SoPN
			inner join SanPham on CTPhieuNhap.MaSP = SanPham.MaSP
			inner join CTPhieuXuat on SanPham.MaSP = CTPhieuXuat.MaSP
group by SanPham.MaSP, SanPham.TenSP, SanPham.MaSP
go

select*
from dbo.fc2()

---------------------------------------------------------------------------------------------------------------------
--store procedure
--SP 1 (Cho biết tổng trị giá của mỗi sản phẩm)
create proc pr_1
as
begin
	select SanPham.MaSP,SanPham.TenSP,SoLuongNhap*GiaNhap as 'Trigia'
	from CTPhieuNhap inner join SanPham on CTPhieuNhap.MaSP = SanPham.MaSP
	group by SanPham.MaSP,SanPham.TenSP,CTPhieuNhap.SoLuongNhap, CTPhieuNhap.GiaNhap
end

exec pr_1

--SP2(Xem thông tin phiếu xuất gồm có: mã phiếu xuất, mã nhân viên, họ tên nhân viên, mã
--khách hàng, họ tên khách hàng, ngày bán với mã số khách hàng do người dùng yêu cầu.)
create proc pr_2(@makh nchar(4))
as
begin
if exists
		(select MaKh
		from PhieuXuat
		where MaKh=@makh)
Begin
		select PhieuXuat.SoPX,NhanVien.MaNv,HoTenNV,KhachHang.MaKh,TenKH,NgayBan
		from PhieuXuat inner join NhanVien on PhieuXuat.MaNV = NhanVien.MaNV
					inner join KhachHang on PhieuXuat.MaKH = KhachHang.MaKH
		where KhachHang.MaKh=@makh
end
	else print N'Không tồn tại'
	end

exec pr_2 'KH01'

--SP3 (Xem thông tin khách hàng với mã kh do người dùng nhập)
create proc pr_3 (@makh nchar(4))
as
Begin
	select *	
	from KhachHang
	where MaKh=@makh
end

exec pr_3 'KH03'

--SP4: Xem thông tin phiếu xuất gồm mã phiếu xuất, mã sản phẩm, tên sản phẩm, số lượng bán, đơn giá bán theo khoảng thời gian từ ngày đến ngày do người dùng yêu cầu.
create proc pr_4 (@ngaybd date,@ngaykt date)
	as
	begin
		if exists (
					select ngayban
					from  phieuxuat
					where phieuxuat.ngayban between @ngaybd and @ngaykt )

					Begin 
								select phieuxuat.SoPX,NhanVien.MaNv,nhanvien.HoTenNV,KhachHang.MaKh,TenKh,phieuxuat.NgayBan
								from phieuxuat inner join NhanVien on phieuxuat.manv=NhanVien.MaNv
									inner join KhachHang on phieuxuat.MaKh = KhachHang.MaKh
								where phieuxuat.ngayban between @ngaybd and @ngaykt 
					end
		else print 'Khong ton tai'
	end

	exec pr_4 '2018-03-12' , '2018-05-15'
--SP5: Xem số lượng tồn của sản phẩm, nếu số lượng tồn >0 thì thông báo “còn hàng”, ngược lại thông báo “đã hết hàng”, với mã sản phẩm do người dùng nhập
create proc pr_5 (@masp nchar(4))
as
begin
	declare @slgton int;
	if exists (
				select MaSP
				from sanpham 
				where MaSP=@masp )
	Begin
				set @slgton =(select SoLuongTon
							from KhoHang inner join sanpham on khohang.masp = sanpham.masp
							where SanPham.MaSP=@masp)
				if @slgton > 0 print N'Còn hàng'
				else print N'Đã hết hàng'	
				end
				else print 'Khong ton tai'
	end

	exec pr_5 'SP03'

	exec pr_5 'SP01'
--SP6: Cho biết doanh thu bán hàng trong một ngày với ngày bán hàng là tham số truyền vào và doanh thu là tham số truyền ra
create proc pr_6 (@ngaybanhang datetime)
	as
	begin
		
		
		if exists (
					select NgayBan
					from phieuxuat
					where NgayBan=@ngaybanhang)
					
					Begin
						(select NgayBan,sum(SoLuongBan*GiaBan) as 'Doanh thu'
						from CTPhieuXuat inner join SanPham on CTPhieuXuat.MaSP=SanPham.MaSP
										inner join PhieuXuat on CTPhieuXuat.SoPX = PhieuXuat.SoPX
						where NgayBan=@ngaybanhang
						group by NgayBan)
						
					end
					else print 'Khong ton tai'
	end

	exec pr_6 '2018-04-15'


---------------------------------------------------------------------------------------------------------------------

--trigger 
--Trigger1: Cập nhật hàng trong kho sau khi bán hàng hoặc cập nhật.
create TRIGGER trg_CapNhatHang ON CTPhieuXuat AFTER INSERT AS 
BEGIN
	UPDATE KhoHang
	SET SoLuongTon = SoLuongTon - (
		SELECT SoLuongBan
		FROM inserted
		WHERE MaSP = KhoHang.MaSP
	)
	FROM KhoHang
	JOIN inserted ON KhoHang.MaSP = inserted.MaSP
END
GO
--Trigger2: Cập nhật hàng trong kho sau khi cập nhật bán hàng.
CREATE TRIGGER trg_CapNhatBanHang on CTPhieuXuat after update AS
BEGIN
   UPDATE KhoHang SET SoLuongTon = SoLuongTon -
	   (SELECT SoLuongBan FROM inserted WHERE MaSP = KhoHang.MaSP) +
	   (SELECT SoLuongBan FROM deleted WHERE MaSP = KhoHang.MaSP)
   FROM KhoHang 
   JOIN deleted ON KhoHang.MaSP = deleted.MaSP
end
GO
--Trigger 3: cập nhật hàng trong kho sau khi hủy bán hàng */
create TRIGGER trg_HuyBanHang ON CTPhieuXuat FOR DELETE AS 
BEGIN
	UPDATE KhoHang
	SET SoLuongTon = SoLuongTon + (SELECT SoLuongBan FROM deleted WHERE MaSP = KhoHang.MaSP)
	FROM KhoHang 
	JOIN deleted ON KhoHang.MaSP = deleted.MaSP
End

--Ban đầu select kiểm tra toàn bộ Kho hàng và CTPX (Kho và CTPX ban đầu):
go 
select * from KhoHang
go
select * from CTPhieuXuat

--Sau đấy bán được 2 sản phẩm với mã sản phẩm là SP03 - phiếu xuất PX01
insert into CTPhieuXuat values
('PX01', 'SP03', 2, 85000)

go
select * from KhoHang
go
select * from CTPhieuXuat

--Cập nhật lên bán được 10 sản phẩm
update CTPhieuXuat
set SoLuongBan = 10
where SoPX = 'PX01' and MaSP = 'SP03'

go
select * from KhoHang
go
select * from CTPhieuXuat

--Cập nhật về lại bán được 3 sản phẩm
update CTPhieuXuat
set SoLuongBan = 3
where SoPX = 'PX01' and MaSP = 'SP03'

go
select * from KhoHang
go
select * from CTPhieuXuat

--Xóa đơn bán hàng
delete CTPhieuXuat
where SoPX = 'PX01' and MaSP = 'SP03'

go
select * from KhoHang
go
select * from CTPhieuXuat


---------------------------------------------------------------------------------------------------------------------
(--User1:Tạo tài khoản
--Tạo tài khoản đăng nhập cho nhanvien với password là: 9876543
create login Nhanvien with password = '9876543'
--Tạo tài khoản đăng nhập cho quanly với password là quanly123
create login QuanLy with password = 'quanly123'

--User2: Tạo người dùng
-- Tạo người dùng có tên Trần Như Ý với tài khoản đăng nhập là nhanvien
create user TranNhuY for login Nhanvien
--Tạo người dùng có tên Lê Hồng Hà với tài khoản đăng nhập là quanly
create user LeHongHa for login QuanLy 

--User3: Cấp quyền
--B1: Tạo nhóm người dùng (Nhóm ở đây là nhóm xemdulieu) có quyền xem CSDL của Ministop
use QLBH_Ministop
create role xemdulieu
--B2: Cấp quyền cho nhóm người dùng (Cấp quyền select, insert, update trên bảng KhachHang cho người dùng TranNhuY, bảng NhanVien cho LeHongHa)
grant select, insert, update on KhachHang to TranNhuY
grant select, insert, update on NhanVien to LeHongHa


