<div style="padding:20px;">
	<table>
		<tr>
			<td><span class="flx-icon icon-vcard-2 azul3"></span></td>
			<td>
              <span class="azul3" style="font:14px arial;">Código:</span>
              <span id="spanClienteCodigo" class="azul3" style="font:14px arial;">{{CODIGO}}</span>
              <span id="spanClienteBaja" style="margin-left:30px; font:bold 14px arial; color:red;" class="{{BAJA|switch:[0:inv]}}">BAJA: {{FechaBaja}}</span>
            </td>
			<td id="tdGestores" rowspan="6" style="vertical-align:top; background:#EDEFF3; padding:10px; box-sizing:border-box;">
              <span class="azul3" style="font:14px arial;">Gestores</span>
			  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			  <span id="btnrAsignarGestor" class="flR"><span class="MIbotonBlue ml20" onclick="asignarGestor(); event.stopPropagation();">Asignar Gestor</span></span>
			  <span id="btnAsignarGestorAV" class="ml20 avTXT inv"></span>			  
			  <br><br><div id="dvGestoresCliente" style="max-height:60px; overflow:hidden; overflow-y:auto;"></div>
			</td>
		</tr>
		<tr>
			<td><span class="flx-icon icon-man azul2"></span></td>
			<td><span class="azul2" style="font:bold 16px arial;">{{NOMBRE}}</span></td>
		</tr>
		<tr>
			<td><span class="flx-icon icon-map-point"></span></td>
			<td><span style="font:12px arial;">{{DIRECCION}}</span></td>
		</tr>
		<tr>
			<td><span class="fa fa-map-o"></span></td>
			<td><span style="font:12px arial;">{{CP}} {{POBLACION}} {{PROVINCIA}}</span></td>
		</tr>
		<tr>
			<td><span class="flx-icon icon-phone"></span></td>
			<td colspan="3"><span style="font:12px arial;">{{TELEFONO|switch:[isnull:Sin Teléfono,:Sin Teléfono]}}</span></td>
		</tr>
		<tr>
			<td><span class="flx-icon icon-email"></span></td>
			<td><span style="font:12px arial;">{{EMAIL}}</span></td>
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
			<td><img id="imgDiaria" src="./Merlos/images/icoCheck_O.png" alt="1"> Diaria</td>
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
	
	$("#tbTablaDeLlamadas img").off().on("click",function(){  
		var elSRC = $(this).attr("src");
		if(elSRC==="./Merlos/images/icoCheck_O.png"){ 
			$(this).attr("src","./Merlos/images/icoCheck_I.png"); 
			var horaSel = "";
			$("#tbTablaDeLlamadas").find("input").each(function () { if($(this).val()!==""){ horaSel = $(this).val();} });
			$("#tbTablaDeLlamadas").find("img").each(function () {
				var imgId = $(this).attr("id"); var dia = imgId.split("img")[1]; var diaVal = "inp" + dia + "Horario";
				if ($(this).attr("src") === "./Merlos/images/icoCheck_I.png" && $("#" + diaVal).val() === "") { $("#" + diaVal).val(horaSel); }
			});
		}else{ 
			$(this).attr("src","./Merlos/images/icoCheck_O.png");  
			$("#tbTablaDeLlamadas").find("img").each(function () {
				var imgId = $(this).attr("id"); var dia = imgId.split("img")[1]; var diaVal = "inp" + dia + "Horario";
				if ($(this).attr("src") === "./Merlos/images/icoCheck_O.png") { $("#" + diaVal).val(""); }
			});
		}
	});
	
	$("#tbTablaDeLlamadas input").off().on("click",function(){ mostrarRelojEJG(this.id,true); });
	
	$("#tbTablaDeLlamadasPeriodo img").off().on("click",function(){	
		$("#tbTablaDeLlamadasPeriodo").find("img").each(function(){ $(this).attr("src","./Merlos/images/icoCheck_O.png"); });
		$(this).attr("src","./Merlos/images/icoCheck_I.png"); 
		$("#inpPeriodo").prop("disabled",true);
		var elId = $(this).prop("id");
		var elSRC = $(this).attr("src");
		//if(elId==="imgDiaria"){	$("#tbTablaDeLlamadas").find("img").each(function(){ $(this).attr("src","./Merlos/images/icoCheck_I.png"); }); }
		if(elId==="imgPeriodo"){ $("#inpPeriodo").prop("disabled",false); }
	});	
	
	function establecerHorarioDeLlamadas(){		
		var dia = "";
		var horario = "";
		var bit = 0;
		var js = "";
		var tipo = "";
		var periodo = parseInt($.trim($("#inpPeriodo").val()));
		var parar = false;
		if(isNaN(periodo)){ periodo=null; }
		
		if($("#imgPeriodo").attr("src")==="./Merlos/images/icoCheck_I.png" && periodo===null){ alert("Debes especificar los días del periodo!"); return; }
		
		$("#tbTablaDeLlamadas").find("img").each(function(){
			dia = $(this).attr("alt").toLowerCase();
			horario = $.trim($("#inp"+$(this).attr("alt")+"Horario").val());
			bit = 0;
			if($(this).attr("src")==="./Merlos/images/icoCheck_I.png"){ 
				bit=1; 
				if(horario===""){ parar = true; alert("Debes especificar el horario del "+dia+"!"); }
			}
			js += '{"dia":"'+dia+'","activo":'+bit+',"horario":"'+horario+'"}';
		}); 
		$("#tbTablaDeLlamadasPeriodo").find("img").each(function(){			
			if($(this).attr("src")==="./Merlos/images/icoCheck_I.png"){ tipo=$(this).attr("alt"); }			
		}); 
		js = '{"cliente":"{{CODIGO}}","dias":['+js.replace(/}{/g,"},{")+'],"tipo":"'+tipo+'","periodo":'+periodo+'}'; 
		if(parar){ return; }
		$("#btnGuardar").hide(); $("#btnGuardarAV").html(icoCargando16+" guardando...").fadeIn();
		flexygo.nav.execProcess('pClientesADI','',null,null,[{'key':'modo','value':'editar'},{'key':'elJS','value':js}],'modal640x480',false,$(this),function(ret){
			if(ret){
				$("#btnGuardarAV").html("guardado correcto!");
				setTimeout(function(){ $("#btnGuardarAV").hide(); $("#btnGuardar").fadeIn(); },2000);
			}
			else{ alert("Error SP: pClientesADI!!!"+JSON.stringify(ret)); }
		},false);
	}
	
	function cargarTablasDeLlamadas(){
		flexygo.nav.execProcess('pClientesADI','',null,null,[{'key':'modo','value':'cargarTablasDeLlamadas'},{'key':'elJS','value':"{{CODIGO}}"}],'modal640x480',false,$(this),function(ret){
			if(ret){ 
				if(ret.JSCode===""){ return; }
				var js = JSON.parse(ret.JSCode);
				if(js.length>0){
					for(var d in llDias){
						if(js[0][llDias[d]]){ 
							$("#img"+capitalizar(llDias[d])).attr("src","./Merlos/images/icoCheck_I.png"); 
							$("#inp"+capitalizar(llDias[d])+"Horario").val($.trim(js[0]["hora_"+llDias[d]])); 
						}
					}
					$("#tbTablaDeLlamadasPeriodo").find("img[alt='"+js[0].tipo_llama+"']").attr("src","./Merlos/images/icoCheck_I.png");
					if(js[0].tipo_llama===5){ $("#inpPeriodo").val(js[0].dias_period).prop("disabled",false); }
				}
			}else{ alert("Error SP: pClientesADI!!!"+JSON.stringify(ret)); }
		},false);
	}
	
	function asignarGestor(modo,gestor,n){ 
		if(modo){
			$("#btnrAsignarGestor").hide(); $("#btnAsignarGestorAV").html(icoCargando16+" asignando...").show(); 
			$("flx-module[modulename='usuariosTV']").stop().slideUp();
			var parametros = '{"modo":"'+modo+'","cliente":"{{CODIGO}}","gestor":"'+gestor+'","nGestor":"'+n+'",'+paramStd+'}';
			flexygo.nav.execProcess('pClienteDatos','',null,null,[{'key':'parametros','value':limpiarCadena(parametros)}],'modal640x480',false,$(this),function(ret){
				if(ret){
					flexygo.nav.openPage('view','Cliente','CODIGO=\'{{CODIGO}}\'','{\'CODIGO\':\'{{CODIGO}}\'}','current',false,$(this));
				}else{ alert("Error SP: pClienteDatos!!!"+JSON.stringify(ret)); }
			},false);
		}else{ $("flx-module[modulename='usuariosTV']").css("margin-top","-180px").stop().slideDown(); }		
	}
	
	function cargarGestoresCliente(gestoresDelCliente){
		$("#dvGestoresCliente").html("");
		var contenido = "";
		for(var i in gestoresDelCliente){ contenido +="<div>"
													+"	<div class='img16 icoAspa' "
													+"	onclick='asignarGestor(\"quitarGestor\",\""+gestoresDelCliente[i].gestor+"\",\""+gestoresDelCliente[i].nombreGestor+"\")'></div> "
													+"	&nbsp;&nbsp;&nbsp; "
													+	gestoresDelCliente[i].gestor+" - "+gestoresDelCliente[i].nombreGestor
													+"</div>"; }
		$("#dvGestoresCliente").html(contenido);
	}
	
	
	var gestoresDelCliente = "";
	try{ gestoresDelCliente = JSON.parse('{{gestores}}');}catch{} 
	if(gestoresDelCliente.length>0){ cargarGestoresCliente(gestoresDelCliente); }
	
	cargarTablasDeLlamadas();
</script>