use ahorcado;

create proc PalabraAleatoria
@tipojuego int,
@nivel int,
@jugador1 int,
@jugador2 int
as
begin
	declare @palabra varchar(30);
	declare @palabraX varchar (30);
	declare @idpalabra int;	
	declare @jugador int;	
	if @jugador2 is null
			begin
			rep:
			set @idpalabra= (select top 1 id_palabra from palabras where id_dificultad=@nivel  order by NEWID());
			if exists (select id_palabra from palabras_jugador where id_palabra =@idpalabra and id_jugador=@jugador1)
				begin
				goto rep;
				end;
			else
				begin	
				select @palabra = palabra from palabras where id_palabra=@idpalabra; 
				set @palabraX = dbo.retornaRayas (@palabra);
				update juego set id_palabra=@idpalabra where jugador1 = @jugador1 and estado =1;
				update partida set palabraconrayas = @palabraX where jugador1 = @jugador1 and estado =1;
				insert into palabras_jugador values (@jugador1,@idpalabra);
				end;				 
			end ;
	else 
		begin
			set @palabra= (select top 1 palabra from palabras where id_dificultad = @nivel and palabra not in (select palabra
			from palabras_jugador where id_jugador=@jugador1 or id_jugador = @jugador2 )order by NEWID());	
			set @palabraX = dbo.retornaRayas (@palabra);
			select @idpalabra = id_palabra from palabras where palabra=@palabra; 
			update juego set id_palabra=@idpalabra where jugador1 = @jugador1 and jugador2=@jugador2 and estado =1;
			update partida set palabraconrayas = @palabraX where jugador1 = @jugador1 and jugador2=@jugador2  and estado =1;
			insert into palabras_jugador values (@jugador1,@idpalabra);
			insert into palabras_jugador values (@jugador2,@idpalabra);
		end;
end;

create function retornaRayas (@palabra varchar(30))
returns varchar(30)
as
begin
	declare @valorRetorno varchar(30);
	declare @cantidadLetras int;
	declare @indice int;
	set  @valorRetorno = '';
	set @indice = 1;
	set @cantidadLetras = len( @palabra ); 
		while @indice <= @cantidadLetras
		begin 
			set @valorRetorno = @valorRetorno + ' _';
		set @indice = @indice + 1;
		end; 
   return ( @valorRetorno );
end;

create procedure monito
@intento int
as
begin
declare @1 varchar(2);
declare @2 varchar(2);
declare @3 varchar(2);
declare @4 varchar(2);
declare @5 varchar(2);
declare @6 varchar(2);
set @1=' O';
set @2='/';
set @3=' |';
set @4=' \';
set @5=' /';
set @6=' \';
if @intento >=0
	begin
		if @intento = 5
			begin
			set @6 = ' ';
			end;
		if @intento = 4
			begin
			set @6 = ' ';set @5 = ' ';
			end;
		if @intento = 3
			begin
			set @6 = ' ';set @5 = ' ';set @4 = ' ';
			end;
		if @intento = 2
			begin
			set @6 = ' ';set @5 = ' ';set @4 = ' ';set @3 = ' ';
			end;
		if @intento = 1
			begin
			set @6 = ' ';set @5 = ' ';set @4 = ' ';set @3 = ' ';set @2 = ' ';
			end;
		if @intento = 0
			begin
			set @6 = ' ';set @5 = ' ';set @4 = ' ';set @3 = ' ';set @2 = ' ';set @1 = ' ';
			end;
	end;

print ' '+@1+CHAR(10)+@2+@3+@4+CHAR(13)+@5+@6
end;

