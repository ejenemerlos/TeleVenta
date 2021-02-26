

BEGIN TRY

MERGE INTO [Objects_Templates] AS Target
USING (VALUES
  (N'Cliente_Datos',N'Cliente',N'view',N'Cliente_Datos',N'<div style="padding:20px;">
	<table>
		<tr>
			<td><span class="flx-icon icon-vcard-2 azul3"></span></td>
			<td colspan="3">
              <span class="azul3" style="font:14px arial;">Código:</span>
              <span id="spanClienteCodigo" class="azul3" style="font:14px arial;">{{CODIGO}}</span>
              <span id="spanClienteBaja" style="margin-left:30px; font:bold 14px arial; color:red;" class="{{BAJA|switch:[0:inv]}}">BAJA: {{FechaBaja}}</span>
            </td>
		</tr>
		<tr>
			<td><span class="flx-icon icon-man azul2"></span></td>
			<td colspan="3"><span class="azul2" style="font:bold 16px arial;">{{NOMBRE}}</span></td>
		</tr>
		<tr>
			<td><span class="flx-icon icon-map-point"></span></td>
			<td colspan="3"><span style="font:12px arial;">{{DIRECCION}}</span></td>
		</tr>
		<tr>
			<td><span class="fa fa-map-o"></span></td>
			<td colspan="3"><span style="font:12px arial;">{{CP}} {{POBLACION}} {{PROVINCIA}}</span></td>
		</tr>
		<tr>
			<td><span class="flx-icon icon-phone"></span></td>
			<td colspan="3"><span style="font:12px arial;">{{TELEFONO|switch:[isnull:Sin Teléfono,:Sin Teléfono]}}</span></td>
		</tr>
		<tr>
			<td><span class="flx-icon icon-email"></span></td>
			<td><span style="font:12px arial;">{{EMAIL}}</span></td>
			<td style="text-align:right;"><span class="{{gestor|switch:[:inv]}}"><span  class="azul3" style="font:14px arial;">Gestor: </span> ({{gestor}}) {{nGestor}}</span></td>
			<td style="text-align:right;">
				<span id="btnrAsignarGestor">
					<span class="MIbotonBlue ml20" onclick="asignarGestor(); event.stopPropagation();">Asignar Gestor</span>
					<span class="MIbotonBlue ml20 {{gestor|switch:[:inv]}}" onclick="asignarGestor(''quitarGestor'');  event.stopPropagation();">Quitar Gestor</span>
				</span>
				<span id="btnAsignarGestorAV" class="ml20 avTXT inv"></span>
			</td>
		</tr>
	</table>
</div>

<div id="dvTablaLlamadas" class="{{currentRole|switch:[Vendedor:inv,Cliente:inv]}}" style="background:#f2f2f2; padding:10px; font:12px arial; color:#333;">
	<table id="tbTablaDeLlamadas" class="tbLlamadas">
		<tr>
			<td><img id="imgLunes" src="./Merlos/images/icoCheck_O.png" alt="Lunes"> Lunes</td>
			<td><input type="text" id="inpLunesHorario" readonly></td>
			<td><img id="imgMartes" src="./Merlos/images/icoCheck_O.png" alt="Martes"> Martes</td>
			<td><input type="text" id="inpMartesHorario" readonly></td>
			<td><img id="imgMiercoles" src="./Merlos/images/icoCheck_O.png" alt="Miercoles"> Miércoles</td>
			<td><input type="text" id="inpMiercolesHorario" readonly></td>
			<td><img id="imgJueves" src="./Merlos/images/icoCheck_O.png" alt="Jueves"> Jueves</td>
			<td><input type="text" id="inpJuevesHorario" readonly></td>
		</tr>
		<tr>			
			<td><img id="imgViernes" src="./Merlos/images/icoCheck_O.png" alt="Viernes"> Viernes</td>
			<td><input type="text" id="inpViernesHorario" readonly></td>
			<td><img id="imgSabado" src="./Merlos/images/icoCheck_O.png" alt="Sabado"> Sábado</td>
			<td><input type="text" id="inpSabadoHorario" readonly></td>			
			<td><img id="imgDomingo" src="./Merlos/images/icoCheck_O.png" alt="Domingo"> Domingo</td>
			<td><input type="text" id="inpDomingoHorario" readonly></td>
			<td></td>
			<td></td>
		</tr>
	</table>
	
	<div class="azul3" style="font:14px; arial;"><br>Periodicidad de llamadas</div>
	<table id="tbTablaDeLlamadasPeriodo" class="tbLlamadas">
		<tr>
			<td><img id="imgDiaria" src="./Merlos/images/icoCheck_I.png" alt="1"> Diaria</td>
			<td><img id="imgSemanal" src="./Merlos/images/icoCheck_O.png" alt="2"> Semanal</td>
			<td><img id="imgQuincenal" src="./Merlos/images/icoCheck_O.png" alt="3"> Quincenal</td>
			<td><img id="imgMensual" src="./Merlos/images/icoCheck_O.png" alt="4"> Mensual</td>
			<td>
				<span class="esq05" style="border:1px solid #999; padding:6px;">
					<img id="imgPeriodo" src="./Merlos/images/icoCheck_O.png" alt="5"> Cada 
					<input type="text" id="inpPeriodo" class="C" style="padding:2px; width:30px;" maxlength="3"
					onkeyup="soloNums(this.id,this.value)" disabled> días
				</span>				
			</td>			
			<td style="width:200px; text-align:center;">
				<span id="btnGuardar" class="MIbotonGreen ml20" onclick="establecerHorarioDeLlamadas()">Guardar</span>
				<span id="btnGuardarAV" class="ml20 avTXT inv">guardado</span>
			</td>
		</tr>
	</table>
</div>


<script>	
	var llDias = ["lunes","martes","miercoles","jueves","viernes","sabado","domingo"];
	
	' + convert(nvarchar(max),NCHAR(36)) + N'("#tbTablaDeLlamadas img").off().on("click",function(){  
		var elSRC = ' + convert(nvarchar(max),NCHAR(36)) + N'(this).attr("src");
		if(elSRC==="./Merlos/images/icoCheck_O.png"){ 
			' + convert(nvarchar(max),NCHAR(36)) + N'(this).attr("src","./Merlos/images/icoCheck_I.png"); 
			var horaSel = "";
			' + convert(nvarchar(max),NCHAR(36)) + N'("#tbTablaDeLlamadas").find("input").each(function () { if(' + convert(nvarchar(max),NCHAR(36)) + N'(this).val()!==""){ horaSel = ' + convert(nvarchar(max),NCHAR(36)) + N'(this).val();} });
			' + convert(nvarchar(max),NCHAR(36)) + N'("#tbTablaDeLlamadas").find("img").each(function () {
				var imgId = ' + convert(nvarchar(max),NCHAR(36)) + N'(this).attr("id"); var dia = imgId.split("img")[1]; var diaVal = "inp" + dia + "Horario";
				if (' + convert(nvarchar(max),NCHAR(36)) + N'(this).attr("src") === "./Merlos/images/icoCheck_I.png" && ' + convert(nvarchar(max),NCHAR(36)) + N'("#" + diaVal).val() === "") { ' + convert(nvarchar(max),NCHAR(36)) + N'("#" + diaVal).val(horaSel); }
			});
		}else{ 
			' + convert(nvarchar(max),NCHAR(36)) + N'(this).attr("src","./Merlos/images/icoCheck_O.png");  
			' + convert(nvarchar(max),NCHAR(36)) + N'("#tbTablaDeLlamadas").find("img").each(function () {
				var imgId = ' + convert(nvarchar(max),NCHAR(36)) + N'(this).attr("id"); var dia = imgId.split("img")[1]; var diaVal = "inp" + dia + "Horario";
				if (' + convert(nvarchar(max),NCHAR(36)) + N'(this).attr("src") === "./Merlos/images/icoCheck_O.png") { ' + convert(nvarchar(max),NCHAR(36)) + N'("#" + diaVal).val(""); }
			});
		}
	});
	
	' + convert(nvarchar(max),NCHAR(36)) + N'("#tbTablaDeLlamadas input").off().on("click",function(){ mostrarRelojEJG(this.id,true); });
	
	' + convert(nvarchar(max),NCHAR(36)) + N'("#tbTablaDeLlamadasPeriodo img").off().on("click",function(){	
		' + convert(nvarchar(max),NCHAR(36)) + N'("#tbTablaDeLlamadasPeriodo").find("img").each(function(){ ' + convert(nvarchar(max),NCHAR(36)) + N'(this).attr("src","./Merlos/images/icoCheck_O.png"); });
		' + convert(nvarchar(max),NCHAR(36)) + N'(this).attr("src","./Merlos/images/icoCheck_I.png"); 
		' + convert(nvarchar(max),NCHAR(36)) + N'("#inpPeriodo").prop("disabled",true);
		var elId = ' + convert(nvarchar(max),NCHAR(36)) + N'(this).prop("id");
		var elSRC = ' + convert(nvarchar(max),NCHAR(36)) + N'(this).attr("src");
		//if(elId==="imgDiaria"){	' + convert(nvarchar(max),NCHAR(36)) + N'("#tbTablaDeLlamadas").find("img").each(function(){ ' + convert(nvarchar(max),NCHAR(36)) + N'(this).attr("src","./Merlos/images/icoCheck_I.png"); }); }
		if(elId==="imgPeriodo"){ ' + convert(nvarchar(max),NCHAR(36)) + N'("#inpPeriodo").prop("disabled",false); }
	});	
	
	function establecerHorarioDeLlamadas(){		
		var dia = "";
		var horario = "";
		var bit = 0;
		var js = "";
		var tipo = "";
		var periodo = parseInt(' + convert(nvarchar(max),NCHAR(36)) + N'.trim(' + convert(nvarchar(max),NCHAR(36)) + N'("#inpPeriodo").val()));
		var parar = false;
		if(isNaN(periodo)){ periodo=null; }
		
		if(' + convert(nvarchar(max),NCHAR(36)) + N'("#imgPeriodo").attr("src")==="./Merlos/images/icoCheck_I.png" && periodo===null){ alert("Debes especificar los días del periodo!"); return; }
		
		' + convert(nvarchar(max),NCHAR(36)) + N'("#tbTablaDeLlamadas").find("img").each(function(){
			dia = ' + convert(nvarchar(max),NCHAR(36)) + N'(this).attr("alt").toLowerCase();
			horario = ' + convert(nvarchar(max),NCHAR(36)) + N'.trim(' + convert(nvarchar(max),NCHAR(36)) + N'("#inp"+' + convert(nvarchar(max),NCHAR(36)) + N'(this).attr("alt")+"Horario").val());
			bit = 0;
			if(' + convert(nvarchar(max),NCHAR(36)) + N'(this).attr("src")==="./Merlos/images/icoCheck_I.png"){ 
				bit=1; 
				if(horario===""){ parar = true; alert("Debes especificar el horario del "+dia+"!"); }
			}
			js += ''{"dia":"''+dia+''","activo":''+bit+'',"horario":"''+horario+''"}'';
		}); 
		' + convert(nvarchar(max),NCHAR(36)) + N'("#tbTablaDeLlamadasPeriodo").find("img").each(function(){			
			if(' + convert(nvarchar(max),NCHAR(36)) + N'(this).attr("src")==="./Merlos/images/icoCheck_I.png"){ tipo=' + convert(nvarchar(max),NCHAR(36)) + N'(this).attr("alt"); }			
		}); 
		js = ''{"cliente":"{{CODIGO}}","dias":[''+js.replace(/}{/g,"},{")+''],"tipo":"''+tipo+''","periodo":''+periodo+''}''; 
		if(parar){ return; }
		' + convert(nvarchar(max),NCHAR(36)) + N'("#btnGuardar").hide(); ' + convert(nvarchar(max),NCHAR(36)) + N'("#btnGuardarAV").html(icoCargando16+" guardando...").fadeIn();
		flexygo.nav.execProcess(''pClientesADI'','''',null,null,[{''key'':''modo'',''value'':''editar''},{''key'':''elJS'',''value'':js}],''modal640x480'',false,' + convert(nvarchar(max),NCHAR(36)) + N'(this),function(ret){
			if(ret){
				' + convert(nvarchar(max),NCHAR(36)) + N'("#btnGuardarAV").html("guardado correcto!");
				setTimeout(function(){ ' + convert(nvarchar(max),NCHAR(36)) + N'("#btnGuardarAV").hide(); ' + convert(nvarchar(max),NCHAR(36)) + N'("#btnGuardar").fadeIn(); },2000);
			}
			else{ alert("Error SP: pClientesADI!!!"+JSON.stringify(ret)); }
		},false);
	}
	
	function cargarTablasDeLlamadas(){
		flexygo.nav.execProcess(''pClientesADI'','''',null,null,[{''key'':''modo'',''value'':''cargarTablasDeLlamadas''},{''key'':''elJS'',''value'':"{{CODIGO}}"}],''modal640x480'',false,' + convert(nvarchar(max),NCHAR(36)) + N'(this),function(ret){
			if(ret){ 
				if(ret.JSCode===""){ return; }
				var js = JSON.parse(ret.JSCode);
				if(js.length>0){
					for(var d in llDias){
						if(js[0][llDias[d]]){ 
							' + convert(nvarchar(max),NCHAR(36)) + N'("#img"+capitalizar(llDias[d])).attr("src","./Merlos/images/icoCheck_I.png"); 
							' + convert(nvarchar(max),NCHAR(36)) + N'("#inp"+capitalizar(llDias[d])+"Horario").val(' + convert(nvarchar(max),NCHAR(36)) + N'.trim(js[0]["hora_"+llDias[d]])); 
						}
					}
					' + convert(nvarchar(max),NCHAR(36)) + N'("#tbTablaDeLlamadasPeriodo").find("img[alt=''"+js[0].tipo_llama+"'']").attr("src","./Merlos/images/icoCheck_I.png");
					if(js[0].tipo_llama===5){ ' + convert(nvarchar(max),NCHAR(36)) + N'("#inpPeriodo").val(js[0].dias_period).prop("disabled",false); }
				}
			}else{ alert("Error SP: pClientesADI!!!"+JSON.stringify(ret)); }
		},false);
	}
	
	function asignarGestor(modo,gestor,n){ 
		if(modo){
			' + convert(nvarchar(max),NCHAR(36)) + N'("#btnrAsignarGestor").hide(); ' + convert(nvarchar(max),NCHAR(36)) + N'("#btnAsignarGestorAV").html(icoCargando16+" asignando...").show(); 
			' + convert(nvarchar(max),NCHAR(36)) + N'("flx-module[modulename=''usuariosTV'']").stop().slideUp();
			var parametros = ''{"modo":"''+modo+''","cliente":"{{CODIGO}}","gestor":"''+gestor+''","nGestor":"''+n+''",''+paramStd+''}'';
			flexygo.nav.execProcess(''pClienteDatos'','''',null,null,[{''key'':''parametros'',''value'':limpiarCadena(parametros)}],''modal640x480'',false,' + convert(nvarchar(max),NCHAR(36)) + N'(this),function(ret){
				if(ret){
					flexygo.nav.openPage(''view'',''Cliente'',''CODIGO=\''{{CODIGO}}\'''',''{\''CODIGO\'':\''{{CODIGO}}\''}'',''current'',false,' + convert(nvarchar(max),NCHAR(36)) + N'(this));
				}else{ alert("Error SP: pClienteDatos!!!"+JSON.stringify(ret)); }
			},false);
		}else{ ' + convert(nvarchar(max),NCHAR(36)) + N'("flx-module[modulename=''usuariosTV'']").css("margin-top","-180px").stop().slideDown(); }		
	}
	
	cargarTablasDeLlamadas();
