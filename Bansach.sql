use master
go
if EXISTS (select * from sys.databases where name='BanSach')
drop database BanSach
go
create database BanSach
go
use BanSach
create table customer (
	CustomerId int identity(1,1) primary key,
	CustomerName varchar(50),
	Address varchar(100),
	Phone varchar(12)
	);
create table Book (
	BookCode int primary key,
	Category varchar(50),
	Author varchar(50),
	Publisher varchar(50),
	Title varchar(100),
	Price int,
	InStore int 
	);
create table BookSold (
	BookSoldID int primary key,
	CustomerID int,
	BookCode int,
	Date datetime,
	Price int ,
	Amount int 
	constraint fk_Bookcode foreign key (BookCode) references Book(BookCode),
	constraint fk_CustomerID foreign key (CustomerID) references Customer(CustomerID)
	);

	--1. Chèn ít nhất 5 bản ghi vào bảng Books, 5 bản ghi vào bảng Customer và 10 bản ghi vào bảng BookSold.
	insert into customer values('Jack','VietNan','091274495566');
	insert into customer values('Jill','VietNam','091274495333');
	insert into customer values('Harry','Cananda','091274495777');
	insert into customer values('Ron','China','091274495888');
	insert into customer values('Hermonie','Laos','091274495999');

	insert into Book values('110','Van hoc','HongNam','KimDong','Dac Nhan Tam','250000','200');
	insert into Book values('111','Kinh te','ChuDung','KimDong','Cach lam giau','230000','500');
	insert into Book values('112','Van hoc','NhatNam','KimDong','Bo ganh lo di','350000','2000');
	insert into Book values('113','Khoa hoc ung dung','JackKirby','KimDong','HowtoCode','400000','1000');
	insert into Book values('114','Kinh te','JohnPearl','ThanhNien','MakemeBetter','250000','400');
	
	insert into BookSold values('300','1','110','2020-02-28','235000','2');
	insert into BookSold values('301','1','113','2020-02-28','400000','1');
	insert into BookSold values('302','2','112','2020-03-01','340000','1');
	insert into BookSold values('303','3','110','2020-02-28','230000','3');
	insert into BookSold values('304','3','114','2020-03-02','238000','1');
	insert into BookSold values('305','4','111','2020-02-28','220000','2');
	insert into BookSold values('306','5','113','2020-02-25','230000','3');
	insert into BookSold values('307','5','112','2020-02-28','230000','4');
	insert into BookSold values('308','5','111','2020-02-13','230000','1');
	insert into BookSold values('309','2','112','2020-02-28','230000','2');
	insert into BookSold values('310','2','114','2020-02-28','230000','1');

	--2. Tạo một khung nhìn chứa danh sách các cuốn sách (BookCode, Title, Price) kèm theo số lượng đã bán được của mỗi cuốn sách.
	create view DS_booksold as
	select Book.BookCode, Book.Title, BookSold.Price,BookSold.Amount from Book full join BookSold on Book.BookCode=BookSold.BookCode

	select*from DS_booksold
	--3. Tạo một khung nhìn chứa danh sách các khách hàng (CustomerID, CustomerName, Address) kèm theo số lượng các cuốn sách mà khách hàng đó đã mua.
	create view DSKhachHang as
	select customer.CustomerId, customer.CustomerName, customer.Address, Book.Title,BookSold.Amount 
	from (customer inner join BookSold on customer.CustomerId=BookSold.CustomerID)
		left join book on book.BookCode=BookSold.BookCode

	select * from DSKhachHang

	--4. Tạo một khung nhìn chứa danh sách các khách hàng (CustomerID, CustomerName, Address) đã mua sách vào tháng trước, kèm theo tên các cuốn sách mà khách hàng đã mua.
	create view DSKhachHang1 as
	select customer.CustomerId, customer.CustomerName, customer.Address, Book.Title,BookSold.Amount 
	from (customer inner join BookSold on customer.CustomerId=BookSold.CustomerID)
		left join book on book.BookCode=BookSold.BookCode where (datediff(MONTH,BookSold.Date,getdate())>1)

	select * from DSKhachHang1
	--5. Tạo một khung nhìn chứa danh sách các khách hàng kèm theo tổng tiền mà mỗi khách hàng đã chi cho việc mua sách.
	create view tongtien as
	select customer.CustomerName,sum(BookSold.Price*BookSold.Amount) as tongtien from customer full join BookSold on customer.CustomerId=BookSold.CustomerID
	group by customer.CustomerName

	select * from tongtien