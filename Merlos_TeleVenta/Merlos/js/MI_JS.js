/* 
	*************************
		   Variables
	************************* 
*/
var currentRole = flexygo.context.currentRole;
var currentRoleId = flexygo.context.currentRoleId;
var currentReference = flexygo.context.currentReference;
var currentUserLogin = flexygo.context.currentUserLogin;
var currentUserId = flexygo.context.currentUserId;
var currentUserFullName = flexygo.context.currentUserFullName;
var currentSubreference = flexygo.context.currentSubreference;
var EWtrabajaPeso = flexygo.context.EWtrabajaPeso;
var UsuariosTV = flexygo.context.usuariosTV;
var CodigoEmpresa = flexygo.context.CodigoEmpresa;
var MesesConsumo = flexygo.context.MesesConsumo;
var SERIE = flexygo.context.TVSerie;
var SERIES = "";
var IdTeleVenta = "";
var GestorTeleVenta = "";
var FechaTeleVenta = "";
var NombreTeleVenta = "";
var opVendedor = ""; var opSerie = ""; var opMarca = ""; var opFamilia = ""; var opSubfamilia = "";
var TVvendedores = "";
var TVseries = "";
var TVmarcas = "";
var TVfamilias = "";
var TVsubfamilias = "";
var fechaAnterior = "";
var autoNombreTV = false;
var ClienteOferta = false;
var PedidoNoCobrarPortes = 0;
var ConfNoCobrarPortes = 0;
var ConfMostrarStockVirtual = 0;
var TARIFA = "";
var ObservacionesDelPedido = "";
var ObservacionesInternas = "";
var tfArticuloSeleccionado = "";
var tfArticuloSeleccionadoI = 0;

var paramStd = '"paramStd":[{"currentRole":"' + currentRole + '","currentReference":"' + currentReference + '"}]';

