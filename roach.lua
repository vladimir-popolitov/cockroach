
--���������� ������, ��� ���� ������ ����� ���������� ���������� ��������� package.seeall
module(..., package.seeall)

-- ��� ����� ������������ �������� new, ������� ���������� ������, ���������� ������������ �������
-- ������� �� ����������, ���� ��� ������ ����� ��������� ����� ���� �����������
function new(params)
	local g = display.newGroup()
	-- ������� "��������", ����� 0 - ��� �����, ���� ������ 0 - ������� ������ ����� ������
	local dead = 0;
	
	-- �������� �� � � �� �
	local dx, dy
	
	-- ��������� ������� ������������� ��������� �������� � �����������, ����� ������� ��� ��������
	if math.random(2) > 1 then
		g.x = -40		
		dx = 5
	else
		g.x = 360
		dx = -5		
	end
	
	-- ��������� ������� ��������� �� � � �������� �� �
	g.y = 40 + math.random(360)
	dy = -5 + math.random(10)
	
	-- ��������� ��� �������
	local rimage = display.newImageRect( "images/r" .. params.rnum .. ".png", 82, 130 )
	rimage.x = 0; rimage.y = 0;
	
	-- ����������
	local function unloadMe()
		-- ����������� �������
		if rimage then
			rimage:removeSelf()
			rimage = nil
		end
		-- ������� ������ ��������
		-- ���� ���� ���������� ������, �� � ������ ������ ������ game ��������� ����� �� ������� - ��� ����
		g:removeSelf()
		g = nil
	end
	
	-- ������� ������� �� ��������
	local function touchEvent(event)
		-- �� ����
		dead = 1
		--�������� �������� �� ��������
		rimage:removeSelf()
		rimage = display.newImageRect( "images/r" .. params.rnum .. "dead.png", 82, 130 )
		g:insert(rimage)
		-- ���������� ������� ��� �� �����
		g:removeEventListener("touch", touchEvent)
	end
	
	-- ���������� �� ������ �����, ����� ��������� ���������
	function g:objectLoop(params)
		-- ���� �����
		if dead < 1 then
			-- ����������� ���� - ����������� ��� �����-������
			g:rotate(3*math.sin(params.ticks/20))		
			--����������
			--��� ����� ������� ���. ���� � ����������� ���� ������������ �������� params.ticks - ��� �����, ����������� �� ����
			--� ������ �������� - �������� ��������� ����� �������� �� �������� ����������
			--��� � �������� �� ������������, ������
			g.x = g.x + dx
			g.y = g.y + dy
			
			-- ������ ����������� �� �
			-- ����� ����� ������� ����� ��� ���� ����� ������
			dy = math.min(7, math.max(-7, dy + math.random(3) - 2))
			
			-- ���� ������� �� ����� - ����� ������� ��� ���� (����� �������)
			if g.x < -50 or g.x > 400 then 
				-- ����� ��������� ��� ��� >400 � <-50 ��� �� ����� � ������� dead=200 - ������������ �������� �� ������������������
				dead = 100
			end
		else
		-- ���� �������
			--������� ���������
			dead = dead + 1		
			-- ���� ������� �� 100 �� 200 - ���������� ������� � ������
			if dead > 100 then
				rimage.alpha = math.max(0, (200 - dead) / 100.0)
			end
			-- ���� �� ��� ������ ���������� - ������� ������������
			if dead > 200 then
				unloadMe()
			end
		end
	end
	
	-- dead - ��������� ����������, ���� ����������� �������� � �������� ����� - ����� ������������ ���� �����
	function g:dead()
		return dead;
	end
		
	-- ��������� ���������� �������
	g:addEventListener("touch", touchEvent)
	
	-- ��������� � ����� ������
	g:insert(rimage)
	-- ������ ��������� � ������ ������ ���������� ����� - ����� ����� ������� ����-���� - ��������� ���-�� ���� ������
	g:setReferencePoint(display.BottomCenterReferencePoint)

	-- MUST return a display.newGroup()
	return g
end