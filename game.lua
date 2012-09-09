
--определ€ем модуль, при этом модуль видит глобальные переменные благодар€ package.seeall
module(..., package.seeall)

-- все сцены определ€ютс€ функцией new, котора€ возвращает группу, содержащую отображаемые объекты
function new()
	local gameGroup = display.newGroup()
	
	--им€ файла заднего фона
	local backgroundFilename1 = "images/floor.jpg"
	
	--загружаем модуль таракана
	local roach = require("roach")
	
	--группы позвол€ют манипулировать несколькими объектами сразу, при этом могут содержать другие группы
	local roaches = display.newGroup()
	
	--ƒве полезные функции из игры TurtleVSHares, которые пока никак не используютс€
	--ƒл€ сохранени€ произвольных данных в локальном хранилище
	--ќставил просто как пример
	--***************************************************

	-- saveValue() --> used for saving high score, etc.
	
	--***************************************************
	local saveValue = function( strFilename, strValue )
		-- will save specified value to specified file
		local theFile = strFilename
		local theValue = strValue
		
		local path = system.pathForFile( theFile, system.DocumentsDirectory )
		
		-- io.open opens a file at path. returns nil if no file found
		local file = io.open( path, "w+" )
		if file then
		   -- write game score to the text file
		   file:write( theValue )
		   io.close( file )
		end
	end
	
	--***************************************************

	-- loadValue() --> load saved value from file (returns loaded value as string)
	
	--***************************************************
	local loadValue = function( strFilename )
		-- will load specified file, or create new file if it doesn't exist		
		local theFile = strFilename		
		local path = system.pathForFile( theFile, system.DocumentsDirectory )
		
		-- io.open opens a file at path. returns nil if no file found
		local file = io.open( path, "r" )
		if file then
		   -- read all contents of file into a string
		   local contents = file:read( "*a" )
		   io.close( file )
		   return contents
		else
		   -- create file b/c it doesn't exist yet
		   file = io.open( path, "w" )
		   file:write( "0" )
		   io.close( file )
		   return "0"
		end
	end	
	
	-- рисует задний фон и добавл€ет его в общую группу
	local drawBackground = function()
		backgroundImage1 = display.newImageRect( "images/floor.jpg", 320, 568 )
		backgroundImage1.x = 160; backgroundImage1.y = 240
					
		gameGroup:insert( backgroundImage1 )		
	end
	
	-- переменные: когда рендерили предыдущий кадр, когда создали последнего таракана, с каким интервалом их создавать
	local last_frame_time
	local last_roach_create_time
	local delta_new_roach = 1000

	-- обработчик событи€ enterFrame - рисует очередной кадр
	local gameLoop = function(event)
		-- инициализируем переменные - изначально они равны nil
		-- event.time - врем€, прошедшее от запуска приложени€
		last_frame_time = last_frame_time or event.time
		last_roach_create_time = last_roach_create_time or event.time
		
		-- врем€ между предыдущим и текущим кадром... ну или 0 на самом первом кадре
		local delta = event.time - last_frame_time
		
		-- перебираем тараканов и обновл€ем каждого
		for i=1,roaches.numChildren do
			if roaches[i] then 
				-- передавать большое или неизвестное количество параметров массивом в луа очень удобно
				roaches[i]:objectLoop({ticks=event.time, delta=delta})
			end
		end
		
		-- если в тараканьей группе не более 100 объектов + пора уже создать нового - создаем
		if roaches.numChildren < 100 and last_roach_create_time < event.time - delta_new_roach then 
			-- rnum - тип таракана, соотв. их изображени€м r1.png, r2.png, r3.png
			roaches:insert( roach.new({ rnum = math.random(3), }) )
			
			-- запоминаем когда создали и мен€ем интервал чтобы придать динамики
			last_roach_create_time = event.time
			delta_new_roach = math.max(250, delta_new_roach - 20)
		end
	end
	
	--обработчик системных событий
	local onSystem = function( event )
		if event.type == "applicationSuspend" then
			-- на этом месте надо поставить игру на паузу - приложение свернули
		elseif event.type == "applicationExit" then
			if system.getInfo( "environment" ) == "device" then
				-- prevents iOS 4+ multi-tasking crashes
				os.exit()
			end
		end
	end
	
	--инициализаци€ игры
	local gameInit = function()
		-- задний фон
		drawBackground()	
		-- добавл€ем группу тараканов в общую
		gameGroup:insert(roaches)
		-- устанавливаем обработчики событий
		Runtime:addEventListener("enterFrame", gameLoop)
		Runtime:addEventListener( "system", onSystem )
	end
	
	-- удаление игры
	unloadMe = function()	
		-- убрать обработчики
		Runtime:removeEventListener( "enterFrame", gameLoop )
		Runtime:removeEventListener( "system", onSystem )
		
		-- удалить тараканов
		for i = roaches.numChildren,1,-1 do
			local child = roaches[i]
			child.parent:remove( child )
			child = nil
		end
		
		-- удалить все остальное из общей группы
		for i = gameGroup.numChildren,1,-1 do
			local child = gameGroup[i]
			child.parent:remove( child )
			child = nil
		end
	end
	
	gameInit()
	
	-- MUST return a display.newGroup()
	return gameGroup
end