var nomMes = ["", "ENERO", "FEBRERO", "MARZO", "ABRIL", "MAYO", "JUNIO", "JULIO", "AGOSTO", "SEPTIEMPRE", "OCTUBRE", "NOVIEMBRE", "DICIEMBRE"];
var numMes = ["", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"];

var calendarioFormato = "aammdddd";
var calendarioInput = "";

var paginadorRegistros = 0;
var paginadorResultados = 0;

var ElementosClickOff = ["#dv-inci-cliente", "#dvLLBserieConfig", "#dvLLBserie", "#dvLLBvendedor", "#dvIncidenciasTemp", "#dvCalendarioEJG", "#dvinputDatosTemp", "#dvDatosTemp", "#trID", ".c_trID", "#veloClientes", "flx-module[modulename='usuariosTV']"];

$(document).click(function (e) {
    for (var i in ElementosClickOff) {
        var container = $(ElementosClickOff[i]);
        if (!container.is(e.target) && container.has(e.target).length === 0) { $(ElementosClickOff[i]).fadeOut(); }
    }
});


/*
	*************************
		     Iconos
	*************************
*/
/* Ejemplo de uso: <div class='img20 icoRecarga' onclick="resetFrm('OpcionesTV')"></div> */
var icoCargando16 = "<div class='img16 icoCargando rotarR'></div>";
var icoDownC = "<div class='img16 icoDownC'></div>";
var icoRecarga16 = "<div class='img16 icoRecarga'></div>";
var icoRecargaAzul20 = "<div class='img20 icoRecargaAzul'></div>";
var icoAspa = "<div class='img16 icoAspa'></div>";
var BtnDesI = "./Merlos/images/BtnDesI.png";
var BtnDesO = "./Merlos/images/BtnDesO.png";


/*
	*************************
		    Funciones
	*************************
*/
$(document).mousedown(function (e) { if (e.detail > 1) { e.preventDefault(); } });

function limpiarLaCache(){
    flexygo.nav.execProcess('ReloadCache', '', '', null, null, 'current', false, $(this));
    cacheAutoClick();
}	
	
function cacheAutoClick(){
	var botonYes = $("body").find(".lobibox-btn-yes");
	if(botonYes.is(":visible")){ botonYes.click(); }else{ setTimeout(cacheAutoClick,500); }
}

function abrirVelo(contenido, ancho) {
    if(ancho===null || !ancho || ancho===""){ ancho=500; }
    $("#dvVelo").remove();
    $("body").prepend("<div id='dvVelo' class='inv'><div id='dvVeloContenido' class='C' style='width:" + ancho + "px;'>" + contenido + "</div></div>");
    $("#dvVelo").stop().fadeIn();
}
function abrirAVT(contenido, ancho) {
    if(!ancho){ ancho=500; }
    $("#dvAVT").remove();
    $("body").prepend("<div id='dvAVT' style='z-index:10; position:fixed; width:100%; height:1px; top:50px;'><div class='sombra C' style='width:" + ancho + "px; margin:auto; background:#FFF;padding:10px;'>" + contenido + "</div></div>");
    $("#dvAVT").stop().fadeIn();
}
function abrirIcoCarga() {
    $("#dvVelo").remove();
    $("body").prepend(
        "<div id='dvVelo' class='dvVelo inv' style='text-align:center'>"
        +"  <img src='./Merlos/images/icoCarga150.png' style='width:100px; margin-top:100px;' class='rotarR'>"
        +"</div>"
    );
    $("#dvVelo").stop().fadeIn();
}
function cerrarVelo() { $("#dvVelo").stop().fadeOut().html(""); }
function cerrarAVT() { $("#dvAVT").stop().fadeOut().html(""); }

function buscarEn(elInput, elDiv) {
    var buscar = $.trim($("#" + elInput).val()).toLowerCase();

    if (event.keyCode == 13) {
        if (elInput.substring(0, 11) === "inpArticulo") { cargarArticulos(elInput.split("inpArticulo")[1], buscar); }
        if (elInput === "inpdvMultiseleccionContenidoBuscador") { cargarArticulosMultiseleccion(buscar); }
    }
    else {
        $("#" + elDiv).find("div").each(function () {
            var contenido = $.trim($(this).text()).toLowerCase();
            if (contenido.indexOf(buscar) !== -1) { $(this).removeClass("inv"); } else { $(this).addClass("inv"); }
        });
    }
}

function buscarEnTabla(elInput, laTabla) {
    var buscar = $.trim($("#" + elInput).val()).toLowerCase();
    $("#" + laTabla).find("tr").each(function () {
        var en = "";
        $(this).find("td").each(function () { en += $(this).text().toLowerCase(); }); 
        if (en.indexOf(buscar) !== -1) { $(this).removeClass("inv"); } else { $(this).addClass("inv"); }
    });
}

function masmenos(mm, inp, min, max) {
    var valor = $("#" + inp).val();
    if (mm) { valor++; } else { valor--; }
    if (min && valor < min) { valor = min; }
    if (max && valor > max) { valor = max; }
    $("#" + inp).val(valor);
    return false;
}

function soloNums(elID, elValor) { $('#' + elID).val(elValor.replace(/[^0-9]/, '')); }

function capitalizar(word) { return word[0].toUpperCase() + word.slice(1); }

function paginador(mm) {
    if (mm) { paginadorRegistros += 100; } else { paginadorRegistros -= 100; }
    if (paginadorRegistros < 0) { paginadorRegistros = 0; }
}

function repintarZebra(tb, color) {
    var bg = color;
    $("#" + tb).find("tr").each(function () {
        if (bg === color) { bg = ""; } else { bg = color; }
        $(this).css("background", bg);
    });
}

function resetFrm(frm) {
    if (frm === "OpcionesTV") {
        $("#inpNombreTV,#inpFechaTV").val("");
        $("#inputDatosGestor0,#inputDatosGestor,#inputDatosRuta,#inputDatosVendedor,#inputDatosSerie,#inputDatosMarca,#inputDatosFamilia,#inputDatosSubfamilia").html("");
    }
}



/* 
	*************************
		      INICIO
	************************* 
*/
limpiarCookies();
comprobarCargaMainMenu();
function comprobarCargaMainMenu() {
    if ($("#mainMenu").is(":visible")) { configuracionDeMenus(); }
    else { setTimeout(function () { comprobarCargaMainMenu(); }, 300); }
}


function configuracionDeMenus() {
    $("li[title='Avisos']").hide();
}



/*	
	***************
		FECHA
	***************
*/

var Fmeses = new Array("Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre");

function anyoActual() {
    var f = new Date();
    return f.getFullYear();
}

function fechaCorta(formato, separador = "-") {
    var f = new Date();
    var dia = f.getDate();
    var mes = f.getMonth() + 1;
    var any = f.getFullYear();
    var laFecha = "";

    dia = dia < 10 ? "0" + (dia) : dia;
    mes = mes < 10 ? "0" + (mes) : mes;

    if (formato === "amd") { laFecha = any + separador + mes + separador + dia; }
    else { laFecha = dia + separador + mes + separador + any; }
    return laFecha
}

function fechaLarga() {
    var f = new Date();
    var hora = f.getHours();
    var min = f.getMinutes();
    var seg = f.getSeconds();

    hora = hora < 10 ? "0" + (hora) : hora;
    min = min < 10 ? "0" + (min) : min;
    seg = seg < 10 ? "0" + (seg) : seg;

    return fechaCorta() + " " + hora + ":" + min + ":" + seg;
}

function hora() {
    var f = new Date();
    var hora = f.getHours();
    var min = f.getMinutes();
    var seg = f.getSeconds();

    hora = hora < 10 ? "0" + (hora) : hora;
    min = min < 10 ? "0" + (min) : min;
    seg = seg < 10 ? "0" + (seg) : seg;

    return hora + ":" + min + ":" + seg;
}

function fechaDeHoy() {
    var f = new Date();
    return (f.getDate() + " de " + Fmeses[f.getMonth()] + " de " + f.getFullYear());
}

function fechaDeAyer() {
    var TuFecha = new Date();
    TuFecha.setDate(TuFecha.getDate() - 1);
    var dia = TuFecha.getDate();
    var mes = TuFecha.getMonth() + 1;
    var any = TuFecha.getFullYear();
    if (dia.toString().length == 1) { dia = "0" + dia; }
    if (mes.toString().length == 1) { mes = "0" + mes; }
    return dia + "/" + mes + "/" + any;
}

function fechaDeManyana(formato = "dma", simbolo = "-") {
    var TuFecha = new Date();
    TuFecha.setDate(TuFecha.getDate() + 1);
    var dia = TuFecha.getDate();
    var mes = TuFecha.getMonth() + 1;
    var ano = TuFecha.getFullYear();
    if (dia.toString().length == 1) { dia = "0" + dia; }
    if (mes.toString().length == 1) { mes = "0" + mes; }
    var laFecha = dia + simbolo + mes + simbolo + ano;
    if (formato === "amd") { laFecha = ano + simbolo + mes + simbolo + dia; }
    return laFecha;
}

function fechaCambiaFormato(fecha) {
    var separador = "/"; if (fecha.includes("-")) { separador = "-"; }
    return fecha.split(separador)[2] + separador + fecha.split(separador)[1] + separador + fecha.split(separador)[0];
}

function fechaConDia() {
    var TuFecha = new Date();
    TuFecha.setDate(TuFecha.getDate() + 1);
    var dia = TuFecha.getDate();
    var mes = TuFecha.getMonth() + 1;
    var any = TuFecha.getFullYear();
    if (dia.toString().length == 1) { dia = "0" + dia; }
    if (mes.toString().length == 1) { mes = "0" + mes; }
    var dias = ["domingo", "lunes", "martes", "miércoles", "jueves", "viernes", "sábado"];
    var dt = new Date(mes + ' ' + dia + ', ' + any);
    return dias[dt.getUTCDay()] + " " + (TuFecha.getDate() + " de " + Fmeses[TuFecha.getMonth()] + " de " + TuFecha.getFullYear());
}

function existeFecha(fecha, separador = "-") {
    var fechaf = fecha.split(separador);
    var day = fechaf[0];
    var month = fechaf[1];
    var year = fechaf[2];
    var date = new Date(year, month, '0');
    if ((day - 0) > (date.getDate() - 0)) { return false; }
    return true;
}

function validarFechaMayorActual(fecha, separador = "-") {
    var x = new Date();
    var laFecha = x.setFullYear(fecha.split(separador)[2], fecha.split(separador)[1] - 1, fecha.split(separador)[0]);
    var today = new Date();
    if (x >= today) { return true; } else { return false; }
}




/*	
	******************
		CALENDARIO
	******************
*/
var actual = new Date();
function mostrarCalendario(year, month, tf=false, elInput) {
    var now = new Date(year, month - 1, 1);
    var last = new Date(year, month, 0);
    var primerDiaSemana = (now.getDay() == 0) ? 7 : now.getDay();
    var ultimoDiaMes = last.getDate();
    var dia = 0;
    var resultado = "<tr>";
    var diaActual = 0;

    var last_cell = primerDiaSemana + ultimoDiaMes;

    var meses = Array("Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre");

    // hacemos un bucle hasta 42, que es el máximo de valores que puede haber... 6 columnas de 7 dias
    for (var i = 1; i <= 42; i++) {
        if (i == primerDiaSemana) {
            // determinamos en que dia empieza
            dia = 1;
        }
        if (i < primerDiaSemana || i >= last_cell) {
            // celda vacia
            resultado += "<td>&nbsp;</td>";
        } else {
            // mostramos el dia
            var elOnClick = "onclick='verFecha(" + dia + "," + month + "," + year + ",\"" + elInput + "\")'";
            var calendAP = "";
            if (tf) {
                if ((dia == actual.getDate() && month == actual.getMonth() + 1 && year == actual.getFullYear())
                    || dia > actual.getDate() || month > actual.getMonth() + 1 || year > actual.getFullYear()
                ) { elOnClick = "onclick='verFecha(" + dia + "," + month + "," + year + ",\""+elInput+"\")'"; }
                else { calendAP = "calendarioEJGAnt"; }
            }
            if (dia == actual.getDate() && month == actual.getMonth() + 1 && year == actual.getFullYear()) {
                resultado += "<td class='calendarioEJGHoy' " + elOnClick + ">" + dia + "</td>";
            } else { resultado += "<td class='" + calendAP + "' " + elOnClick + ">" + dia + "</td>"; }
            dia++;
        }
        if (i % 7 == 0) {
            if (dia > ultimoDiaMes)
                break;
            resultado += "</tr><tr>\n";
        }
    }
    resultado += "</tr>";

    // Calculamos el siguiente mes y año
    nextMonth = month + 1;
    nextYear = year;
    if (month + 1 > 12) {
        nextMonth = 1;
        nextYear = year + 1;
    }

    // Calculamos el anterior mes y año
    prevMonth = month - 1;
    prevYear = year;
    if (month - 1 < 1) {
        prevMonth = 12;
        prevYear = year - 1;
    }

    document.getElementById("calendEJG").getElementsByTagName("caption")[0].innerHTML =
        "<div class='calenarioEJGMesAny'>" + meses[month - 1] + " / " + year
        + "     <span style='float:right;'> "
        + "      <span class='curP' onclick='mostrarCalendario(" + prevYear + "," + prevMonth + "," + tf + "); event.stopPropagation();'>&#x2b9c;</span> "
        + "      <span class='curP' onclick='mostrarCalendario(" + nextYear + "," + nextMonth + "," + tf + "); event.stopPropagation();'>&#x2b9e;</span>"
        + "      <span style='margin-left:20px;cursor:pointer;' onclick='cerrarCalendarioEJG()'>&#x2bbe;</span>"
        + "     </span>"
        + "</div>";
    document.getElementById("calendEJG").getElementsByTagName("tbody")[0].innerHTML = resultado;
}

function calendarioEJGkeyUp(elInput, valor, separador = "-") {
    $("#" + elInput).val(valor.replace(/[^0-9]/g, ""));
    var vvv = $("#" + elInput).val();
    var dia = vvv.substring(0, 2);
    var mes = vvv.substring(2, 4);
    var ano = vvv.substring(4, 8);
    if (vvv.length > 2) { $("#" + elInput).val(dia + separador + mes); }
    if (vvv.length > 4) { $("#" + elInput).val(dia + separador + mes + separador + ano); }
}

function verFecha(d, m, a, elInput) {
    var fechaDMA = PadLeft(d, 2) + "-" + PadLeft(m, 2) + "-" + a;
    var fechaAMD = a + "-" + PadLeft(m, 2) + "-" + PadLeft(d, 2);
    var calendarioDevolverFecha = fechaDMA;
    if (calendarioFormato === "amd") { calendarioDevolverFecha = fechaAMD; }
    $("#" + calendarioInput).val(calendarioDevolverFecha);
    if (fechaAnterior !== calendarioDevolverFecha) { $("#" + calendarioInput).change(); }
    cerrarCalendarioEJG();
}

function PadLeft(value, length) {
    return (value.toString().length < length) ? PadLeft("0" + value, length) :
        value;
}

function mostrarElCalendarioEJG(elInput, tf = false, formato = "dma", separador = "-") {
    fechaAnterior = $("#" + elInput).val();
    $("#dvCalendarioEJG").remove();
    $("#" + elInput).select();
    $("#" + elInput).off().on("keyup", function () { calendarioEJGkeyUp(elInput, $("#" + elInput).val(), separador); });
    calendarioInput = elInput;
    calendarioFormato = formato;
    var x = window.event.clientX - 200;
    var y = window.event.clientY - 100;
    $("body").append('<div id="dvCalendarioEJG" style="z-index:10; position:absolute;top:' + y + 'px; left:' + x + 'px; width:300px;"> '
        + '   <table id = "calendEJG" > '
        + '    <caption></caption> '
        + '    <thead><tr><th>Lun</th><th>Mar</th><th>Mié</th><th>Jue</th><th>Vie</th><th>Sáb</th><th>Dom</th></tr></thead> '
        + '    <tbody></tbody> '
        + '    </table > '
        + '</div > '
    );
    $("#dvCalendarioEJG").slideDown();
    mostrarCalendario(actual.getFullYear(), actual.getMonth() + 1, tf, elInput);
}

function cerrarCalendarioEJG() { $("#dvCalendarioEJG").remove(); }

function formatFecha(f){
	var fecha = new Date(f); 
	var nfM = fecha.getMonth()+1; 	nfM = nfM < 10 ? "0" + (nfM):nfM;
	var nfD = fecha.getDate(); 		nfD = nfD < 10 ? "0" + (nfD):nfD;
	var laFecha = fecha.getFullYear() + "-" + nfM + "-" + nfD;
	return laFecha;
}

function formatFechaHora(f){
	var fecha = new Date(f); 
	var nfM = fecha.getMonth()+1; 	nfM = nfM < 10 ? "0" + (nfM):nfM;
	var nfD = fecha.getDate(); 		nfD = nfD < 10 ? "0" + (nfD):nfD;
	var nfH = fecha.getHours(); 	nfH = nfH < 10 ? "0" + (nfH):nfH;
	var nfi = fecha.getMinutes(); 	nfi = nfi < 10 ? "0" + (nfi):nfi;
	var laFecha = fecha.getFullYear() + "-" + nfM + "-" + nfD + "T" + nfH + ":" + nfi;
	return laFecha;
}

function formatSqlFecha(f){
	var fecha = new Date(f); 
	var nfM = fecha.getMonth()+1; 	nfM = nfM < 10 ? "0" + (nfM):nfM;
	var nfD = fecha.getDate(); 		nfD = nfD < 10 ? "0" + (nfD):nfD;
	var laFecha = nfD + "-" + nfM + "-" + fecha.getFullYear();
	return laFecha;
}

function formatSqlFechaHora(f){
	var fecha = new Date(f); 
	var nfM = fecha.getMonth()+1; 	nfM = nfM < 10 ? "0" + (nfM):nfM;
	var nfD = fecha.getDate(); 		nfD = nfD < 10 ? "0" + (nfD):nfD;
	var nfH = fecha.getHours(); 	nfH = nfH < 10 ? "0" + (nfH):nfH;
	var nfi = fecha.getMinutes(); 	nfi = nfi < 10 ? "0" + (nfi):nfi;
	var laFecha = nfD + "-" + nfM + "-" + fecha.getFullYear() + " " + nfH + ":" + nfi;
	return laFecha;
}

/*	
	***************
	   Reloj EJG
	***************
*/
var elRelojEJG = "<div id='dvRelojEJG' class='esq10'>"
    + "<table id='tbRelojEJG'>"
    + "	<tr>"
    + "         <th colspan='6' style='padding:5px;'>"
    + "                 <span id='horaDesde' class='inv'><img id='imgDesde' class='imgRelojEJGdh' src='./Merlos/images/icoCheck_I.png' width='14'> Desde las </span> <span id='horaSelecDesde'>00:00</span>"
    + "                 <span id='horaHasta' class='inv' style='margin-left:10px;'><img id='imgHasta'  class='imgRelojEJGdh' src='./Merlos/images/icoCheck_O.png' width='14'> Hasta las </span>  <span id='horaSelecHasta'>00:00</span>"
    + "         </th>"
    + "   </tr>"
    + "	<tr>"
    + "		<td class='h'>00</td>"
    + "		<td class='h'>01</td>"
    + "		<td class='h'>02</td>"
    + "		<td class='h'>03</td>"
    + "		<td class='h'>04</td>"
    + "		<td class='h'>05</td>"
    + "	</tr>"
    + "	<tr>"
    + "		<td class='h'>06</td>"
    + "		<td class='h'>07</td>"
    + "		<td class='h'>08</td>"
    + "		<td class='h'>09</td>"
    + "		<td class='h'>10</td>"
    + "		<td class='h'>11</td>"
    + "	</tr>"
    + "	<tr>"
    + "		<td class='h'>12</td>"
    + "		<td class='h'>13</td>"
    + "		<td class='h'>14</td>"
    + "		<td class='h'>15</td>"
    + "		<td class='h'>16</td>"
    + "		<td class='h'>17</td>"
    + "	</tr>"
    + "	<tr>"
    + "		<td class='h'>18</td>"
    + "		<td class='h'>19</td>"
    + "		<td class='h'>20</td>"
    + "		<td class='h'>21</td>"
    + "		<td class='h'>22</td>"
    + "		<td class='h'>23</td>"
    + "	</tr>"
    + "	<tr><th colspan='6' style='padding:5px;'></th></tr>"
    + "	<tr>"
    + "		<td class='m'>00</td>"
    + "		<td class='m'>05</td>"
    + "		<td class='m'>10</td>"
    + "		<td class='m'>15</td>"
    + "		<td class='m'>20</td>"
    + "		<td class='m'>25</td>"
    + "	</tr>"
    + "	<tr>"
    + "		<td class='m'>30</td>"
    + "		<td class='m'>35</td>"
    + "		<td class='m'>40</td>"
    + "		<td class='m'>45</td>"
    + "		<td class='m'>50</td>"
    + "		<td class='m'>55</td>"
    + "	</tr>"
    + "	<tr><th colspan='6' style='padding:5px;' class='C'><br><span class='MIbotonGreen' onclick='asignarHora()'>asignar</span>&nbsp;&nbsp;&nbsp;<span class='MIbotonRed' onclick='cancelarHora()'>cancelar</span><br></th></tr>"
    + "</table>"
    + "</div>";

var relojEJGhora = "";
var relojEJGmin = "";
var spanSelec = "horaSelecDesde";
var relojEJG_desdeHasta = 0;
var inpHoraEJG = "";
function mostrarRelojEJG(inpId, inicioYfinal) {
    inpHoraEJG = inpId;
    relojEJGhora = relojEJGmin = relojEJGinicioHora = relojEJGinicioMin = relojEJGfinalHora = relojEJGfinalMin = "";

    var posCurX = event.clientX;
    var posCurY = event.clientY;
    if ($("#veloRelojEJG").is(":visible")) { $("#veloRelojEJG").remove(); }
    $("body").prepend("<div id='veloRelojEJG' style='z-index:2; position:absolute; left:" + (posCurX - 50) + "px; top:" + (posCurY - 100) + "px;'>" + elRelojEJG + "</div>");
    if (inicioYfinal) { $("#horaDesde, #horaHasta").show(); }

    $(".imgRelojEJGdh").off().on("click", function () {
        if (relojEJG_desdeHasta === 0) {
            relojEJG_desdeHasta = 1;
            spanSelec = "horaSelecHasta";
            $("#imgDesde").attr("src", './Merlos/images/icoCheck_O.png');
            $("#imgHasta").attr("src", './Merlos/images/icoCheck_I.png');
        } else {
            relojEJG_desdeHasta = 0;
            spanSelec = "horaSelecDesde";
            $("#imgDesde").attr("src", './Merlos/images/icoCheck_I.png');
            $("#imgHasta").attr("src", './Merlos/images/icoCheck_O.png');
        }
        relojEJGhora = relojEJGmin = "";
    });

    $("#tbRelojEJG td").off().on("click", function () {
        if ($(this).hasClass("h")) { relojEJGhora = $(this).text(); }
        if ($(this).hasClass("m")) { relojEJGmin = $(this).text(); }
        if (relojEJGhora === "") { relojEJGhora = "00"; }
        if (relojEJGmin === "") { relojEJGmin = "00"; }
        $("#" + spanSelec).text(relojEJGhora + ":" + relojEJGmin);
    });
}

function asignarHora() {
    var horaSel = $("#horaSelecDesde").text() + " - " + $("#horaSelecHasta").text();
    var ultimaHora = "";

    if ($("#mod-TV_Pedido").is(":visible") && $("#inciCliente").is(":visible")) {
        llamarMasTardeCliente(horaSel);
    } else {
        $("#" + inpHoraEJG).val(horaSel);

        $("#tbTablaDeLlamadas").find("img").each(function () {
            var imgId = $(this).attr("id"); var dia = imgId.split("img")[1]; var diaVal = "inp" + dia + "Horario";
            if ($(this).attr("src") === "./Merlos/images/icoCheck_I.png" && $("#" + diaVal).val() === "") { $("#" + diaVal).val(horaSel); }
            if ($("#" + diaVal).val() !== "") { $("#" + imgId).attr("src", "./Merlos/images/icoCheck_I.png"); }
        });
    }

    $("#veloRelojEJG").fadeOut(300, function () { $("#veloRelojEJG").remove(); relojEJG_desdeHasta = 0; spanSelec = "horaSelecDesde"; });
}

function cancelarHora() {
    $("#veloRelojEJG").fadeOut(300, function () { $("#veloRelojEJG").remove(); relojEJG_desdeHasta = 0; spanSelec = "horaSelecDesde"; });
}


/*	
	***************
		COOKIES
	***************
*/

function setCookie(cname, cvalue, exdays) {
    var d = new Date();
    d.setTime(d.getTime() + (exdays * 24 * 60 * 60 * 1000));
    var expires = "expires=" + d.toUTCString();
    document.cookie = cname + "=" + cvalue + ";" + expires + ";path=/";
}

function setCookieSeg(cname, cvalue, segundos) {
    var d = new Date();
    d.setTime(d.getTime() + segundos * 1000);
    var expires = "expires=" + d.toUTCString();
    document.cookie = cname + "=" + cvalue + ";" + expires + ";path=/";
}

function getCookie(cname) {
    var name = cname + "=";
    var decodedCookie = decodeURIComponent(document.cookie);
    var ca = decodedCookie.split(';');
    for (var i = 0; i < ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0) == ' ') { c = c.substring(1); }
        if (c.indexOf(name) == 0) { return c.substring(name.length, c.length); }
    }
    return "";
}


