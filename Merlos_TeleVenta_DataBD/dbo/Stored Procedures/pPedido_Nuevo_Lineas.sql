CREATE PROCEDURE [dbo].[pPedido_Nuevo_Lineas] @parametros varchar(max), @respuesta varchar(max)='' output	
AS
BEGIN TRY 
	/**/ insert into Merlos_Log (accion) values (concat('[pPedido_Nuevo_Lineas] ''', @parametros, ''''))

	declare @IdTransaccion varchar(50) = isnull((select JSON_VALUE(@parametros,'$.IdTransaccion')),'')  
		,	@UserLogin varchar(50) = isnull((select JSON_VALUE(@parametros,'$.UserLogin')),'')  
		,	@UserID varchar(50) = isnull((select JSON_VALUE(@parametros,'$.UserID')),'')  
		,	@UserName varchar(50) = isnull((select JSON_VALUE(@parametros,'$.UserName')),'')  
		,	@currentReference varchar(50) = isnull((select JSON_VALUE(@parametros,'$.currentReference')),'')  
		,	@sentencia varchar(max) = ''

	--------------------------------------------------------------------------------------------------------------
	--	Insertar Registro	
	declare @la varchar(max)
	declare @er varchar(max)
	/**/ set @la = ' -00901- ----------------------------------------------------------- inicio de [pPedido_Nuevo_Lineas] '	exec [pMerlos_LOG] @accion=@la
	/**/ set @la = concat('-00901A-[pPedido_Nuevo_Lineas] @parametros ',@parametros)	exec [pMerlos_LOG] @accion=@la

	-- reasignar números de línea
	;WITH CTE AS (
		SELECT id, linea, ROW_NUMBER() OVER (ORDER BY linea) AS linea_nueva
		from Temp_Pedido_Detalle
		where IdTransaccion=@IdTransaccion
	)
	UPDATE CTE SET linea = linea_nueva;


	begin try
		INSERT INTO [2023YB].[DBO].d_pedive (usuario, empresa, numero, linia, articulo, definicion, unidades, precio, dto1, dto2
					, importe, tipo_iva, coste, cliente, precioiva, importeiva, cajas, familia, preciodiv, importediv, peso, letra
					, impdiviva, prediviva, RECARG, PVERDE)
		select t.UserName
			, t.empresa
			, t.numero
			, t.linea
			, t.articulo
			, t.descrip
			, t.unidades
			, t.precio
			, t.dto1
			, t.dto2
			, 0.00 as importe
			, case when t.articulo=''
				then ''
				else case when cli.tipo_iva!='' 
					then cli.TIPO_IVA 
					else art.TIPO_IVA 
					end 
				end as tipo_iva
			, coalesce(art.COST_ULT1,0.00) as coste
			, c.cliente
			, 0.00 as precioiva
			, 0.00 as importeiva
			, t.cajas
			, coalesce(art.familia,'') as familia
			, t.precio
			, t.importeiva
			, t.peso, t.letra
			, '0' as impdiviva
			, '0' as prediviva
			, case when t.articulo=''
				then 0.00
				else
					case when cli.RECARGO=1 
						then 
							1
						else	
							0
					end
			end as recargo
			, case when coalesce(art.pverde,0) =1 and coalesce(art.p_tan,0)=2 and cli.PVERDE=0 
				then case when t.peso>0
					then t.peso * coalesce(art.P_IMPORTE,0.00)
					else
						t.unidades * coalesce(art.P_IMPORTE,0.00)
					end
				else
					0.00
			end as costeresiduo

			 
		from Temp_Pedido_Detalle t
		INNER JOIN Temp_Pedido_Cabecera c on c.IdTransaccion=t.IdTransaccion
		inner join [2023YB].dbo.clientes cli on cli.CODIGO=c.cliente collate Modern_Spanish_CS_AI
		left join [2023YB].dbo.articulo art on art.CODIGO=t.articulo collate Modern_Spanish_CS_AI
		left join [2023YB].dbo.tipo_iva iva on iva.CODIGO =  case when cli.tipo_iva!='' then cli.TIPO_IVA else art.tipo_iva end
		where t.IdTransaccion=@IdTransaccion
	end try
	begin catch
		set @la = ' -00901E- Error al insertar línea de pedido'	
		set @er = ERROR_MESSAGE()
		exec [pMerlos_LOG] @accion=@la, @error = @er

		BEGIN TRY
			-- Enviar correo
			DECLARE @EMAILMENSAJE NVARCHAR(max), @EMAILASUNTO NVARCHAR(50)	
			SET @EMAILASUNTO = 'Disteco - TELEVENTA - Error [pPedido_Nuevo] !!!'
			SET @EMAILMENSAJE = concat('
				Disteco - TELEVENTA - Error [pPedido_Nuevo_Lineas] !!!		
				',CAST(FORMAT(getdate(),'dd-MM-yyyy HH:mm') as varchar(50)),'		

				-----------------------------------------------------------------

				tabla: Temp_Pedido_Detalle - IdTransaccion: ',@IdTransaccion,'

				-----------------------------------------------------------------

				@ERROR_MESSAGE():
				',ERROR_MESSAGE(),'
			')

			EXEC msdb.dbo.sp_send_dbmail
			@profile_name = 'Disteco',
			@recipients = 'e.jene@merlos.net;jc.villalobos@merlos.net',
			@body = @EMAILMENSAJE,
			@subject = @EMAILASUNTO
		END TRY BEGIN CATCH END CATCH

	end catch

	/**/ set @la = ' -00902- '	exec [pMerlos_LOG] @accion=@la	

	-- incidencias de artículos
	insert into TeleVentaIncidencias (id,gestor,tipo,incidencia,cliente,idpedido,articulo,observaciones) 
		select IdTeleventa, UserReference,'Articulo',incidencia,cliente,IdPedido,articulo,observacion
		from [Temp_Pedido_Detalle] 
		where IdTransaccion=@IdTransaccion and (incidencia is not null or (observacion is not null and observacion<>''))

	-- camposAD
	IF OBJECT_ID('[CAMPOSYB].dbo.D_PEDIVEEW') IS NOT NULL BEGIN
		insert into [CAMPOSYB].dbo.d_pediveew (ejercicio, empresa, numero, letra, linia)
		select Ejercicio, empresa, numero, letra, linea from [Temp_Pedido_Detalle] where IdTransaccion=@IdTransaccion
	END
	
	-- actualizar marcas de proceso
	update Temp_pedido_Cabecera set estado=1 where IdTransaccion=@IdTransaccion
	update Temp_pedido_Detalle  set estado=1 where IdTransaccion=@IdTransaccion

	/**/ set @la = ' -00907- '	exec [pMerlos_LOG] @accion=@la

	RETURN -1  
END TRY
BEGIN CATCH
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError=ERROR_MESSAGE()+char(13)+ERROR_NUMBER()+char(13)+ERROR_PROCEDURE()+char(13)+@@PROCID+char(13)+ERROR_LINE()
	RAISERROR(@CatchError,12,1)
	RETURN 0
END CATCH


