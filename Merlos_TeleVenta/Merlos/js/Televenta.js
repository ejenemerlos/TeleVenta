var ClienteCodigo = "";
var ClientePVerde = false;
var ctvll = "";
var PedidoGenerado = "";
var ArticuloClienteBuscando = false;
var _CargarOfertasCliente = false;
var dentroDelDiv = false;
var IdTransaccion = "";
var datosDelClienteConfirmacion = "";
var ConfirmacionDePedido = false;
var terminandoLlamada = false;
var terminarReintento = 0;


function inicioTeleVenta() {
    cerrarVelo();
    PedidoGenerado = "";
    PedidoDetalle = [];
    $("#btnPedido").text("Pedido");
    $(".moduloTV, #btnConfiguracion").stop().fadeIn();
    $(".moduloPedido").hide();
    recargarTVLlamadas();
}

function recargarTVLlamadas(tf) {
    if (tf) {
        cargarTbConfigOperador("recargar", false);
    } else {
        abrirVelo(icoCargando16 + " recargando datos...");
        tbLlamadasGlobal_Sel(IdTeleVenta, FechaTeleVenta, NombreTeleVenta);
        setTimeout(function() {
            tbLlamadasGlobal_Sel(IdTeleVenta, FechaTeleVenta, NombreTeleVenta);
            cerrarVelo();
        }, 1000);
    }
}

function configurarTeleVenta(tf) {
    if ($("#dvConfiguracionTeleVenta").is(":visible") || tf) {
        FechaTeleVenta = $.trim($("#tdFechasTeleventa").text());
        NombreTeleVenta = $.trim($("#inpNombreTV").val());
        if (FechaTeleVenta === "") { alert("Debes seleccionar la fecha!"); return; }
        if (NombreTeleVenta === "") { alert("El nombre no puede estar vacío!"); return; }
        if (!existeFecha(FechaTeleVenta)) { alert("Ups! Parece que la fecha no es correcta!"); return; }
        $("#btnTerminar,#btnPedido,#btnConfiguracion").show();
        $("flx-module[moduleName='TV_Cliente'],flx-module[moduleName='TV_Llamadas'],flx-module[moduleName='TV_UltimosPedidos']").slideDown();
        $("flx-module[moduleName='TV_LlamadasTV']").stop().slideUp();
        $("#dvConfiguracionTeleVenta").stop().slideUp(300, function() { $("#dvOpcionesTV").removeClass("esq1100").addClass("esq10"); });
        cargarTeleVentaLlamadas("cargarLlamadas");
        $("#dvFechaTV").html(FechaTeleVenta);
        estTV();
    } else {
        $("#btnTerminar,#btnPedido,#btnConfiguracion").hide();
        $("flx-module[moduleName='TV_Cliente'],flx-module[moduleName='TV_Llamadas'],flx-module[moduleName='TV_UltimosPedidos']").hide();
        $("#dvOpcionesTV").removeClass("esq10").addClass("esq1100");
        $("flx-module[moduleName='TV_LlamadasTV'],#dvConfiguracionTeleVenta").stop().slideDown();
        cargarTeleVentaLlamadas("listaGlobal");
    }
}

function estTV() {
    $("#dvEstTV").html(icoCargando16 + " cargando datos...");
    var contenido = "";
    var parametros = '{"modo":"estadisticas","IdTeleVenta":"' + IdTeleVenta + '","FechaTeleVenta":"' + FechaTeleVenta + '","nombreTV":"' + NombreTeleVenta + '",' + paramStd + '}';
    flexygo.nav.execProcess('pEstTV', '', null, null, [{ 'key': 'parametros', 'value': limpiarCadena(parametros) }], 'current', false, $(this), function(ret) {
        if (ret) {
            var js = JSON.parse(limpiarCadena(ret.JSCode));
            contenido = "Clientes: " + js[0].clientes + "&nbsp;&nbsp;&nbsp; Llamadas: " + js[0].llamadas +
                "&nbsp;&nbsp;&nbsp; Pedidos: " + js[0].pedidos +
                "&nbsp;&nbsp;&nbsp; Importe: " + js[0].importe + "&euro;";
            $("#dvEstTV").html(contenido);
            var filtros = js[0].filtros;
            var losFiltros = "";
            if (js[0].filtros[0].gestor.length > 0) { losFiltros += " gestor,"; }
            if (js[0].filtros[0].ruta.length > 0) { losFiltros += " ruta,"; }
            if (js[0].filtros[0].vendedor.length > 0) { losFiltros += " vendedor,"; }
            if (js[0].filtros[0].serie.length > 0) { losFiltros += " serie,"; }
            if (js[0].filtros[0].marca.length > 0) { losFiltros += " marca,"; }
            if (js[0].filtros[0].familia.length > 0) { losFiltros += " familia,"; }
            if (js[0].filtros[0].subfamilia.length > 0) { losFiltros += " subfamilia "; }

            if (losFiltros.length > 0) {
                losFiltros = losFiltros.substring(0, losFiltros.length - 1);
                $("#dvFiltrosTV").html("El registro '" + NombreTeleVenta + "' contiene filtros de " + losFiltros);
            } else { $("#dvFiltrosTV").html("Registro '" + NombreTeleVenta + "'"); }
        } else { alert("Error SP: pEstTV!!!" + JSON.stringify(ret)); }
    }, false);
}

function asignarMesesConsumo() {
    flexygo.nav.execProcess('pConfiguracion', '', null, null, [{ 'Key': 'modo', 'Value': 'MesesConsumo' }, { 'Key': 'valor', 'Value': $("#inpMesesConsumo").val() }], 'current', false, $(this), function(ret) {
        if (ret) {
            $("#spanAsignacionAviso").fadeIn();
            MesesConsumo = $("#inpMesesConsumo").val();
            setTimeout(function() { $("#spanAsignacionAviso").fadeOut(); }, 2000);
        } else { alert('Error S.P. pConfiguracion!!!\n' + ret); }
    }, false);
}

function cargarConfiguracionTV(elCallBack) {
    var parametros = '{"modo":"lista"}';
    flexygo.nav.execProcess('pConfiguracion', '', null, null, [{ 'Key': 'parametros', 'Value': limpiarCadena(parametros) }], 'current', false, $(this), function(ret) {
        if (ret) {
            var js = JSON.parse(limpiarCadena(ret.JSCode));
            // Interruptores
            for (var i in js.IO) { if (parseInt(js.IO[i].valor) === 0) { window["Conf" + js.IO[i].nombre] = 0; } else { window["Conf" + js.IO[i].nombre] = 1; } }
            if (ConfNoCobrarPortes === 1) { $("#spNoCobrarPortes").show(); } else { $("#spNoCobrarPortes").hide(); }
            if (ConfVerificarPedido === 1) { $("#spVerificarPedido").show(); } else { $("#spVerificarPedido").hide(); }
            // Comprobar si el cliente tiene varias direcciones
            var direcciones = '{"sp":"pClientesDirecciones","modo":"dameDirecciones","cliente":"' + ClienteCodigo + '"}';
            flexygo.nav.execProcess('pMerlos', '', null, null, [{ 'Key': 'parametros', 'Value': limpiarCadena(direcciones) }], 'current', false, $(this), function(ret) {
                if (ret) {
                    var contenido = "";
                    var dir = JSON.parse(limpiarCadena(ret.JSCode));
                    if (dir.error === "") {
                        try {
                            $("#tdDirEntrega").html(dir.datos[0].DIRECCION);
                            $("#inpDirEntrega").val(dir.datos[0].LINEA);
                        } catch (errorJSON) {}
                        if (dir.datos.length > 1) {
                            $("#thDirEntrega").addClass("fadeIO").addClass("modifDir").css("color", "green");
                            $("#tdDirEntrega").css("background", "#C6FFC5");
                            for (var d in dir.datos) {
                                var direccion = dir.datos[d];
                                contenido += "<div class='dvSub' onclick='asignarDireccionEntrega(\"" + (direccion.DIRECCION).replace("'", "-") + "\",\"" + direccion.LINEA + "\")'>" + direccion.DIRECCION + "</div>";
                            }
                        } else {
                            $("#thDirEntrega").removeClass("fadeIO").removeClass("modifDir").css("color", "#666");
                            $("#tdDirEntrega").css("background", "#EDEFF3");
                        }
                    } else {
                        contenido = "Error! - pClientesDirecciones!";
                    }
                    $("#dvCliDir").html(contenido);
                } else { alert('Error SP pClientesDirecciones - dameDirecciones!' + JSON.stringify(ret)); }
            }, false);
            if (elCallBack) { elCallBack(); }
        } else { alert("Error SP: cargarConfiguracionTV - pConfiguracion - lista!!!\n" + JSON.stringify(ret)); }
    }, false);
}

function pedidoTV() {
    //if (new Date(fechaCambiaFormato(FechaTeleVenta)) < new Date(fechaCambiaFormato(fechaCorta())) && currentRole !== "Admins") { alert("No se pueden crear pedidos de días anteriores!"); return; }
    if (new Date(FechaTeleVenta) < fechaCorta("dma", "/") && currentRole !== "Admins") { alert("No se pueden crear pedidos de días anteriores!"); return; }
    //if (new Date(FechaTeleVenta) < fechaCorta("dma", "/")) { alert("No se pueden crear pedidos de días anteriores!"); return; }

    if (ClienteCodigo === "") { alert("Debes seleccionar un cliente!"); return; }
    if ($("#btnPedido").text() === "Pedido") {
        IdTransaccion = Date.now();
        $("#btnPedido").text("TeleVenta");
        $("#dvDatosDelClienteMin").html(datosDelCliente);
        $(".moduloTV, #btnConfiguracion").hide();
        $(".moduloPedido").stop().fadeIn();
        cargarConfiguracionTV(function() { cargarArticulosDisponibles(ClienteCodigo); });

        // comprobar si tiene Ofertas
        var parametros = '{"modo":"ofertasDelCliente","cliente":"' + ClienteCodigo + '","fecha":"' + FechaTeleVenta + '",' + paramStd + '}';
        flexygo.nav.execProcess('pOfertas', '', null, null, [{ 'Key': 'parametros', 'Value': limpiarCadena(parametros) }], 'current', false, $(this), function(ret) {
            if (ret) {
                var js = JSON.parse(limpiarCadena(ret.JSCode));
                if (js.length > 0) { $("#btnClienteOfertas").addClass("fadeIO"); } else { $("#btnClienteOfertas").removeClass("fadeIO"); }
            } else { alert("Error SP: pOfertas - ofertasDelCliente!!!\n" + JSON.stringify(ret)); }
        }, false);

        PedidoDetalle = [];
        $("#dvPedidoDetalle").html(""); // por si se ha terminado una llamada sin crear pedido.
    } else {
        $("#btnPedido").text("Pedido");
        $(".moduloTV, #btnConfiguracion").stop().fadeIn();
        $(".moduloPedido").hide();
        $("#taObsInt").val(ObservacionesInternas);
    }

    if (PedidoNoCobrarPortes === 1) { PedidoNoPortes(); };
    //if(VerificarPedido===1){ PedidoVerificar(); }; // mantenerlo siempre el estado
}

function cargarSubDatos(objeto, cliente, id, pos) {
    var y = ($("#" + id).offset()).top;
    var x = ($("#" + id).offset()).left;
    var contenido = "";
    var elTXT = "";
    var elJS = '{"objeto":"' + objeto + '","cliente":"' + cliente + '",' + paramStd + '}';

    if (pos === -1) { x -= 100; }

    $("#dvDatosTemp").remove();
    $("body").prepend("<div id='dvDatosTemp' class='dvTemp' data-id='" + id + "'>" + icoCargando16 + " cargando datos...</div>");
    $("#dvDatosTemp").offset({ top: y, left: x }).stop().fadeIn();

    flexygo.nav.execProcess('pObjetoDatos', '', null, null, [{ 'Key': 'elJS', 'Value': elJS }], 'current', false, $(this), function(ret) {
        if (ret) {
            if (esJSON(ret.JSCode)) {
                var js = JSON.parse(limpiarCadena(ret.JSCode));
                if (js.length > 0) {
                    for (var i in js) {
                        if (objeto === "contactos") { elTXT = js[i].LINEA + " - " + js[i].PERSONA; }
                        if (objeto === "inciCli" || objeto === "inciArt") { elTXT = js[i].codigo + " - " + js[i].nombre; }
                        contenido += "<div class='dvSub' onclick='asignarObjetoDatos(\"" + id + "\",$(this).text())'>" + elTXT + "</div>";
                    }
                    if (objeto === "inciCli") {
                        contenido = "<div class='dvSub' onclick='asignarObjetoDatos(\"MT\",\"Llamar más tarde\")'>MT - Llamar más tarde</div>" +
                            "<div class='dvSub' onclick='asignarObjetoDatos(\"OD\",\"Llamar otro día\")'>OD - Llamar otro día</div>" + contenido;
                    }
                } else { contenido = "<div style='color:red;'>Sin resultados!</div>"; }
                if (objeto === "inciArt") {
                    var inciAsig = $("#inpIncidenciaSolINP" + id.split("inpIncidenciaSol")[1]).val();
                    if (inciAsig !== "") { contenido = "<div class='dvSubI' onclick='desasignarCliArt(\"" + objeto + "\",\"" + cliente + "\",\"" + id + "\",\"" + pos + "\")'>Asignado: " + inciAsig + "</div><br>" + contenido; }
                }
            } else { contenido = "<div style='color:red;'>Sin resultados!</div>"; }
            $("#dvDatosTemp").html(contenido);
        } else {
            $("#dvDatosTemp").remove();
            alert('Error S.P. pSeries!\n' + JSON.stringify(ret));
        }
    }, false);
}

function asignarObjetoDatos(id, txt) {
    if (Left(id, 16) === "inpIncidenciaSol") {
        var idN = id.split("inpIncidenciaSol")[1];
        id = "inpIncidenciaSolINP" + idN;
        $("#inpIncidenciaSolImg" + idN).attr("src", "./Merlos/images/inciRed.png");
        var parametros = '{"modo":"incidenciaArticulo","IdTeleVenta":"' + IdTeleVenta + '","incidencia":"' + txt.split(" - ")[0] + '","cliente":"' + ClienteCodigo + '"' +
            ',"articulo":"' + $("#tbArtDispTR" + idN).attr("data-art") + '","observaciones":"' + $.trim($("#inpObservaSolTA" + idN).val()) + '",' + paramStd + '}';
        flexygo.nav.execProcess('pLlamadas', '', null, null, [{ 'Key': 'parametros', 'Value': limpiarCadena(parametros) }], 'current', false, $(this), function(ret) {});
    }
    // Llamar más tarde
    if (id === "MT") {
        id = "inciCliente";
        mostrarRelojEJG("inciCliente", true);
    }
    // Llamar otro día
    if (id === "OD") {
        abrirVelo(
            "Asignar llamada para el cliente " + ClienteCodigo +
            "<br><br>" +
            "<input type='text' id='inpClienteOD' placeholder='Fecha y hora para la próxima llamada' " +
            "style='text-align:center;' " +
            "onfocus='(this.type=\"datetime-local\")' onblur='(this.type=\"text\")'>" +
            "<br><br><br>" +
            "<span class='MIbotonGreen esq05' onclick='ClienteLlamarOtroDia()'>establecer</span>" +
            "&nbsp;&nbsp;&nbsp;<span class='MIbotonRed esq05' onclick='cerrarVelo();'>cancelar</span>"
        );
        return;
    }

    $("#" + id).val(txt);
    $("#dvDatosTemp").fadeOut();
}

function desasignarCliArt(objeto, cliente, id, pos) {
    $("#inpIncidenciaSolINP" + id.split("inpIncidenciaSol")[1]).val("");
    $("#inpIncidenciaSolImg" + id.split("inpIncidenciaSol")[1]).attr("src", "./Merlos/images/inciGris.png");
    cargarSubDatos(objeto, cliente, id, pos);
}

function ClienteLlamarOtroDia() {
    var nuevaLlamada = formatSqlFechaHora($.trim($("#inpClienteOD").val()));
    abrirVelo(icoCargando16 + " agendando llamada...");
    $("#inciCliente").val("OD - Llamar otro día");
    var parametros = '{"modo":"llamarOtroDia","cliente":"' + ClienteCodigo + '","IdTeleVenta":"' + IdTeleVenta + '","nuevaLlamada":"' + nuevaLlamada + '",' + paramStd + '}';
    flexygo.nav.execProcess('pLlamadas', '', null, null, [{ 'Key': 'parametros', 'Value': limpiarCadena(parametros) }], 'current', false, $(this), function(ret) {
        if (ret) { terminarLlamada(); } else { alert("Error pLlamadas - llamarOtroDia!\n" + JSON.stringify(ret)); }
    }, false);
}


/*  TV_Cliente  **************************************************************************************************************** */

var elVendedor = "";
var datosDelCliente = "";

function cargarTeleVentaCliente(CliCod) {
    ClientePVerde = false;
    abrirIcoCarga();
    ClienteCodigo = CliCod;
    var parametros = '{"cliente":"' + ClienteCodigo + '","FechaTeleVenta":"' + FechaTeleVenta + '"}';
    flexygo.nav.execProcess('pClienteDatos', '', null, null, [{ 'key': 'parametros', 'value': limpiarCadena(parametros) }], 'current', false, $(this), function(ret) {
        if (ret) {
            if (ret.JSCode === "") { return; }
            var contenido = "";
            datosDelCliente = "";
            var js = JSON.parse(limpiarCadena(ret.JSCode));
            if (js.length > 0) {
                ClientePVerde = js[0].PVERDE;
                ObservacionesInternas = js[0].ObservacionesInternas.replace(/<br>/g, "\n");

                var lasVacaciones = "";
                var vacaciones = js[0].vacaciones;
                if (vacaciones.length > 0) { lasVacaciones = "<span style='background:#900;padding:5px;color:#FFF;'>vacaciones del " + vacaciones[0].INICIO + " al " + vacaciones[0].FINAL + "</span>"; }

                contenido =
                    "<table id='tbClienteDatos' class='tbTV'>" +
                    "  <tr><th>Código</th><td>" + js[0].CODIGO + "</td><th>Nombre</th><td>" + js[0].NOMBRE + "</td></tr>" +
                    "  <tr><th>CIF</th><td>" + js[0].CIF + "</td><th>R. Comercial</th><td>" + js[0].RCOMERCIAL + "</td></tr>" +
                    "  <tr><th>Dirección</th><td colspan='3'>" + js[0].DIRECCION + "</td></tr>" +
                    "  <tr><th>CP</th><td>" + js[0].CP + "</td><th>Población</th><td>" + js[0].POBLACION + "</td></tr>" +
                    "  <tr><th>Provincia</th><td colspan='3'>" + js[0].provincia + "</td></tr>" +
                    "  <tr><th>Email</th><td>" + js[0].EMAIL + "</td><th>Teléfono</th><td>" + $.trim(js[0].TELEFONO) + "" +
                    "		<span class='fR MIbotonP esq05' onclick='verTodosLosTelfs()'>ver todos</span></td></tr>" +
                    "  <tr id='trTelfsCli' class='inv'></tr>" +
                    "  <tr><th>Vendedor</th><td colspan='3'>" + js[0].VENDEDOR + " - " + js[0].nVendedor + "</td></tr>" +
                    "  <tr><th colspan='4'>Observaciones del Cliente</th></tr>" +
                    "  <tr><td colspan='4'><textarea style='width:100%; height:50px;' disabled>" + js[0].OBSERVACIO + "</textarea></td></tr>" +
                    "  <tr><th colspan='4'>Observaciones Internas" +
                    "  <span id='spanVacaciones' style='float:right;'>" + lasVacaciones + "</span>" +
                    "		&nbsp;&nbsp;&nbsp;<span id='ObsIntAV' style='font:bold 14px arial; color:#00a504; display:none;'>Autoguardado - OK</span>" +
                    "	</th></tr>" +
                    "  <tr><td colspan='4'><textarea id='taObsInt' style='width:100%; height:50px; font:14px arial;'>" + ObservacionesInternas + "</textarea></td></tr>" +
                    "</table>";


                var btnOfertas = "inv";
                ClienteOferta = false;
                if (js[0].OFERTA === "1" || js[0].OFERTA === "true" || js[0].OFERTA === true) {
                    btnOfertas = "";
                    ClienteOferta = true;
                }

                var fe = $.trim(js[0].FechaEntrega);
                if ((fe.split("-")[0]).length === 4) { fe = fe.substr(8, 2) + "-" + fe.substr(5, 2) + "-" + fe.substr(0, 4); }

                datosDelCliente = "" +
                    "<div style='background:#fff;'>" +
                    "		<table class='tbStdC'>" +
                    "			<tr>" +
                    "				<td style='width:400px;'>" +
                    "                    <span class='inv' id='spanIdClienteVentas'>" + js[0].CODIGO + "</span> " +
                    "					<div style='padding:10px;box-sizing:border-box;background:#e1e3e7;color:#333;'>" +
                    "						(" + js[0].CODIGO + ") " + js[0].NOMBRE + "" +
                    "						<br>" + js[0].RCOMERCIAL + " (" + js[0].POBLACION + ")" +
                    "						<br>e-mail: " + js[0].EMAIL + "" +
                    "						<br>teléfono: " + js[0].TELEFONO + "" +
                    "						<div style='margin-top:12px;'></div>" +
                    "						<div class='dvRiesgo esq05' onclick='abrirModuloRiesgo(\"" + js[0].CODIGO + "\")'>" +
                    "							RECIBOS PENDIENTES: " + js[0].numRecibos +
                    "							&nbsp;&nbsp;&nbsp;IMPORTE: " + parseFloat(js[0].importeRecibos).toFixed(2) + "&euro;" +
                    "							<br>RIESGO: " + parseFloat(js[0].CREDITO).toFixed(2) + "&euro;" +
                    "						</div>" +
                    "					</div>" +
                    "				</td>" +
                    "				<td style='width:400px; vertical-align:top; padding-top:10px;'>" +
                    "					<table id='tbClienteDatosMin'>" +
                    "						<tr>" +
                    "							<th class='vaM pl20' style='width:180px;'>Contacto</th>" +
                    "							<td>" +
                    "								<input type='text' id='inpDataContacto' style='text-align:left; color:#333;' " +
                    "								onclick='cargarSubDatos(\"contactos\",\"" + ClienteCodigo + "\",this.id,0);event.stopPropagation();'>" +
                    "							</td>" +
                    "						<tr>" +
                    " 						<th id='thDirEntrega' class='vaM pl20'>Dir. Entrega</th>" +
                    "							<div id='dvCliDir' class='dvTemp'></div><input type='text' id='inpDirEntrega' style='display:none;' />" +
                    "							<td id='tdDirEntrega' style='background:#EDEFF3; overflow:hidden;' onclick='verDireccionesDelCliente(); event.stopPropagation();'></td>" +
                    "						</tr>" +
                    "						<tr>" +
                    "							<th class='vaM pl20'>Fecha Entrega</th>" +
                    "							<td>" +
                    "								<input type='text' id='inpFechaEntrega' style='text-align:center; color:#333;' " +
                    "								onkeyup='calendarioEJGkeyUp(this.id,this.value)' " +
                    "								onclick='mostrarElCalendarioEJG(this.id,true);event.stopPropagation();' " +
                    "								value='" + fe + "'>" +
                    "							</td>" +
                    "						</tr>" +
                    "						<tr>" +
                    "							<th class='vaM pl20'>Incidencia Cliente</th>" +
                    "							<td>" +
                    "								<input type='text' id='inciCliente'" +
                    "								onclick='cargarSubDatos(\"inciCli\",\"" + ClienteCodigo + "\",this.id,0);event.stopPropagation();' >" +
                    "							</td>" +
                    "						</tr>" +
                    "						<tr>" +
                    "							<th class='vaM pl20'>Ventas agrupadas</th>" +
                    "							<td>" +
                    "								<input value='Ver ventas del artículo' type='button' id='verVentasArticulosAgrupados'" +
                    "								onclick='verVentasArticulosAgrupados(\"" + ClienteCodigo + "\");' >" +
                    "							</td>" +
                    "						</tr>" +
                    "					</table>" +
                    "				</td>" +
                    "				<td class='vaT pl20' style='padding-top:7px;'>" +
                    "					Observaciones <span id='spObservacionesPedInt' class='curP' style='font:bold 14px arial; color:#00a504;' onclick='PedidoObservaciones()'>del Pedido</span>" +
                    "					<br>" +
                    "					<textarea id='taObservacionesDelPedido' style='width:98%;height:80px;padding:5px;box-sizing:border-box;'>" + ObservacionesDelPedido + "</textarea>" +
                    "				</td>" +
                    "				<td id='tdOfertas' class='vaT pl20 taC " + btnOfertas + "' style='width:150px; padding-top:45px;'>" +
                    "					<span id='btnClienteOfertas' class='MIbtnF' style='padding:20px;' onclick='ofertasDelCliente()'>Ofertas</span>" +
                    "				</td>" +
                    "			</tr>" +
                    "		</table>" +
                    "</div>";
            } else { contenido = "No se han obtenido resultados!"; }
            $("#dvDatosDelCliente").html(contenido);
            $("#taObsInt").off().on("blur", () => { ObservacionesInternas_Blur(); });
            elVendedor = js[0].VENDEDOR;
            cerrarVelo();
        } else { alert("Error SP: pClientesADI!" + JSON.stringify(ret)); }
    }, false);
}

