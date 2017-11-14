


select pgmail_multipart(
    mailfrom:='from_mail_address',
    mailto:='to_mail_address',
    subject:='html_test',
    message_html:='<html><body><img src="https://www.postgresql.org/media/img/layout/hdr_left.png">
    <h2>This is a test mail from pg_mail</h2>
    <p>Showing some formatting</p></body></html>',
    message_plain:='This is a test mail from pg_mail in plain text'
    );
