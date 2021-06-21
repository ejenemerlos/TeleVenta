

<!-- cabecera -->
<table id="tbRecibosPendientes" class="tbStd">
	<tr>
		<th class="{{currentRole|Switch:[Cliente:inv]}}">Cliente</th>
		<th>Orden</th>
		<th>Factura</th>
		<th>Fecha de emisión</th>
		<th>Fecha de vencimiento</th>
		<th>Importe</th>
	</tr>




<!-- cuerpo -->
<tr>
   	<td class="{{currentRole|Switch:[Cliente:inv]}}">{{nCliente}}</td>
    <td class="C">{{ORDEN}}</td>
    <td>{{NUMFRA}}</td>
    <td>{{Fecha de emisión}}</td>
    <td>{{Fecha de vencimiento}}</td>
   	<td class="R recibosImporte">{{ImporteTotalF}}</td>
</tr>





<!-- pie -->
<tr style="border-top:1px solid #11698E;">
   	<td></td>
    <td></td>
    <td class="L colorAzulMedio">Cantidad</td>
   	<td id="recibosTdCantidadTotal" class="C colorAzulMedio"></td>
    <td class="L colorAzulMedio">Importe Total</td>
   	<td id="recibosTdImporteTotal"  class="R colorAzulMedio"></td>
  </tr>
</table>

<script>
  var recibosCantidad = 0;
  var RecibosImporteTotal = 0.00;
  $("#tbRecibosPendientes").find(".recibosImporte").each(function(){
    recibosCantidad++;
    RecibosImporteTotal += parseFloat(($(this).text()).replace(" €","").replace(" &euro;","").replace(",","."));
  });
  $("#recibosTdCantidadTotal").html(recibosCantidad);
  $("#recibosTdImporteTotal").html(RecibosImporteTotal.toFixed(2)+" &euro;");
</script>