function removeCookie(cname) { document.cookie = cname + '=; expires=Thu, 01 Jan 1970 00:00:01 GMT;'; }

function limpiarCookies() {
    document.cookie.split(";").forEach(function (c) {
        document.cookie = c.replace(/^ +/, "").replace(/=.*/, "=;expires=" + new Date().toUTCString() + ";path=/");
    });
}


// ORDENAR JSON
function sortJSON(data, key, orden) {
    return data.sort(function (a, b) {
        var x = a[key], y = b[key];
        if (orden === 'asc') { return ((x < y) ? -1 : ((x > y) ? 1 : 0)); }
        if (orden === 'desc') { return ((x > y) ? -1 : ((x < y) ? 1 : 0)); }
    });
}

function esJSON(str) {
    try {
        JSON.parse(str);
    } catch (e) {
        return false;
    }
    return true;
}


// Limpiar Cadena
function limpiarCadena(cadena) {
    return cadena.replace(/\r/g, "<br>").replace(/\n/g, "<br>").replace(/\t/g, "").replace(/\b/g, "").replace(/\f/g, "").replace(/\\/g, "");
}



function Left(str, n) {
    if (n <= 0)
        return "";
    else if (n > String(str).length)
        return str;
    else
        return String(str).substring(0, n);
}

