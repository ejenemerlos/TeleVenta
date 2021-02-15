<div class="tvTitulo esq1100">Pedido</div>
<div id="dvDatosDelClienteMin"></div>
<div id="dvPedido" style="border:1px solid #323f4b; padding:10px; border-sizing:border-box;">
	<span id="spanBotoneraPag" class="vaM">
		<span style="font:14px arial; color:#4985D6;">Buscar artículo</span>
		<input type="text" id="inpBuscarArticuloDisponible" style="width:300px;font:14px arial; color:#333;padding:4px;" 
			placeholder="Buscar por código o descipción" onkeyup="buscarArticuloDisponible()" onclick="$(this).select()">
		<span id="spBtnBuscarArt" class="MIboton esq05" onclick="buscarArticuloDisponible(window.event.keyCode=13)">Buscar</span>
		<span id="spResultados" class="inv">
			<span id="spResultadosT" class="esq05" style="margin:0 30px; border:1px solid #4985D6; color:#4985D6; padding:4px;"></span>
			<span id="spResBtn">
				<div class="icoLeft img30" onclick="paginador(); cargarArticulosDisponibles();"></div>
				<div class="icoRight img30" onclick="paginador(true); cargarArticulosDisponibles();"></div>
			</span>
		</span>
	</span>
	<span id="spanPersEPinfo" class="info" style="margin-left: 20px; display: none;">
		<div class="icoCarga img14 rotarR"></div> cargando artículos...
	</span>
	
	<div id="dvPersEP_Articulos" class="inv">
		<br>
		<table id="tbPersEP_ArticulosCab"></table>
		<div style="overflow:hidden; max-height:300px; overflow-y:auto">
			<table id="tbPersEP_Articulos"></table>		
		</div>
		<span id="spBtnAnyCont">
			<br>
			<span class="MIboton esq05" onclick="pedidoAnyadirDetalle()">añadir al pedido</span>
		</span>
		<div id="dvPedidoDetalle"></div>
	</div>
</div>