</script>',NULL,NULL,NULL,NULL,NULL,NULL,0,0,1,1)
 ,(N'ClienteDefaultList',N'Cliente',N'list',N'Cliente Default List',N'  <tr onclick="flexygo.nav.openPage(''view'',''Cliente'',''CODIGO=\''{{CODIGO}}\'''',''{\''CODIGO\'':\''{{CODIGO}}\''}'',''current'',false,' + convert(nvarchar(max),NCHAR(36)) + N'(this));">
   
    <td class="C {{horarioAsignado|switch:[1:inv]}}"></td>
    <td class="C {{horarioAsignado|switch:[0:inv]}}"><img src="./Merlos/images/relojVerde.png" width="16"></td>
    
    <td>{{CODIGO}}</td>
    <td>{{NOMBRE}}</td>
    <td><span class="flx-icon icon-phone icon-margin-right " ></span><a  href="tel:{{TELEFONO|isnull:#}}">{{TELEFONO|isnull:{{translate|Sin teléfono}}}}</a></td>
    <td><span class="flx-icon icon-email icon-margin-right "></span><a  href="mailto:{{EMAIL|isnull:#}}">{{EMAIL|isnull:{{translate|Sin correo}}}}</a></td>
    <td><span class="fa fa-map-o  icon-margin-right "></span><a href="https://maps.google.com/maps?q={{DIRECCION|isnull:{{translate|Sin dirección}}}} {{CP}} {{POBLACION}}" target="_blank">{{DIRECCION|isnull:Sin dirección}} {{CP}} {{POBLACION}}</a></td>
  </tr>',NULL,NULL,N'<table class="tbStd">
  <tr>
    <th class="C"><img src="./Merlos/images/relojBlanco.png" width="16"></th>
    <th>Código</th>
    <th>Nombre</th>
    <th>Teléfono</th>
    <th>E-mail</th>
    <th>Dirección</th>
  </tr>',N'</table>',NULL,NULL,1,0,1,1)
 ,(N'gestorDefaultList',N'gestor',N'list',N'gestor Default List',N'  <tr>
    <td>{{codigo}}</td>
    <td>{{nombre}}</td>
    <td>{{apellidos}}</td>
  </tr>',NULL,NULL,N'<table id="tbGestores" class="tbStd">
  <tr>
    <th>Código</th>
    <th>Nombre</th>
    <th>Apellidos</th>
  </tr>',N'</table>',NULL,NULL,1,0,1,1)
 ,(N'gestores',N'gestor',N'list',N'gestores',N'<tr onclick="asignarGestor(''asignarGestor'',''{{codigo}}'',''{{nombre}} {{apellidos}}'')">
    <td>{{codigo}}</td>
    <td>{{nombre}}</td>
    <td>{{apellidos}}</td>
  </tr>',NULL,NULL,N'<table id="tbGestores" class="tbStd">
  <tr>
    <th>Código</th>
    <th>Nombre</th>
    <th>Apellidos</th>
  </tr>',N'</table>',NULL,NULL,0,0,1,1)
 ,(N'inciARTDefaultList',N'inciART',N'list',N'inciART Default List',N'<tr>
  <td>{{laFecha}}</td>
  <td>({{gestor}}) {{nGestor}}</td>
  <td>({{articulo}}) {{nArticulo}}</td>
  <td>{{incidencia}} - {{nIncidencia}}</td>
  <td>({{cliente}}) {{nCliente}}</td>
  <td>{{pedido}}</td>
  <td>{{observaciones}}</td>
</tr>',NULL,NULL,N'<table id="tbInciCLI" class="tbStd">
  	<tr>
  		<th>Fecha</th>
  		<th>Gestor</th>
  		<th>Artículo</th>
  		<th>Incidencia</th>
  		<th>Cliente</th>
  		<th>Pedido</th>
  		<th>Observaciones</th>
	</tr>',N'</table>',NULL,NULL,1,0,1,1)
 ,(N'inciCLIDefaultList',N'inciCLI',N'list',N'inciCLI Default List',N'<tr>
  <td>{{laFecha}}</td>
  <td>({{gestor}}) {{nGestor}}</td>
  <td>{{incidencia}} - {{nIncidencia}}</td>
  <td>({{cliente}}) {{nCliente}}</td>
  <td>{{pedido}}</td>
  <td>{{observaciones}}</td>
</tr>',NULL,NULL,N'<table id="tbInciCLI" class="tbStd">
  	<tr>
  		<th>Fecha</th>
  		<th>Gestor</th>
  		<th>Incidencia</th>
  		<th>Cliente</th>
  		<th>Pedido</th>
  		<th>Observaciones</th>
	</tr>',N'</table>',NULL,NULL,1,0,1,1)
 ,(N'PedidosPlantilla01',N'Pedido',N'list',N'Listado de Pedidos',N'<tr>
<td>{{numero}}</td>
<td>{{LETRA}}</td>
<td>{{FECHA}}</td>
<td class=''taR''>{{TOTALDOCformato}}</td>
</tr>',N'vPedidosOrderBySQLFECHAdesc',N'CLIENTE=''{{CODIGO}}''',N'<table class=''tbStd''>
<tr>
<th>Número</th>
<th>Serie</th>
<th>Fecha</th>
<th class=''taC''>Importe</th>
</tr>',N'</table>',NULL,NULL,0,0,1,1)
 ,(N'usuariosTV',N'sysUser',N'list',N'usuariosTV',N'<tr onclick="asignarGestor(''asignarGestor'',''{{Reference}}'',''{{Name}} {{SurName}}'',''{{UserName}}'')">
  <td>{{Name}}</td>
  <td>{{SurName}}</td>
  <td>{{UserName}}</td>
  <td>{{Reference}}</td>
</tr>',NULL,NULL,N'<table class="tbStd">
 <tr>
  <th>Nombre</th>
  <th>Apellidos</th>
  <th>Usuario</th>
  <th>Código</th>
</tr>',N'</table>',NULL,NULL,0,0,1,1)
) AS Source ([TemplateId],[ObjectName],[TypeId],[Descrip],[Body],[ViewName],[WhereSentence],[Header],[Footer],[Empty],[ModuleClass],[IsDefault],[Offline],[Active],[OriginId])
ON (Target.[TemplateId] = Source.[TemplateId])
WHEN MATCHED AND (
	NULLIF(Source.[ObjectName], Target.[ObjectName]) IS NOT NULL OR NULLIF(Target.[ObjectName], Source.[ObjectName]) IS NOT NULL OR 
	NULLIF(Source.[TypeId], Target.[TypeId]) IS NOT NULL OR NULLIF(Target.[TypeId], Source.[TypeId]) IS NOT NULL OR 
	NULLIF(Source.[Descrip], Target.[Descrip]) IS NOT NULL OR NULLIF(Target.[Descrip], Source.[Descrip]) IS NOT NULL OR 
	NULLIF(Source.[Body], Target.[Body]) IS NOT NULL OR NULLIF(Target.[Body], Source.[Body]) IS NOT NULL OR 
	NULLIF(Source.[ViewName], Target.[ViewName]) IS NOT NULL OR NULLIF(Target.[ViewName], Source.[ViewName]) IS NOT NULL OR 
	NULLIF(Source.[WhereSentence], Target.[WhereSentence]) IS NOT NULL OR NULLIF(Target.[WhereSentence], Source.[WhereSentence]) IS NOT NULL OR 
	NULLIF(Source.[Header], Target.[Header]) IS NOT NULL OR NULLIF(Target.[Header], Source.[Header]) IS NOT NULL OR 
	NULLIF(Source.[Footer], Target.[Footer]) IS NOT NULL OR NULLIF(Target.[Footer], Source.[Footer]) IS NOT NULL OR 
	NULLIF(Source.[Empty], Target.[Empty]) IS NOT NULL OR NULLIF(Target.[Empty], Source.[Empty]) IS NOT NULL OR 
	NULLIF(Source.[ModuleClass], Target.[ModuleClass]) IS NOT NULL OR NULLIF(Target.[ModuleClass], Source.[ModuleClass]) IS NOT NULL OR 
	NULLIF(Source.[IsDefault], Target.[IsDefault]) IS NOT NULL OR NULLIF(Target.[IsDefault], Source.[IsDefault]) IS NOT NULL OR 
	NULLIF(Source.[Offline], Target.[Offline]) IS NOT NULL OR NULLIF(Target.[Offline], Source.[Offline]) IS NOT NULL OR 
	NULLIF(Source.[Active], Target.[Active]) IS NOT NULL OR NULLIF(Target.[Active], Source.[Active]) IS NOT NULL OR 
	NULLIF(Source.[OriginId], Target.[OriginId]) IS NOT NULL OR NULLIF(Target.[OriginId], Source.[OriginId]) IS NOT NULL) THEN
 UPDATE SET
  [ObjectName] = Source.[ObjectName], 
  [TypeId] = Source.[TypeId], 
  [Descrip] = Source.[Descrip], 
  [Body] = Source.[Body], 
  [ViewName] = Source.[ViewName], 
  [WhereSentence] = Source.[WhereSentence], 
  [Header] = Source.[Header], 
  [Footer] = Source.[Footer], 
  [Empty] = Source.[Empty], 
  [ModuleClass] = Source.[ModuleClass], 
  [IsDefault] = Source.[IsDefault], 
  [Offline] = Source.[Offline], 
  [Active] = Source.[Active], 
  [OriginId] = Source.[OriginId]
WHEN NOT MATCHED BY TARGET THEN
 INSERT([TemplateId],[ObjectName],[TypeId],[Descrip],[Body],[ViewName],[WhereSentence],[Header],[Footer],[Empty],[ModuleClass],[IsDefault],[Offline],[Active],[OriginId])
 VALUES(Source.[TemplateId],Source.[ObjectName],Source.[TypeId],Source.[Descrip],Source.[Body],Source.[ViewName],Source.[WhereSentence],Source.[Header],Source.[Footer],Source.[Empty],Source.[ModuleClass],Source.[IsDefault],Source.[Offline],Source.[Active],Source.[OriginId])
WHEN NOT MATCHED BY SOURCE AND TARGET.OriginId = 1 THEN 
 DELETE
;
END TRY
BEGIN CATCH
    DECLARE @ERRORNUMBER	INT,@ERRORMSG		VARCHAR(MAX),@ERRORSTATE		INT
    SELECT @ERRORNUMBER = 50000 + ERROR_NUMBER(),@ERRORMSG = ERROR_MESSAGE(), @ERRORSTATE = ERROR_STATE();
    THROW @ERRORNUMBER, @ERRORMSG, @ERRORSTATE
END CATCH
GO