function Right(str, n) {
    if (n <= 0)
        return "";
    else if (n > String(str).length)
        return str;
    else {
        var iLen = String(str).length;
        return String(str).substring(iLen, iLen - n);
    }
}






/* 
	****************************************
		 Pizarra HTML / ANDROID
	**************************************** 
*/
var ongoingTouches = [];
var elFirma;
var ctx, cw, ch;
var puntos = [];
var estoyDibujando = false;
var evt = window.event;
var factorDeAlisamiento = 2;
var Trazados = [];

function abrirPizarra() {
    var laPizarra = '<div id="CONT_pizarra" class="seccion" style="z-index:2;width:100%;height:100%;position:fixed;margin:0px;padding:0px;top:0px;left:0px;background-color:white;text-align:center;display:none;">' +
        '<br>Firma del cliente<br>' +
        '<elFirma id="lienzoPizarra" width="300" height="300" style="border:1px solid #CCC;"></elFirma>' +
        '<br>' +
        '<table>' +
        '    <tr><td style="text-align:right;">Cargo&nbsp;&nbsp;</td><td><input type="text" id="firmaCargo"></td></tr>' +
        '    <tr><td style="text-align:right;">Nombre&nbsp;&nbsp;</td><td><input type="text" id="firmaNombre"></td></tr>' +
        '</table>' +
        '<br><br>' +
        '<span class="boton" onclick="guardarFirma()">GUARDAR</span>' +
        '<span class="boton" onclick="borrarFirma()">BORRAR</span>' +
        '<span class="boton" onclick="cancelarFirma()">CANCELAR</span>' +
        '<img id="elFirmaIMG" style="display:none;">' +
        '</div>';

    comenzarPizarra();
}


