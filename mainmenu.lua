
--определяем модуль, при этом модуль видит глобальные переменные благодаря package.seeall
module(..., package.seeall)

-- все сцены определяются функцией new, которая возвращает группу, содержащую отображаемые объекты
function new()
	local menuGroup = display.newGroup()
	
	-- загружаем модуль ui
	local ui = require("ui")
	
	-- переменные для анимации кнопки и звука нажатия.
	-- это единственный звук в игре )
	local playTween
	local tapSound = audio.loadSound( "sounds/tapsound.wav" )
	
	-- функция которая рисует меню
	local drawScreen = function()
		-- загружаем фон
		local backgroundImage = display.newImageRect( "images/mainmenu.png", 320, 568 )
		backgroundImage.x = 160; backgroundImage.y = 240
		
		--добавляем его в основную группу
		menuGroup:insert( backgroundImage )
				
		--переменная для кнопки
		local playBtn
		
		--обработчик события нажатие
		local onPlayTouch = function( event )
			-- фаза: отпустили, и при этом активна кнопка
			if event.phase == "release" and playBtn.isActive then				
				--играем звук
				audio.play( tapSound )
				playBtn.isActive = false
				
				--переходим к следующей сцене. Второй параметр - тип анимации
				director:changeScene( "game", "overFromRight" )
			end
		end
		
		--создаем кнопку. среди параметров - картинки нажатого и отпущенного состояний, размеры, обработчик события, и др
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
		
		-- позиция задается для нижней центральной точки кнопки
		playBtn:setReferencePoint( display.BottomCenterReferencePoint )
		playBtn.x = 156 playBtn.y = 700
		
		-- добавляем в общую группу
		menuGroup:insert( playBtn )		
		
		-- анимация выскакивания кнопки
		playTween = transition.to( playBtn, { time=1000, y=400, rotation=3, transition=easing.inOutExpo } )	
	end
	
	drawScreen()
		
	--типа деструктор, удаляет анимацию, аудио, и все отображаемые объекты
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
