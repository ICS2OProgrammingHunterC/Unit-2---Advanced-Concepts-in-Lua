-----------------------------------------------------------------------------------------
--
-- main.lua
-- Created by: Gil Robern
-- Date: Nov. 26th, 2014
-- Description: This calls the splash screen of the app to load itself.
-----------------------------------------------------------------------------------------

-- Hiding Status Bar
display.setStatusBar( display.HiddenStatusBar )

-----------------------------------------------------------------------------------------

-- Use composer library
local composer = require( "composer" )

-----------------------------------------------------------------------------------------

-- Go to main menu screen
composer.gotoScene( "main_menu" )