function ObservacionesInternas_Blur() {
    var ObservacionesInternas_ta = $.trim($("#taObsInt").val());
    if (ObservacionesInternas_ta !== ObservacionesInternas) {
        $("#ObsIntAV").fadeIn();
        ObservacionesInternas_Click(true);
        setTimeout(() => { $("#ObsIntAV").fadeOut(); }, 1000);
    }
}

function taObservacionesDelPedido_Blur() {
    var ObservacionesInternas_ta = limpiarCadena($.trim($("#taObservacionesDelPedido").val()));
    if (ObservacionesInternas_ta !== ObservacionesInternas) {
        $("#taObservacionesDelPedidoAV").fadeIn();
        ObservacionesInternas_Click();
        setTimeout(() => { $("#taObservacionesDelPedidoAV").fadeOut(); }, 1000);
    }
}

function abrirModuloRiesgo(cliente) {
    flexygo.nav.openPage('list', 'RecibosPendientes', 'CLIENTE=\'' + ClienteCodigo + '\'', '{\'CLIENTE\':\'' + ClienteCodigo + '\'}', 'popup', false, $(this));
}

function PedidoObservaciones() {
    if ($("#spObservacionesPedInt").text() === "del Pedido") {
        $("#spObservacionesPedInt").html("Internas&nbsp;&nbsp;&nbsp;<span id='taObservacionesDelPedidoAV' style='font:bold 14px arial; color:#00a504; display:none;'>Autoguardado - OK</span>");
        $("#taObservacionesDelPedido").val(ObservacionesInternas);
        $("#taObservacionesDelPedido").off().on("blur", () => { taObservacionesDelPedido_Blur(); });
    } else {
        $("#spObservacionesPedInt").text("del Pedido");
        $("#taObservacionesDelPedido").val(ObservacionesDelPedido);
        $("#taObservacionesDelPedido").off()
    }
}

function ObservacionesInternas_Click(tf) {
    ObservacionesInternas = limpiarCadena($.trim($("#taObservacionesDelPedido").val()));
    if (tf) { ObservacionesInternas = $.trim($("#taObsInt").val()); }
    var parametros = '{"modo":"ObservacionesInternas","cliente":"' + ClienteCodigo + '","observaciones":"' + ObservacionesInternas + '",' + paramStd + '}';
    flexygo.nav.execProcess('pClienteDatos', '', null, null, [{ 'Key': 'parametros', 'Value': limpiarCadena(parametros) }], 'current', false, $(this), function(ret) {
        if (!ret) { alert("Error pClienteDatos!\n" + JSON.stringify(ret)); }
    }, false);
}

function verFichaDeCliente() {
    if (ClienteCodigo === "") { alert("Ningún cliente seleccionado!"); return; }
    flexygo.nav.openPage('view', 'Cliente', 'CODIGO=\'' + ClienteCodigo + '\'', '{\'CODIGO\':\'' + ClienteCodigo + '\'}', 'popup', false, $(this));
}

function ofertasDelCliente() {
    var parametros = '{"modo":"ofertasDelCliente","cliente":"' + ClienteCodigo + '","fecha":"' + FechaTeleVenta + '",' + paramStd + '}';
    flexygo.nav.execProcess('pOfertas', '', null, null, [{ 'Key': 'parametros', 'Value': limpiarCadena(parametros) }], 'current', false, $(this), function(ret) {
        if (ret) {
            var js = JSON.parse(limpiarCadena(ret.JSCode));
            if (js.length > 0) { $("#btnClienteOfertas").addClass("fadeIO"); } else { $("#btnClienteOfertas").removeClass("fadeIO"); }
            abrirVelo("<div>" + icoCargando16 + " buscando ofertas para el cliente " + ClienteCodigo + "...</div>");
            var contenido = "<span style='font:bold 14px arial; color:#68CDF9;'>Ofertas - Cliente " + ClienteCodigo + "</span>" +
                "<span style='float:right;' onclick='cerrarVelo();'>" + icoAspa + "</span>" +
                "<br><br>" +
                "<div style='max-height:500px; overflow:hidden; overflow-y:auto;'>" +
                "	<table id='tbOfertasCliente' class='tbStd'>" +
                "	<tr>" +
                "		<th class='taL'>Artículo</th>" +
                "		<th class='taC'>Inicio</th>" +
                "		<th class='taC'>Fin</th>" +
                "		<th class='taC'>PVP</th>" +
                "		<th class='taC'>Dto.</th>" +
                "	</tr>";
            if (js.length > 0) {
                for (var i in js) {
                    contenido += "<tr onclick='ofertaArticuloBuscar(\"" + $.trim(js[i].ARTICULO) + "\")'>" +
                        "	<td class='taL'>" + $.trim(js[i].ARTICULO) + "</td>" +
                        "	<td class='taC'>" + $.trim(js[i].FECHA_IN) + "</td>" +
                        "	<td class='taC'>" + $.trim(js[i].FECHA_FIN) + "</td>" +
                        "	<td class='taR'>" + parseFloat(js[i].PVP).toFixed(2) + "</td>" +
                        "	<td class='taR'>" + parseFloat(js[i].DTO1).toFixed(2) + "</td>" +
                        "</tr>";
                }
                contenido += "</table></div><br><br>";
            } else {
                contenido = "<div>No se han obtenido ofertas para el cliente " + ClienteCodigo + "!" +
                    "<br><br><br><span class='MIboton esq05' onclick='cerrarVelo();'>aceptar</span>" +
                    "</div>";
            }
            abrirVelo(contenido);
        } else { alert("Error pOfertas!\n" + JSON.stringify(ret)); }
    }, false);
}

function ofertaArticuloBuscar(articulo) {
    $("#inpBuscarArticuloDisponible").val(articulo);
    buscarArticuloDisponible(window.event.keyCode = 13);
    cerrarVelo();
}

function verTodosLosTelfs() {
    if ($("#trTelfsCli").is(":visible")) { $("#trTelfsCli").hide(); return; }
    var parametros = '{"modo":"verTodosLosTelfs","cliente":"' + ClienteCodigo + '",' + paramStd + '}';
    flexygo.nav.execProcess('pClienteDatos', '', null, null, [{ 'Key': 'parametros', 'Value': limpiarCadena(parametros) }], 'current', false, $(this), function(ret) {
        if (ret) {
            var contenido = "<table class='tbStd'>" +
                "	<tr>" +
                "		<th>Persona</th>" +
                "		<th>Cargo</th>" +
                "		<th>Teléfono</th>" +
                "	</tr>";
            var js = JSON.parse(ret.JSCode);
            if (js.length > 0) {
                for (var i in js) {
                    contenido += "	<tr>" +
                        "		<td>" + $.trim(js[i].PERSONA) + "</td>" +
                        "		<td>" + $.trim(js[i].CARGO) + "</td>" +
                        "		<td>" + $.trim(js[i].TELEFONO) + "</td>" +
                        "	</tr>";
                }
                contenido += "</table>"
            } else { contenido = "No se han obtenido resultados!"; }
            $("#trTelfsCli").html("<td colspan='4'>" + contenido + "</td>").show();
        } else { alert("Error pClienteDatos verTodosLosTelfs!\n" + JSON.stringify(ret)); }
    }, false);
}



/*  TV_Llamadas  **************************************************************************************************************** */
function cargarTeleVentaLlamadas(modo) {
    abrirIcoCarga();
    ctvll = modo;
    var elDV = "dvLlamadas";
    var contenido = "";
    var elDisabledPedido = "inv";
    var pedidoTieneFormato = false;
    var parametros = '{"modo":"' + modo + '","cliente":"' + ClienteCodigo + '","IdTeleVenta":"' + IdTeleVenta + '","nombreTV":"' + NombreTeleVenta + '","FechaTeleVenta":"' + FechaTeleVenta + '","usuariosTV":' + UsuariosTV + ',' + paramStd + '}';
    console.log(parametros);
    flexygo.nav.execProcess('pLlamadas', '', null, null, [{ 'key': 'parametros', 'value': limpiarCadena(parametros) }], 'current', false, $(this), function(ret) {
        if (ret) {
            if (ret.JSCode === "") { contenido = "No se han obtenido resultados!"; } else {
                contenido = "";
                var js = JSON.parse(limpiarCadena(ret.JSCode));
                if (js.length > 0) {
                    contenido += "<div style='height:370px; overflow:hidden; overflow-y:auto;'>";
                    if (modo === "llamadasDelCliente") {
                        contenido += "<table id='tbLlamadasDelCliente' class='tbStdP'>" +
                            "	<tr>" +
                            "		<th>Fecha</th>" +
                            "		<th>Hora</th>" +
                            "		<th>Incidencia</th>" +
                            "		<th>Pedido</th>" +
                            "	</tr>";
                    }
                    if (modo === "cargarLlamadas") {
                        contenido += "<table id='tbLlamadas' class='tbStdP'>" +
                            "	<tr>" +
                            "		<th>Cliente</th>" +
                            "		<th>Nombre</th>" +
                            "		<th style='text-align:center;'>Horario</th>" +
                            "		<th style='text-align:center;'>Estado</th>" +
                            "		<th style='text-align:center;'></th>" +
                            "		<th style='text-align:center;'>Último pedido</th>" +
                            "		<th style='text-align:center;'>Pedido</th>" +
                            "		<th style='text-align:center;'>Fecha llamada</th>" +
                            "	</tr>";
                    }
                    if (modo === "listaGlobal") {
                        contenido += "" +
                            "<input type='text' id='inpListadoGlobal' placeholder='buscar' " +
                            " onkeyup='buscarEnTabla(this.id,\"tbLlamadasGlobal\")'>" +
                            "<table id='tbLlamadasGlobal' class='tbStdP' style='margin-top:4px;'>" +
                            "	<tr>" +
                            "		<th style='width:150px;'>Fecha</th>" +
                            "		<th class='rolTeleVentaO'>Usuario</th>" +
                            "		<th>Nombre</th>" +
                            "		<th style='text-align:center;'>Clientes</th>" +
                            "		<th style='text-align:center;'>Llamadas</th>" +
                            "		<th style='text-align:center;'>Pedidos</th>" +
                            "		<th style='text-align:center;'>Importe</th>" +
                            "		<th style='text-align:center;'>Total</th>" +
                            "	</tr>";
                    }

                    for (var i in js) {
                        var elPedido = $.trim(js[i].serie) + "-" + $.trim(js[i].pedido);
                        if ($.trim(js[i].serie) === "") { elPedido = $.trim(js[i].pedido); }
                        if (modo === "llamadasDelCliente") {
                            var laHora = Left($.trim(js[i].hora), 5);
                            var laIncidencia = $.trim(js[i].incidencia) + " - " + $.trim(js[i].ic[0].nIncidencia);
                            var laFecha = $.trim(js[i].fecha);
                            if ((laFecha.split("-")[0]).length === 4) { laFecha = laFecha.substr(8, 2) + "-" + laFecha.substr(5, 2) + "-" + laFecha.substr(0, 4); }
                            if ($.trim(js[i].incidencia) === "") { laIncidencia = ""; }
                            contenido += "<tr>" +
                                "	<td>" + laFecha + "</td>" +
                                "	<td>" + laHora + "</td>" +
                                "	<td>" + laIncidencia + "</td>" +
                                "	<td>" + elPedido + "</td>" +
                                "</tr>";
                        }
                        if (modo === "cargarLlamadas") {
                            var elBG = "";
                            var estado = "PENDIENTE";
                            var fechaLlamada = js[i].fechaLlamada;
                            var ultimoPedido = js[i].cli[0].ultimoPedido;
                            if (ultimoPedido === "null" || ultimoPedido == null) { ultimoPedido = ""; }
                            if ($.trim(js[i].completado) === "1") {
                                elBG = "style='background:#FFCFCF;'";
                                estado = "COMPLETADO";
                                pedidoTieneFormato = tieneFormatoCorrecto(elPedido);
                                if (!pedidoTieneFormato) {
                                    elDisabledPedido = "";
                                }
                            }

                            contenido += "<tr " + elBG + " >" +
                                "	<td onclick='TV_SelecionarCliente(\"" + $.trim(js[i].cliente) + "\",\"" + $.trim(fechaLlamada) + "\")'>" + $.trim(js[i].cliente) + "</td>" +
                                "	<td onclick='TV_SelecionarCliente(\"" + $.trim(js[i].cliente) + "\",\"" + $.trim(fechaLlamada) + "\")'>" + $.trim(js[i].cli[0].NOMBRE) + "</td>" +
                                "	<td style='text-align:center;' onclick='TV_SelecionarCliente(\"" + $.trim(js[i].cliente) + "\",\"" + $.trim(fechaLlamada) + "\")'>" + $.trim(js[i].horario) + "</td>" +
                                "	<td onclick='TV_SelecionarCliente(\"" + $.trim(js[i].cliente) + "\",\"" + $.trim(fechaLlamada) + "\")' data-completado='" + $.trim(js[i].completado) + "' style='text-align:center;'>" + estado + "</td>" +
                                "	<td style='text-align:center;'><img class='" + elDisabledPedido + "' title='Cambiar estado' src='./Merlos/images/mrls_relacion.png' style='width:20px; cursor:pointer;' onclick='cambiarEstadoLlamadaCliente(\"" + $.trim(js[i].cliente) + "\",\"" + $.trim(js[i].IdDoc) + "\");'></td>" +
                                "	<td onclick='TV_SelecionarCliente(\"" + $.trim(js[i].cliente) + "\",\"" + $.trim(fechaLlamada) + "\")' style='text-align:right;'>" + ultimoPedido + "</td>" +
                                "	<td  onclick='TV_SelecionarCliente(\"" + $.trim(js[i].cliente) + "\",\"" + $.trim(fechaLlamada) + "\")' style='text-align:right;'>" + elPedido + "</td>" +
                                "	<td  onclick='TV_SelecionarCliente(\"" + $.trim(js[i].cliente) + "\",\"" + $.trim(fechaLlamada) + "\")' style='text-align:center;'>" + fechaLlamada + "</td>" +
                                "</tr>";
                        }
                        if (modo === "listaGlobal") {
                            var elSubTotal = parseFloat($.trim(js[i].subtotal)).toFixed(2);
                            if (isNaN(elSubTotal)) { elSubTotal = ""; } else { elSubTotal += " &euro;"; }
                            var elImporte = parseFloat($.trim(js[i].importe)).toFixed(2);
                            if (isNaN(elImporte)) { elImporte = ""; } else { elImporte += " &euro;"; }
                            contenido += "<tr onclick='tbLlamadasGlobal_Sel(\"" + $.trim(js[i].id) + "\",\"" + $.trim(js[i].fecha) + "\",\"" + $.trim(js[i].nombreTV) + "\",1)'>" +
                                "	<td>" + $.trim(js[i].fecha) + "</td>" +
                                "	<td class='rolTeleVentaO'>" + $.trim(js[i].usuario) + "</td>" +
                                "	<td>" + $.trim(js[i].nombreTV) + "</td>" +
                                "	<td style='text-align:right;'>" + $.trim(js[i].clientes) + "</td>" +
                                "	<td style='text-align:right;'>" + $.trim(js[i].llamadas) + "</td>" +
                                "	<td style='text-align:right;'>" + $.trim(js[i].pedidos) + "</td>" +
                                "	<td style='text-align:right;'>" + elSubTotal + "</td>" +
                                "	<td style='text-align:right;'>" + elImporte + "</td>" +
                                "</tr>";
                            elDV = "dvLlamadasTeleVenta";
                        }
                    }
                    contenido += "</table></div>";
                } else { contenido = "Sin registros!"; }
            }
            $("#" + elDV).html(contenido);
            if (currentRole === "TeleVenta") { $(".rolTeleVentaO").hide(); }
            cerrarVelo();
        } else { alert("Error SP: pLlamadas!!!" + JSON.stringify(ret)); }
    }, false);
}

function tbLlamadasGlobal_Sel(id, fecha, nombre, VerificarErrorPedidos) {
    printarVariableFechas(fecha);
    crearVariableFechas();
    //$("#inpFechaTV").val(fecha);
    $("#inpNombreTV").val(nombre);
    IdTeleVenta = id;
    FechaTeleVenta = fecha;
    NombreTeleVenta = nombre;
    cargarTbConfigOperador("cargar");
    configurarTeleVenta();
    if (VerificarErrorPedidos) { verificarPedidosError(); }
    $("#dvFechaTV").show();
}

function verificarPedidosError() {
    if ($("#dvVelo").is(":visible")) { setTimeout(verificarPedidosError, 500); return; }
    var parametros = '{"sp":"pPedidoControl","modo":"verificarPedidosError",' + paramStd + '}';
    flexygo.nav.execProcess('pMerlos', '', null, null, [{ 'Key': 'parametros', 'Value': limpiarCadena(parametros) }], 'current', false, $(this), function(ret) {
        if (ret) {
            var contenido = `
			<div style="margin-bottom:20px;">Pedidos no enviados por errores del sistema o no finalizados correctamente</div>
			<table id="tbPedidosError" class="tbStdP">
				<tr>
					<th>Transacción</th>
					<th style="text-align:center;">Fecha</th>
					<th>Serie</th>
					<th>Cliente</th>
					<th>Nombre</th>
					<th style="text-align:center;">reenviar</th>
					<th style="text-align:center;">eliminar</th>
				</tr>
		`;
            var js = JSON.parse(ret.JSCode);
            if (js.length > 0) {
                js.forEach(dato => {
                    var fecha = (dato.fecha).substring(0, 10);
                    fecha = fecha.substring(8, 10) + "-" + fecha.substring(5, 7) + "-" + fecha.substring(0, 4);
                    contenido += `
					<tr>
						<td>` + dato.IdTransaccion + `</td>
						<td style="text-align:center;">` + fecha + `</td>
						<td>` + dato.letra + `</td>
						<td>` + dato.cliente + `</td>
						<td>` + dato.nombre + `</td>
						<td style="text-align:center;" onclick="PedidoErrorReenviar('` + dato.IdTransaccion + `')"><i class="flx-icon icon-next-11 icon-1.5x deNegroAVerde"></i></td>							
						<td style="text-align:center;" onclick="PedidoErrorEliminar('` + dato.IdTransaccion + `')"><i class="fa fa-close icon-next-11 icon-1.5x deNegroARojo"></i></td>							
					</tr>
				`;
                });
                contenido += "</table><div id='veloMensaje'></div>";
                abrirVelo(contenido, 800);
            }
        } else { alert('Error SP pPedidoControl!' + JSON.stringify(ret)); }
    }, false);
}