function comenzarPizarra() {
    elFirma = document.getElementById("lienzoPizarra");
    ctx = elFirma.getContext("2d");
    ctx.lineJoin = "round";
    cw = elFirma.width = 300, cx = cw / 2;
    ch = elFirma.height = 300, cy = ch / 2;

    // HTML
    limpiar = document.getElementById("limpiarPizarra");
    ctx = elFirma.getContext("2d");
    cw = elFirma.width = 300, cx = cw / 2;
    ch = elFirma.height = 300, cy = ch / 2;
    ctx.lineJoin = "round";

    limpiar.addEventListener('click', function (evt) {
        estoyDibujando = false;
        ctx.clearRect(0, 0, cw, ch);
        Trazados.length = 0;
        puntos.length = 0;
    }, false);


    elFirma.addEventListener('mousedown', function (evt) {
        estoyDibujando = true;
        puntos.length = 0;
        ctx.beginPath();
    }, false);

    elFirma.addEventListener('mouseup', function (evt) { redibujarTrazados(); }, false);

    elFirma.addEventListener("mouseout", function (evt) { redibujarTrazados(); }, false);

    elFirma.addEventListener("mousemove", function (evt) {
        if (estoyDibujando) {
            var m = oMousePos(elFirma, evt);
            puntos.push(m);
            ctx.lineTo(m.x, m.y);
            ctx.stroke();
        }
    }, false);

    $("#limpiarPizarra").click();
    $("#firmaNombre, #firmaCargo, #firmaDNI").val("");

    // Android
    elFirma.addEventListener("touchstart", handleStart, false);
    elFirma.addEventListener("touchend", handleEnd, false);
    elFirma.addEventListener("touchcancel", handleCancel, false);
    elFirma.addEventListener("touchmove", handleMove, false);
}

