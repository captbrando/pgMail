insert into orders (id,firstname,lastname,email) values (1,'Customer','number1','<YOUREMAIL>');
insert into orders (id,firstname,lastname,email,paystatus) values (2,'Customer','number2','<YOUREMAIL>','y');
insert into orders (id,firstname,lastname,email) values (3,'Customer','number3','<YOUREMAIL>');
update orders set paystatus = 'y' where id = 1;
