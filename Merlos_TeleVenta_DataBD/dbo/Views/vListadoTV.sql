	
CREATE VIEW vListadoTV AS
select id, usuario, fecha, nombre, isnull(clientes,'') as clientes, isnull(llamadas,'') as llamadas, isnull(pedidos,'') as pedidos, isnull(subtotal,0.00) as subtotal
, isnull(importe,0.00) as importe, FechaInsertUpdate 
from [TeleVentaCab]