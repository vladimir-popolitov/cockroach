
--определяем модуль, при этом модуль видит глобальные переменные благодаря package.seeall
module(..., package.seeall)

-- все сцены определяются функцией new, которая возвращает группу, содержащую отображаемые объекты
-- таракан не исключение, хотя его группа будет содержать всего одно изображение
function new(params)
	local g = display.newGroup()
	-- счетчик "дохлости", когда 0 - оно живое, если больше 0 - сколько кадров назад умерло
	local dead = 0;
	
	-- скорость по х и по у
	local dx, dy
	
	-- случайным образом устанавливаем начальную скорость и направление, слева направо или наоборот
	if math.random(2) > 1 then
		g.x = -40		
		dx = 5
	else
		g.x = 360
		dx = -5		
	end
	
	-- случайным образом положение по у и скорость по у
	g.y = 40 + math.random(360)
	dy = -5 + math.random(10)
	
	-- загружаем его портрет
	local rimage = display.newImageRect( "images/r" .. params.rnum .. ".png", 82, 130 )
	rimage.x = 0; rimage.y = 0;
	
	-- деструктор
	local function unloadMe()
		-- изображение удаляем
		if rimage then
			rimage:removeSelf()
			rimage = nil
		end
		-- удаляем группу таракана
		-- чаще этим занимается предок, но в данном случае модуль game тараканов нигде не удаляет - они сами
		g:removeSelf()
		g = nil
	end
	
	-- событие нажатия на таракана
	local function touchEvent(event)
		-- он умер
		dead = 1
		--картинку заменить на мертвого
		rimage:removeSelf()
		rimage = display.newImageRect( "images/r" .. params.rnum .. "dead.png", 82, 130 )
		g:insert(rimage)
		-- обработчик события уже не нужен
		g:removeEventListener("touch", touchEvent)
	end
	
	-- вызывается на каждом кадре, здесь обновляем положение
	function g:objectLoop(params)
		-- если живой
		if dead < 1 then
			-- имитировать шаги - поворачивая его влево-вправо
			g:rotate(3*math.sin(params.ticks/20))		
			--перемещаем
			--вот здесь ужасный баг. надо в перемещении тоже использовать параметр params.ticks - это время, затраченное на кадр
			--в данном варианте - скорость тараканов будет зависеть от скорости устройства
			--как и скорость их исчезновения, кстати
			g.x = g.x + dx
			g.y = g.y + dy
			
			-- меняем направление по у
			-- может легко убежать вверх или вниз очень быстро
			dy = math.min(7, math.max(-7, dy + math.random(3) - 2))
			
			-- если выбежал за экран - можно считать что умер (своей смертью)
			if g.x < -50 or g.x > 400 then 
				-- можно убедиться что при >400 и <-50 его не видно и сделать dead=200 - положительно скажется на производительности
				dead = 100
			end
		else
		-- если мертвый
			--счетчик обновляем
			dead = dead + 1		
			-- если счетчик от 100 до 200 - плавненько убираем с экрана
			if dead > 100 then
				rimage.alpha = math.max(0, (200 - dead) / 100.0)
			end
			-- если он уже совсем прозрачный - удаляем окончательно
			if dead > 200 then
				unloadMe()
			end
		end
	end
	
	-- dead - локальная переменная, если понадобится получить её значение извне - можно использовать этот метод
	function g:dead()
		return dead;
	end
		
	-- добавляем обработчик нажатия
	g:addEventListener("touch", touchEvent)
	
	-- добавляем в общую группу
	g:insert(rimage)
	-- начало координат в группе ставим посередине внизу - когда будем вращать туда-сюда - получится что-то типа шажков
	g:setReferencePoint(display.BottomCenterReferencePoint)

	-- MUST return a display.newGroup()
	return g
end