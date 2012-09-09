
--���������� ������, ��� ���� ������ ����� ���������� ���������� ��������� package.seeall
module(..., package.seeall)

-- ��� ����� ������������ �������� new, ������� ���������� ������, ���������� ������������ �������
function new()
	local menuGroup = display.newGroup()
	
	-- ��������� ������ ui
	local ui = require("ui")
	
	-- ���������� ��� �������� ������ � ����� �������.
	-- ��� ������������ ���� � ���� )
	local playTween
	local tapSound = audio.loadSound( "sounds/tapsound.wav" )
	
	-- ������� ������� ������ ����
	local drawScreen = function()
		-- ��������� ���
		local backgroundImage = display.newImageRect( "images/mainmenu.png", 320, 568 )
		backgroundImage.x = 160; backgroundImage.y = 240
		
		--��������� ��� � �������� ������
		menuGroup:insert( backgroundImage )
				
		--���������� ��� ������
		local playBtn
		
		--���������� ������� �������
		local onPlayTouch = function( event )
			-- ����: ���������, � ��� ���� ������� ������
			if event.phase == "release" and playBtn.isActive then				
				--������ ����
				audio.play( tapSound )
				playBtn.isActive = false
				
				--��������� � ��������� �����. ������ �������� - ��� ��������
				director:changeScene( "game", "overFromRight" )
			end
		end
		
		--������� ������. ����� ���������� - �������� �������� � ����������� ���������, �������, ���������� �������, � ��
		playBtn = ui.newButton{
			defaultSrc = "images/playButton.png",
			defaultX = 260,
			defaultY = 70,
			overSrc = "images/playOver.png",
			overX = 260,
			overY = 70,
			onEvent = onPlayTouch,
			id = "PlayButton",
			text = "",
			font = "Helvetica",
			textColor = { 255, 255, 255, 255 },
			size = 0,
			emboss = false
		}
		
		-- ������� �������� ��� ������ ����������� ����� ������
		playBtn:setReferencePoint( display.BottomCenterReferencePoint )
		playBtn.x = 156 playBtn.y = 700
		
		-- ��������� � ����� ������
		menuGroup:insert( playBtn )		
		
		-- �������� ������������ ������
		playTween = transition.to( playBtn, { time=1000, y=400, rotation=3, transition=easing.inOutExpo } )	
	end
	
	drawScreen()
		
	--���� ����������, ������� ��������, �����, � ��� ������������ �������
	unloadMe = function()
		if playTween then transition.cancel( playTween ); end		
		if tapSound then audio.dispose( tapSound ); end
		for i = menuGroup.numChildren,1,-1 do
			local child = menuGroup[i]
			child.parent:remove( child )
			child = nil
		end
	end
	
	-- MUST return a display.newGroup()
	return menuGroup
end
