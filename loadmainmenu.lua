
--определяем модуль, при этом модуль видит глобальные переменные благодаря package.seeall
module(..., package.seeall)

-- все сцены определяются функцией new, которая возвращает группу, содержащую отображаемые объекты
function new()
	local localGroup = display.newGroup()
	
	--переменные для таймера и картинки "loading"
	local theTimer
	local loadingImage
	
	local showLoadingScreen = function()
		-- загружаем и отображаем картинку
		loadingImage = display.newImageRect( "images/6.jpg", 320, 568 )
		loadingImage.x = 160; loadingImage.y = 240;
		--добавляем картинку в группу, которая потом возвращается из нашей функции new. 
		--если не добавить - действия, применяемые к группе не отразятся на картинке - тот же director не сработает как должен.
		localGroup:insert(loadingImage)		
		
		-- используем директор чтобы перейти собственно к меню
		local goToLevel = function()
			director:changeScene( "mainmenu", "overFromRight" )
		end
		-- переходим к меню через секунду, а эту секунду в общем-то... ничего не делаем
		theTimer = timer.performWithDelay( 1000, goToLevel, 1 )
	end
	
	showLoadingScreen()
	
	-- аналог деструктора в ООП, вызывается при удалении сцены
	unloadMe = function()
		-- таймер отменяем
		if theTimer then timer.cancel( theTimer ); end
		
		--картинку удаляем
		if localGroup and loadingImage then
			localGroup:remove(loadingImage)
			loadingImage = nil
		end
	end
	
	-- MUST return a display.newGroup()
	return localGroup
end
