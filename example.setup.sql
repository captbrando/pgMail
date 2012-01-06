create table orders (
	id integer,
	firstname varchar(200),
	lastname varchar(200),
	email varchar(200),
	paystatus varchar(1) default 'n'
);

create function checkordermail() returns opaque as '
DECLARE
	customerRec RECORD;
	textMessage text;
BEGIN
	select into customerRec * from orders where id = NEW.id;
	if customerRec.paystatus = ''y'' then
		textMessage := ''Thank you for paying your bill.  How sweet of you.
			I love cake.  Dont you?'';
		perform pgmail(''Order System<os@fart.com>'',customerRec.email,''You paid.  How nice.'', textMessage);
	end if;
	return NEW;
END;' language 'plpgsql';

CREATE TRIGGER trgCheckOrderMail
	AFTER INSERT OR UPDATE ON orders FOR EACH ROW
	EXECUTE PROCEDURE checkordermail();