// Pizarra HTML
function reducirArray(n, elArray) {
    var nuevoArray = [];
    nuevoArray[0] = elArray[0];
    for (var i = 0; i < elArray.length; i++) {
        if (i % n == 0) {
            nuevoArray[nuevoArray.length] = elArray[i];
        }
    }
    nuevoArray[nuevoArray.length - 1] = elArray[elArray.length - 1];
    Trazados.push(nuevoArray);
}

function calcularPuntoDeControl(ry, a, b) {
    var pc = {}
    pc.x = (ry[a].x + ry[b].x) / 2;
    pc.y = (ry[a].y + ry[b].y) / 2;
    return pc;
}

function alisarTrazado(ry) {
    if (ry.length > 1) {
        var ultimoPunto = ry.length - 1;
        ctx.beginPath();
        ctx.moveTo(ry[0].x, ry[0].y);
        for (i = 1; i < ry.length - 2; i++) {
            var pc = calcularPuntoDeControl(ry, i, i + 1);
            ctx.quadraticCurveTo(ry[i].x, ry[i].y, pc.x, pc.y);
        }
        ctx.quadraticCurveTo(ry[ultimoPunto - 1].x, ry[ultimoPunto - 1].y, ry[ultimoPunto].x, ry[ultimoPunto].y);
        ctx.stroke();
    }
}


