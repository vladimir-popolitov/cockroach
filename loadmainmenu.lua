
--���������� ������, ��� ���� ������ ����� ���������� ���������� ��������� package.seeall
module(..., package.seeall)

-- ��� ����� ������������ �������� new, ������� ���������� ������, ���������� ������������ �������
function new()
	local localGroup = display.newGroup()
	
	--���������� ��� ������� � �������� "loading"
	local theTimer
	local loadingImage
	
	local showLoadingScreen = function()
		-- ��������� � ���������� ��������
		loadingImage = display.newImageRect( "images/6.jpg", 320, 568 )
		loadingImage.x = 160; loadingImage.y = 240;
		--��������� �������� � ������, ������� ����� ������������ �� ����� ������� new. 
		--���� �� �������� - ��������, ����������� � ������ �� ��������� �� �������� - ��� �� director �� ��������� ��� ������.
		localGroup:insert(loadingImage)		
		
		-- ���������� �������� ����� ������� ���������� � ����
		local goToLevel = function()
			director:changeScene( "mainmenu", "overFromRight" )
		end
		-- ��������� � ���� ����� �������, � ��� ������� � �����-��... ������ �� ������
		theTimer = timer.performWithDelay( 1000, goToLevel, 1 )
	end
	
	showLoadingScreen()
	
	-- ������ ����������� � ���, ���������� ��� �������� �����
	unloadMe = function()
		-- ������ ��������
		if theTimer then timer.cancel( theTimer ); end
		
		--�������� �������
		if localGroup and loadingImage then
			localGroup:remove(loadingImage)
			loadingImage = nil
		end
	end
	
	-- MUST return a display.newGroup()
	return localGroup
end
