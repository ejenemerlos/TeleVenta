﻿CREATE PROCEDURE [dbo].[01_CrearFunciones]
AS
SET NOCOUNT ON
BEGIN TRY	
-- ============================
--	Variables de configuración
-- ============================
	declare @GESTION	varchar(20)	 set @GESTION = '['+(select top 1 GESTION from Configuracion_SQL)+']'
	declare @GESTIONAnt varchar(20)	 set @GESTIONAnt = '['+ cast(cast((select top 1 EJERCICIO from Configuracion_SQL) as int)-1 as varchar)+']'
	declare @CAMPOS		varchar(10)  set @CAMPOS = '['+(select top 1 isnull(CAMPOS,'xxxxxx') from Configuracion_SQL)+']'
	declare @COMUN		varchar(10)  set @COMUN = '['+(select top 1 COMUN from Configuracion_SQL)+']'
	declare @ANY		char(4)		 set @ANY = (select top 1 EJERCICIO from Configuracion_SQL)
	declare @ANYLETRA	char(6)		 set @ANYLETRA = (select top 1 EJERCICIO +''+ LETRA from Configuracion_SQL)
	declare @EMPRESA	char(2)		 set @EMPRESA   = (select top 1 EMPRESA from Configuracion_SQL)
	declare @Sentencia	varchar(MAX)
-- ====================================================================================================================================

DECLARE @TMP_MI_PREUS TABLE
		( TIPO_PVP CHAR(8) COLLATE Modern_Spanish_CS_AI, PVP NUMERIC(15,6), DTO1 NUMERIC(15,6), DTO2 NUMERIC(15,6), IMPORTE NUMERIC(15,6) )


set @Sentencia = '
IF EXISTS ( SELECT  1
            FROM    Information_schema.Routines
            WHERE   Specific_schema = ''dbo''
                    AND specific_name = ''ftDonamPreu''
                    AND Routine_Type = ''FUNCTION'' ) drop function ftDonamPreu
					'
exec (@Sentencia)
set @Sentencia='
-- ACTIVAR PRUEBAS - COMENTAR JUSTO EN LA LÍNEA INFERIOR A ESTA
CREATE FUNCTION [dbo].[ftDonamPreu](@EMPRESA CHAR(2),@CLIENTE CHAR(20),@ARTICULO CHAR(20),@TARIFA CHAR(2),@UNIDADES NUMERIC(18,4) ,@FECHA SMALLDATETIME )
RETURNS @aPreus TABLE 
(
   --Columns returned by the function
   PVP numeric(15,6) NOT NULL DEFAULT(0), 
   DTO1 NUMERIC(15,6) NOT NULL DEFAULT(0), 
   DTO2 NUMERIC(15,6) NOT NULL DEFAULT(0),
   IDERROR INT
)
AS 
-- ACTIVAR PRUEBAS - COMENTAR JUSTO EN LA LÍNEA SUPERIOR A ESTA