function PedidoErrorEliminar(IdTransaccion, confirmacion) {
    $("#tbPedidosError").hide();
    if (confirmacion) {
        $("#veloMensaje").html(icoCargando16 + " eliminando el pedido de la base de datos...").slideDown();
        var parametros = '{"sp":"pPedidoControl","modo":"eliminarPedidosError","IdTransaccion":"' + IdTransaccion + '",' + paramStd + '}';
        flexygo.nav.execProcess('pMerlos', '', null, null, [{ 'Key': 'parametros', 'Value': limpiarCadena(parametros) }], 'current', false, $(this), function(ret) {
            if (ret) {
                tbLlamadasGlobal_Sel(IdTeleVenta, FechaTeleVenta, NombreTeleVenta, 1);
            } else { alert('Error SP pPedidoControl! - eliminarPedidosError' + JSON.stringify(ret)); }
        }, false);
    } else {
        $("#veloMensaje").html(`
			Confirma para eliminar este registro.<br>Los datos se borrarán y no se podrá recuperar el pedido.
			<br><br><br><span class="MIbotonGreen" onclick="PedidoErrorEliminar('` + IdTransaccion + `',1);">aceptar</span>
			&nbsp;&nbsp;&nbsp;<span class="MIbotonRed" onclick="$('#veloMensaje').hide();$('#tbPedidosError').slideDown();">cancelar</span>
		`).slideDown();
    }
}

var contadorPedidoErrorReenviar = 0;

function PedidoErrorReenviar(IdTransaccion, confirmacion) {
    $("#tbPedidosError").hide();
    if (confirmacion) {
        $("#veloMensaje").html(icoCargando16 + " generando el pedido...").slideDown();
        // comrpobar que el SP no esté en uso
        var parametros = '{"sp":"pEnUso","objeto":"pPedido_Nuevo","terminarReintento":"' + contadorPedidoErrorReenviar + '"}';
        flexygo.nav.execProcess('pMerlos', '', null, null, [{ 'Key': 'parametros', 'Value': limpiarCadena(parametros) }], 'current', false, $(this), function(ret) {
            if (ret) {
                if (parseInt(ret.JSCode) === 1) {
                    setTimeout(function() {
                        contadorPedidoErrorReenviar++;
                        PedidoErrorReenviar(IdTransaccion, confirmacion);
                    }, 500);
                } else {
                    parametros = '{"sp":"pPedidoControl","modo":"reenviarPedido","IdTransaccion":"' + IdTransaccion + '",' + paramStd + '}';
                    console.log(parametros);
                    flexygo.nav.execProcess('pMerlos', '', null, null, [{ 'Key': 'parametros', 'Value': limpiarCadena(parametros) }], 'current', false, $(this), function(rt) {
                        if (rt) {
                            tbLlamadasGlobal_Sel(IdTeleVenta, FechaTeleVenta, NombreTeleVenta, 1);
                        } else { alert('Error SP pPedidoControl! - reenviarPedido - IdTransaccion: ' + IdTransaccion + '\n' + JSON.stringify(rt)); }
                    }, false);
                }
            } else { alert('Error SP pEnUso! - objeto: pPedido_Nuevo' + JSON.stringify(ret)); }
        }, false);
    } else {
        $("#veloMensaje").html(`
			Confirma para generar el pedido.
			<br><br><br><span class="MIbotonGreen" onclick="contadorPedidoErrorReenviar=0; PedidoErrorReenviar('` + IdTransaccion + `',1);">generar pedido</span>
			&nbsp;&nbsp;&nbsp;<span class="MIbotonRed" onclick="$('#veloMensaje').hide();$('#tbPedidosError').slideDown();">cancelar</span>
		`).slideDown();
    }
}

function asignarserieconfig() {
    var serie = $.trim($("#inpLLBserieConfig").val());
    flexygo.nav.execProcess('pConfiguracion', '', null, null, [{ 'Key': 'modo', 'Value': 'TVSerie' }, { 'Key': 'valor', 'Value': serie }], 'current', false, $(this), function(ret) {
        if (ret) {
            $("#spanAsignacionSerieAviso").fadeIn(); // SERIE = serie;
            setTimeout(function() { $("#spanAsignacionSerieAviso").fadeOut(); }, 2000);
        } else { alert("Error SP: pConfiguracion!!!\n" + JSON.stringify(ret)); }
    }, false);
}

function TV_SelecionarCliente(cliente, fecha) {
    FechaTeleVenta = fecha;
    $("#dvFechaTV").text(FechaTeleVenta);
    $("#tdFechasTeleventa").text(fecha);

    cargarTeleVentaCliente(cliente);
    cargarTeleVentaUltimosPedidos(cliente);
}

function inpDatos_Click(id) {
    $(".dvListaDatos").stop().fadeOut();
    var elInp = id.split("LLB")[1];
    var contenido = "";
    var elInpSQL = elInp;
    var asigSerie = "";
    if (elInp === "serieConfig") {
        elInpSQL = "serie";
        asigSerie = "asignarserieconfig();";
    }
    var elJS = '{"modo":"' + elInpSQL + '",' + paramStd + '}';
    $("#dvLLB" + elInp).html(icoCargando16 + " cargando...").stop().slideDown();
    flexygo.nav.execProcess('pInpDatos', '', null, null, [{ 'Key': 'elJS', 'Value': elJS }], 'current', false, $(this), function(ret) {
        if (ret) {
            var js = JSON.parse(limpiarCadena(ret.JSCode));
            if (js.length > 0) {
                for (var i in js) {
                    var elClick = js[i].codigo + " - " + js[i].nombre;
                    if (id === "inpLLBserie" || id === "inpLLBserieConfig") {
                        elClick = js[i].codigo;
                        SERIE = js[i].codigo;
                    }
                    contenido += "<div class='dvLista' " +
                        "onclick='$(\"#" + id + "\").val(\"" + elClick + "\"); $(\"#dvLLB" + elInp + "\").stop().slideUp(); " + asigSerie + "'>" +
                        js[i].codigo + " - " + js[i].nombre +
                        "</div>";
                }
            } else { contenido = "<div style='color:red;'>Sin resultados!</div>"; }
            $("#dvLLB" + elInp).html(contenido);
        } else { alert('Error S.P. pSeries!\n' + JSON.stringify(ret)); }
    }, false);
}




/*  TV_UltimosPedidos  *********************************************************************************************************** */

function cargarTeleVentaUltimosPedidos(ClienteCodigo) {
    var parametros = '{"cliente":"' + ClienteCodigo + '",' + paramStd + '}';
    flexygo.nav.execProcess('pUltimosPedidos', '', null, null, [{ 'key': 'parametros', 'value': limpiarCadena(parametros) }], 'current', false, $(this), function(ret) {
        if (ret) {
            if (ret.JSCode === "") { ret.JSCode = "[]"; }
            var contenido = "<table class='tbStdP'>" +
                "<tr>" +
                "	<th style='width:100px;'>Fecha</th>" +
                "	<th class='C' style='width:100px;'>Pedido</th>" +
                "	<th class='C' style='width:100px;'>Entrega</th>" +
                "	<th class='C' style='width:100px;'>Ruta</th>" +
                "	<th class='C' style='width:100px;'>Estado</th>" +
                "	<th class='L'>Observaciones</th>" +
                "	<th class='C' style='width:200px;'>Importe</th>" +
                "	<th class='C' style='width:200px;'>Total</th>" +
                "</tr>";
            var js = JSON.parse(limpiarCadena(ret.JSCode));
            if (js.length > 0) {
                for (var i in js) {
                    contenido += "<tr>" +
                        "	<td>" + $.trim(js[i].FECHA) + "</td>" +
                        "	<td id='tdPedidoVer_" + i + "' class='C' onmouseenter='verPedidoDetalle(\"" + $.trim(js[i].IDPEDIDO) + "\",\"" + $.trim(js[i].LETRA) + "-" + $.trim(js[i].numero) + "\"," + i + ")' " +
                        "	onmouseleave='dentroDelDiv=false; cerrarAVT();' style='cursor:pointer; color:#000;'>" + $.trim(js[i].LETRA) + "-" + $.trim(js[i].numero) + "</td>" +
                        "	<td class='C'>" + $.trim(js[i].ENTREGA) + "</td>" +
                        "	<td class='C'>" + $.trim(js[i].RUTA) + "</td>" +
                        "	<td class='C'>" + $.trim(js[i].ESTADO) + "</td>" +
                        "	<td class='L' style='overflow:hidden;'>" + $.trim(js[i].OBSERVACIO) + "</td>" +
                        "	<td class='R'>" + $.trim(js[i].TOTALPEDformato) + "</td>" +
                        "	<td class='R'>" + $.trim(js[i].TOTALDOCformato) + "</td>" +
                        "</tr>"
                }
                contenido += "</table>"
            } else { contenido = "No se han obtenido resultados!"; }
            $("#dvUltimosPedidos").html("<div style='max-height:200px; overflow:hidden; overflow-y:auto;'>" + contenido + "</div>");
        } else { alert("Error SP: pUltimosPedidos!\n" + JSON.stringify(ret)); }
    }, false);
}

function verPedidoDetalle(idpedido, pedido, i) {
    if (ArticuloClienteBuscando) { return; }
    ArticuloClienteBuscando = true;
    dentroDelDiv = true;
    var contenido = icoCargando16 + " cargando lineas del pedido " + pedido + "...";
    abrirAVT(contenido);
    contenido = "<span style='font:bold 16px arial; color:#666;'>Datos del pedido " + pedido + "</span>" +
        "<br><br>" +
        "<div style='max-height:600px; overflow:hidden; overflow-y:auto;'>" +
        "	<table id='tbPedidosDetalle' class='tbStd'>" +
        "		<tr>" +
        "			<th>Artículo</th>" +
        "			<th>Descripción</th>" +
        "			<th class='C'>Cajas</th>" +
        "			<th class='C'>Uds.</th>" +
        "			<th class='C'>Peso</th>" +
        "			<th class='C'>Precio</th>" +
        "			<th class='C'>Dto</th>" +
        "			<th class='C'>Importe</th>" +
        "		</tr>";
    var parametros = '{"idpedido":"' + idpedido + '",' + paramStd + '}';
    flexygo.nav.execProcess('pPedidoDetalle', '', null, null, [{ 'key': 'parametros', 'value': limpiarCadena(parametros) }], 'current', false, $(this), function(ret) {
        if (ret) {
            var js = JSON.parse(limpiarCadena(ret.JSCode));
            if (js.length > 0) {
                for (var j in js) {
                    contenido += "<tr>" +
                        "		<td>" + js[j].ARTICULO + "</td>" +
                        "		<td>" + js[j].DEFINICION + "</td>" +
                        "		<td class='C'>" + js[j].cajas + "</td>" +
                        "		<td class='C'>" + js[j].UNIDADES + "</td>" +
                        "		<td class='C'>" + js[j].PESO + "</td>" +
                        "		<td class='C'>" + js[j].PRECIO + "</td>" +
                        "		<td class='C'>" + js[j].DTO1 + "</td>" +
                        "		<td class='R'>" + js[j].IMPORTEf + "</td>" +
                        "	</tr>";
                }
                contenido += "</table></div>";
            } else { contenido = "No se han obtenido resultados! <span class='flR' onclick='cerrarVelo()'>" + icoAspa + "</span>"; }
            abrirAVT(contenido, 800);
            ArticuloClienteBuscando = false;
            if (!dentroDelDiv) { cerrarAVT(); }
        } else { alert("Error SP: pPedidoDetalle!!!" + JSON.stringify(ret)); }
    }, false);
}



/*  TV_Pedido  **************************************************************************************************************** */

var PedidoActivo = "";
var PedidoActivoNum = "";
var PedidoModo = "crear";
var PedidoDetalle = [];
var dvIncidenciasCLI = "";
var dvIncidenciasART = "";

var Values = "";
var ContextVars = '<Row>' +
    '<Property Name="currentReference" Value="' + currentReference + '"/>' +
    '<Property Name="currentSubreference" Value="' + currentSubreference + '"/>' +
    '<Property Name="currentRole" Value="' + currentRole + '"/>' +
    '<Property Name="currentRoleId" Value="' + currentRoleId + '"/>' +
    '<Property Name="currentUserLogin" Value="' + currentUserLogin + '"/>' +
    '<Property Name="currentUserId" Value="' + currentUserId + '"/>' +
    '<Property Name="currentUserFullName" Value="' + currentUserFullName + '"/>' +
    '</Row>';
var RetValues = '<Property Success="False" SuccessMessage="" WarningMessage="" JSCode="" JSFile="" CloseParamWindow="False" refresh="False"/>';


function llamarMasTardeCliente(horaSel) {
    abrirIcoCarga();
    var parametros = '{"modo":"llamarMasTardeCliente","IdTeleVenta":"' + IdTeleVenta + '","cliente":"' + ClienteCodigo + '","horario":"' + horaSel + '",' + paramStd + '}';
    flexygo.nav.execProcess('pLlamadas', '', null, null, [{ 'Key': 'parametros', 'Value': limpiarCadena(parametros) }], 'current', false, $(this), function(ret) {
        if (ret) {
            pedidoTV();
            recargarTVLlamadas();
        } else { alert("Error pLlamadas llamarMasTardeCliente!\n" + JSON.stringify(ret)); }
        cerrarVelo();
    }, false);
}
var celdaValor = "";

