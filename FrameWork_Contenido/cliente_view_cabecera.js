<table class="tbS">
  <tr>
    <th>
		<span class="flx-icon icon-phone" style="color:green;font:"></span> 
		<span style="font:bold 12px arial;">LLAMADAS </span> 
		<span id="spanLlamadas" style="font:bold 12px arial;"></span>
	</th>
    <th>
		<span class="flx-icon icon-document" style="color:orange;"></span> 
		<span style="font:bold 12px arial;">PEDIDOS </span> 
		<span id="spanPedidos" style="font:bold 12px arial;"></span>
	</th>
    <th>
		<span class="flx-icon icon-euros" style="color:#5DB5E6;"></span> 
		<span style="font:bold 12px arial;">IMPORTE </span> 
		<span id="spanImporte" style="font:bold 12px arial;"></span>
	</th>
  </tr>  
</table>


<script>
cargarDatosCliente();
function cargarDatosCliente(){
	var ClienteCodigo = $.trim($("#spanClienteCodigo").text());
	if(ClienteCodigo===undefined || ClienteCodigo===""){ setTimeout(function(){ cargarDatosCliente(); },100); return; }
	flexygo.nav.execProcess('pClienteDatos','',null,null
		,[{'key':'cliente','value':ClienteCodigo},{'key':'modo','value':'datos'}],'modal640x480',false,$(this),function(ret){
		if(ret){ 
			try{
				var js = JSON.parse(ret.JSCode);
				$("#spanLlamadas").html(js[0].numLlamadas);
				$("#spanPedidos").html(js[0].numPedidos);
				$("#spanImporte").html(js[0].ImportePedidos);
			}
			catch{}
		}else{ alert("Error SP: pLlamadas!!!"+JSON.stringify(ret)); }	
	},false);
}

</script>