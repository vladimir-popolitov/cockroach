
--���������� ������, ��� ���� ������ ����� ���������� ���������� ��������� package.seeall
module(..., package.seeall)

-- ��� ����� ������������ �������� new, ������� ���������� ������, ���������� ������������ �������
function new()
	local gameGroup = display.newGroup()
	
	--��� ����� ������� ����
	local backgroundFilename1 = "images/floor.jpg"
	
	--��������� ������ ��������
	local roach = require("roach")
	
	--������ ��������� �������������� ����������� ��������� �����, ��� ���� ����� ��������� ������ ������
	local roaches = display.newGroup()
	
	--��� �������� ������� �� ���� TurtleVSHares, ������� ���� ����� �� ������������
	--��� ���������� ������������ ������ � ��������� ���������
	--������� ������ ��� ������
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
	
	-- ������ ������ ��� � ��������� ��� � ����� ������
	local drawBackground = function()
		backgroundImage1 = display.newImageRect( "images/floor.jpg", 320, 568 )
		backgroundImage1.x = 160; backgroundImage1.y = 240
					
		gameGroup:insert( backgroundImage1 )		
	end
	
	-- ����������: ����� ��������� ���������� ����, ����� ������� ���������� ��������, � ����� ���������� �� ���������
	local last_frame_time
	local last_roach_create_time
	local delta_new_roach = 1000

	-- ���������� ������� enterFrame - ������ ��������� ����
	local gameLoop = function(event)
		-- �������������� ���������� - ���������� ��� ����� nil
		-- event.time - �����, ��������� �� ������� ����������
		last_frame_time = last_frame_time or event.time
		last_roach_create_time = last_roach_create_time or event.time
		
		-- ����� ����� ���������� � ������� ������... �� ��� 0 �� ����� ������ �����
		local delta = event.time - last_frame_time
		
		-- ���������� ��������� � ��������� �������
		for i=1,roaches.numChildren do
			if roaches[i] then 
				-- ���������� ������� ��� ����������� ���������� ���������� �������� � ��� ����� ������
				roaches[i]:objectLoop({ticks=event.time, delta=delta})
			end
		end
		
		-- ���� � ���������� ������ �� ����� 100 �������� + ���� ��� ������� ������ - �������
		if roaches.numChildren < 100 and last_roach_create_time < event.time - delta_new_roach then 
			-- rnum - ��� ��������, �����. �� ������������ r1.png, r2.png, r3.png
			roaches:insert( roach.new({ rnum = math.random(3), }) )
			
			-- ���������� ����� ������� � ������ �������� ����� ������� ��������
			last_roach_create_time = event.time
			delta_new_roach = math.max(250, delta_new_roach - 20)
		end
	end
	
	--���������� ��������� �������
	local onSystem = function( event )
		if event.type == "applicationSuspend" then
			-- �� ���� ����� ���� ��������� ���� �� ����� - ���������� ��������
		elseif event.type == "applicationExit" then
			if system.getInfo( "environment" ) == "device" then
				-- prevents iOS 4+ multi-tasking crashes
				os.exit()
			end
		end
	end
	
	--������������� ����
	local gameInit = function()
		-- ������ ���
		drawBackground()	
		-- ��������� ������ ��������� � �����
		gameGroup:insert(roaches)
		-- ������������� ����������� �������
		Runtime:addEventListener("enterFrame", gameLoop)
		Runtime:addEventListener( "system", onSystem )
	end
	
	-- �������� ����
	unloadMe = function()	
		-- ������ �����������
		Runtime:removeEventListener( "enterFrame", gameLoop )
		Runtime:removeEventListener( "system", onSystem )
		
		-- ������� ���������
		for i = roaches.numChildren,1,-1 do
			local child = roaches[i]
			child.parent:remove( child )
			child = nil
		end
		
		-- ������� ��� ��������� �� ����� ������
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
