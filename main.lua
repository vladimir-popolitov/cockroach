-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- самый главный модуль

-- SOME INITIAL SETTINGS
display.setStatusBar( display.HiddenStatusBar ) --прячем статус бар устройства

-- загружаем модуль директора
local director = require("director")

-- создаем самую главную группу в приложении
local mainGroup = display.newGroup()

-- Main function
local function main()
	
	-- директора добавляем в главную группу
	mainGroup:insert(director.directorView)
	
	-- Uncomment below code and replace init() arguments with valid ones to enable openfeint
	--[[
	openfeint = require ("openfeint")
	openfeint.init( "App Key Here", "App Secret Here", "Ghosts vs. Monsters", "App ID Here" )
	]]--
	
	-- выводим первую сцену - экран с надписью "загрузка". второй параметр - эффект, с которым появляется эта сцена
	director:changeScene( "loadmainmenu", "overFromRight" )
	
	return true
end

-- Begin
main()