BEGIN
-- ACTIVAR PRUEBAS - DESCOMENTAR JUSTO EN LA LÍNEA INFERIOR A ESTA
/*
--         SOLO PARA PRUEBAS!!!! COMENTAR PUNTO ANTERIOR DEL ALTER FUNCTION AL AS
-- PONER DATOS MANUALMENTE EN LAS VARIABLES DECLARADAS MÁS ABAJO
-- CREAR TABLA AA EN LA BBDD MERLOSTEMP CON LOS CAMPOS: PVP NUMERIC(15,6) / DTO1 NUMERIC(15,6) / DTO2 NUMERIC(15,6) / IDERROR INT / TIPO_PVP CHAR(8)
-- ACTIVAR INSERT A LA TABLA AA QUE HAY AL FINAL 
DECLARE @aPreus TABLE 
(
   --Columns returned by the function
   PVP numeric(15,6) NOT NULL DEFAULT(0), 
   DTO1 NUMERIC(15,6) NOT NULL DEFAULT(0), 
   DTO2 NUMERIC(15,6) NOT NULL DEFAULT(0),
   IDERROR INT
)

DECLARE @EMPRESA CHAR(2),@CLIENTE CHAR(20),@ARTICULO CHAR(20),@TARIFA CHAR(2),@UNIDADES NUMERIC(18,4) ,@FECHA SMALLDATETIME
SET @EMPRESA=''ZZ''
SET @CLIENTE=''43000033''
SET @ARTICULO=''ALIM0023''
SET @TARIFA=''''
SET @UNIDADES=45
SET @FECHA=GETDATE()

*/
-- ACTIVAR PRUEBAS - DESCOMENTAR JUSTO EN LA LÍNEA SUPERIOR A ESTA
' set @Sentencia = @Sentencia + '
    DECLARE 
        @PREU NUMERIC(15,6), 
        @DTO1 NUMERIC(15,6), 
        @DTO2 NUMERIC(15,6),
                        @FAMILIA VARCHAR(20),
                        @MARCA VARCHAR(20),
                        @SUBFAMILIA VARCHAR(20),
                        @TIPO_PVP AS CHAR(8),
                        @IMPORT NUMERIC(15,6),
                        @PRECIOTARIFA NUMERIC(15,6),
                        @ESCALADO BIT,
                        @StrFecha VARCHAR(8)
                        
            --INICIALIZAR VARIABLES

            SET @PREU = 0.0000
            SET @PRECIOTARIFA=0.0000
            SET @DTO1 = 0.00
            SET @DTO2 = 0.00
            SET @IMPORT=0.00
            SET @FAMILIA=''''
            SET @MARCA=''''
            SET @SUBFAMILIA=''''
            SET @TIPO_PVP=''''

            --Mirar empresa y Articulo
            IF COALESCE(@ARTICULO,'''') = '''' OR COALESCE(@EMPRESA,'''')='''' -- Si no hay articulo devuleve 0s
            BEGIN
                        INSERT @aPreus SELECT @PREU, @DTO1, @DTO2, 1
                        RETURN 
            END
            -- Mirar Tarifa
            IF COALESCE(@TARIFA,'''') = '''' 
            BEGIN
                        SELECT @TARIFA=TARIFA FROM vClientes WHERE CODIGO=@CLIENTE
                        IF @TARIFA = '''' SELECT @TARIFA=TARIFAPRET FROM vDatosEmpresa WHERE CODIGO=@EMPRESA
            END
            
            IF @FECHA IS NULL OR @FECHA=''''
                        BEGIN
                                    SET @StrFecha=CONVERT(VARCHAR(8), GETDATE(), 112)  -- Mirar Fecha

                        END
            ELSE
                        BEGIN
                                    SET @StrFecha=CONVERT(VARCHAR(8), @FECHA, 112) 
                        END
            IF @UNIDADES IS NULL SET @UNIDADES=0  -- Mirar Unidades
                        
            SELECT @FAMILIA=FAMILIA, @MARCA=MARCA, @SUBFAMILIA=SUBFAMILIA FROM vArticulos WHERE CODIGO=@ARTICULO -- Sacar Familia, Marca y Subfamilia del artículo
            
            DECLARE @TMP_MI_PREUS TABLE
                        ( TIPO_PVP CHAR(8) COLLATE Modern_Spanish_CS_AI, PVP NUMERIC(15,6), DTO1 NUMERIC(15,6), DTO2 NUMERIC(15,6), IMPORTE NUMERIC(15,6) )
' set @Sentencia = @Sentencia + '         
            -- CALCULAR EL PRECIO DE TARIFA
            SELECT @PREU=PVP FROM vPvp WHERE ARTICULO=@ARTICULO AND TARIFA=@TARIFA
            SET @PRECIOTARIFA=@PREU
            
            IF COALESCE(@CLIENTE,'''')=''''
            BEGIN
                        INSERT @aPreus SELECT @PREU, @DTO1, @DTO2, 2
                        RETURN
            END

            /* CALCULO DE PRECIOS Y DESCUENTOS */
                        --1.1 buscar precio con dto grales cliente (tabla clientes)
                        SELECT @DTO1=DESCU1, @DTO2=DESCU2 FROM vClientes WHERE CODIGO = @CLIENTE
                        SELECT @PREU=PVP FROM vPvp WHERE ARTICULO=@ARTICULO AND TARIFA=@TARIFA
                        SET @PRECIOTARIFA=@PREU
                        SET @IMPORT=@PREU*(1-(@DTO1/100))*(1-(@DTO2/100))
                        IF @DTO1<>0 OR @DTO2<>0 INSERT INTO @TMP_MI_PREUS SELECT ''CLI_GRAL'', @PREU, @DTO1, @DTO2, @IMPORT

                        --1.2. Buscar descuentos de clientes por articulo
                        INSERT INTO @TMP_MI_PREUS 
                        SELECT TOP 1 ''CLI_ARTI'' AS TIPO_PVP, (CASE WHEN PVP=0 THEN @PRECIOTARIFA ELSE PVP END) AS PVP, DTO1, DTO2,(CASE WHEN PVP=0 THEN @PRECIOTARIFA ELSE PVP END)*(1-(DTO1/100))*(1-(DTO2/100)) AS IMPORTE 
                        FROM vOfertas WHERE TIPO=''CLIENTE'' AND CLIENTE=@CLIENTE AND ARTICULO=@ARTICULO AND ARTICULO!='''' AND (@StrFecha BETWEEN FECHA_IN AND FECHA_FIN) AND (@UNIDADES BETWEEN UNI_INI AND UNI_FIN) ORDER BY IMPORTE ASC

                        --1.3 Buscar descuentos de cliente por familia
                        INSERT INTO @TMP_MI_PREUS 
                        SELECT TOP 1 ''CLI_FAMI'' AS TIPO_PVP, (CASE WHEN PVP=0 THEN @PRECIOTARIFA ELSE PVP END) AS PVP, DTO1, DTO2,(CASE WHEN PVP=0 THEN @PRECIOTARIFA ELSE PVP END)*(1-(DTO1/100))*(1-(DTO2/100)) AS IMPORTE 
                        FROM vOfertas WHERE TIPO=''CLIENTE'' AND CLIENTE=@CLIENTE AND FAMILIA=@FAMILIA AND FAMILIA!='''' AND (@StrFecha BETWEEN FECHA_IN AND FECHA_FIN) AND (@UNIDADES BETWEEN UNI_INI AND UNI_FIN) ORDER BY IMPORTE ASC

                        --1.4 Buscar descuentos de cliente por marca
                        INSERT INTO @TMP_MI_PREUS 
                        SELECT TOP 1 ''CLI_MARC'' AS TIPO_PVP, (CASE WHEN PVP=0 THEN @PRECIOTARIFA ELSE PVP END) AS PVP, DTO1, DTO2,(CASE WHEN PVP=0 THEN @PRECIOTARIFA ELSE PVP END)*(1-(DTO1/100))*(1-(DTO2/100)) AS IMPORTE 
                        FROM vOfertas WHERE TIPO=''CLIENTE'' AND CLIENTE=@CLIENTE AND MARCA=@MARCA AND MARCA!='''' AND (@StrFecha BETWEEN FECHA_IN AND FECHA_FIN) AND (@UNIDADES BETWEEN UNI_INI AND UNI_FIN) ORDER BY IMPORTE ASC

                        --1.5 Buscar descuentos de cliente por subfamilia
                        INSERT INTO @TMP_MI_PREUS 
                        SELECT TOP 1 ''CLI_SUBF'' AS TIPO_PVP, (CASE WHEN PVP=0 THEN @PRECIOTARIFA ELSE PVP END) AS PVP, DTO1, DTO2,(CASE WHEN PVP=0 THEN @PRECIOTARIFA ELSE PVP END)*(1-(DTO1/100))*(1-(DTO2/100)) AS IMPORTE 
                        FROM vOfertas WHERE TIPO=''CLIENTE'' AND CLIENTE=@CLIENTE AND SUBFAMILIA=@SUBFAMILIA AND SUBFAMILIA!='''' AND (@StrFecha BETWEEN FECHA_IN AND FECHA_FIN) AND (@UNIDADES BETWEEN UNI_INI AND UNI_FIN) ORDER BY IMPORTE ASC

                        --1.6 Buscar ofertas de articulos
                        INSERT INTO @TMP_MI_PREUS 
                        SELECT TOP 1 ''ART_OFER'' AS TIPO_PVP, (CASE WHEN PVP=0 THEN @PRECIOTARIFA ELSE PVP END) AS PVP, DTO1, DTO2,(CASE WHEN PVP=0 THEN @PRECIOTARIFA ELSE PVP END)*(1-(DTO1/100))*(1-(DTO2/100)) AS IMPORTE 
                        FROM vOfertas WHERE TIPO=''ARTICULO'' AND ARTICULO=@ARTICULO AND (@StrFecha BETWEEN FECHA_IN AND FECHA_FIN) AND (@UNIDADES BETWEEN UNI_INI AND UNI_FIN) ORDER BY IMPORTE ASC

                        --1.7 Buscar descuentos de familia
                        INSERT INTO @TMP_MI_PREUS 
                        SELECT TOP 1 ''DTO_FAMI'' AS TIPO_PVP, @PRECIOTARIFA AS PVP, [TAN] AS DTO1, 0 AS DTO2, @PRECIOTARIFA*(1-([TAN]/100)) AS IMPORTE 
                        FROM '+@COMUN+'.dbo.desc_fam WHERE FAMILIA=@FAMILIA AND (@StrFecha BETWEEN CONVERT(SMALLDATETIME,REPLACE(FECHA_INI,''00'',''01'')+''/''+RIGHT(YEAR(GETDATE()),2),3) AND CONVERT(SMALLDATETIME,FECHA_FIN+''/''+RIGHT(YEAR(GETDATE()),2),3)) AND (@UNIDADES BETWEEN UNI_INI AND UNI_FIN) AND [TAN]!=0.00 ORDER BY IMPORTE ASC

                        --1.8 Buscar descuentos de subfamilia
                        INSERT INTO @TMP_MI_PREUS 
                        SELECT TOP 1 ''DTO_SUBF'' AS TIPO_PVP, @PRECIOTARIFA AS PVP, [TAN] AS DTO1, 0 AS DTO2, @PRECIOTARIFA*(1-([TAN]/100)) AS IMPORTE 
                        FROM '+@COMUN+'.dbo.desc_sub WHERE SUBFAM=@SUBFAMILIA AND (@StrFecha BETWEEN CONVERT(SMALLDATETIME,REPLACE(FECHA_INI,''00'',''01'')+''/''+RIGHT(YEAR(GETDATE()),2),3) AND CONVERT(SMALLDATETIME,FECHA_FIN+''/''+RIGHT(YEAR(GETDATE()),2),3)) AND (@UNIDADES BETWEEN UNI_INI AND UNI_FIN) AND [TAN]!=0.00 ORDER BY IMPORTE ASC
            
                        
                        --1.9 Buscar descuentos de marca
                        INSERT INTO @TMP_MI_PREUS 
                        SELECT TOP 1 ''TAR_MARC'' AS TIPO_PVP, @PRECIOTARIFA AS PVP, descuen AS DTO1, 0 AS DTO2, @PRECIOTARIFA*(1-(descuen/100)) AS IMPORTE 
                        FROM vMarcas WHERE CODIGO=@MARCA AND descuen!=0.00 ORDER BY IMPORTE ASC
' set @Sentencia = @Sentencia + '
                        --1.10 Buscar descuentos de lineas de descuento por articulo
                        INSERT INTO @TMP_MI_PREUS 
                        SELECT TOP 1 ''L_D_ARTI'' AS TIPO_PVP, (CASE WHEN PVP=0 THEN @PRECIOTARIFA ELSE PVP END) AS PVP, DTO1, DTO2, (CASE WHEN PVP=0.00 THEN @PRECIOTARIFA ELSE PVP END)*(1-(DTO1/100))*(1-(DTO2/100)) AS IMPORTE  
                        FROM vOfertas WHERE TIPO=''LINDESC'' AND ARTICULO=@ARTICULO AND CLIENTE=@CLIENTE AND ARTICULO!='''' AND (@StrFecha BETWEEN FECHA_IN AND FECHA_FIN) AND (@UNIDADES BETWEEN UNI_INI AND UNI_FIN) ORDER BY IMPORTE ASC 

                        --1.11 Buscar descuentos de lineas de descuento por familia
                        INSERT INTO @TMP_MI_PREUS 
                        SELECT TOP 1 ''L_D_FAMI'' AS TIPO_PVP, (CASE WHEN PVP=0.00 THEN @PRECIOTARIFA ELSE PVP END) AS PVP, DTO1, DTO2, (CASE WHEN PVP=0.00 THEN @PRECIOTARIFA ELSE PVP END)*(1-(DTO1/100))*(1-(DTO2/100)) AS IMPORTE  
                        FROM vOfertas WHERE TIPO=''LINDESC'' AND FAMILIA=@FAMILIA AND CLIENTE=@CLIENTE AND FAMILIA!='''' AND (@StrFecha BETWEEN FECHA_IN AND FECHA_FIN) AND (@UNIDADES BETWEEN UNI_INI AND UNI_FIN) AND DTO1+DTO2!=0.00 ORDER BY IMPORTE ASC 

                        --1.12 Buscar descuentos de lineas de descuento por marca
                        INSERT INTO @TMP_MI_PREUS 
                        SELECT TOP 1 ''L_D_MARC'' AS TIPO_PVP, (CASE WHEN PVP=0.00 THEN @PRECIOTARIFA ELSE PVP END) AS PVP, DTO1, DTO2, (CASE WHEN PVP=0.00 THEN @PRECIOTARIFA ELSE PVP END)*(1-(DTO1/100))*(1-(DTO2/100)) AS IMPORTE  
                        FROM vOfertas WHERE TIPO=''LINDESC'' AND MARCA=@MARCA AND CLIENTE=@CLIENTE AND (@StrFecha BETWEEN FECHA_IN AND FECHA_FIN) AND (@UNIDADES BETWEEN UNI_INI AND UNI_FIN) AND MARCA!='''' AND DTO1+DTO2!=0.00  ORDER BY IMPORTE ASC 

                        --1.13 Buscar descuentos de lineas de descuento por subfamilia
                        INSERT INTO @TMP_MI_PREUS 
                        SELECT TOP 1 ''L_D_SUBF'' AS TIPO_PVP, (CASE WHEN PVP=0.00 THEN @PRECIOTARIFA ELSE PVP END) AS PVP, DTO1, DTO2, (CASE WHEN PVP=0.00 THEN @PRECIOTARIFA ELSE PVP END)*(1-(DTO1/100))*(1-(DTO2/100)) AS IMPORTE  
                        FROM vOfertas WHERE TIPO=''LINDESC'' AND SUBFAMILIA=@SUBFAMILIA  AND CLIENTE=@CLIENTE AND (@StrFecha BETWEEN FECHA_IN AND FECHA_FIN) AND (@UNIDADES BETWEEN UNI_INI AND UNI_FIN) AND SUBFAMILIA!='''' AND DTO1+DTO2!=0.00 ORDER BY IMPORTE ASC 

                        --1.14 Buscar descuentos de cliente por obra
                                    
                        --1.15 Buscar descuentos de cliente por raíz de familia

                        -- Añadir el precio de tarifa
                        INSERT INTO @TMP_MI_PREUS SELECT ''TARIFA'' AS TIPO_PVP, @PRECIOTARIFA AS PVP, 0 AS DTO1, 0 AS DTO2, @PRECIOTARIFA AS IMPORTE
            
            -- SELECT * FROM @TMP_MI_PREUS T

            /* DEVOLVER PRECIOS */
            --INSERT INTO [MERLOSTEMP].DBO.AA  (PVP, DTO1, DTO2, TIPO_PVP, IMPORTE) SELECT PVP,DTO1,DTO2, TIPO_PVP, IMPORTE FROM @TMP_MI_PREUS

            SELECT @ESCALADO=ESTADO FROM '+@COMUN+'.dbo.OPCEMP WHERE EMPRESA=@EMPRESA AND TIPO_OPC=''10027''  -- Mirar si se aplican precios escalados
            BEGIN
                        IF @ESCALADO=1 
                                    INSERT INTO @aPreus SELECT TOP 1 T.PVP,T.DTO1, T.DTO2, -1 FROM @TMP_MI_PREUS T INNER JOIN '+@COMUN+'.dbo.ESCALADO E ON E.CODIGO = T.TIPO_PVP WHERE T.PVP!=0.00 ORDER BY COALESCE(E.ORDEN,999) ASC

                        ELSE 
                                    INSERT INTO @aPreus SELECT TOP 1 PVP,DTO1,DTO2, -2 FROM @TMP_MI_PREUS WHERE PVP!=0.00 ORDER BY IMPORTE ASC

                        RETURN
            END
END
'

	exec (@Sentencia) 

	RETURN -1
END TRY

BEGIN CATCH	
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError=ERROR_MESSAGE()+char(13)+ERROR_NUMBER()+char(13)+ERROR_PROCEDURE()+char(13)+@@PROCID+char(13)+ERROR_LINE()
	RAISERROR(@CatchError,12,1)
	RETURN 0
END CATCH