function cargarArticulosDisponibles(modo) {
    var buscar = $.trim($("#inpBuscarArticuloDisponible").val());
    buscar = buscar.replace(/['"]+/g, '');
    tfArticuloSeleccionado = "";
    $("#spanBotoneraPag , #spResultados, #dvPersEP_Articulos").hide();
    $("#spanPersEPinfo").fadeIn(300, function() {
        var varios = "paginar";
        var esconder_spResBtn = false;
        var registrosTotales = 0;
        var elSP = "pArticulosBuscar";
        var parametros = '{"registros":' + paginadorRegistros + ',"buscar":"' + buscar + '","cliente":"' + ClienteCodigo + '","IdTeleVenta":"' + IdTeleVenta + '","fechaTV":"' + FechaTeleVenta + '","nombreTV":"' + NombreTeleVenta + '",' + paramStd + '}';
        if (modo) { elSP = "pArticulosCliente"; }
        console.log(`sp: ${elSP} PARAMETROS ${parametros}`);
        flexygo.nav.execProcess(elSP, '', null, null, [{ "Key": "parametros", "Value": parametros }], 'current', false, $(this), function(ret) {
            if (ret) {
                var respuesta = limpiarCadena(ret.JSCode);
                if (respuesta === "") { respuesta = "[]"; }
                var contenido = "";
                var art = JSON.parse(respuesta);
                var incluido = "";
                var claseIncluido = "";
                console.log(JSON.stringify(art));
                var elColSpan = 12;
                if (ConfMostrarStockVirtual === 0) { elColSpan = 11; }
                if (art.length > 0) {
                    var elTamanoTotal = art.length;
                    registrosTotales = art[0].registros;
                    var contenidoCab = "";
                    if (modo) {
                        contenidoCab += "<tr>" +
                            "	<th colspan='2'></th>" +
                            "	<th colspan='3' style='text-align:center; background:rgb(73, 133, 214);'>Última Venta</th>" +
                            "	<th colspan='" + elColSpan + "'></th>";
                    }
                    contenidoCab += "<tr>" +
                        "	<th id='thCodigo' style='width:10%;'>Código</th>" +
                        "	<th>Descripción</th>";
                    if (modo) {
                        contenidoCab += "<th style='width:5%; text-align:center; background:rgb(73, 133, 214);'>Cajas</th>" +
                            "<th style='width:5%; text-align:center; background:rgb(73, 133, 214);'>Uds.</th>" +
                            "<th style='width:5%; text-align:center; background:rgb(73, 133, 214);'>Peso</th>";
                    }
                    contenidoCab += "	<th class='PedidoMaximo inv' style='width:5%; text-align:center;'>Pedido Máximo</th>" +
                        "<th style='width:5%; text-align:center;'>Cajas</th>" +
                        "<th style='width:5%; text-align:center;'>Uds.</th>" +
                        "<th style='width:5%; text-align:center;'>Peso</th>" +
                        "<th style='width:5%; text-align:center;'>Tarifa mín.</th>" +
                        "<th style='width:5%; text-align:center; cursor:pointer; color:#99ffa5;' onclick='mostrarTarifaArticulo()'>Precio</th>" +
                        "<th style='width:5%; text-align:center;'>Dto.</th>" +
                        "<th style='width:5%; text-align:center;'>Importe</th>" +
                        "<th style='width:5%; text-align:center;' class='inpStockVirtual'>Stock Disponible</th>" +
                        "<th style='width:5%; text-align:center;' class='inpStockVirtual'>Stock Virtual</th>" +
                        "<th style='width:40px; text-align:center; box-sizing:border-box;'></th>" +
                        "<th style='width:40px; text-align:center; box-sizing:border-box;'></th>" +
                        "<th style='width:40px; text-align:center; box-sizing:border-box; background:#D2FFC6; border:1px solid green; cursor:pointer;' onclick='PedidoAnyadirTodo();'>" +
                        "		<img src='./Merlos/images/icoCestaIn.png' width='24'>" +
                        "</th>" +
                        "</tr>";
                    $("#tbPersEP_ArticulosCab").html(contenidoCab);

                    var valorPeso = "";
                    for (var i in art) {
                        var CajasIO = "";
                        var UdsIO = "";
                        var PesoIO = "";
                        var elPedUniCaja = "0";
                        var claseCaja = "";
                        var clasePeso = "";
                        var elPeso = $.trim(art[i].PesoArticulo);
                        if (elPeso === "" || elPeso === null) { elPeso = "0"; }
                        var elPedUniCajaValor = elPedUniCaja;
                        if (elPedUniCajaValor === "0") { elPedUniCajaValor = ""; }
                        var elPesoValor = elPeso;
                        if (elPesoValor === "0") { elPesoValor = ""; }
                        var eOnClick = "";
                        var stockVirtual = parseInt(art[i].StockVirtual);
                        var stockReal = parseInt(art[i].StockReal);
                        incluido = parseInt(art[i].Incluido);
                        if (incluido == 1) {
                            claseIncluido = "descIncluido";
                        } else {
                            claseIncluido = "";
                        }
                        //console.log(`El articulo es ${art[i].NOMBRE.trim()} el incluido ${incluido} y la clase incluido ${claseIncluido}`);
                        if (modo) {
                            stockVirtual = parseInt(art[i].StockVirtual);
                            if (isNaN(stockVirtual)) { stockVirtual = ""; }
                            stockReal = parseInt(art[i].StockReal);
                            if (isNaN(stockReal)) { stockReal = ""; }
                            elPedUniCaja = $.trim(art[i].UNICAJA);
                            if (elPedUniCaja === "" || elPedUniCaja === null) { elPedUniCaja = "0"; }
                            if (parseFloat(elPedUniCaja) > 0) {} else {
                                CajasIO = "readonly disabled";
                                claseCaja = "inv";
                            }
                            if (parseFloat(art[i].PESO) > 0) {} else {
                                PesoIO = "readonly disabled";
                                clasePeso = "inv";
                            }
                            eOnClick = "onclick='articuloCliente(\"tbArtDispTR" + i + "\",\"" + art[i].CODIGO + "\")' onmouseenter='articuloCliente(\"tbArtDispTR" + i + "\",\"" + art[i].CODIGO + "\")' onmouseleave='dentroDelDiv=false;cerrarAVT();'";
                        } else {
                            elPedUniCaja = $.trim(art[i].UNICAJA);
                            if (parseFloat(elPedUniCaja) > 0) {} else {
                                CajasIO = "readonly disabled";
                                claseCaja = "inv";
                            }
                            elPeso = $.trim(art[i].peso);
                            if (elPeso === "" || elPeso === null) { elPeso = "0"; }
                            if (parseFloat(elPeso) > 0) {} else {
                                PesoIO = "readonly disabled";
                                clasePeso = "inv";
                            }
                            valorPeso = " value='" + parseFloat(elPeso).toFixed(3) + "' ";
                        }

                        contenido += `<tr id='tbArtDispTR` + i + `' class='trBsc' 
									data-json='{` +
                            '"articulo":"' + art[i].CODIGO.trim() + '"' +
                            ',"nombre":"' + art[i].NOMBRE.trim() + '"' +
                            `}'
									data-art='` + art[i].CODIGO.trim() + `' 
									data-nom='` + art[i].NOMBRE.trim() + `'
                                    data-peso='` + elPeso + `'
                                    data-unicaja='` + elPedUniCaja + `'
									data-i='` + i + `'>
									<td class='trBscCod' style='width:10%;' ` + eOnClick + ` >` + art[i].CODIGO.trim() + `</td>
									<td class='trBscNom ` + claseIncluido + `'>` + art[i].NOMBRE.trim() + `</td>`;
                        if (modo) {
                            contenido += "<td class='C' style='width:5%;'>" + art[i].CAJAS + "</td>" +
                                "<td class='C' style='width:5%;'>" + art[i].UDS + "</td>" +
                                "<td id='tdPesoUltVenta_" + i + "' class='C' style='width:5%;'>" + art[i].PESO + "</td>";
                        }
                        contenido += " 	<td class='C trBscCajas inv' style='width:10%;'>" + elPedUniCaja + "</td>" +
                            "	<td class='C' style='width:5%;'>" +
                            "		<input type='text' autocomplete='off' id='inp_cajas_" + i + "' class='inpCajasSol " + claseCaja + "' " +
                            "		onkeyup='inputTeclas(\"inp_cajas_\"," + i + "," + elPedUniCaja + "," + elPeso + ", \"cajas\", false, $(this)," + elTamanoTotal + ",false);' " +
                            "		onblur='inputTeclas(\"inp_cajas_\"," + i + "," + elPedUniCaja + "," + elPeso + ", \"cajas\", false, $(this)," + elTamanoTotal + ",true);' " +
                            "		" + CajasIO + ">" +
                            "	</td>" +
                            "	<td class='C' style='width:5%;'>" +
                            "		<input autocomplete='off' type='text' id='inp_uds_" + i + "' class='inpCantSol' " +
                            "		onkeyup='inputTeclas(\"inp_uds_\"," + i + "," + elPedUniCaja + "," + elPeso + ", \"unidades\", false, $(this)," + elTamanoTotal + ",false);' " +
                            "		onblur='inputTeclas(\"inp_uds_\"," + i + "," + elPedUniCaja + "," + elPeso + ", \"unidades\", false, $(this)," + elTamanoTotal + ",true);' " +
                            "		" + UdsIO + ">" +
                            "	</td>" +
                            "	<td class='C' style='width:5%;'>" +
                            "		<input type='text' autocomplete='off' id='inp_peso_" + i + "' class='inpPesoSol C " + clasePeso + "' " + valorPeso + " " +
                            "		onkeyup='inputTeclas(\"inp_peso_\"," + i + "," + elPedUniCaja + "," + elPeso + ", \"peso\", false, $(this)," + elTamanoTotal + ");' " +
                            "	</td>";
                        if (modo) { contenido += "<td id='tarifaTD" + i + "' class='C' style='width:5%;'></td>"; } else { contenido += "<td id='tarifaTD" + i + "' class='C' style='width:5%;'>" + (art[i].pvp).toFixed(2) + "</td>"; }
                        contenido += "	<td id='precioTD" + i + "' class='C' style='width:5%;'></td>" +
                            "	<td id='DtoTD" + i + "' class='C' style='width:5%;'> </td>" +
                            "	<td class='inpImporteSol R' style='width:5%;'></td>" +
                            "	<td class='inpStockVirtual R' style='width:5%;'>" + stockReal + "</td>" +
                            "	<td class='inpStockVirtual R' style='width:5%;'>" + stockVirtual + "</td>" +
                            "	<td id='inpIncidenciaSol" + i + "' class='C' style='width:40px; box-sizing:border-box;' " +
                            "	style='table-layout:fixed;' " +
                            "	onclick='cargarSubDatos(\"inciArt\",\"" + ClienteCodigo + "\",this.id,-1);event.stopPropagation();'>" +
                            "		<img id='inpIncidenciaSolImg" + i + "' src='./Merlos/images/inciGris.png' width='14'>" +
                            "		<input type='text' id='inpIncidenciaSolINP" + i + "' class=' trInciArt inv'>" +
                            "	</td>" +
                            "	<td id='inpObservaSol" + i + "' class='C' style='width:40px;  box-sizing:border-box;' " +
                            "	onclick='incidencia(\"obs\",this.id);event.stopPropagation();'>" +
                            "		<img id='inpObservaSolImg" + i + "' src='./Merlos/images/ojoGris.png' width='14'>" +
                            "		<textarea id='inpObservaSolTA" + i + "' class='trObservaArt inv'></textarea>" +
                            "	<td id='inpCesta" + i + "' class='C' style='width:40px;  box-sizing:border-box;' " +
                            "	onclick='cesta_Click(" + i + "); event.stopPropagation();'>" +
                            "		<img id='inpCestaImg" + i + "' src='./Merlos/images/icoCestaIn.png' width='24'>" +
                            "	</td>" +
                            "</tr>";
                        spanBotoneraPag
                    }
                    $("#tbPersEP_Articulos").html(contenido);
                    if (ConfMostrarStockVirtual === 0) { $(".inpStockVirtual").hide(); }

                    if (flexygo.context.ConfigArtMaxPedido === "1") { $(".PedidoMaximo").removeClass("inv").addClass("vis"); }
                    var pagRD = paginadorRegistros + 1;
                    var pagRH = paginadorRegistros + 100;
                    if (pagRH > registrosTotales) {
                        pagRH = registrosTotales;
                        esconder_spResBtn = true;
                    }
                    $("#spResultadosT").text("Mostrando registros del " + pagRD + " al " + pagRH + " de " + registrosTotales + " encontrados.").stop().fadeIn();
                    $("#spanBotoneraPag, #spResultados, #dvPersEP_Articulos, #spBtnAnyCont, #tbPersEP_ArticulosCab").stop().fadeIn();
                    if (modo) { $("#spResultados").hide(); }
                    if (esconder_spResBtn) {
                        $("#spResultadosT, #spResBtn").hide();
                        paginadorRegistros = 0;
                    }
                    if (modo) {
                        $("#thCodigo").css("background", "#4985D6");
                        $(".trBscCod").css("color", "#4985D6");
                    }
                    $("#inpBuscarArticuloDisponible").val("");
                } else {
                    $("#tbPersEP_Articulos").html("No se han obtenido resultados!");
                    $("#spanBotoneraPag, #spResultados, #dvPersEP_Articulos, #spBtnBuscarArtDispCli").stop().fadeIn();
                    $("#spBtnAnyCont , #tbPersEP_ArticulosCab, #spResultadosT, #spResBtn").stop().hide();
                    paginadorRegistros = 0;
                }
                $("#spanPersEPinfo").hide();
            } else { alert("Error pArticulosBuscar!\n" + JSON.stringify(ret)); }
        }, false);
    });
}

function inputTeclas(elInput, i, elPedUniCaja, elPeso, objeto, io, elemento, tamanoTotal, elBlur) {
    console.log(`inputTeclas(elInput ${elInput}, i ${i}, elPedUniCaja ${elPedUniCaja}, elPeso ${elPeso}, objeto ${objeto}, io ${io}, elemento ${elemento},tamanoTotal ${tamanoTotal}) event key ${event.key}`);
    var lineaSiguiente = parseInt(i) + 1;
    var lineaAnterior = parseInt(i) - 1;
    var cajas = $("#inp_cajas_" + i).val();
    var unidades = $("#inp_uds_" + i).val();
    var peso = $("#inp_peso_" + i).val();
    var idSiguiente = "";
    var eltb = "";
    if (elBlur) {
        if (objeto == 'cajas') {
            if (cajas !== "") {
                eltb = "tbArtDispTR" + i;
                calcCUP("cajas", eltb, elPedUniCaja, elPeso, false, "", "");
                idSiguiente = "inp_cajas_" + i;
                cargarPrecio(i, idSiguiente, "cajas");
            }
            //$("#inp_uds_" + i).focus();
        }
        if (objeto == 'unidades') {
            //console.log(`El objeto es unidades y la linea siguiente es ${lineaSiguiente} y el tamano total es ${tamanoTotal}`);
            if (unidades !== "") {
                eltb = "tbArtDispTR" + i;
                calcCUP("uds", eltb, elPedUniCaja, elPeso, false, "", "");
                idSiguiente = "inp_uds_" + i;
                cargarPrecio(i, idSiguiente, "uds");
            }
            // if (!$("#inp_peso_" + i).hasClass("inv")) {
            //     $("#inp_peso_" + i).focus();
            // } else {
            //     setTimeout(function() {
            //         $("#inpPrecioSol_" + i).focus();
            //     }, 500);
            // }
        }
    } else {
        if (event.key === "ArrowUp") {
            if (objeto == 'cajas') {
                if (parseInt(lineaAnterior) >= 0) {
                    if (!$("#inp_cajas_" + lineaAnterior).prop("disabled")) {
                        // idSiguiente = "inp_cajas_" + lineaAnterior;
                        // cargarPrecio(lineaAnterior, idSiguiente, "cajas");
                        $("#inp_cajas_" + lineaAnterior).focus();
                    }
                }
            }
            if (objeto == 'unidades') {
                if (parseInt(lineaAnterior) >= 0) {
                    // idSiguiente = "inp_uds_" + lineaAnterior;
                    // cargarPrecio(lineaAnterior, idSiguiente, "uds");
                    $("#inp_uds_" + lineaAnterior).focus();
                }
            }
            if (objeto == 'peso') {
                if (parseInt(lineaAnterior) >= 0) {
                    if (!$("#inp_peso_" + lineaAnterior).prop("disabled")) {
                        // idSiguiente = "inp_peso_" + lineaAnterior;
                        // cargarPrecio(lineaAnterior, idSiguiente, "peso");
                        $("#inp_peso_" + lineaAnterior).focus();
                    }
                }
            }
        } else {
            if (event.key === "ArrowDown") {
                //console.log(`El ArrowDown y el objeto es ${objeto}`);
                if (objeto == 'cajas') {
                    if (cajas !== "") {
                        eltb = "tbArtDispTR" + i;
                        calcCUP("cajas", eltb, elPedUniCaja, elPeso, false, "", "");
                        idSiguiente = "inp_cajas_" + i;
                        cargarPrecio(i, idSiguiente, "cajas");
                    }
                    if (parseInt(lineaSiguiente) < parseInt(tamanoTotal)) {
                        if (!$("#inp_cajas_" + lineaSiguiente).prop("disabled")) {
                            $("#inp_cajas_" + lineaSiguiente).focus();
                        }
                    }
                }
                if (objeto == 'unidades') {
                    //console.log(`El objeto es unidades y la linea siguiente es ${lineaSiguiente} y el tamano total es ${tamanoTotal}`);
                    if (unidades !== "") {
                        eltb = "tbArtDispTR" + i;
                        calcCUP("uds", eltb, elPedUniCaja, elPeso, false, "", "");
                        idSiguiente = "inp_uds_" + i;
                        cargarPrecio(i, idSiguiente, "uds");
                    }
                    if (parseInt(lineaSiguiente) < parseInt(tamanoTotal)) {
                        $("#inp_uds_" + lineaSiguiente).focus();
                    }
                }
                if (objeto == 'peso') {
                    // cargarPrecio(i, idSiguiente, "peso");
                    if (parseInt(lineaSiguiente) < parseInt(tamanoTotal)) {
                        if (!$("#inp_peso_" + lineaSiguiente).hasClass("inv")) {
                            $("#inp_peso_" + lineaSiguiente).focus();
                        }
                    }
                }
            } else {
                if (event.key === "Enter") {
                    if (objeto == 'cajas') {
                        if (cajas !== "") {
                            eltb = "tbArtDispTR" + i;
                            calcCUP("cajas", eltb, elPedUniCaja, elPeso, false, "", "");
                            idSiguiente = "inp_cajas_" + i;
                            cargarPrecio(i, idSiguiente, "cajas");
                        }
                        $("#inp_uds_" + i).focus();
                    }
                    if (objeto == 'unidades') {
                        //console.log(`El objeto es unidades y la linea siguiente es ${lineaSiguiente} y el tamano total es ${tamanoTotal}`);
                        if (unidades !== "") {
                            eltb = "tbArtDispTR" + i;
                            calcCUP("uds", eltb, elPedUniCaja, elPeso, false, "", "");
                            idSiguiente = "inp_uds_" + i;
                            cargarPrecio(i, idSiguiente, "uds");
                        }
                        if (!$("#inp_peso_" + i).hasClass("inv")) {
                            $("#inp_peso_" + i).focus();
                        } else {
                            setTimeout(function() {
                                $("#inpPrecioSol_" + i).focus();
                            }, 500);
                        }
                    }
                    if (objeto == 'peso') {
                        // cargarPrecio(i, idSiguiente, "peso");
                        setTimeout(function() {
                            $("#inpPrecioSol_" + i).focus();
                        }, 500);
                    }
                }
            }
        }
    }
    // var aplicarEvento = false;

    // if (event.key === "ArrowUp") {
    //     i--;
    //     aplicarEvento = true;
    // } else if (event.key === "ArrowDown") {
    //     i++;
    //     aplicarEvento = true;
    // } else if (event.key === "Enter") {
    //     var siguienteInput = "";
    //     var elementoId = $(elemento).attr("id");

    //     if (objeto === "cajas") { siguienteInput = "inp_uds_"; }
    //     if (objeto === "unidades") {
    //         siguienteInput = "inp_peso_";
    //         if ($("#" + siguienteInput + "" + i).prop("disabled")) { siguienteInput = "inpPrecioSol_"; }
    //     }
    //     if (objeto === "peso") { siguienteInput = "inpPrecioSol_"; }

    //     $("#" + siguienteInput + "" + i).focus().select();
    // }

    // if (aplicarEvento) { $("#" + elInput + "" + i).click(); }
}

function teclaEnter(clase, i) {
    if (event.key === "Enter") {
        var siguienteInput = "";
        var siguiente = i + 1;

        setTimeout(function() {
            if (clase === "inpPrecioSol") { siguienteInput = "inpDtoSol_" + i; }
            if (clase === "inpDtoSol") {
                if ($("#" + siguienteInput).prop("enabled")) { siguienteInput = "inp_cajas_" + siguiente; } else { siguienteInput = "inp_uds_" + siguiente }
            }

            $("#" + siguienteInput).focus().select();
        }, 300);
    }
}

function cargarPrecio(i, inp, cajasUdsPeso) {
    var elArticulo = $("#tbArtDispTR" + i).attr("data-art");
    var unidades = $.trim($("#" + inp).val());
    if (isNaN(unidades) || unidades === "") { unidades = 0; }
    var parametros = '{' +
        '"modo":"verArticuloPrecio"' +
        ',"empresa":"' + flexygo.context.CodigoEmpresa + '"' +
        ',"cliente":"' + ClienteCodigo + '"' +
        ',"articulo":"' + elArticulo + '"' +
        ',"unidades":' + unidades +
        ',"cajasUdsPeso":"' + cajasUdsPeso + '"' +
        ',"FechaTeleVenta":"' + FechaTeleVenta + '"' +
        ',' + paramStd +
        '}';
    flexygo.nav.execProcess('pPreciosTabla', '', null, null, [{ 'Key': 'parametros', 'Value': limpiarCadena(parametros) }], 'current', false, $(this), function(ret) {
        if (ret) {
            try {
                var js = JSON.parse(limpiarCadena(ret.JSCode));
                var PT = js[0].precioTarifa;
                if (isNaN(PT) || PT === "") { PT = 0.00; }
                var PC = js[0].precio;
                if (isNaN(PC) || PC === "") { PC = 0; }
                var DT = js[0].dto;
                if (isNaN(DT) || DT === "") { DT = 0; }
                $("#tarifaTD" + i).html(parseFloat(PT).toFixed(2));
                $("#precioTD" + i).html(
                    "<input type='text' id='inpPrecioSol_" + i + "' class='inpPrecioSol' " +
                    "onkeyup='$(this).css(\"color\",\"#000\"); calcularImporte(\"tbArtDispTR" + i + "\"," + i + "); teclaEnter(\"inpPrecioSol\"," + i + ");' " +
                    "onclick='$(this).select(); tfArtSel(" + i + ")' " +
                    "value='" + parseFloat(PC).toFixed(2) + "'>"
                );
                $("#DtoTD" + i).html(
                    "<input type='text' id='inpDtoSol_" + i + "' class='inpDtoSol' " +
                    "onkeyup='$(this).css(\"color\",\"#000\"); calcularImporte(\"tbArtDispTR" + i + "\"," + i + "); teclaEnter(\"inpDtoSol\"," + i + ")' " +
                    "onclick='$(this).select();' " +
                    "value='" + parseFloat(DT).toFixed(2) + "'>"
                );
                calcularImporte("tbArtDispTR" + i, i);
            } catch (err) { alert("Error JSON pPreciosTabla - verArticuloPrecio!\n" + JSON.stringify(ret)); }
        } else { alert("Error RET - pPreciosTabla - verArticuloPrecio!\n" + JSON.stringify(ret)); }
    }, false);
}

function tfArtSel(i) {
    tfArticuloSeleccionadoI = i;
    tfArticuloSeleccionado = $("#tbArtDispTR" + i).attr("data-art");
}

function mostrarTarifaArticulo() {
    if (tfArticuloSeleccionado === "") { return; }
    abrirVelo(icoCargando16 + " buscando el artículo " + tfArticuloSeleccionado + " en las distintas tarifas...");
    var parametros = '{"modo":"verArticuloTarifas","articulo":"' + tfArticuloSeleccionado + '"}';
    flexygo.nav.execProcess('pPreciosTabla', '', null, null, [{ 'Key': 'parametros', 'Value': limpiarCadena(parametros) }], 'current', false, $(this), function(ret) {
        if (ret) {
            var contenido = "<span style='font:bold 14px arial; color:#68CDF9;'>Artículo: " + tfArticuloSeleccionado + " - Tarifas</span>" +
                "<span style='float:right;' onclick='cerrarVelo();'>" + icoAspa + "</span>" +
                "<br><br>" +
                "<table id='tbArticulosTarifas' class='tbStd'>" +
                "	<tr>" +
                "		<th>Tarifa</th>" +
                "		<th>PVP</th>" +
                "	</tr>";
            var js = JSON.parse(limpiarCadena(ret.JSCode));
            if (js.length > 0) {
                for (var i in js) {
                    var elPVP = parseFloat(js[i].pvp).toFixed(2);
                    if (isNaN(elPVP)) { elPVP = "0.00"; }
                    contenido += "<tr onclick='establecerPvpTarifa(" + js[i].pvp + ")'>" +
                        "	<td>" + js[i].tarifa + "</td>" +
                        "	<td>" + elPVP + "</td>" +
                        "</tr>";
                }
                contenido += "</table>";
            } else { contenido = "No se han obtenido registros!<br><br><br><span class='MIboton esq05' onclick='cerrarVelo();'>aceptar</span>"; }
            abrirVelo(contenido);
        } else { alert("Error pPreciosTabla - verArticuloTarifas!\n" + JSON.stringify(ret)); }
    }, false);
}

function establecerPvpTarifa(pvp) {
    $("#tbArtDispTR" + tfArticuloSeleccionadoI).find(".inpPrecioSol").val(parseFloat(pvp).toFixed(2));
    cerrarVelo();
}

function articuloCliente(trid, articulo) {
    if (ArticuloClienteBuscando) { return; }
    ArticuloClienteBuscando = true;
    dentroDelDiv = true;
    abrirAVT(icoCargando16 + " buscando el artículo " + articulo + " en los albaranes...");
    var contenido = "<span style='font:bold 14px arial; color:#68CDF9;'>Artículo: " + articulo + "</span>" +
        "<br><br>" +
        "<table class='tbStd'>" +
        "	<tr>" +
        "		<th class='C'>Fecha</th>" +
        "		<th class='C'>Cajas</th>" +
        "		<th class='C'>Uds.</th>" +
        "		<th class='C'>Peso</th>" +
        "		<th class='C'>Precio</th>" +
        "		<th class='C'>Dto</th>" +
        "		<th class='C'>Importe</th>" +
        "	</tr>";
    var parametros = '{"modo":"UltimasVentasArticulo","registros":' + paginadorRegistros + ',"buscar":"' + $.trim($("#inpBuscarArticuloDisponible").val()) + '","articulo":"' + articulo + '","cliente":"' + ClienteCodigo + '","IdTeleVenta":"' + IdTeleVenta + '","fechaTV":"' + FechaTeleVenta + '","nombreTV":"' + NombreTeleVenta + '",' + paramStd + '}';
    flexygo.nav.execProcess('pArticulosCliente', '', null, null, [{ 'Key': 'parametros', 'Value': limpiarCadena(parametros) }], 'current', false, $(this), function(ret) {
        if (ret) {
            var js = JSON.parse(limpiarCadena(ret.JSCode));
            if (js.length > 0) {
                for (var i in js) {
                    contenido += "	<tr>" +
                        "		<td class='C'>" + js[i].FECHA + "</td>" +
                        "		<td class='C'>" + js[i].CAJAS + "</td>" +
                        "		<td class='C'>" + js[i].UDS + "</td>" +
                        "		<td class='C'>" + js[i].PESO + "</td>" +
                        "		<td class='C'>" + js[i].PRECIO + "</td>" +
                        "		<td class='C'>" + js[i].DTO1 + "</td>" +
                        "		<td class='C'>" + js[i].IMPORTE + "</td>" +
                        "	</tr>";
                }
                contenido += "</table>";
            } else { contenido = "No se han obtenido registros!<br><br><br><span class='MIboton esq05' onclick='cerrarAVT();'>aceptar</span>"; }
            abrirAVT(contenido, 800);
            ArticuloClienteBuscando = false;
            if (!dentroDelDiv) { cerrarAVT(); }
        } else {
            alert("Error pArticulosCliente - UltimasVentasArticulo!\n" + JSON.stringify(ret));
            ArticuloClienteBuscando = false;
        }
    }, false);
}

function calcCUP(modo, i, unicaja, unipeso, uniprecio, elENTER, linea, elId) {
    console.log(`calcCUP(modo ${modo}, i ${i}, unicaja ${unicaja}, unipeso ${unipeso}, uniprecio ${uniprecio}, elENTER ${elENTER})`);
    var elTR = "#" + i;
    var cajas = $(elTR).find(".inpCajasSol").val();
    if (isNaN(cajas)) { cajas = 0; }
    var uds = $(elTR).find(".inpCantSol").val();
    if (isNaN(uds)) { uds = 0; }
    var peso = $(elTR).find(".inpPesoSol").val();
    if (isNaN(peso)) { peso = 0; }
    var codigo = $(elTR).find(".inpCodigoSol").val();
    var linia = $(elTR).find(".inpLiniaSol").val();

    if (modo === "cajas") {
        uds = cajas * unicaja;
        if (isNaN(uds)) { uds = 0; }
        $(elTR).find(".inpCantSol").val(uds);
        if (parseFloat(unipeso) > 0) {
            peso = uds * unipeso;
            if (isNaN(peso)) { peso = 0; }
            $(elTR).find(".inpPesoSol").val(peso.toFixed(3));
        }
    }
    if (modo === "uds") {
        if (parseFloat(unicaja) > 0) {
            cajas = uds / unicaja;
            if (isNaN(cajas)) { cajas = 0; }
            $(elTR).find(".inpCajasSol").val(Math.floor(cajas));
        }
        if (parseFloat(unipeso) > 0) {
            peso = uds * unipeso;
            if (isNaN(peso)) { peso = 0; }
            $(elTR).find(".inpPesoSol").val(peso.toFixed(3));
        }
    }

    calcularImporte(i, i);
    if (elENTER) {
        cargarPrecio(linea, elId, "uds");
    }
}

function calcularImporte(i, iValor) {

    $(elTR).find(".inpImporteSol").html("");
    var elPesoUltVent = $("#tdPesoUltVenta_" + i).text();
    var elTR = "#" + i;
    var uds = $(elTR).find(".inpCantSol").val();
    if (isNaN(uds)) { uds = 0; }
    var peso = $(elTR).find(".inpPesoSol").val();
    if (isNaN(peso)) { peso = 0; }
    var dto = $(elTR).find(".inpDtoSol").val();
    if (isNaN(dto)) { dto = 0; }
    var precio = $(elTR).find(".inpPrecioSol").val();
    if (isNaN(precio)) { precio = 0; }
    var importe = parseFloat(precio) * parseFloat(uds);
    if (parseFloat(peso) > 0 && parseInt(EWtrabajaPeso) === 1) { importe = parseFloat(precio) * parseFloat(peso); }
    if (parseFloat(dto) > 0) { importe = importe - ((importe * dto) / 100); }
    if (isNaN(importe)) { importe = 0; }
    $(elTR).find(".inpImporteSol").html(importe.toFixed(2) + "&euro;");
    console.log(`calcularImporte uds ${uds} peso ${peso} dto ${dto} precio ${precio} importe ${importe} elTR ${elTR} elPesoUltVent ${elPesoUltVent}`);
    // rojo si el precio es menor al de la tarifa mínima
    var precioTarifaMinima = parseFloat($("#tarifaTD" + iValor).text());
    if (precio < precioTarifaMinima) { $(elTR).find(".inpPrecioSol").css("color", "red"); } else { $(elTR).find(".inpPrecioSol").css("color", "#000"); }
}

function buscarArticuloDisponible() {
    if (ClienteCodigo === "") { alert("No hay un cliente seleccionado!"); return; }
    if (event.keyCode === 13) {
        var buscarArticulo = $.trim($("#inpBuscarArticuloDisponible").val());
        if (buscarArticulo === "") { return; }
        paginadorRegistros = 0;
        cargarArticulosDisponibles(false);
        return;
    }
    var buscar = $.trim($("#inpBuscarArticuloDisponible").val()).toUpperCase();
    if (buscar === "") { $(".trBsc").removeClass("inv"); return; }
    $("#tbPersEP_Articulos").find(".trBsc").each(function() {
        var cod = $(this).find(".trBscCod").text().toUpperCase();
        var nom = $(this).find(".trBscNom").text().toUpperCase();
        if (cod.indexOf(buscar) >= 0 || nom.indexOf(buscar) >= 0) { $(this).removeClass("inv"); } else { $(this).addClass("inv"); }
    });
    repintarZebra("tbPersEP_Articulos", "#fff");
}

function buscarArtDispCli() { cargarArticulosDisponibles(ClienteCodigo); }

function ultimoArticulo_Click(art) { /* $("#inpBuscarArticuloDisponible").val(art); buscarArticuloDisponible(window.event.keyCode=13);*/ }

function pedidoVerDetalle() {
    //console.log(PedidoDetalle);
    if (PedidoDetalle.length > 0) {
        var CosteResiduoArticulos = [];
        var elTotal = 0.00;
        var contenido = "<br><table id='tbPedidoDetalle' class='tbStd'>" +
            "	<tr>" +
            "	<th colspan='9' style='vertical-align:middle; background:#CCC;'>Líneas del Pedido</th>" +
            "	</tr>" +
            "	<tr>" +
            "		<th style='width:50px;'></th>" +
            "		<th style='width:150px;'>código</th>" +
            "		<th class='taL'>nombre</th>" +
            "		<th class='taC' style='width:80px;'>unidades</th>" +
            "		<th class='taC' style='width:80px;'>peso</th>" +
            "		<th class='taC' style='width:80px;'>precio</th>" +
            "		<th class='taC' style='width:80px;'>dto</th>" +
            "		<th class='taC' style='width:80px;'>C.Residuo</th>" +
            "		<th class='taC' style='width:100px;'>importe</th>" +
            "	</tr>";
        var js = JSON.parse("[" + PedidoDetalle + "]");
        for (var i in js) {
            var importe = parseInt(js[i].unidades) * parseFloat(js[i].precio);
            if (parseFloat(js[i].peso) > 0) { importe = parseFloat(js[i].peso) * parseFloat(js[i].precio) }
            var dto = (importe * parseFloat(js[i].dto)) / 100;
            importe = importe - dto;
            var CosteResiduo = parseFloat(js[i].CosteResiduo);
            if (isNaN(CosteResiduo)) { CosteResiduo = 0; }
            elTotal += importe + CosteResiduo;

            var peso = parseFloat(js[i].peso).toFixed(2);
            if (isNaN(peso)) { peso = ""; }
            var precio = parseFloat(js[i].precio).toFixed(2);
            if (isNaN(precio)) { precio = ""; }
            var dto1 = parseFloat(js[i].dto).toFixed(2);
            if (isNaN(dto1)) { dto1 = ""; }

            var lasUds = js[i].unidades;
            if (isNaN(lasUds)) { lasUds = ""; }

            contenido += "	<tr>" +
                "		<td class='taC'>" +
                "			<img src='./Merlos/images/icoCestaInX.png' class='curP' width='20' " +
                "			onclick='PedidoEliminarLinea(\"" + js[i].jsId + "\")'>" +
                "		</td>" +
                "		<td class='taL'>" + js[i].codigo + "</td>" +
                "		<td class='taL'>" + js[i].nombre + "</td>" +
                "		<td class='taR'>" + lasUds + "</td>" +
                "		<td class='taR'>" + peso + "</td>" +
                "		<td class='taR'>" + precio + " &euro;</td>" +
                "		<td class='taR'>" + dto1 + "</td>" +
                "		<td class='taR' id='CosteResiduo_" + js[i].codigo + "'>" + parseFloat(CosteResiduo).toFixed(3) + "</td>" +
                "		<td class='taR'>" + importe.toFixed(2) + " &euro;</td>" +
                "	</tr>";

            if (js[i].observacion !== "") {
                var obs = js[i].observacion;
                //console.log(obs);
                if (obs.includes("MI_RETCARRO_MI")) {
                    obs = obs.replace(/_MI_RETCARRO_MI_/g, "<br>");
                }
                contenido += "	<tr>" +
                    "		<td class='taC'>" +
                    "			<img src='./Merlos/images/icoCestaInX.png' class='curP' width='20' " +
                    "			onclick='PedidoEliminarLinea(\"" + js[i].jsId + "\")'>" +
                    "		</td>" +
                    "		<td></td>" +
                    "		<td style='color:#4985D6; text-align:left;'>" + obs + "</td>" +
                    "		<td class='taR'></td>" +
                    "		<td class='taR'></td>" +
                    "		<td class='taR'></td>" +
                    "		<td class='taR'></td>" +
                    "		<td class='taR'></td>" +
                    "		<td class='taR'></td>" +
                    "	</tr>";
            }
        }
        contenido += "<tr><th colspan='2'></th><th colspan='6'>TOTAL PEDIDO</th><th class='taR'>" + elTotal.toFixed(2) + "</th></tr></table>"
        $("#dvPedidoDetalle").html(contenido);
    } else { $("#dvPedidoDetalle").html("<div style='padding:10px; color:red;'>Sin Lineas para el pedido!</div>"); }
}

function PedidoEliminarLinea(jsId) {
    //console.log(jsId);
    var js = JSON.parse("[" + PedidoDetalle + "]");
    //console.log(`pedidoDetalleAntes ${JSON.stringify(js)}`);
    var nuevoP = [];
    for (var i in js) {
        if (parseInt(js[i].jsId) !== parseInt(jsId)) {
            // nuevoP.push('{"jsId":"' + Date.now() + '","codigo":"' + js[i].codigo + '","nombre":"' + js[i].nombre +
            //     '","unidades":"' + js[i].unidades + '","peso":"' + js[i].peso + '","precio":"' + js[i].precio +
            //     '","dto":"' + js[i].dto +
            //     '","importe":"' + js[i].importe +
            //     '","CosteResiduo":"' + js[i].CosteResiduo +
            //     '","CosteResiduoArt":"' + js[i].articulo +
            //     '","ArtUnicaja":"' + js[i].cajas +
            //     '","incidencia":"' + js[i].incidencia +
            //     '","incidenciaDescrip":"' + js[i].incidenciaDescrip +
            //     '","observacion":"' + js[i].observacion + '"}');
            nuevoP.push('{"jsId":"' + js[i].jsId + '","codigo":"' + js[i].codigo + '","nombre":"' + js[i].nombre +
                '","unidades":"' + js[i].unidades + '","peso":"' + js[i].peso + '","precio":"' + js[i].precio +
                '","dto":"' + js[i].dto +
                '","importe":"' + js[i].importe +
                '","CosteResiduo":"' + js[i].CosteResiduo +
                '","CosteResiduoArt":"' + js[i].articulo +
                '","ArtUnicaja":"' + js[i].cajas +
                '","incidencia":"' + js[i].incidencia +
                '","incidenciaDescrip":"' + js[i].incidenciaDescrip +
                '","observacion":"' + js[i].observacion + '"}');
        }
    }
    PedidoDetalle = nuevoP;
    var parametros = '{"modo":"eliminarLinea","IdTransaccion":"' + IdTransaccion + '","jsId":"' + jsId + '","articulo":"' + jsId + '"}';
    console.log(parametros);
    flexygo.nav.execProcess('pPedido_Linea', '', null, null, [{ 'key': 'parametros', 'value': limpiarCadena(parametros) }], 'current', false, $(this), function(r1) {
        if (r1) {
            // var js = JSON.parse("[" + PedidoDetalle + "]");
            // console.log(`pedidoDetalleDespues ${JSON.stringify(js)}`);
            pedidoVerDetalle();
        } else { alert("Error! - pPedido_Linea - guardar línea en tabla temporal: " + JSON.stringify(r1)); }
    }, false);
}


function terminarLlamada(reintento) {
    if (terminandoLlamada && !reintento) { return; }
    if (terminarReintento === 10) {
        terminarReintento = 0;
        abrirVelo(`
			Se ha superado el máximo de 10 reintentos para generar el pedido!
			<br><br><br><span class='MIbotonGreen' onclick='terminarLlamada()'>reintentar</span>
			&nbsp;&nbsp;&nbsp;<span class='MIbotonRed' onclick='cerrarVelo()'>cancelar</span>
		`);
        return;
    }
    terminandoLlamada = true;
    if (ClienteCodigo === "") {
        alert("No hay un cliente activo!");
        terminandoLlamada = false;
        return;
    }
    var contacto = ($.trim($("#inpDataContacto").val())).split(" - ")[0];
    if (PedidoDetalle.length > 0 && PedidoGenerado === "") {
        var fff = $.trim($("#inpFechaEntrega").val());
        if (fff !== "") {
            if (!existeFecha(fff)) {
                alert("Ups! Parece que la fecha no es correcta!");
                terminandoLlamada = false;
                return;
            }
            if (!validarFechaMayorActual(fff)) {
                alert("La fecha debe ser posterior a hoy!");
                terminandoLlamada = false;
                return;
            }
        }
        if (!reintento) { abrirVelo(icoCargando16 + " generando el pedido..."); }
        var lasLineas = (JSON.stringify(PedidoDetalle)).replace(/{/g, "_openLL_").replace(/}/g, "_closeLL_");

        if ($("#imgPedidoNoCobrarPortes").attr("src") === BtnDesO) { PedidoNoCobrarPortes = 0; } else { PedidoNoCobrarPortes = 1; }
        if ($("#imgVerificarPedido").attr("src") === BtnDesO) { VerificarPedido = 0; } else { VerificarPedido = 1; }

        if (!ConfirmacionDePedido) { MostrarConfirmacionDePedido(); return; }

        var Values = '<Row rowId="elRowDelObjetoPedido" ObjectName="Pedido">' +
            '<Property Name="MODO" Value="Pedido"/>' +
            '<Property Name="IdTransaccion" Value="' + IdTransaccion + '"/>' +
            '<Property Name="IdTeleVenta" Value="' + IdTeleVenta + '"/>' +
            '<Property Name="FechaTV" Value="' + FechaTeleVenta + '"/>' +
            '<Property Name="NombreTV" Value="' + NombreTeleVenta + '"/>' +
            '<Property Name="IDPEDIDO" Value="' + PedidoActivo + '"/>' +
            '<Property Name="EMPRESA" Value="' + flexygo.context.CodigoEmpresa + '"/>' +
            '<Property Name="CLIENTE" Value="' + ClienteCodigo + '"/>' +
            '<Property Name="ENV_CLI" Value="' + $("#inpDirEntrega").val() + '"/>' +
            '<Property Name="SERIE" Value="' + $("#dvSerieTV").text() + '"/>' +
            '<Property Name="CONTACTO" Value="' + contacto + '"/>' +
            '<Property Name="INCICLI" Value="' + $.trim(($("#inciCliente").val()).split(" - ")[0]) + '"/>' +
            '<Property Name="INCICLIDescrip" Value="' + $.trim(($("#inciCliente").val()).split(" - ")[1]) + '"/>' +
            '<Property Name="ENTREGA" Value="' + $.trim($("#inpFechaEntrega").val()) + '"/>' +
            '<Property Name="VENDEDOR" Value="' + elVendedor + '"/>' +
            "<Property Name='NoCobrarPortes' Value='" + PedidoNoCobrarPortes + "'/>" +
            "<Property Name='VerificarPedido' Value='" + VerificarPedido + "'/>" +
            "<Property Name='OBSERVACIO' Value='" + ($.trim($("#taObservacionesDelPedido").val())).replace(/<br>/g, "\r") + "'/>" +
            '</Row>';

        var parametros = '{"sp":"pEnUso","clave":"PEDIDO","tipo":"Stored Procedure","objeto":"pPedido_Nuevo","terminarReintento":' + terminarReintento + ',' + paramStd + '}';
        flexygo.nav.execProcess('pMerlos', '', null, null, [{ 'Key': 'parametros', 'Value': limpiarCadena(parametros) }], 'current', false, $(this), function(veu) {
            if (veu) {
                if (parseInt(veu.JSCode) === 1) {
                    setTimeout(function() {
                        terminarReintento++;
                        terminarLlamada('reintento');
                    }, 500);
                } else {
                    terminarReintento = 0;
                    ConfirmacionDePedido = false;
                    var losParametros = [{ key: 'Values', value: Values }, { key: 'ContextVars', value: ContextVars }, { key: 'RetValues', value: RetValues }];
                    generarNuevoPedido(losParametros);
                }
            } else { alert('Error SP pEnUso!' + JSON.stringify(rt)); }
        }, false);
    } else { terminarLlamadaDef(); }
}

function generarNuevoPedido(losParametros) {
    if (terminarReintento === 10) {
        terminarReintento = 0;
        abrirVelo(`
			Se ha superado el máximo de 10 reintentos para generar el pedido!
			<br><br><br><span class='MIbotonGreen' onclick='terminarLlamada()'>reintentar</span>
			&nbsp;&nbsp;&nbsp;<span class='MIbotonRed' onclick='cerrarVelo()'>cancelar</span>
		`);
        return;
    }
    //console.log(JSON.stringilosParametros);
    flexygo.nav.execProcess('pPedido_Nuevo', 'Pedido', null, null, losParametros, 'current', false, $(this), function(ret) {
        if (ret) {
            if ((ret.JSCode).indexOf("Error-pPedidoNuevo-") != -1) {
                terminarReintento++;
                setTimeout(function() { generarNuevoPedido(losParametros); }, 250);
            } else {
                var js = JSON.parse(limpiarCadena(ret.JSCode));
                cargarTeleVentaUltimosPedidos(ClienteCodigo);
                $("#inpBuscarArticuloDisponible").val("");
                $("#tbPersEP_ArticulosCab, #dvPedidoDetalle").html("");
                $("#dvPersEP_Articulos, #spResultados").slideUp();
                PedidoGenerado = js.Codigo;
                terminarLlamadaDef(PedidoGenerado, true);
                terminarReintento = 0;
            }
        } else { alert('Error SP pPedido_Nuevo!' + JSON.stringify(ret)); }
    }, false);
}

function terminarLlamadaDef(pedido, confirmacion) {
    var incidenciaCliente = $.trim($("#inciCliente").val()).split(" - ")[0];
    var incidenciaClienteDescrip = $.trim($("#inciCliente").val()).split(" - ")[1];
    var observaciones = limpiarCadena($.trim($("#taObservacionesDelPedido").val()));
    var elTXT;
    if ((incidenciaCliente === "" && observaciones === "") && !confirmacion) {
        if (incidenciaCliente === "" && observaciones === "") { elTXT = "No se han indicado observaciones del pedido<br>ni incidencias del cliente!"; }
        if (incidenciaCliente === "" && observaciones !== "") { elTXT = "No se ha indicado incidencia del cliente!"; }
        if (incidenciaCliente !== "" && observaciones === "") { elTXT = "No se han indicado observaciones del cliente!"; }
        abrirVelo(
            elTXT +
            "<br><br><br>" +
            "<span class='MIbotonGreen' onclick='terminarLlamadaDef(\"" + pedido + "\",true)'>Terminar la llamada</span>" +
            "&nbsp;&nbsp;&nbsp;<span class='MIbotonRed' onclick='cerrarVelo()'>cancelar</span>"
        );
        terminandoLlamada = false;
        return;
    }
    var incidenciasSinPedido = "";
    if (PedidoGenerado === "" && PedidoDetalle.length === 0) {
        var articulo = "";
        var inciArt = "";
        var obsArt = "";
        var elID = 0;
        $("#tbPersEP_Articulos").find("tr").each(function() {
            articulo = $(this).attr("data-art");
            inciArt = $.trim($("#inpIncidenciaSolINP" + elID).val());
            if (inciArt == undefined) { inciArt = ""; }
            obsArt = $.trim($("#inpObservaSolTA" + elID).val());
            if (obsArt == undefined) { obsArt = ""; }

            if (inciArt !== "" || obsArt !== "") {
                var iArt = inciArt.split(" - ")[0];
                var iArtDescrip = inciArt.split(" - ")[1];
                if (iArt === "") { iArtDescrip = ""; }
                incidenciasSinPedido += '{"articulo":"' + articulo + '","incidencia":"' + iArt + '","descrip":"' + iArtDescrip + '","observacion":"' + obsArt + '"}';
            }
            elID++;
        });
        incidenciasSinPedido = ',"inciSinPed":[' + incidenciasSinPedido.replace(/}{/g, "},{") + ']';
    }
    var parametros = '{"modo":"terminar","cliente":"' + ClienteCodigo + '","IdTeleVenta":"' + IdTeleVenta + '","FechaTeleVenta":"' + FechaTeleVenta + '","nombreTV":"' + NombreTeleVenta + '"' +
        ',"incidenciaCliente":"' + incidenciaCliente + '","incidenciaClienteDescrip":"' + incidenciaClienteDescrip + '","observaciones":"' + observaciones + '"' +
        ',"pedido":"' + pedido + '","empresa":"' + CodigoEmpresa + '","serie":"' + $("#dvSerieTV").text() + '"' + incidenciasSinPedido + ',' + paramStd + '}';
    flexygo.nav.execProcess('pLlamadas', '', null, null, [{ 'key': 'parametros', 'value': limpiarCadena(parametros) }], 'current', false, $(this), function(ret) {
        if (ret) {
            terminandoLlamada = false;
            if (ctvll === "llamadasDelCliente") {
                flexygo.nav.openPage('list', 'Clientes', '(BAJA=0)', null, 'current', false, $(this));
                $("#mainNav").show();
            } else { inicioTeleVenta(); }
        } else { alert("Error SP: pLlamadas!!!" + JSON.stringify(ret)); }
    }, false);
}

function MostrarConfirmacionDePedido() {
    datosDelClienteConfirmacion = datosDelCliente + $("#PedidoBotonesPortesVerif").html() + "<br>" + $("#dvPedidoDetalle").html();

    datosDelClienteConfirmacion = datosDelClienteConfirmacion.replace(/tdOfertas/g, "tdOfertasConfirmacion")
        .replace(/dvRiesgo/g, "dvRiesgoConfirmacion")
        .replace(/tbPedidoDetalle/g, "tbPedidoDetalleConfirmacion")
        .replace(/PedidoBotonesPortesVerif/g, "PedidoBotonesPortesVerifConfirmacion")
        .replace(/PedidoBotonesPortesVerif/g, "PedidoBotonesPortesVerifConfirmacion")
        .replace(/imgPedidoNoCobrarPortes/g, "imgPedidoNoCobrarPortesConfirmacion")
        .replace(/imgVerificarPedido/g, "imgVerificarPedidoConfirmacion")
        .replace(/inpDataContacto/g, "inpDataContactoConfirmacion")
        .replace(/tdDirEntrega/g, "tdDirEntregaConfirmacion")
        .replace(/inpFechaEntrega/g, "inpFechaEntregaConfirmacion")
        .replace(/inciCliente/g, "inciClienteConfirmacion")
        .replace(/taObservacionesDelPedido/g, "taObservacionesDelPedidoConfirmacion");

    abrirVelo(`
		<div style="text-align:center; background:#19456B; font:bold 16px arial; color:#FFF; padding:8px;">
			<i class="flx-icon icon-eye"></i> Confirmación de Pedido
			<i class="flx-icon icon-close" style="float:right; cursor:pointer;" onclick="cerrarVelo()"></i>
		</div>
		${datosDelClienteConfirmacion}
		<div id="ConfirmacionPedidoBtnConfirmar" style="margin-top:20px; text-align:center;">
			<span class="MIbotonGreen" onclick="ConfirmacionDePedido=true; terminarLlamada();">Confirmar el Pedido</span>
		</div>
	`, 'todo');

    $("#inpDataContactoConfirmacion").val($("#inpDataContacto").val());
    $("#tdDirEntregaConfirmacion").text($("#tdDirEntrega").text());
    $("#inpFechaEntregaConfirmacion").val($("#inpFechaEntrega").val());
    $("#inciClienteConfirmacion").val($("#inciCliente").val());
    $("#taObservacionesDelPedidoConfirmacion").val($("#taObservacionesDelPedido").val());

    ConfirmacionPedidoTratarVelo();
}

function ConfirmacionPedidoTratarVelo() {
    if (!$("#ConfirmacionPedidoBtnConfirmar").is(":visible")) { setTimeout(ConfirmacionPedidoTratarVelo, 100); } else {
        $("#tdOfertasConfirmacion , #dvRiesgoConfirmacion , #tbPedidoDetalleConfirmacion img").remove();
        $("#imgPedidoNoCobrarPortesConfirmacion , #imgVerificarPedidoConfirmacion").attr("onclick", "");

        terminandoLlamada = false;
    }
}

function cargarIncidencias(modo) {
    abrirVelo(icoCargando16 + " obteniendo incidencias...");
    var parametros = '{"modo":"' + modo + '",' + paramStd + '}';
    flexygo.nav.execProcess('pIncidencias', '', null, null, [{ 'key': 'parametros', 'value': limpiarCadena(parametros) }], 'current', false, $(this), function(ret) {
        if (ret) {
            var js = JSON.parse(limpiarCadena(ret.JSCode));
            window["dvIncidencias" + modo.toUpperCase()] = "";
            for (var i in js) {
                window["dvIncidencias" + modo.toUpperCase()] += "<div class='indiencia dvSub' " +
                    "onclick='asignarIncidencia($(this).parent().attr(\"data-id\"),\"" + js[i].codigo + " - " + js[i].nombre + "\")'>" +
                    js[i].codigo + " - " + js[i].nombre +
                    "</div>";
            }
            cerrarVelo();
        } else { alert("Error SP: pIncidencias!!!" + JSON.stringify(ret)); }
    }, false);
}

function incidencia(modo, id) {
    $("#dvIncidenciasTemp").remove();
    if (modo === "obs") {
        var uds = $.trim($("#tbArtDispTR" + id.split("inpObservaSol")[1]).find(".inpCantSol").val());
        if ((uds === "" || parseInt(uds) === 0 || isNaN(uds)) && $("#" + id).find("img").attr("src") === "./Merlos/images/ojoGris.png") { return; }
        var pHolder = "placeholder='Observaciones del producto'";
        var obsArt = $("#inpObservaSolTA" + id.split("inpObservaSol")[1]).val();
        if (obsArt !== "") { pHolder = ""; }
        $("body").prepend(
            "<div id='dvIncidenciasTemp' class='dvTemp'>" +
            "	<textarea style='width:100%;height:130px;padding:5px;box-sizing:border-box;' " + pHolder + " maxlength='75'>" + obsArt + "</textarea>" +
            "	<div style='text-align:center;padding:10px;'><span class='MIbotonGreen' " +
            "		onclick='observacionesArticulo(\"" + id + "\")'>guardar</span>" +
            "	</div>" +
            "</div>"
        );
    } else { $("body").prepend("<div id='dvIncidenciasTemp' class='dvTemp' data-id='" + id + "'>" + window["dvIncidencias" + modo.toUpperCase()] + "</div>"); }
    var y = ($("#" + id).offset()).top - ($("#dvIncidenciasTemp").height());
    var x = (($("#" + id).offset()).left - $("#dvIncidenciasTemp").width()) + $("#" + id).width();
    $("#dvIncidenciasTemp").offset({ top: y, left: x }).stop().fadeIn();
}

function asignarIncidencia(dis, inci) {
    if (dis === "inciCliente") { $("#inciCliente").val(inci); } else {
        $("#inpIncidenciaSolImg" + dis.split("inpIncidenciaSol")[1]).attr("src", "./Merlos/images/inciRed.png");
        $("#inpIncidenciaSolINP" + dis.split("inpIncidenciaSol")[1]).html(inci);
    }
    $("#dvIncidenciasTemp").remove();
}

function observacionesArticulo(id) {
    var ind = id.split("inpObservaSol")[1];
    var ta = ($("#dvIncidenciasTemp textarea").val());
    $("#inpObservaSolImg" + ind).attr("src", "./Merlos/images/ojoRed.png");
    $("#inpObservaSolTA" + ind).val(ta);
    $("#dvIncidenciasTemp").remove();
}

/*  TV_LlamadasTV  **************************************************************************************************************** */
/*
function cargarIncidencias(modo){
	var parametros = '{"modo":"'+modo+'",'+paramStd+'}';
	flexygo.nav.execProcess('pIncidencias','',null,null,[{'key':'parametros','value':limpiarCadena(parametros)}],'current',false,$(this),function(ret){
		if(ret){
			var js = JSON.parse(limpiarCadena(ret.JSCode));   
			window["dvIncidencias"+modo.toUpperCase()] = "";
			for(var i in js){ 
				window["dvIncidencias"+modo.toUpperCase()] += "<div class='indiencia dvSub' "
							  +  "onclick='asignarIncidencia($(this).parent().attr(\"data-id\"),\""+js[i].codigo+" - "+js[i].nombre+"\")'>"
							  +  js[i].codigo+" - "+js[i].nombre
							  +  "</div>";
			}
		}else{ alert("Error SP: pIncidencias!!!"+JSON.stringify(ret)); }
	},false);
}
*/

function generarOptSelectClienteNuevo() {
    var fechas = $("#tdFechasTeleventa").text();
    var contenido = ``;
    let fechasTel = fechas.split("|");
    for (var i in fechasTel) {
        contenido += `<option value="${fechasTel[i]}">${fechasTel[i]}</option>`;
    }
    return contenido;
}

function anyadirCliente() {
    console.log(`anyadirCliente FechaTeleventa ${FechaTeleVenta} fechaCorta ${fechaCorta("","/")}`);
    $(".spanSelFechaClienteNuevo").remove();
    //if (new Date(fechaCambiaFormato(FechaTeleVenta)) < new Date(fechaCambiaFormato(fechaCorta()))) { alert("No se pueden asignar clientes a registros de días anteriores!"); return; }
    if (new Date(FechaTeleVenta) < new Date(fechaCorta())) { alert("No se pueden asignar clientes a registros de días anteriores!"); return; }
    var contenidoDvLlamadas = $("#dvLlamadas").html();
    var direccion = "";
    var opciones = "";
    var contenidoFechaAnadirCliente = ``;
    var fechas = $("#tdFechasTeleventa").text();
    if (fechas.includes("|")) {
        opciones = generarOptSelectClienteNuevo();
        contenidoFechaAnadirCliente = `
            <span style="font-size:15px;" class="spanSelFechaClienteNuevo">
               con fecha llamada: <select id="selFechaClienteNuevo" class="input-form">${opciones}</select>
            </span>
        `;
    } else {
        contenidoFechaAnadirCliente = ``;
    }

    $("#dvLlamadas").html("<div>" +
        "	<div class='div-agrup'><span style=`font-weight:bold; font-size:15px; `>Añadir Cliente al listado actual</span>" + contenidoFechaAnadirCliente + "</div>" +
        "	<input type='text' id='inpAnyadirCli' placeholder='buscar...' onkeyup='buscarEnCampos(this.id,\"dvAnyadirCli\")'>" +
        "	<div id='dvAnyadirCli' style='height:250px; overflow:hidden; overflow-y:auto;'><div class='taC vaM'>" + icoCargando16 + " cargando clientes...</div></div>" +
        "</div>");
    flexygo.nav.execProcess('pClientesBasic', '', null, null, [{ 'key': 'usuario', 'value': currentReference }, { 'key': 'rol', 'value': currentRole }], 'current', false, $(this), function(ret) {
        if (ret) {
            var contenido = "";
            var js = JSON.parse(limpiarCadena(ret.JSCode));
            if (js.clientes.length > 0) {
                for (var i in js.clientes) {
                    direccion = js.clientes[i].DIRECCION;
                    var telefonos = "";
                    for (var j in js.clientes[i].TELEFONOS) { telefonos += js.clientes[i].TELEFONOS[j].TELEFONO + " "; }
                    contenido += "<div class='dvSub' data-buscar='" + telefonos + " " + js.clientes[i].codigo + " " + js.clientes[i].nombre + " " + js.clientes[i].nComercial + " " + js.clientes[i].CIF + " " + direccion + "' " +
                        "onclick='dvAnyadirCli_Click(\"" + js.clientes[i].codigo + "\")'>" + js.clientes[i].codigo + " - " + js.clientes[i].nombre + " - " + direccion + "</div>";
                }
            } else { contenido = "<div style='text-align:center; color:red;'>Sin resultados!</div>"; }
            $("#dvAnyadirCli").html(contenido)
        } else { alert("Error SP: pClientesBasic!!!" + JSON.stringify(ret)); }
    }, false);
}

function dvAnyadirCli_Click(cliente) {
    var fechas = $("#tdFechasTeleventa").text();
    console.log(`dvAnyadirCli_Click cliente ${cliente} fechas ${fechas} fechaTeleventa ${FechaTeleVenta}`);
    var fechaLlamada = "";
    if (fechas.includes("|")) {
        fechaLlamada = $("#selFechaClienteNuevo").val();
    } else {
        fechaLlamada = FechaTeleVenta;
    }

    $("#dvLlamadas").html("<div class='taC vaM'>" + icoCargando16 + " añadiendo el cliente " + cliente + " al listado...</div>");
    var parametros = '{"modo":"anyadirCliente","IdTeleVenta":"' + IdTeleVenta + '","nombreTV":"' + NombreTeleVenta + '","FechaTeleVenta":"' + fechaLlamada + '"' +
        ',"cliente":"' + cliente + '",' + paramStd + '}';
    console.log(parametros);
    flexygo.nav.execProcess('pLlamadas', '', null, null, [{ 'key': 'parametros', 'value': limpiarCadena(parametros) }], 'current', false, $(this), function(ret) {
        if (ret) {
            if (ret.JSCode === "clienteExiste!") { alert("El cliente ya existe en la lista actual!"); }
            recargarTVLlamadas();
        } else { alert("Error SP: pLlamadas - dvAnyadirCli_Click!!!" + JSON.stringify(ret)); }
    }, false);
}

function verDireccionesDelCliente() {
    if (!$("#thDirEntrega").hasClass("modifDir")) { return; }
    $("#dvCliDir").stop().slideDown();
}

function asignarDireccionEntrega(direccion, linea) {
    $("#tdDirEntrega").text(direccion);
    $("#inpDirEntrega").val(linea);
    $("#thDirEntrega").removeClass("fadeIO");
    $("#tdDirEntrega").css("background", "#C5FFF7");
    $(document).click();
}

function cesta_Click(i) {
    var jsId = Date.now();
    var articulo = $("#tbArtDispTR" + i).find(".trBscCod").text();
    var nombre = $("#tbArtDispTR" + i).find(".trBscNom").text();
    var cajas = $("#inp_cajas_" + i).val();
    var unidades = $("#inp_uds_" + i).val();
    var peso = $("#inp_peso_" + i).val();
    var precio = $("#tbArtDispTR" + i).find(".inpPrecioSol").val();
    var dto = $("#tbArtDispTR" + i).find(".inpDtoSol").val();
    var importe = $("#tbArtDispTR" + i).find(".inpImporteSol").val();
    var stockVirtual = $("#tbArtDispTR" + i).find(".inpStockVirtual").text();
    var incidencia = $("#tbArtDispTR" + i).find(".trInciArt").val().split(" - ")[0];
    var incidenciaDescrip = $("#tbArtDispTR" + i).find(".trInciArt").val().split(" - ")[1];
    var observacion = $("#tbArtDispTR" + i).find(".trObservaArt").val().replace(/\n/g, "_MI_RETCARRO_MI_");
    var CosteResiduo = "";

    var cab_CLIENTE = ClienteCodigo;
    var cab_ENV_CLI = $("#inpDirEntrega").val();
    var cab_SERIE = $("#dvSerieTV").text();
    var cab_CONTACTO = ($.trim($("#inpDataContacto").val())).split(" - ")[0];
    var cab_INCICLI = $.trim(($("#inciCliente").val()).split(" - ")[0]);
    var cab_INCICLIDescrip = $.trim(($("#inciCliente").val()).split(" - ")[1]);
    var cab_ENTREGA = $.trim($("#inpFechaEntrega").val());
    var cab_VENDEDOR = elVendedor;
    var cab_NoCobrarPortes;
    var cab_VerificarPedido;
    var cab_OBSERVACIO = ($.trim($("#taObservacionesDelPedido").val())).replace(/<br>/g, "\r");

    var losDatos = "";
    var laLinea = [];

    if ($("#imgPedidoNoCobrarPortes").attr("src") === BtnDesO) { cab_NoCobrarPortes = 0; } else { cab_NoCobrarPortes = 1; }
    if ($("#imgVerificarPedido").attr("src") === BtnDesO) { cab_VerificarPedido = 0; } else { cab_VerificarPedido = 1; }

    if (isNaN(peso) || peso === "") { peso = 0; }
    if (isNaN(precio) || precio === "") { precio = 0; }
    if (isNaN(dto) || dto === "") { dto = 0; }
    if (isNaN(importe) || importe === "") { importe = 0; }
    if (isNaN(CosteResiduo) || CosteResiduo === "") { CosteResiduo = 0; }

    if (parseFloat(cajas) > 0 || parseFloat(unidades) > 0) {
        // comprobar Coste Residuo
        (function() {
            var parametros = '{"modo":"residuo","articulo":"' + articulo + '"}';
            flexygo.nav.execProcess('pArticulos', '', null, null, [{ 'Key': 'parametros', 'Value': limpiarCadena(parametros) }], 'current', false, $(this), function(ret) {
                if (ret) {
                    var residuo = JSON.parse(ret.JSCode);
                    var pImporte = parseFloat(residuo[0].P_IMPORTE);

                    if (residuo[0].PVERDE && parseInt(residuo[0].P_TAN) === 2) {
                        if (parseFloat(peso) > 0) { CosteResiduo = parseFloat(pImporte) * parseFloat(peso); } else { CosteResiduo = parseFloat(pImporte) * parseFloat(unidades); }
                    }

                    if (ClientePVerde) { CosteResiduo = 0; } //<---- ClientePVerde=true -> no cobrar coste residuos

                    losDatos = '{"jsId":"' + jsId + '","codigo":"' + articulo + '","nombre":"' + nombre + '","unidades":"' + unidades + '","peso":"' + peso + '","precio":"' + precio + '","dto":"' + dto + '"' +
                        ',"importe":"' + importe + '","CosteResiduo":"' + CosteResiduo + '","CosteResiduoArt":"' + articulo + '","artUnicaja":"' + cajas + '"' +
                        ',"incidencia":"' + incidencia + '","incidenciaDescrip":"' + incidenciaDescrip + '","observacion":"' + observacion + '"}';
                    PedidoDetalle.push(losDatos);
                    laLinea.push(losDatos);

                    // comprobar Impuesto Bebidas Azucaradas
                    var param = '{"modo":"bebidasAzucaradas","articulo":"' + articulo + '"}';
                    flexygo.nav.execProcess('pArticulos', '', null, null, [{ 'key': 'parametros', 'value': limpiarCadena(param) }], 'current', false, $(this), function(r) {
                        if (r) {
                            var esc = JSON.parse(r.JSCode);
                            if (esc.length > 0) {
                                for (var x = 0; x < esc.length; x++) {
                                    var escComponente = esc[x].COMPONENTE;
                                    if (escComponente === null) { continue; }
                                    var escUds = parseFloat(unidades) * parseFloat(esc[x].UNIDADES);
                                    var escPrecio = parseFloat(esc[x].PVP)
                                    var escImporte = escUds * escPrecio;
                                    var pImporte = parseFloat(esc[x].P_IMPORTE)

                                    if (isNaN(escImporte) || escImporte === "") { escImporte = 0; }

                                    losDatos = '{"jsId":"' + jsId + '","codigo":"' + escComponente + '","nombre":"' + nombre + '","unidades":"' + escUds + '","peso":"' + peso + '"' +
                                        ',"precio":"' + escPrecio + '","dto":"0","importe":"' + escImporte + '"' +
                                        ',"CosteResiduo":"' + CosteResiduo + '","CosteResiduoArt":"' + articulo + '","artUnicaja":"' + cajas + '","incidencia":"' + incidencia + '"' +
                                        ',"incidenciaDescrip":"' + incidenciaDescrip + '","observacion":"' + observacion + '"}';
                                    PedidoDetalle.push(losDatos);
                                    laLinea.push(losDatos);
                                }
                            }
                            // guardar línea en tabla temporal
                            var linea = JSON.stringify(laLinea);
                            var p1 = '{"lineas":[' + laLinea + '],"IdTeleVenta":"' + IdTeleVenta + '","IdTransaccion":"' + IdTransaccion + '"' +
                                ',"FechaTeleVenta":"' + FechaTeleVenta + '","nombreTV":"' + NombreTeleVenta + '","currentUserLogin":"' + currentUserLogin + '"' +
                                ',"currentUserId":"' + currentUserId + '","currentUserFullName":"' + currentUserFullName + '","currentReference":"' + currentReference + '"' +
                                ',"cab_CLIENTE":"' + cab_CLIENTE + '"' +
                                ',"cab_ENV_CLI":"' + cab_ENV_CLI + '"' +
                                ',"cab_SERIE":"' + cab_SERIE + '"' +
                                ',"cab_CONTACTO":"' + cab_CONTACTO + '"' +
                                ',"cab_INCICLI":"' + cab_INCICLI + '"' +
                                ',"cab_INCICLIDescrip":"' + cab_INCICLIDescrip + '"' +
                                ',"cab_ENTREGA":"' + cab_ENTREGA + '"' +
                                ',"cab_VENDEDOR":"' + cab_VENDEDOR + '"' +
                                ',"cab_NoCobrarPortes":"' + cab_NoCobrarPortes + '"' +
                                ',"cab_VerificarPedido":"' + cab_VerificarPedido + '"' +
                                ',"cab_OBSERVACIO":"' + cab_OBSERVACIO + '"' +
                                ',' + paramStd + '}';
                            flexygo.nav.execProcess('pPedido_Linea', '', null, null, [{ 'key': 'parametros', 'value': limpiarCadena(p1) }], 'current', false, $(this), function(r1) {
                                if (r1) {
                                    $("#tbArtDispTR" + i).find(".inpCajasSol").val("");
                                    $("#tbArtDispTR" + i).find(".inpCantSol").val("");
                                    $("#tbArtDispTR" + i).find(".inpPesoSol").val("");

                                    pedidoVerDetalle();
                                } else { alert("Error! - pPedido_Linea - guardar línea en tabla temporal: " + JSON.stringify(r1)); }
                            }, false);
                        } else { alert("Error! - pArticulos - impuestos: " + JSON.stringify(r)); }
                    }, false);
                } else { alert('Error SP pArticulos - residuos!' + JSON.stringify(ret)); }
            }, false);
        })();
    }
}

function PedidoAnyadirTodo() {
    var elId = "inp_uds";
    var elTb = "tbArtDispTR"
    $("#tbPersEP_Articulos").find("tr").each(function() {
        var trI = $(this).attr("data-i");
        // var elPeso = $(this).attr("data-peso");
        // var elPedUniCaja = $(this).attr("data-unicaja");
        // elId = elId + trI;
        // elTb = elTb + trI;
        // calcCUP("uds", elTb, elPedUniCaja, elPeso, true, trI, elId);
        var cantidad = $.trim($(this).find(".inpCantSol").val());
        if (parseFloat(cantidad) > 0) { cesta_Click(trI); }
    });
}



var ArticuloClienteBuscando = false;

function verDetallePedidoCliente(idpedido, empresa, letra, pedido, i) {
    if (ArticuloClienteBuscando) { return; }
    ArticuloClienteBuscando = true;
    dentroDelDiv = true;
    var contenido = icoCargando16 + " cargando lineas del pedido " + pedido + "...";
    abrirAVT(contenido);
    contenido = "<span style='font:bold 16px arial; color:#666;'>Datos del pedido " + pedido + "</span>" +
        "<br><br>" +
        "<div style='max-height:300px; overflow:hidden; overflow-y:auto;'>" +
        "	<table id='tbPedidosDetalle' class='tbStd'>" +
        "		<tr>" +
        "			<th>Artículo</th>" +
        "			<th>Descipción</th>" +
        "			<th class='C'>Cajas</th>" +
        "			<th class='C'>Uds.</th>" +
        "			<th class='C'>Peso</th>" +
        "			<th class='C'>Precio</th>" +
        "			<th class='C'>Dto</th>" +
        "			<th class='C'>Importe</th>" +
        "		</tr>";
    var parametros = '{"idpedido":"' + idpedido + '",' + paramStd + '}';
    flexygo.nav.execProcess('pPedidoDetalle', '', null, null, [{ 'key': 'parametros', 'value': limpiarCadena(parametros) }], 'modal640x480', false, $(this), function(ret) {
        if (ret) {
            var js = JSON.parse(limpiarCadena(ret.JSCode));
            if (js.length > 0) {
                for (var j in js) {
                    contenido += "<tr>" +
                        "		<td>" + js[j].ARTICULO + "</td>" +
                        "		<td>" + js[j].DEFINICION + "</td>" +
                        "		<td class='C'>" + js[j].cajas + "</td>" +
                        "		<td class='C'>" + js[j].UNIDADES + "</td>" +
                        "		<td class='C'>" + js[j].PESO + "</td>" +
                        "		<td class='C'>" + js[j].PRECIO + "</td>" +
                        "		<td class='C'>" + js[j].DTO1 + "</td>" +
                        "		<td class='R'>" + js[j].IMPORTEf + "</td>" +
                        "	</tr>";
                }
                contenido += "</table></div>";
            } else { contenido = "No se han obtenido resultados! <span class='flR' onclick='cerrarVelo()'>" + icoAspa + "</span>"; }
            abrirAVT(contenido, 800);
            ArticuloClienteBuscando = false;
            if (!dentroDelDiv) { cerrarAVT(); }
        } else { alert("Error SP: pPedidoDetalle!!!" + JSON.stringify(ret)); }
    }, false);
}

function asignarGestor(modo, gestor, n) {
    if (modo) {
        var CodCliente = $("#spanClienteCodigo").text();
        $("#btnrAsignarGestor").hide();
        $("#btnAsignarGestorAV").html(icoCargando16 + " asignando...").show();
        $("flx-module[modulename='usuariosTV']").stop().slideUp();
        var parametros = '{"modo":"' + modo + '","cliente":"' + CodCliente + '","gestor":"' + gestor + '","nGestor":"' + n + '",' + paramStd + '}';
        flexygo.nav.execProcess('pClienteDatos', '', null, null, [{ 'key': 'parametros', 'value': limpiarCadena(parametros) }], 'modal640x480', false, $(this), function(ret) {
            if (ret) {
                flexygo.nav.openPage('view', 'Cliente', 'CODIGO=\'' + CodCliente + '\'', '{\'CODIGO\':\'' + CodCliente + '\'}', 'current', false, $(this));
            } else { alert("Error SP: pClienteDatos!!!" + JSON.stringify(ret)); }
        }, false);
    } else { $("flx-module[modulename='usuariosTV']").css("margin-top", "-180px").stop().slideDown(); }
}


function Merlos_Inicio() {
    if ($("#mainNav").is(':visible')) {
        flexygo.nav.toggleNavBar();
    }
    //$("#miniButton, #mainNav").remove();
}


function cambiarEstadoLlamadaCliente(cliente, IdDoc) {
    abrirVelo(`
    ¿Desea cambiar el estado de la llamada?
    <br><br><br><span class='MIbotonGreen' onclick='cambiarEstadoLlamadaClienteProc("${cliente}","${IdDoc}")'>aceptar</span>
    &nbsp;&nbsp;&nbsp;<span class='MIbotonRed' onclick='cerrarVelo()'>cancelar</span>
`);

}

function cambiarEstadoLlamadaClienteProc(cliente, IdDoc) {
    var parametros = `{"sp":"pLlamadas_CambiarEstado","cliente":"${cliente}","IdTeleVenta":"${IdTeleVenta}","IdDoc":"${IdDoc}"}`;
    flexygo.nav.execProcess('pMerlos', '', null, null, [{ 'Key': 'parametros', 'Value': parametros }], 'current', false, $(this), function(ret) {
        if (ret) {
            cerrarVelo();
            cargarTeleVentaLlamadas("cargarLlamadas");

        } else { alert('Error SP pPedidoControl!' + JSON.stringify(ret)); }
    }, false);

}

function tieneFormatoCorrecto(cadena) {
    // La expresión regular busca:
    // ^       : inicio de la cadena
    // [a-zA-Z]{2} : dos caracteres alfabéticos
    // -       : un guion
    // \d+     : uno o más dígitos
    // $       : fin de la cadena
    const regex = /^[a-zA-Z]{2}-\d+$/;
    //const regex = /^[a-zA-Z]{2}-[a-zA-Z]+$/;
    //const regex = /^[a-zA-Z]{2} - [a-zA-Z]+$/;

    return regex.test(cadena);
}

var estPaginador = 0;
var clienteGlobal = "";

function verVentasArticulosAgrupados(cliente) {
    var fechaPrimeraAnyo = fechaCortaPrimeraAnyo("amd");
    var fechaUltimaAnyo = fechaCortaUltimaAnyo("amd");
    abrirVelo(`
        <div class="inp-fecha-agrup">
            <input type="date" placeholder="Desde" value="${fechaPrimeraAnyo}" id="inpFechaDesdeAgrup">
            <input type="date" placeholder="Hasta" value="${fechaUltimaAnyo}" id="inpFechaHastaAgrup">
        </div>
        <br>        
        <div id="divTbVentasAgrupadasArticulos" hidden>
            <div class="vaM" class="inv">
                <span id="spMostrando" ></span>
                <img src='./Merlos/images/irLeft.png'  width='20' style='margin-left:30px;' class='vaM inv' onclick='estPaginadorMM(false)'>
                <img src='./Merlos/images/irRight.png' width='20' style='margin-left:5px;'  class='vaM inv' onclick='estPaginadorMM(true)'>
            </div>
            <input type="text" id="inpTbVentasAgrupadasArticulos" placeholder="buscar" onkeyup="buscarEnTabla(this.id,'tbVentasAgrupadasArticulos')">
            <table class="tbStd" id="tbVentasAgrupadasArticulos">
                <tr class="stickyTr">
                    <th>Código</th>
                    <th>Nombre</th>
                    <th>Unidades</th>
                    <th>Últ precio</th>
                </tr>
            </table>
        </div>
        <div id="divNoDataAgrup" hidden>
            <span>¡No hay datos disponibles!</span>
        </div>
    <br><br><br><span class='MIbotonGreen' onclick='buscarDatosVentasAgrupadas("${cliente}");'>buscar datos</span>
    &nbsp;&nbsp;&nbsp;<span class='MIbotonRed' onclick='cerrarVelo()'>cancelar</span>
`);

}
var estResultados = 0;

function estPaginadorMM(n) {
    if (n) {
        estPaginador += 10;
    } else {
        estPaginador -= 10;
    }
    if (estPaginador < 0 || estPaginador >= estResultados) {
        estPaginador = 0;
    }
    var cliente = $("#spanIdClienteVentas").text();
    buscarDatosVentasAgrupadas(cliente);
}

function buscarDatosVentasAgrupadas(cliente) {
    var fechaDesde = $("#inpFechaDesdeAgrup").val();
    var fechaHasta = $("#inpFechaHastaAgrup").val();
    fechaDesde = fechaCambiaFormatoBarra(fechaDesde);
    fechaHasta = fechaCambiaFormatoBarra(fechaHasta);
    var contenido = ``;
    var parametros = `{"sp":"pDatosVentasArticulosAgrupados","cliente":"${cliente}","fechaDesde":"${fechaDesde}","fechaHasta":"${fechaHasta}","paginador":${estPaginador}}`;
    console.log(parametros);
    flexygo.nav.execProcess('pMerlos', '', null, null, [{ 'Key': 'parametros', 'Value': parametros }], 'current', false, $(this), function(ret) {
        if (ret) {
            var r = ret.JSCode;
            var js = JSON.parse(r);
            if (js.length > 0) {
                for (var i in js) {
                    contenido += `
                        <tr class="trArtAgrup " data-buscar="${js[i].articulo} ${js[i].DEFINICION} ${js[i].unidades} ${js[i].precio.toFixed(2)} ">
                            <td>${js[i].articulo}</td>
                            <td>${js[i].DEFINICION}</td>
                            <td>${js[i].unidades}</td>
                            <td>${js[i].precio.toFixed(2)}</td>
                        </tr>                    
                    `;
                }
                $(".trArtAgrup").remove();
                $("#tbVentasAgrupadasArticulos").append(contenido);
                $("#divTbVentasAgrupadasArticulos").show();
                var rslt = (estPaginador + 10);
                estResultados = js[0].registros;
                if (rslt > estResultados) {
                    rslt = estResultados;
                }
                // $("#spMostrando").text("mostrando registros del " + (estPaginador + 1) + " al " + rslt + " de " + js[0].registros + " resultados.");
                $("#divNoDataAgrup").hide();
            } else {
                $("#divTbVentasAgrupadasArticulos").hide();
                $("#divNoDataAgrup").show();
            }

        } else { alert('Error SP pPedidoControl!' + JSON.stringify(ret)); }
    }, false);
}


/*

MultiFecha


*/

function Llamada_Multiseleccion_Anyadir(f) {
    $("#inpLlamada_MultiseleccionValores").append(`
        <span class="fCont" style="border:1px solid #CCC; font:10px arial; padding:3px; margin-right:4px;">
            <i class="flx-icon icon-close-11" style="cursor:pointer;" onclick="Llamada_Multiseleccion_Quitar('${fechaFormato(f)}');"></i> 
            <span class="fVal">${fechaFormato(f)}</span>
        </span>
    `);
    //$("#inpProductividadMin , #inpProductividadMax").val("");
}


function Llamada_Multiseleccion_Quitar(f) {
    $("#inpLlamada_MultiseleccionValores .fCont").find(".fVal").each(function() { if ($(this).text() === f) { $(this).parent().remove(); } });
    //if (($("#inpLlamada_MultiseleccionValores").html()).replace(/\s+/g, '') === "") { $("#inpProductividadMin , #inpProductividadMax").val(fechaCorta(null, '-')); }
}

function crearVariableFechas() {
    var fechas = "";
    var valor = "";
    $("#inpLlamada_MultiseleccionValores .fCont").find(".fVal").each(function() {
        valor = fechaCambiaFormatoBarraTel($(this).text());
        fechas += `${valor}|`;
    });
    fechas = fechas.replace(/\|$/, "");
    $("#tdFechasTeleventa").text(fechas);
}

function printarVariableFechas(fechas) {
    let valores = fechas.split("|");
    borrarFechasMultiselect();
    for (let f of valores) {
        $("#inpLlamada_MultiseleccionValores").append(`
        <span class="fCont" style="border:1px solid #CCC; font:10px arial; padding:3px; margin-right:4px;">
            <i class="flx-icon icon-close-11" style="cursor:pointer;" onclick="Llamada_Multiseleccion_Quitar('${f}');"></i> 
            <span class="fVal">${f}</span>
        </span>
        `);
    }

}

/** TELEVENTA OPCIONES */
function guardarTeleVenta(tf) {
    var nombre = $.trim($("#inpNombreTV").val());
    crearVariableFechas();
    //var fecha = $.trim($("#inpLlamada_MultiseleccionValores").text());
    var fecha = $.trim($("#tdFechasTeleventa").text());
    if (nombre === "") {
        alert("El nombre para el registro de llamadas es obligatorio!");
        return;
    }
    if (fecha === "") {
        alert("La fecha es obligatoria!");
        return;
    }
    FechaTeleVenta = fecha;
    $("#dvFechaTV").html(fecha);
    cargarTbConfigOperador("guardar", tf);
}



function seriesTV() {
    var contenido = "";
    flexygo.nav.execProcess('pSeries', '', null, null, [{
        'Key': 'modo',
        'Value': 'Serie'
    }], 'modal640x480', false, $(this), function(ret) {
        if (ret) {
            var js = JSON.parse(ret.JSCode);
            if (js.length > 0) {
                for (var i in js) {
                    contenido += "<div class='dvLista' onclick='asignarSerieGlobal(\"" + js[i].codigo + "\")'>" + js[i].codigo + " - " + js[i].nombre + "</div>";
                }
            } else {
                contenido = "<div style='color:red;'>Sin resultados!</div>";
            }
            $("#dvSeriesListado").html(contenido).slideDown();
        } else {
            alert('Error S.P. pSeries!!!\n' + ret);
        }
    }, false);
}

function asignarSerieGlobal(laSerie) {
    SERIE = laSerie;
    $("#dvSerieTV").html(SERIE + dvSerieTvContenido);
    cerrarVelo();
}


function cargarTbConfigOperador(modo, comprobar) {
    // var fecha = $.trim($("#inpFechaTV").val());
    var fecha = $.trim($("#tdFechasTeleventa").text());
    //tdFechasTeleventa
    var nombre = $.trim($("#inpNombreTV").val());

    var elJS = '{"modo":"' + modo + '","IdTeleVenta":"' + IdTeleVenta + '","nombreTV":"' + nombre + '","fecha":"' + fecha + '",' + paramStd + '}';

    if (modo === "guardar" || modo === "recargar") {
        var objetos = ["Gestor", "Ruta", "Vendedor", "Serie", "Marca", "Familia", "Subfamilia"];
        for (var o in objetos) {
            var tr = "";
            $("#inputDatos" + objetos[o]).find("div").each(function() {
                tr += '{"' + objetos[o] + '":"' + ($(this).text()).split(" - ")[0] + '"}';
            });
            window["op" + objetos[o]] = '"' + objetos[o] + '":[' + tr.replace(/}{/g, "},{") + ']';
        }

        elJS = '{"modo":"' + modo + '","comprobar":"' + comprobar + '","IdTeleVenta":"' + IdTeleVenta + '","nombreTV":"' + nombre + '","fecha":"' + fecha + '"' +
            ',' + window["opGestor"] + ',' + window["opRuta"] + ',' + window["opVendedor"] + ',' + window["opSerie"] + ',' + window["opMarca"] + '' +
            ',' + window["opFamilia"] + ',' + window["opSubfamilia"] + ',' + paramStd + '}';
    }
    //Obtener Vendedor, Serie, Marca, Familia y Subfamilia
    flexygo.nav.execProcess('pOperadorConfig', '', null, null, [{'Key': 'elJS','Value': limpiarCadena(elJS)}], 'current', false, $(this), function(ret) {
        if (ret) {
            if (ret.JSCode === "nombreTV_Existe!") {
                alert("El nombre ya existe en la base de datos!");
                return;
            }

            var js = JSON.parse(limpiarCadena(ret.JSCode));
            SERIE = js.serieActiva;

            var gestores = "";
            for (var i in js.gestor) {
                gestores += "<div class='dvSub' onclick='inputTbDatosEliminar(\"Gestor\",\"" + js.gestor[i].gestor + "\")'>" + js.gestor[i].gestor + "</div>";
            }
            $("#inputDatosGestor").html(gestores);

            var rutas = "";
            for (var i in js.ruta) {
                rutas += "<div class='dvSub' onclick='inputTbDatosEliminar(\"Ruta\",\"" + js.ruta[i].ruta + "\")'>" + js.ruta[i].ruta + "</div>";
            }
            $("#inputDatosRuta").html(rutas);

            var vendedores = "";
            for (var i in js.vendedor) {
                vendedores += "<div class='dvSub' onclick='inputTbDatosEliminar(\"Vendedor\",\"" + js.vendedor[i].vendedor + "\")'>" + js.vendedor[i].vendedor + "</div>";
            }
            $("#inputDatosVendedor").html(vendedores);

            var series = "";
            for (var i in js.serie) {
                series += "<div class='dvSub' onclick='inputTbDatosEliminar(\"Serie\",\"" + js.serie[i].serie + "\")'>" + js.serie[i].serie + "</div>";
            }
            $("#inputDatosSerie").html(series);

            var marcas = "";
            for (var i in js.marca) {
                marcas += "<div class='dvSub' onclick='inputTbDatosEliminar(\"Marca\",\"" + js.marca[i].marca + "\")'>" + js.marca[i].marca + "</div>";
            }
            $("#inputDatosMarca").html(marcas);

            var familias = "";
            for (var i in js.familia) {
                familias += "<div class='dvSub' onclick='inputTbDatosEliminar(\"Familia\",\"" + js.familia[i].familia + "\")'>" + js.familia[i].familia + "</div>";
            }
            $("#inputDatosFamilia").html(familias);

            var subfamilias = "";
            for (var i in js.subfamilia) {
                subfamilias += "<div class='dvSub' onclick='inputTbDatosEliminar(\"Subfamilia\",\"" + js.subfamilia[i].subfamilia + "\")'>" + js.subfamilia[i].subfamilia + "</div>";
            }
            $("#inputDatosSubfamilia").html(subfamilias);

            if (modo === "guardar") {
                cargarTeleVentaLlamadas("listaGlobal");
                if (js.llamUserReg === "0") {
                    $("#inpNombreTV, #inpFechaTV").val("");
                    borrarFechasMultiselect();
                    alert("No se han encontrado llamadas con los parámetros seleccionados!");
                }
            }
            if (modo === "recargar") {
                recargarTVLlamadas();
            }
        } else {
            alert('Error S.P. pOperadorConfig!\n' + JSON.stringify(ret));
        }
    }, false);
}

function borrarFechasMultiselect() {
    $("#inpLlamada_MultiseleccionValores .fCont").find(".fVal").each(function() { $(this).parent().remove(); });
}

function inputTbDatos(id) {
    if (id === "Fecha" || id === "Nombre" || id === "") {
        return;
    }
    $("#dvinputDatosTemp").remove();
    $("body").prepend("<div id='dvinputDatosTemp' class='dvTemp'>" + icoCargando16 + "cargando datos...</div>");
    var y = ($("#inputDatos" + id).offset()).top;
    var x = ($("#inputDatos" + id).offset()).left;
    $("#dvinputDatosTemp").offset({
        top: y,
        left: x
    }).stop().fadeIn();

    var contenido = "";
    var modo = id.toLowerCase().replace(" ", "_").normalize("NFD").replace(/[\u0300-\u036f]/g, "");
    var elJS = '{"modo":"' + modo + '",' + paramStd + '}';

    flexygo.nav.execProcess('pInpDatos', '', null, null, [{
        'Key': 'elJS',
        'Value': limpiarCadena(elJS)
    }], 'modal640x480', false, $(this), function(ret) {
        if (ret) {
            var js = JSON.parse(limpiarCadena(ret.JSCode));
            if (js.length > 0) {
                for (var i in js) {
                    contenido += "<div class='dvLista' onclick='inputTbDatosAsignar(\"" + id + "\",\"" + js[i].codigo + " - " + $.trim(js[i].nombre) + "\")'>" +
                        js[i].codigo + " - " + js[i].nombre +
                        "</div>";
                }
            } else {
                contenido = "<div style='color:red;'>Sin resultados!</div>";
            }
            $("#dvinputDatosTemp").html(contenido);
        } else {
            alert('Error S.P. pInpDatos!\n' + JSON.stringify(ret));
        }
    }, false);
}

function inputTbDatosAsignar(id, valor) {
    if (($("#inputDatos" + id).html()).indexOf(valor) === -1) {
        var htmlVal = $("#inputDatos" + id).html();
        if (id === "Serie") {
            htmlVal = "";
        }
        $("#inputDatos" + id).html(htmlVal + "<div class='dvSub' onclick='inputTbDatosEliminar(\"" + id + "\",\"" + valor + "\")'>" + valor + "</div>");
        if ($.trim($("#inpNombreTV").val()) === "") {
            autoNombreTV = true;
        }
        if (autoNombreTV) {
            $("#inpNombreTV").val(($("#inpNombreTV").val()).replace("+" + id, "").replace(id, "") + "+" + id);
            var elNom = $("#inpNombreTV").val();
            if (Left(elNom, 1) === "+") {
                $("#inpNombreTV").val(elNom.replace("+", ""));
            }
        }
    }
    $("#dvinputDatosTemp").fadeOut(300, function() {
        $("#dvinputDatosTemp").remove();
    });
}

function inputTbDatosEliminar(id, valor) {
    var contenido = "";
    $("#inputDatos" + id).find("div").each(function() {
        if ($(this).text() !== valor) {
            contenido += "<div class='dvSub' onclick='inputTbDatosEliminar(\"" + id + "\",\"" + $(this).text() + "\")'>" + $(this).text() + "</div>";
        }
    });
    $("#inputDatos" + id).html(contenido);
    if (autoNombreTV && contenido === "") {
        $("#inpNombreTV").val(($("#inpNombreTV").val()).replace("+" + id, "").replace(id, ""));
    }
    if (Left($("#inpNombreTV").val(), 1) === "+") {
        $("#inpNombreTV").val(($("#inpNombreTV").val()).replace("+", ""));
    }
}




/*LISTADOS*/

function convertirAFecha(fechaString) {
    const [dia, mes, ano] = fechaString.split('/').map(Number);
    return new Date(ano, mes - 1, dia);
}

function fechaDentroDelRango(fechaDesde, fechaHasta, fechaNormal) {
    var desde = convertirAFecha(fechaDesde);
    var hasta = convertirAFecha(fechaHasta);
    var normal = convertirAFecha(fechaNormal);
    return normal >= desde && normal <= hasta;
}

function fechasDentroDelRangoT(fecha1, fecha2, fecha3, fecha4) {
    var inicioRango = convertirAFecha(fecha1);
    var finRango = convertirAFecha(fecha2);
    var fechaAComprobar1 = convertirAFecha(fecha3);
    var fechaAComprobar2 = convertirAFecha(fecha4);

    return (fechaAComprobar1 >= inicioRango && fechaAComprobar1 <= finRango) &&
        (fechaAComprobar2 >= inicioRango && fechaAComprobar2 <= finRango);
}

function algunaFechaDentroDelRango(fechaDesde, fechaHasta, fechas) {
    var desde = convertirAFecha(fechaDesde);
    var hasta = convertirAFecha(fechaHasta);
    let fechasArray = fechas.split('|');
    for (let fecha of fechasArray) {
        var fechaConvertida = convertirAFecha(fecha);
        if (fechaConvertida >= desde && fechaConvertida <= hasta) {
            return true;
        }
    }

    return false;
}

function listadosLlamadasRegBuscarEntreFechas() {
    var fechaDesde = $("#ListadoLlamadasDesdeReg").val();
    var fechaHasta = $("#ListadosLlamadasHastaReg").val();
    fechaDesde = fechaCambiaFormatoBarra(fechaDesde);
    fechaHasta = fechaCambiaFormatoBarra(fechaHasta);
    var fechaDentroDelRangoT = false;
    $("#tbListadosTV").find(".trListadosTV").each(function() {
        fechaDentroDelRangoT = false;
        var contenido = $.trim($(this).attr("data-buscar")).toLowerCase();
        if (contenido.includes("|")) {
            fechaDentroDelRangoT = algunaFechaDentroDelRango(fechaDesde, fechaHasta, contenido);
        } else {
            if (contenido.includes("-")) {
                contenido = fechaCambiaFormatoBarraTel(contenido);
            }
            fechaDentroDelRangoT = fechaDentroDelRango(fechaDesde, fechaHasta, contenido);
        }
        if (!fechaDentroDelRangoT) {
            $(this).addClass("inv");
        } else {
            $(this).removeClass("inv");
        }
        //if (contenido.indexOf(buscar) !== -1) { $(this).removeClass("inv"); } else { $(this).addClass("inv"); }
    });

}

function listadosLlamadasBuscarEntreFechas() {
    var fechaDesde = $("#ListadoLlamadasDesde").val();
    var fechaHasta = $("#ListadosLlamadasHasta").val();
    var fechaDesdeT = "";
    var fechaHastaT = "";
    fechaDesde = fechaCambiaFormatoBarra(fechaDesde);
    fechaHasta = fechaCambiaFormatoBarra(fechaHasta);
    var fechaDentroDelRangoT = false;
    $("#tbListadosListado").find(".trListadosTV").each(function() {
        fechaDentroDelRangoT = false;
        fechaDesdeT = $(this).find(".fechaDesdeListadosListado").text();
        fechaHastaT = $(this).find(".fechaHastaListadosListado").text();
        fechaDentroDelRangoT = fechasDentroDelRangoT(fechaDesde, fechaHasta, fechaDesdeT, fechaHastaT);
        if (!fechaDentroDelRangoT) {
            $(this).addClass("inv");
        } else {
            $(this).removeClass("inv");
        }
        //if (contenido.indexOf(buscar) !== -1) { $(this).removeClass("inv"); } else { $(this).addClass("inv"); }
    });

}

function ponerFechasListados() {
    var fechaDeHoy = fechaDeHoyFormat("amd");
    var fechaSemana = fechaDeAquiSemanaFormat("amd");
    $(".inpFechaDesdeListados").val(fechaDeHoy);
    $(".inpFechaHastaListados").val(fechaSemana);

}

function cargarListadoTV() {
    // var parametros = '{"sp":"pListados","modo":"cargarListadoTV",' + paramStd + '}';
    // flexygo.nav.execProcess('pMerlos', '', null, null, [{
    //     'Key': 'parametros',
    //     'Value': limpiarCadena(parametros)
    // }], 'current', false, $(this), function(ret) {
    //     if (ret) {
    //         ponerFechasListados();
    //         var js = JSON.parse(limpiarCadena(ret.JSCode));
    //         var contenido = `
    //     <table id="tbListadosTV" class="tbStd">
    //         <tr>
    //             <th>Gestor</th>
    //             <th>Fecha</th>
    //             <th>Nombre</th>
    //             <th class="taC">Clientes</th>
    //             <th class="taC">Llamadas</th>
    //             <th class="taC">Pedidos</th>
    //             <th class="taC">SubTotal</th>
    //             <th class="taC">Importe</th>
    //         </tr>
    // `;
    //         if (js.length > 0) {
    //             for (var i in js) {
    //                 contenido += `
    //             <tr class="trListadosTV" onclick="exportarListado('` + js[i].id + `')" data-buscar="${js[i].fecha}" data-linea="${i}">
    //                 <td>` + js[i].usuario + `</td>
    //                 <td>` + js[i].fecha + `</td>
    //                 <td>` + js[i].nombre + `</td>
    //                 <td class="taR">` + js[i].clientes + `</td>
    //                 <td class="taR">` + js[i].llamadas + `</td>
    //                 <td class="taR">` + js[i].pedidos + `</td>
    //                 <td class="taR">` + new Intl.NumberFormat('de-DE', {
    //                     style: 'currency',
    //                     currency: 'EUR',
    //                     minimumFractionDigits: 2
    //                 }).format(parseFloat(js[i].subtotal)) + `</td>
    //                 <td class="taR">` + new Intl.NumberFormat('de-DE', {
    //                     style: 'currency',
    //                     currency: 'EUR',
    //                     minimumFractionDigits: 2
    //                 }).format(parseFloat(js[i].importe)) + `</td>
    //             </tr>
    //         `
    //             }
    //             contenido += "</table>";
    //         } else {
    //             contenido = "Sin resultados!";
    //         }
    //         $("#dvListadosTVListado").html(contenido);
    //     } else {
    //         alert('Error SP pListados - cargarListadoTV!' + JSON.stringify(ret));
    //     }
    // }, false);
}


function exportarListado(id) {
    // $(".ListadoSeccion").hide();
    // $("#dvRegistrosTV, #dvBtnImp").show();
    flexygo.nav.openPage('list', 'ExportarListadosTV', 'id=\'' + id + '\'', '{\'id\':\'' + id + '\'}', 'current', false, $(this));


    // var parametros = '{"sp":"pListados","modo":"exportarListado","id":"' + id + '",' + paramStd + '}';
    // flexygo.nav.execProcess('pMerlos', '', null, null, [{
    //     'Key': 'parametros',
    //     'Value': limpiarCadena(parametros)
    // }], 'current', false, $(this), function(ret) {
    //     if (ret) {
    //         var js = JSON.parse(limpiarCadena(ret.JSCode));
    //         var contenido = `
    //     <table id="tbListadosTV" class="tbStd">
    //         <tr>
    //             <th>Cód. Cliente</th>
    //             <th>Nombre</th>
    //             <th class="taC">Teléfono</th>
    //             <th class="taC">Horario</th>
    //             <th class="taC">Pedido</th>
    //             <th class="taC">Serie</th>
    //             <th class="taC">SubTotal</th>
    //             <th class="taC">Importe</th>
    //             <th class="taC">Completado</th>
    //         </tr>
    // `;
    //         if (js.length > 0) {
    //             for (var i in js) {
    //                 contenido += `
    //             <tr>
    //                 <td>` + js[i].cliente + `</td>
    //                 <td>` + js[i].vc[0].RCOMERCIAL + `</td>
    //                 <td class="taC">` + js[i].vc[0].TELEFONO + `</td>
    //                 <td class="taC">` + js[i].horario + `</td>
    //                 <td class="taR">` + js[i].pedido + `</td>
    //                 <td class="taC">` + js[i].serie + `</td>
    //                 <td class="taR">` + new Intl.NumberFormat('de-DE', {
    //                     style: 'currency',
    //                     currency: 'EUR',
    //                     minimumFractionDigits: 2
    //                 }).format(parseFloat(js[i].subtotal)) + `</td>
    //                 <td class="taR">` + new Intl.NumberFormat('de-DE', {
    //                     style: 'currency',
    //                     currency: 'EUR',
    //                     minimumFractionDigits: 2
    //                 }).format(parseFloat(js[i].importe)) + `</td>
    //                 <td class="taC">` + js[i].completado + `</td>
    //             </tr>
    //         `
    //             }
    //             contenido += "</table>";
    //         } else {
    //             contenido = "Sin resultados!";
    //         }
    //         $("#dvListadosTVListado").html(contenido);
    // $(".ListadoSeccion").hide();
    // $("#dvRegistrosTV, #dvBtnImp").show();
    //     } else {
    //         alert('Error SP pListados - exportarListado - id: ' + id + '!\n' + JSON.stringify(ret));
    //     }
    // }, false);
}

function ListadosVolver() {
    flexygo.nav.openPageName('TV_Listados', '', '', null, 'current', false, $(this));
}

function ListadosVolverExportTV() {
    flexygo.nav.openPage('list', 'ListadosVentas', '', null, 'current', false, $(this));
}

function listadosGestores() {
    var parametros = '{"sp":"pListadosGestores","modo":"dameGestores",' + paramStd + '}';
    flexygo.nav.execProcess('pMerlos', '', null, null, [{
        'Key': 'parametros',
        'Value': limpiarCadena(parametros)
    }], 'current', false, $(this), function(ret) {
        if (ret) {
            var contenido = "";
            var js = JSON.parse(ret.JSCode);
            if (js.length > 0) {
                for (var i in js) {
                    contenido += "<div class='dvSub' onclick='ListadosSeleccionarGestor(\"" + js[i].CODIGO + "\",\"" + js[i].NOMBRE + "\")'>" + js[i].CODIGO + " - " + js[i].NOMBRE + "</div>";
                }
            } else {
                contenido = "<div style='text-align:center; font:16px arial; color:red;'>Sin registros!</div>";
            }
            $("#dvListadoGestores").html(contenido).slideDown();
        } else {
            alert('Error SP pListados - exportarListado - id: ' + id + '!\n' + JSON.stringify(ret));
        }
    }, false);
}

function ListadosSeleccionarGestor(codigo, nombre) {
    aListadosGestores.push('{"codigo":"' + codigo + '","nombre":"' + nombre + '"}');
    ListadosDivGestores();
}

function ListadosDivGestores() {
    var contenido = "";
    for (var i in aListadosGestores) {
        var js = JSON.parse(aListadosGestores[i]);
        contenido += "<div class='dvSub' onclick='ListadosEliminarGestor(\"" + js.codigo + "\")'>" + js.codigo + " - " + js.nombre + "</div>";
    }
    $("#dvListadoTDGestores").html(contenido);
    $(document).click();
}

function ListadosEliminarGestor(codigo) {
    console.log("ListadosEliminarGestor(" + codigo + ")");
}

function ListadosComprobarFechas() {
    var ListadosFDesde = $.trim($("#ListadosDesde").val());
    var ListadosFHasta = $.trim($("#ListadosHasta").val());
    if (ListadosFHasta === "") {
        ListadosFHasta = ListadosFDesde;
    }
    $("#ListadosDesde").val(fechaFormato(ListadosFDesde));
    $("#ListadosHasta").val(fechaFormato(ListadosFHasta));
}
var aListadosGestores = [];

function ListadosGenerar() {
    var NombreListado = $.trim($("#inpNombreListado").val());
    var ListadosFDesde = $.trim($("#ListadosDesde").val());
    var ListadosFHasta = $.trim($("#ListadosHasta").val());

    if (NombreListado === "") {
        abrirVelo("No se ha indicado un nombre para el registro!", null, null, 1);
        return;
    }
    if (aListadosGestores.length === 0) {
        abrirVelo("No se han seleccionado Gestores!", null, null, 1);
        return;
    }
    if (ListadosFDesde === "") {
        abrirVelo("No se ha indicado la fecha de origen!", null, null, 1);
        return;
    }
    if (ListadosFHasta === "") {
        abrirVelo("No se ha indicado la fecha de destino!", null, null, 1);
        return;
    }

    var parametros = '{"sp":"pListadosGestores","modo":"dameListado","NombreListado":"' + NombreListado + '","losGestores":[' + aListadosGestores + '],"ListadosFDesde":"' + ListadosFDesde + '","ListadosFHasta":"' + ListadosFHasta + '",' + paramStd + '}';
    flexygo.nav.execProcess('pMerlos', '', null, null, [{
        'Key': 'parametros',
        'Value': limpiarCadena(parametros)
    }], 'current', false, $(this), function(ret) {
        if (ret) {
            cargarListadosListado();
            resetFrmListados();
        } else {
            alert('Error SP pListados - exportarListado - id: ' + id + '!\n' + JSON.stringify(ret));
        }
    }, false);
}

function cargarListadosListado() {
    $("flx-module[modulename='MI_ListadosLlamadas']").find(".icon-sincronize").click();
    //var parametros = '{"sp":"pListados","modo":"cargarListados",' + paramStd + '}';
    //flexygo.nav.execProcess('pMerlos', '', null, null, [{
    //    'Key': 'parametros',
    //    'Value': limpiarCadena(parametros)
    //}], 'current', false, $(this), function(ret) {
    //    if (ret) {
    //        var js = JSON.parse(limpiarCadena(ret.JSCode));
    //        var contenido = `
    //    <table id="tbListadosListado" class="tbStd">
    //        <tr>
    //            <th>Nombre</th>
    //            <th>Cliente</th>
    //            <th>Gestor</th>
    //            <th class="taC">Desde</th>
    //            <th class="taC">Hasta</th>
    //            <th>Hora</th>
    //        </tr>
    //`;
    //        if (js.length > 0) {
    //            for (var i in js) {
    //                contenido += `
    //            <tr class="trListadosListado" onclick="imprimirListado('` + js[i].id + `')" data-buscar="${js[i].fecha}  ${IsNull(js[i].hasta, "")}">						
    //                <td>` + js[i].nombreListado + `</td>
    //                <td>` + js[i].cliente + `</td>
    //                <td>` + IsNull(js[i].gestor, "") + `</td>
    //                <td class="taC fechaDesdeListadosListado">` + js[i].fecha + `</td>
    //                <td class="taC fechaHastaListadosListado">` + IsNull(js[i].hasta, "") + `</td>
    //                <td>` + js[i].horario + `</td>
    //            </tr>
    //        `
    //            }
    //            contenido += "</table>";
    //        } else {
    //            contenido = "Sin resultados!";
    //        }
    //        $("#dvListadosListado").html(contenido);
    //    } else {
    //        alert('Error SP pListados - cargarListados!' + JSON.stringify(ret));
    //    }
    //}, false);
}

function resetFrmListados() {
    $("#inpNombreListado, #ListadosDesde, #ListadosHasta").val("");
    $("#dvListadoTDGestores").html("");
}

function imprimirListado(id) {
    flexygo.nav.openPage('list', 'ListadosLlamadasImprimir', 'id=\'' + id + '\'', '{\'id\':\'' + id + '\'}', 'current', false, $(this));
    // var parametros = '{"sp":"pListados","modo":"imprimirListado","id":"' + id + '",' + paramStd + '}';
    // flexygo.nav.execProcess('pMerlos', '', null, null, [{
    //     'Key': 'parametros',
    //     'Value': limpiarCadena(parametros)
    // }], 'current', false, $(this), function(ret) {
    //     if (ret) {
    //         var js = JSON.parse(limpiarCadena(ret.JSCode));
    //         var contenido = `
    //     <table id="tbListadosTV" class="tbStd">
    //         <tr>
    //             <th>Cód. Cliente</th>
    //             <th>Cliente</th>
    //             <th>Población</th>
    //             <th class="taC">Fecha</th>
    //             <th class="taC">Horario</th>
    //         </tr>
    // `;
    //         if (js.length > 0) {
    //             for (var i in js) {
    //                 contenido += `
    //             <tr>
    //                 <td>` + $.trim(js[i].cliente) + `</td>
    //                 <td>` + $.trim(js[i].vc[0].nombre) + `</td>
    //                 <td>` + $.trim(js[i].vc[0].poblacion) + `</td>
    //                 <td class="taC" style="white-space: nowrap;">` + $.trim(js[i].fecha) + `</td>
    //                 <td class="taC" style="white-space: nowrap;">` + $.trim(js[i].horario) + `</td>
    //             </tr>
    //         `
    //             }
    //             contenido += "</table>";
    //         } else {
    //             contenido = "Sin resultados!";
    //         }
    //         $("#dvListadosListado").html(contenido);
    //         $(".ListadoSeccion").hide();
    //         $("#dvListadosSeccion, #dvBtnImp").show();
    //     } else {
    //         alert('Error SP pListados - imprimirListado - id: ' + id + '!\n' + JSON.stringify(ret));
    //     }
    // }, false);
}

/*
function verDetallePedidoCliente(idpedido, empresa, letra, numero, i) {
    var pedido = letra + "-" + numero.trim();
    var contenido = icoCargando16 + " cargando lineas del pedido " + pedido + "...";
    abrirVelo(contenido);
    contenido = "<span style='font:bold 16px arial; color:#666;'>Datos del pedido " + pedido + "</span>"
        + "<span class='flR' onclick='cerrarVelo()'>" + icoAspa +"</span>"
        + "<br><br>"
        + "<table id='tbPedidosDetalle' class='tbStd'>"
        + "	<tr>"
        + "		<th>Artículo</th>"
        + "		<th>Descipción</th>"
        + "		<th class='C'>Cajas</th>"
        + "		<th class='C'>Uds.</th>"
        + "		<th class='C'>Peso</th>"
        + "		<th class='C'>Precio</th>"
        + "		<th class='C'>Dto</th>"
        + "		<th class='C'>Importe</th>"
        + "	</tr>";
    var parametros = '{"idpedido":"' + idpedido + '",' + paramStd + '}';
    flexygo.nav.execProcess('pPedidoDetalle', '', null, null, [{ 'key': 'parametros', 'value': limpiarCadena(parametros) }], 'modal640x480', false, $(this), function (ret) {
        if (ret) {
            var js = JSON.parse(limpiarCadena(ret.JSCode));
            if (js.length > 0) {
                for (var j in js) {
                    contenido += "<tr>"
                        + "		<td>" + js[j].ARTICULO + "</td>"
                        + "		<td>" + js[j].DEFINICION + "</td>"
                        + "		<td class='C'>" + js[j].cajas + "</td>"
                        + "		<td class='C'>" + js[j].UNIDADES + "</td>"
                        + "		<td class='C'>" + js[j].PESO + "</td>"
                        + "		<td class='C'>" + js[j].PRECIO + "</td>"
                        + "		<td class='C'>" + js[j].DTO1 + "</td>"
                        + "		<td class='R'>" + js[j].IMPORTEf + "</td>"
                        + "	</tr>";
                }
                contenido += "</table>";
            } else { contenido = "No se han obtenido resultados! <span class='flR' onclick='cerrarVelo()'>" + icoAspa + "</span>"; }
            abrirVelo(contenido,800);
        } else { alert("Error SP: pPedidoDetalle!!!" + JSON.stringify(ret)); }
    }, false);
}*/


var inpFechaTV = "";
var dvSerieTvContenido = `
		&nbsp;<span id="btnSerieGlobal" class="img20 icoDownC" style="vertical-align:middle;" onclick="seriesTV()"></span>
		<div id="dvSeriesListado" style="z-index: 2; position: absolute; padding: 10px; background: #FFF; box-shadow: 2px 2px 4px rgba(0, 0, 0, 0.2); display:none;"></div>
    `;

function initMultifechaOpciones() {
    console.log(`initMultiFechaOpciones FechaTeleVenta ${FechaTeleVenta}`)

    FechaTeleVenta = "";
    IdTeleVenta = "";
    ClienteCodigo = "";
    if (FechaTeleVenta !== "") {
        $("#inpFechaTV").val(FechaTeleVenta);
        $("#dvFechaTV").html(FechaTeleVenta).show();
    } else {
        $("#dvFechaTV").hide();
    }
    $("#dvSerieTV").html(SERIE + dvSerieTvContenido);

    $("#tbConfiguracionOperador th").on("click", function() {
        inputTbDatos(($(this).text()).split(" ")[0]);
        event.stopPropagation();
    });
    inpFechaTV = flatpickr("#inpFechaTV", {
        dateFormat: "d/m/Y", // Formato de fecha       
        mode: "multiple", // Permite seleccionar múltiples fechas
        locale: "es",
        firstDayOfWeek: 1
    });
}

function fechasMultifechaOpciones() {
    console.log(inpFechaTV.selectedDates);
    var datesArray = inpFechaTV.selectedDates;
    var fechasFormateadas = datesArray.map(date => {
        const day = String(date.getDate()).padStart(2, '0');
        const month = String(date.getMonth() + 1).padStart(2, '0'); // Los meses van de 0 a 11, por lo que añadimos 1.
        const year = date.getFullYear();

        return `${day}/${month}/${year}`;
    });
    console.log(fechasFormateadas);
    var variableFechas = "";
    if (fechasFormateadas.length > 1) {
        variableFechas = fechasFormateadas.join("|");
        printarVariableFechas(variableFechas);
    } else {
        borrarFechasMultiselect();
        if (fechasFormateadas.length > 0) {
            Llamada_Multiseleccion_Anyadir(fechasFormateadas[0]);
        }
    }

}

var CliArtMasivo_Articulos = [];
var CliArtMasivo_Clientes = [];
var ArticulosMasivoBuscador = `
    <input type="text" id="CliArt_inpArtBuscador" placeholder="buscar"
    style="width:100%; padding:5px; box-sizing:border-box; outline:none; border:none; background:#EBFCFF;"
    onkeyup="buscarEnGrid(this.id,'CliArtMasivo_dvListaDeArticulos'); CliArt_inpArtBuscador_KeyUp(this)">
`;
var ClientesMasivoBuscador = `
    <input type="text" id="CliArt_inpCliBuscador" placeholder="buscar"
    style="width:100%; padding:5px; box-sizing:border-box; outline:none; border:none; background:#EBFCFF;"
    onkeyup="buscarEnGrid(this.id,'CliArtMasivo_dvListaDeClientes')">
`;

function cargarArticulosMasivo(articulo) {
    $("#CliArtMasivo_dvArticulos").html(`${icoCarga} cargando artículos...`);

    var contenido = "";
    var parametros = { "articulo": articulo, "jsUser": jsUser };
    flexygo.nav.execProcess('pPers_ArtCliMasivo_Articulos', '', null, null, [{ key: 'parametros', value: JSON.stringify(parametros) }], 'current', false, $(this), function(ret) {
        if (ret) {
            var datos = "";
            var js = JSON.parse(ret.JSCode);
            if (js.error === "") {
                jsr = js.respuesta;
                if (jsr.length > 0) {
                    contenido = `
                        ${ArticulosMasivoBuscador}
                        <div style="margin-top:10px; display:grid; grid-template-columns: 2fr 10fr 1fr 1fr 1fr; gap:1px; border-bottom:1px solid #CCC;">
                            <div style="padding:5px; background:#999; font:16px arial; color:#FFF;">Artículo</div>
                            <div style="padding:5px; background:#999; font:16px arial; color:#FFF;">Descripción</div>
                            <div style="padding:5px; background:#999; font:12px arial; color:#FFF; text-align:center;">Incluir</div>
                            <div style="padding:5px; background:#999; font:12px arial; color:#FFF; text-align:center;">Excluir</div>
                            <div style="padding:5px; background:#999; font:12px arial; color:yellow; text-align:center;">Eliminar</div>
                        </div>
                        <div id="CliArtMasivo_dvListaDeArticulos" style="border-bottom:2px solid #CCC; max-height:300px; overflow:hidden; overflow-y:auto;">
                    `;
                    for (var i in jsr) {
                        var incluir_Ckeck = icoCheckO;
                        var excluir_Ckeck = icoCheckO;
                        if (jsr[i].IncluirExcluir === 1) { incluir_Ckeck = icoCheckI; }
                        if (jsr[i].IncluirExcluir === 2) { excluir_Ckeck = icoCheckI; }

                        contenido += `
                            <div class="dvMasivo buscarEnGridTR" style="display:grid; grid-template-columns: 2fr 10fr 1fr 1fr 1fr; gap:1px;"
                            data-buscar="${jsr[i].CODIGO.trim()} ${jsr[i].NOMBRE.trim()}">
                                <div class="codigo" style="padding:4px;">${jsr[i].CODIGO.trim()}</div>
                                <div style="padding:4px;">${jsr[i].NOMBRE.trim()}</div>
                                <div class="incluir" style="padding:4px; text-align:center;" onclick="CliArtMasivo_IncluirExcluir(this)">${incluir_Ckeck}</div>
                                <div class="excluir" style="padding:4px; text-align:center;" onclick="CliArtMasivo_IncluirExcluir(this)">${excluir_Ckeck}</div>
                                <div class="eliminar" style="padding:4px; text-align:center;" onclick="CliArtMasivo_IncluirExcluir(this)">${excluir_Ckeck}</div>
                            </div>
                        `;
                    }
                    contenido += "</div>";
                } else { contenido = `${ArticulosMasivoBuscador}<br><br>Sin resultados!`; }
            } else { contenido = js.error; }
            $("#CliArtMasivo_dvArticulos").html(contenido);
        }
    }, false);
}


function CliArt_inpArtBuscador_KeyUp(elemento) {
    var buscar = $.trim($(elemento).val());
    if (event.key === "Enter") {
        cargarArticulosMasivo(buscar);
    }
}

function CliArt_inpCliBuscador_KeyUp(elemento) {
    var buscar = $.trim($(elemento).val());
    if (event.key === "Enter") {
        cargarClientesMasivo(buscar);
    }
}