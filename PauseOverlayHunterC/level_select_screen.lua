-----------------------------------------------------------------------------------------
--
-- SceneTemplate.lua
-- Scene Template (Composer API)
--
-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
-- INITIALIZATIONS
-----------------------------------------------------------------------------------------

-- Calling Composer Library
local composer = require( "composer" )

local widget = require( "widget" )

-----------------------------------------------------------------------------------------

-- Naming Scene
sceneName = "level_select_screen"

-----------------------------------------------------------------------------------------

-- Creating Scene Object
local scene = composer.newScene( sceneName )


-----------------------------------------------------------------------------------------
-- FORWARD REFERENCES
-----------------------------------------------------------------------------------------

-- local forward references should go here
local bkg

-- Level button variables
local level1Button
local level2Button
local level3Button
local level4Button

-- Creating level select text
local levelSelectText = display.newText( "Level Select Screen", display.contentWidth/2, display.contentHeight/2, nil, 50)
levelSelectText:setTextColor(155/255, 42/255, 198/255)

local addingText = display.newText( "Addition", display.contentWidth*1/4, display.contentHeight*3/4, nil, 30)
addingText:setTextColor(155/255, 42/255, 198/255)

local subtractText = display.newText( "Subtraction", display.contentWidth*3/8, display.contentHeight*4/7, nil, 30)
subtractText:setTextColor(155/255, 42/255, 198/255)

local multiplyText = display.newText( "Multiplication", display.contentWidth/2, display.contentHeight*3/4, nil, 30)
multiplyText:setTextColor(155/255, 42/255, 198/255)

local allText = display.newText( "All Three!", display.contentWidth*2/3, display.contentHeight*4/7, nil, 30)
allText:setTextColor(155/255, 42/255, 198/255)

local creditsScreenMusic = audio.loadSound("Background Music/creditsScreenMusic.wav")
local creditsScreenMusicChannel
-----------------------------------------------------------------------------------------

-- The function called when the screen doesn't exist
function scene:create( event )

    -- Creating a group that associates objects with the scene
    local sceneGroup = self.view

    -- Insert the background image and set it to the center of the screen
    bkg = display.newImage("Images/Level Select Screen.png")
    bkg.x = display.contentCenterX
    bkg.y = display.contentCenterY
    bkg.width = display.contentWidth
    bkg.height = display.contentHeight

    -- Send the background image to the back layer so all other objects can be on top
    bkg:toBack()

-----------------------------------------------------------------------------------------
    -- FUNCTIONS
-----------------------------------------------------------------------------------------
    -- Level 1 transition
    function Level1Transition( )
        composer.gotoScene( "level1_screen", {effect = "zoomInOutFade", time = 300}) 
    end

    -- Level 2 transition
    function Level2Transition( )
        composer.gotoScene( "level2_screen", {effect = "zoomInOutFade", time = 300}) 
    end

    -- Level 3 transition
    function Level3Transition( )
        composer.gotoScene( "level3_screen", {effect = "zoomInOutFade", time = 300}) 
    end

    -- Level 4 transition
    function Level4Transition( )
        composer.gotoScene( "level4_screen", {effect = "zoomInOutFade", time = 300}) 
    end

    -- Creating Transitioning Function back to main menu
    function BackTransition( )
        composer.gotoScene( "main_menu", {effect = "zoomOutInFadeRotate", time = 500})
    end
-----------------------------------------------------------------------------------------
    -- WIDGETS
