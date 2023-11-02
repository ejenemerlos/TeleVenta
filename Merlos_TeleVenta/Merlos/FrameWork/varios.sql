


-----------------------------------------------------------------------------------
--#AUTHOR
--	JUAN CARLOS VILLALOBOS
--#NAME
--	pDatosVentasArticulosAgrupados
--#CREATION
--	04/10/2023
--#DESCRIPTION
--	Contactos clientes
--#PARAMETERS
--	@parametros
--#CHANGES
-- 04/10/2023 JUAN CARLOS VILLALOBOS Creacion del procedimiento
-------------------------------------------------------------------------------------

ALTER PROCEDURE [dbo].[pDatosVentasArticulosAgrupados](@parametros VARCHAR(MAX))
AS
	DECLARE @cliente VARCHAR(25),
			@fechaDesde VARCHAR(10),
			@fechaHasta VARCHAR(10),
			@empresa VARCHAR(2),
			@paginador int
            @ejerActual INT,
            @ejerPasado INT,
            @ejerDosAñosPasados INT
            @letraGestion VARCHAR(2),
            @gestionActual VARCHAR(10),
            @gestionPasada VARCHAR(10),
            @gestionDosAñosPasados VARCHAR(10),
            @cSQL VARCHAR(MAX),
            @cSQL1 VARCHAR(MAX),
            @cSQL2 VARCHAR(MAX),
            @cSQL3 VARCHAR(MAX)
	BEGIN TRY	
		BEGIN TRAN			
			SET @cliente=(SELECT JSON_VALUE(@parametros,'$.cliente'))
			SET @fechaDesde=(SELECT JSON_VALUE(@parametros,'$.fechaDesde'))
			SET @fechaHasta=(SELECT JSON_VALUE(@parametros,'$.fechaHasta'))
			SET @paginador=(SELECT JSON_VALUE(@parametros,'$.paginador'))
            SET @ejerActual=YEAR(GETDATE())
            SET @ejerPasado=@ejerActual-1
            SET @ejerDosAñosPasados=@ejerActual-2
            SET @gestionActual= CONCAT('[',@ejerActual,@letraGestion,']')
            SET @gestionPasada= CONCAT('[',@ejerPasado,@letraGestion,']')
            SET @gestionDosAñosPasados= CONCAT('[',@ejerActual,@ejerDosAñosPasados,']')
			SELECT @empresa=EMPRESA,@letraGestion=LETRA FROM Configuracion_SQL;
            SET @cSQL='WITH LatestPrices AS ('
            IF EXISTS(SELECT name FROM sys.databases WHERE name = CONCAT(@ejerActual,@letraGestion)) AND NOT EXISTS(SELECT name FROM sys.databases WHERE name = CONCAT(@ejerPasado,@letraGestion) AND NOT EXISTS (SELECT name FROM sys.databases WHERE name = CONCAT(@ejerDosAñosPasados,@letraGestion)))
                BEGIN
                    SET @cSQL1='SELECT  asd.ARTICULO, asd.precio, ROW_NUMBER() OVER(PARTITION BY asd.ARTICULO ORDER BY b.FECHA DESC) AS rn
					FROM ' + @gestionActual +'.dbo.d_pedive asd
					INNER JOIN  ' + @gestionActual +'.dbo.c_pedive b  ON  b.EMPRESA = asd.EMPRESA AND b.NUMERO = asd.NUMERO AND b.LETRA = asd.LETRA
					where asd.ARTICULO!='''' and b.TRASPEJER=0 and b.cliente=''' + @cliente + ''' and b.fecha between '''+ @fechaDesde+'''and  '''+@fechaHasta+''''

                    SET @cSQL2='SELECT  a.articulo, a.DEFINICION, SUM(a.unidades) as unidades,a.empresa, a.cliente, lp.precio
					FROM  ' + @gestionActual + '.dbo.d_pedive a
					INNER JOIN ' + @gestionActual + '.dbo.c_pedive b ON  b.EMPRESA = a.EMPRESA AND b.NUMERO = a.NUMERO AND b.LETRA = a.LETRA
					LEFT JOIN LatestPrices lp ON a.articulo = lp.ARTICULO AND lp.rn = 1
					WHERE A.ARTICULO<>'' and b.TRASPEJER=0 and and b.cliente=''' + @cliente + ''' and b.fecha between '''+ @fechaDesde+'''and  '''+@fechaHasta+'''
					GROUP BY a.articulo,a.DEFINICION, a.empresa,a.cliente, b.FECHA, lp.precio'
                END
            IF EXISTS(SELECT name FROM sys.databases WHERE name = CONCAT(@ejerActual,@letraGestion)) AND EXISTS(SELECT name FROM sys.databases WHERE name = CONCAT(@ejerPasado,@letraGestion) AND NOT EXISTS (SELECT name FROM sys.databases WHERE name = CONCAT(@ejerDosAñosPasados,@letraGestion)))
                BEGIN
                    SET @cSQL1='SELECT  asd.ARTICULO, asd.precio, ROW_NUMBER() OVER(PARTITION BY asd.ARTICULO ORDER BY b.FECHA DESC) AS rn
					FROM ' + @gestionActual +'.dbo.d_pedive asd
					INNER JOIN  ' + @gestionActual +'.dbo.c_pedive b  ON  b.EMPRESA = asd.EMPRESA AND b.NUMERO = asd.NUMERO AND b.LETRA = asd.LETRA
					where asd.ARTICULO!='''' and b.TRASPEJER=0 and b.cliente=''' + @cliente + ''' and b.fecha between '''+ @fechaDesde+'''and  '''+@fechaHasta+'''
                    UNION ALL'
                    SET @cSQL1 + 'SELECT  asd.ARTICULO, asd.precio, ROW_NUMBER() OVER(PARTITION BY asd.ARTICULO ORDER BY b.FECHA DESC) AS rn
					FROM ' + @gestionPasada +'.dbo.d_pedive asd
					INNER JOIN  ' + @gestionPasada +'.dbo.c_pedive b  ON  b.EMPRESA = asd.EMPRESA AND b.NUMERO = asd.NUMERO AND b.LETRA = asd.LETRA
					where asd.ARTICULO!='''' and b.TRASPEJER=0 and b.cliente=''' + @cliente + ''' and b.fecha between '''+ @fechaDesde+'''and  '''+@fechaHasta+''' '

                    SET @cSQL2='SELECT  a.articulo, a.DEFINICION, SUM(a.unidades) as unidades,a.empresa, a.cliente, lp.precio
					FROM  ' + @gestionActual + '.dbo.d_pedive a
					INNER JOIN ' + @gestionActual + '.dbo.c_pedive b ON  b.EMPRESA = a.EMPRESA AND b.NUMERO = a.NUMERO AND b.LETRA = a.LETRA
					LEFT JOIN LatestPrices lp ON a.articulo = lp.ARTICULO AND lp.rn = 1
					WHERE A.ARTICULO<>'' and b.TRASPEJER=0 and and b.cliente=''' + @cliente + ''' and b.fecha between '''+ @fechaDesde+'''and  '''+@fechaHasta+'''
					GROUP BY a.articulo,a.DEFINICION, a.empresa,a.cliente, b.FECHA, lp.precio
                    UNION ALL'
                    SET @cSQL2 + 'SELECT  a.articulo, a.DEFINICION, SUM(a.unidades) as unidades,a.empresa, a.cliente, lp.precio
					FROM  ' + @gestionPasada + '.dbo.d_pedive a
					INNER JOIN ' + @gestionPasada + '.dbo.c_pedive b ON  b.EMPRESA = a.EMPRESA AND b.NUMERO = a.NUMERO AND b.LETRA = a.LETRA
					LEFT JOIN LatestPrices lp ON a.articulo = lp.ARTICULO AND lp.rn = 1
					WHERE A.ARTICULO<>'' and b.TRASPEJER=0 and and b.cliente=''' + @cliente + ''' and b.fecha between '''+ @fechaDesde+'''and  '''+@fechaHasta+'''
					GROUP BY a.articulo,a.DEFINICION, a.empresa,a.cliente, b.FECHA, lp.precio'
                END            
            IF EXISTS(SELECT name FROM sys.databases WHERE name = CONCAT(@ejerActual,@letraGestion)) AND EXISTS(SELECT name FROM sys.databases WHERE name = CONCAT(@ejerPasado,@letraGestion) AND EXISTS (SELECT name FROM sys.databases WHERE name = CONCAT(@ejerDosAñosPasados,@letraGestion)))
                BEGIN
                    SET @cSQL1='SELECT  asd.ARTICULO, asd.precio, ROW_NUMBER() OVER(PARTITION BY asd.ARTICULO ORDER BY b.FECHA DESC) AS rn
					FROM ' + @gestionActual +'.dbo.d_pedive asd
					INNER JOIN  ' + @gestionActual +'.dbo.c_pedive b  ON  b.EMPRESA = asd.EMPRESA AND b.NUMERO = asd.NUMERO AND b.LETRA = asd.LETRA
					where asd.ARTICULO!='''' and b.TRASPEJER=0 and b.cliente=''' + @cliente + ''' and b.fecha between '''+ @fechaDesde+'''and  '''+@fechaHasta+'''
                    UNION ALL'
                    SET @cSQL1 + 'SELECT  asd.ARTICULO, asd.precio, ROW_NUMBER() OVER(PARTITION BY asd.ARTICULO ORDER BY b.FECHA DESC) AS rn
					FROM ' + @gestionPasada +'.dbo.d_pedive asd
					INNER JOIN  ' + @gestionPasada +'.dbo.c_pedive b  ON  b.EMPRESA = asd.EMPRESA AND b.NUMERO = asd.NUMERO AND b.LETRA = asd.LETRA
					where asd.ARTICULO!='''' and b.TRASPEJER=0 and b.cliente=''' + @cliente + ''' and b.fecha between '''+ @fechaDesde+'''and  '''+@fechaHasta+'''
                    UNION ALL '
                    SET @cSQL1 + 'SELECT  asd.ARTICULO, asd.precio, ROW_NUMBER() OVER(PARTITION BY asd.ARTICULO ORDER BY b.FECHA DESC) AS rn
					FROM ' + @gestionDosAñosPasados +'.dbo.d_pedive asd
					INNER JOIN  ' + @gestionDosAñosPasados +'.dbo.c_pedive b  ON  b.EMPRESA = asd.EMPRESA AND b.NUMERO = asd.NUMERO AND b.LETRA = asd.LETRA
					where asd.ARTICULO!='''' and b.TRASPEJER=0 and b.cliente=''' + @cliente + ''' and b.fecha between '''+ @fechaDesde+'''and  '''+@fechaHasta+'''
                    '

                    SET @cSQL2='SELECT  a.articulo, a.DEFINICION, SUM(a.unidades) as unidades,a.empresa, a.cliente, lp.precio
					FROM  ' + @gestionActual + '.dbo.d_pedive a
					INNER JOIN ' + @gestionActual + '.dbo.c_pedive b ON  b.EMPRESA = a.EMPRESA AND b.NUMERO = a.NUMERO AND b.LETRA = a.LETRA
					LEFT JOIN LatestPrices lp ON a.articulo = lp.ARTICULO AND lp.rn = 1
					WHERE A.ARTICULO<>'' and b.TRASPEJER=0 and and b.cliente=''' + @cliente + ''' and b.fecha between '''+ @fechaDesde+'''and  '''+@fechaHasta+'''
					GROUP BY a.articulo,a.DEFINICION, a.empresa,a.cliente, b.FECHA, lp.precio
                    UNION ALL'
                    SET @cSQL2 + 'SELECT  a.articulo, a.DEFINICION, SUM(a.unidades) as unidades,a.empresa, a.cliente, lp.precio
					FROM  ' + @gestionPasada + '.dbo.d_pedive a
					INNER JOIN ' + @gestionPasada + '.dbo.c_pedive b ON  b.EMPRESA = a.EMPRESA AND b.NUMERO = a.NUMERO AND b.LETRA = a.LETRA
					LEFT JOIN LatestPrices lp ON a.articulo = lp.ARTICULO AND lp.rn = 1
					WHERE A.ARTICULO<>'' and b.TRASPEJER=0 and and b.cliente=''' + @cliente + ''' and b.fecha between '''+ @fechaDesde+'''and  '''+@fechaHasta+'''
					GROUP BY a.articulo,a.DEFINICION, a.empresa,a.cliente, b.FECHA, lp.precio
                    UNION ALL'
                    SET @cSQL2+'SELECT  a.articulo, a.DEFINICION, SUM(a.unidades) as unidades,a.empresa, a.cliente, lp.precio
					FROM  ' + @gestionDosAñosPasados + '.dbo.d_pedive a
					INNER JOIN ' + @gestionDosAñosPasados + '.dbo.c_pedive b ON  b.EMPRESA = a.EMPRESA AND b.NUMERO = a.NUMERO AND b.LETRA = a.LETRA
					LEFT JOIN LatestPrices lp ON a.articulo = lp.ARTICULO AND lp.rn = 1
					WHERE A.ARTICULO<>'' and b.TRASPEJER=0 and and b.cliente=''' + @cliente + ''' and b.fecha between '''+ @fechaDesde+'''and  '''+@fechaHasta+'''
					GROUP BY a.articulo,a.DEFINICION, a.empresa,a.cliente, b.FECHA, lp.precio
                    UNION ALL'
                END    
            SET @cSQL=@cSQL+@CSQL1 + ')'
            
            SET @cSQL3= @cSQL + 'SELECT ISNULL((' + @cSQL2 + ') a
					group by a.articulo,a.DEFINICION, a.empresa,a.cliente, a.precio
					order by a.ARTICULO									
			FOR JSON AUTO),''[]'') AS JAVASCRIPT'

        EXEC(@cSQL3)
				
			
		COMMIT TRAN	
		RETURN -1
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT >0 BEGIN
			ROLLBACK TRAN 
		END
		DECLARE @CatchError NVARCHAR(MAX)
		SET @CatchError=CONCAT(ERROR_MESSAGE(),ERROR_NUMBER(),ERROR_PROCEDURE(),@@PROCID ,ERROR_LINE())
		RAISERROR(@CatchError,12,1) 
		RAISERROR(@CatchError,12,1) 
		RETURN 0
	END CATCH