create trigger estadojuego
on juego
instead of insert
as
begin
	declare @jugador1 int;
	declare @jugador2 int;
	declare @tipojuego int;
	select @jugador1= i.jugador1 from inserted i;
	select @jugador2= i.jugador2 from inserted i;
	select @tipojuego= null;
	if @jugador2 is null
		begin
			set @tipojuego= 1;
			if exists(select id_palabra from juego where jugador1 = @jugador1 and estado =1)
				begin
					print 'Este jugador ya tiene partidas activas'
					print 'Por favor continue con su juego ejecutando el comando exec jugar' 
				end;
			else
				begin
					if exists(select id_palabra from juego where jugador1 = @jugador1 and estado = 2)
						begin
						print 'Su juego esta pausado para reanudar use el comando exec estados + numero jugador'
						end;
					else
						begin
						insert into juego(tipo_juego,jugador1,jugador2,numintento,estado) values (@tipojuego,@jugador1,null,6,1);
						insert into partida(jugador1,jugador2,tipo_juego,estado) values (@jugador1,null,1,1);	
						end;
				end;
		end;	
	else
		begin
		if exists(select id_palabra from juego where jugador1 = @jugador1 and estado =1) or 
			exists(select id_palabra from juego where jugador2 = @jugador2 and estado = 1)
			begin
				print 'Ya hay partidas activas de estos jugadores'
				print 'Por favor continue con su juego ejecutando el comando exec jugar'
			end;
		else
			begin
			if exists(select id_palabra from juego where jugador1 = @jugador1 and estado = 2) or 
			exists(select id_palabra from juego where jugador2 = @jugador2 and estado = 2)
				begin
				print 'Ya hay partidas pausadas de estos jugadores'				
				print 'Su juego esta pausado para reanudar use el comando exec estados + numero jugador'
				end;
			else
				begin					
				insert into juego(tipo_juego,jugador1,jugador2,numintento,estado) values (@tipojuego,@jugador1,@jugador2,6,1);
				insert into partida(jugador1,jugador2,tipo_juego,estado) values (@jugador1,@jugador2,1,1)	
				end;
			end;
		end;
end;


alter procedure logueo
@nombre varchar (30),
@apellido varchar (50)
as
begin
	if exists (select * from jugador where nombre=@nombre and apellido = @apellido)
		begin
			declare @id int;
			select @id= id_jugador from jugador where nombre=@nombre and apellido = @apellido;
			print 'Este Jugador ya esta registrado';
			print concat ('Su ID es:',@id);
		end;
	else
		begin	
		insert into jugador values (@nombre,@apellido,1,0);
		print concat('Bienvenido ',@nombre,' ',@apellido)
		print 'Ya esta registrado y puede empezar a jugar'
		end;
end;

create proc iniciar
@jugador1 int,
@jugador2 int
as
begin 
	set nocount on	
	declare @palabra varchar (30);
	declare @palabraX varchar (30);
	declare @idpalabra int;
	declare @idjuego int;
	declare @tipojuego int;
	declare @nivel int;
	set @tipojuego = null;
	if exists (select * from jugador where id_jugador =@jugador1) 
	begin 
		if @jugador2 is null
			begin
			set @tipojuego =1;
			insert into juego values (@tipojuego,@jugador1,null,null,6,1);			
			end;
		else
			begin 
				if exists (select * from jugador where id_jugador = @jugador2)
					begin
					set @tipojuego =2;
					insert into juego values (@tipojuego,@jugador1,@jugador2,null,6,1);
					end;
				else
					begin
					print 'el segundo jugador no esta registrado'
					end;
			end;
		if @tipojuego =1 
			begin
				set @idpalabra =(select id_palabra from juego where jugador1=@jugador1 and estado=1)
				if @idpalabra is null
					begin
						select @nivel = nivel from jugador where id_jugador=@jugador1;
						exec PalabraAleatoria @tipojuego,@nivel,@jugador1,null;				
						select @palabraX = palabraconrayas from partida where jugador1 = @jugador1 and estado =1;
						select @idpalabra = p.id_palabra from palabras p inner join juego j on(p.id_palabra=j.id_palabra) 
							where j.jugador1 = @jugador1 and estado =1;
						select @idjuego= id_juego from juego where jugador1=@jugador1 and id_palabra = @idpalabra;	
						update partida set id_juego = @idjuego where jugador1 = @jugador1 and estado =1;
						print 'JUEGO DEL AHORCADO'
						exec monito 6
						print ' '
						print @palabraX;				
					end;
			end;	
		if @tipojuego = 2
			begin				
				if (select nivel from jugador where id_jugador=@jugador1)>(select nivel from jugador where id_jugador=@jugador2)
					begin	
					select @nivel= nivel from jugador where id_jugador=@jugador2;					
					end;
				else				
					begin	
					select @nivel= nivel from jugador where id_jugador=@jugador1;				
					end;				
				exec PalabraAleatoria @tipojuego,@nivel,@jugador1,@jugador2;							
				select @palabraX = palabraconrayas from partida where jugador2 is not null and estado =1;
				print 'JUEGO DEL AHORCADO'
				exec monito 6
				print ' '
				print @palabraX;					
			end;	
		end;
	else 
		begin
		print 'Para iniciar un juego debe estar registrado' 
		end;
