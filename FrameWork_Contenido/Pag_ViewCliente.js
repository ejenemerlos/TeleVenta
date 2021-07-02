
comprobarModuloClientePedidos();
comprobarModuloRecibosPendientes();


function comprobarModuloClientePedidos(){ 
	if($("flx-module[modulename='Cliente_Pedidos']").is(":visible")){
		$("flx-module[modulename='Cliente_Pedidos'] .icon-minus").click();
		$("flx-module[modulename='Cliente_Pedidos'] div.cntBodyHeader, flx-module[modulename='Cliente_Pedidos'] div.cntBodyFooter").hide(); 		
	}else{ setTimeout(function(){ comprobarModuloClientePedidos(); },100); }
}

function comprobarModuloRecibosPendientes(){ 
	if($("flx-module[modulename='TV_Recibos_Pendientes']").is(":visible")){
		$("flx-module[modulename='TV_Recibos_Pendientes'] .icon-minus").click();
		$("flx-module[modulename='TV_Recibos_Pendientes'] div.cntBodyHeader, flx-module[modulename='TV_Recibos_Pendientes'] div.cntBodyFooter").hide(); 		
	}else{ setTimeout(function(){ comprobarModuloRecibosPendientes(); },100); }
}