function redibujarTrazados() {
    estoyDibujando = false;
    ctx.clearRect(0, 0, cw, ch);
    reducirArray(factorDeAlisamiento, puntos);
    for (var i = 0; i < Trazados.length; i++)
        alisarTrazado(Trazados[i]);
}

function oMousePos(elFirma, evt) {
    var ClientRect = elFirma.getBoundingClientRect();
    return {
        x: Math.round(evt.clientX - ClientRect.left),
        y: Math.round(evt.clientY - ClientRect.top)
    }
}


// Pizarra ANDROID
function handleStart(evt) {
    evt.preventDefault();
    ctx = elFirma.getContext("2d");
    var touches = evt.changedTouches;

    for (var i = 0; i < touches.length; i++) {
        ongoingTouches.push(copyTouch(touches[i]));
        var color = colorForTouch(touches[i]);
        ctx.beginPath();
        ctx.fillStyle = color;
        ctx.fill();
    }
}

function handleMove(evt) {
    var poselFirma = $("#lienzoPizarra").offset();

    evt.preventDefault();
    ctx = elFirma.getContext("2d");
    var touches = evt.changedTouches;

    for (var i = 0; i < touches.length; i++) {
        var color = colorForTouch(touches[i]);
        var idx = ongoingTouchIndexById(touches[i].identifier);

        if (idx >= 0) {
            ctx.beginPath();
            ctx.moveTo(ongoingTouches[idx].pageX - poselFirma.left, ongoingTouches[idx].pageY - poselFirma.top);
            ctx.lineTo(touches[i].pageX - poselFirma.left, touches[i].pageY - poselFirma.top);
            ctx.lineWidth = 2;
            ctx.strokeStyle = color;
            ctx.stroke();

            ongoingTouches.splice(idx, 1, copyTouch(touches[i]));  // swap in the new touch record
        } else {
        }
    }
}