-----------------------------------------------------------------------------------------
    -- Level 1 widget
    level1Button = widget.newButton( 
        {
            -- Setting Position
            x = display.contentWidth*1/4,
            
            y = display.contentHeight*2/3,

            -- Setting Dimensions
            -- width = 1000,
            -- height = 106,

            -- Setting Visual Properties
            defaultFile = "Images/Level 1 Button.png",
            overFile = "Images/Level 1 Button.png",

            -- Setting Functional Properties
            onRelease = Level1Transition

        } )

    -- Level 2 widget
    level2Button = widget.newButton( 
        {
            -- Setting Position
            x = display.contentWidth*3/8,
            
            y = display.contentHeight*2/3,

            -- Setting Dimensions
            -- width = 1000,
            -- height = 106,

            -- Setting Visual Properties
            defaultFile = "Images/Level 2 Button.png",
            overFile = "Images/Level 2 Button.png",

            -- Setting Functional Properties
            onRelease = Level2Transition

        } )

    -- Level 3 widget
    level3Button = widget.newButton( 
        {
            -- Setting Position
            x = display.contentWidth/2,
            
            y = display.contentHeight*2/3,

            -- Setting Dimensions
            -- width = 1000,
            -- height = 106,

            -- Setting Visual Properties
            defaultFile = "Images/Level 3 Button.png",
            overFile = "Images/Level 3 Button.png",

            -- Setting Functional Properties
            onRelease = Level3Transition

        } )

    -- Level 4 widget
    level4Button = widget.newButton( 
        {
            -- Setting Position
            x = display.contentWidth*2/3,
            
            y = display.contentHeight*2/3,

            -- Setting Dimensions
            -- width = 1000,
            -- height = 106,

            -- Setting Visual Properties
            defaultFile = "Images/Level 4 Button.png",
            overFile = "Images/Level 4 Button.png",

            -- Setting Functional Properties
            onRelease = Level4Transition

        } )


    -- Creating Back Button
    backButton = widget.newButton( 
    {
        -- Setting Position
        x = display.contentWidth/2,
        y = display.contentHeight*15/16,

        -- Setting Dimensions
        -- width = 1000,
        -- height = 106,

        -- Setting Visual Properties
        defaultFile = "Images/Unpressed Back Button.png",
        overFile = "Images/Pressed Back Button.png",

        -- Setting Functional Properties
        onRelease = BackTransition

    } )


    -----------------------------------------------------------------------------------------


    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
    sceneGroup:insert( levelSelectText )
    sceneGroup:insert( addingText )
    sceneGroup:insert( subtractText )
    sceneGroup:insert( multiplyText )
    sceneGroup:insert( allText )
    sceneGroup:insert( level1Button )
    sceneGroup:insert( level2Button )
    sceneGroup:insert( level3Button )
    sceneGroup:insert( level4Button )
    sceneGroup:insert( backButton )

end

-----------------------------------------------------------------------------------------

-- The function called when the scene is issued to appear on screen
function scene:show( event )

    -- Creating a group that associates objects with the scene
    local sceneGroup = self.view

    -----------------------------------------------------------------------------------------

    local phase = event.phase

    -----------------------------------------------------------------------------------------

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).

    -----------------------------------------------------------------------------------------

    elseif ( phase == "did" ) then

        --play the sound
        creditsScreenMusicChannel = audio.play( creditsScreenMusic, {channel=5, loops=-1} )

        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.
    end

end

-----------------------------------------------------------------------------------------

-- The function called when the scene is issued to leave the screen
function scene:hide( event )

    -- Creating a group that associates objects with the scene
    local sceneGroup = self.view

    -----------------------------------------------------------------------------------------

    local phase = event.phase

    -----------------------------------------------------------------------------------------

    if ( phase == "will" ) then

        --stop the audio
        creditsScreenMusicChannel = audio.stop (5)
        
        -- Called when the scene is on screen (but is about to go off screen).
        -- Insert code here to "pause" the scene.
        -- Example: stop timers, stop animation, stop audio, etc.

    -----------------------------------------------------------------------------------------

    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.
    end

end

-----------------------------------------------------------------------------------------

-- The function called when the scene is issued to be destroyed
function scene:destroy( event )

    -- Creating a group that associates objects with the scene
    local sceneGroup = self.view

    -----------------------------------------------------------------------------------------


    -- Called prior to the removal of scene's view ("sceneGroup").
    -- Insert code here to clean up the scene.
    -- Example: remove display objects, save state, etc.
end

-----------------------------------------------------------------------------------------
-- EVENT LISTENERS
-----------------------------------------------------------------------------------------

-- Adding Event Listeners
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene

