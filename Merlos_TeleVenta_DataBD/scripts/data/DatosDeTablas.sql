IF not exists (select * from Configuracion_Email where Id=1)
insert into Configuracion_Email ( Cuenta, ServidorSMTP, Puerto, [SSL], Usuario, [Password] ) 
values ('noreply@cliseller.com','smtp.ionos.es','587',1,'noreply@cliseller.com','4N6Brt6IH4DKNTYzZfE@')