function handleEnd(evt) {
    evt.preventDefault();
    var elFirma = document.getElementById("lienzoPizarra");
    var ctx = elFirma.getContext("2d");
    var touches = evt.changedTouches;

    for (var i = 0; i < touches.length; i++) {
        var color = colorForTouch(touches[i]);
        var idx = ongoingTouchIndexById(touches[i].identifier);

        if (idx >= 0) {
            ctx.lineWidth = 3;
            ctx.fillStyle = color;
            ctx.beginPath();
            ctx.moveTo(ongoingTouches[idx].pageX, ongoingTouches[idx].pageY);
            ctx.lineTo(touches[i].pageX, touches[i].pageY);
            ongoingTouches.splice(idx, 1);
        }
    }
}

function handleCancel(evt) {
    evt.preventDefault();
    log("touchcancel.");
    var touches = evt.changedTouches;

    for (var i = 0; i < touches.length; i++) {
        var idx = ongoingTouchIndexById(touches[i].identifier);
        ongoingTouches.splice(idx, 1);  // remove it; we're done
    }
}

function colorForTouch(touch) {
    var r = touch.identifier % 16;
    var g = Math.floor(touch.identifier / 3) % 16;
    var b = Math.floor(touch.identifier / 7) % 16;
    r = r.toString(16); // make it a hex digit
    g = g.toString(16); // make it a hex digit
    b = b.toString(16); // make it a hex digit
    var color = "#" + r + g + b;
    return color;
}

function copyTouch(touch) {
    return { identifier: touch.identifier, pageX: touch.pageX, pageY: touch.pageY };
}

function ongoingTouchIndexById(idToFind) {
    for (var i = 0; i < ongoingTouches.length; i++) {
        var id = ongoingTouches[i].identifier;
        if (id === idToFind) {
            return i;
        }
    }
    return -1;    // not found
}

function guardarFirma() {
    var inpFirmaCargo = $.trim($("#firmaCargo").val());
    var inpFirmaNombre = $.trim($("#firmaNombre").val());
    var inpFirmaDNI = $.trim($("#firmaDNI").val());
    var laFirma = elFirma.toDataURL();

    if (inpFirmaCargo === "" || inpFirmaNombre === "" || inpFirmaDNI === "") { alert("Debes rellenar todos los campos!"); return; }
    if (laFirma === "") { alert("Se debe firmar el documento!"); return; }

}

function borrarFirma() { ctx.clearRect(0, 0, elFirma.width, elFirma.height); }
function cancelarFirma() { borrarFirma(); $(".seccion").hide(); $("#dvFinalizar").fadeIn(); }


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
}