end;

create proc jugar 
@jugador int,
@letra varchar(30) 
as 
begin
	set nocount on
	declare @palabra varchar (30);
	declare @palabraX varchar (30);	
	declare @idpalabra int;
	declare @idjuego int;
	declare @pos varchar(5);
	declare @intento int; 	
	declare @id int;		
	declare @id2 int;		
	declare @resultado varchar(30);
	declare @posicion varchar(5);
	set @id =1;
	set @id2 =1;
	select @idpalabra = p.id_palabra from palabras p inner join juego j on(p.id_palabra=j.id_palabra) where j.jugador1 = @jugador and estado =1;
	select @palabra = palabra from palabras where id_palabra = @idpalabra;
	select @palabraX=palabraconrayas from partida where jugador1=@jugador and estado =1;
	select @idjuego= id_juego from partida where jugador1 = @jugador and estado =1;
	select @resultado ='';
	select @intento = numintento from juego where jugador1=@jugador and estado =1;
	if exists (select id_palabra from juego where jugador1=@jugador and estado =1)
	begin
	if @intento>0
		begin
		if @letra = @palabra 
			begin
				print 'Felicidades ha ganado';
				print 'Su palabra era '+@palabra;
				update partida set estado =3,palabraconrayas=@letra where jugador1= @jugador and estado=1;
				update juego set estado = 3 where jugador1= @jugador and estado=1;
				update jugador set puntaje = puntaje + 5 where id_jugador=@jugador;
				insert into intento values(@idjuego,@jugador,@letra,1)
				print 'Me salve !!!';					 
			end;
		else
			begin 
				if len(rtrim(ltrim(@letra))) = 1	
				 begin
					if CHARINDEX (@letra,@palabra)=0
						begin							
							set @intento = @intento-1;
							insert into intento values(@idjuego,@jugador,@letra,0)
							update juego set numintento=@intento where jugador1= @jugador and estado=1;		
							print concat('Te quedan ',@intento,' intentos');
						 end;
					 else 		
						begin
							while @id <=len(@palabra)
							begin								
								select @pos= SUBSTRING(@palabra,@id,1)	
								select @posicion = SUBSTRING (@palabraX,@id*2,1)							
									begin									
									if @letra=@pos
										begin
										select @resultado = @resultado + ' '+ @letra;						
										end;
									else			
										begin
										select @resultado = @resultado + ' '+@posicion
										end;																	
									end;								
								set @id = @id+1;			
							end;
								insert into intento values(@idjuego,@jugador,@letra,1)
								update partida set palabraconrayas = @resultado where jugador1= @jugador and estado=1;								
								update partida set estado =3,palabraconrayas=@letra where jugador1= @jugador and estado=1;
								update juego set estado = 3 where jugador1= @jugador and estado=1;		
								goto final;						
						end;	
				 end						
				else	
					begin
						set @intento = @intento-1;
						insert into intento values(@idjuego,@jugador,@letra,0)
						update juego set numintento=@intento where jugador1= @jugador and estado=1;				
						print concat('Te quedan ',@intento,' intentos');
					end;
				end;					
		end
	if @intento =0
		begin
			print 'Perdiste!!! Intentalo nuevamente'
			print ' U.U ';
			update partida set estado =3 where jugador1= @jugador and estado=1;
			update juego set estado = 3 where jugador1= @jugador and estado=1;
			goto final;
		end;
	end;
	else
		begin
			print 'Debe Iniciar un juego nuevo'	;
			goto final
		end;
	print 'JUEGO DEL AHORCADO';
	exec monito @intento;
	select @palabraX=palabraconrayas from partida where jugador1=@jugador and estado =1;	
	final:
	print @palabraX
end;

exec logueo 'visto','navarro'

exec iniciar 1,2

exec jugar 1,'n'