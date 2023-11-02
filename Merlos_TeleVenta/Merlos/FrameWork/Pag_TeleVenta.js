$("#mainNav").hide();

// Comprobar Ejercicio en Curso ----------------------------------------------------------------------------------------------------------------------------
var parametros = '{"sp":"pConfiguracion","modo":"ComprobarEjercicio"}';
flexygo.nav.execProcess('pMerlos', '', null, null, [{ 'Key': 'parametros', 'Value': limpiarCadena(parametros) }], 'current', false, $(this), function(ret) {
    if (ret) {
        if (ret.JSCode !== "") { console.log("Se ha actualizado el portal al ejercicio " + ret.JSCode); }
    } else { alert('Error S.P. pConfiguracion - ComprobarEjercicio!!!\n' + JSON.stringify(ret)); }
}, false);
// ----------------------------------------------------------------------------------------------------------------------------------------------------------


if ((flexygo.history.get($('main')).defaults) !== null && (flexygo.history.get($('main')).defaults) !== undefined) {
    var elJSON = JSON.parse(flexygo.history.get($('main')).defaults);
    try { ClienteCodigo = elJSON.CODIGO; } catch { ClienteCodigo = ""; }
}

setTimeout(function() {
    if (ClienteCodigo !== "") {
        cargarTeleVentaCliente(ClienteCodigo);
        cargarTeleVentaLlamadas("llamadasDelCliente");
        cargarTeleVentaUltimosPedidos(ClienteCodigo);
    } else { cargarTeleVentaLlamadas("listaGlobal"); }
}, 1000);

/*  TV_Pedido  **************************************************************************************************************** */
cargarIncidencias("art");
cargarIncidencias("cli");