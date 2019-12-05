-----------------------------------------------------------------------------------------
--
-- level1_screen.lua
-- Created by: Gil Robern
-- Date: Nov. 26th, 2014
-- Description: This is the level 1 screen of the game.
-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
-- INITIALIZATIONS
-----------------------------------------------------------------------------------------


-- Use Composer Library
local composer = require( "composer" )

-----------------------------------------------------------------------------------------

-- Use Widget Library
local widget = require( "widget" )

-----------------------------------------------------------------------------------------

-- Naming Scene
sceneName = "level1_screen"

-----------------------------------------------------------------------------------------

-- Creating Scene Object
local scene = composer.newScene( sceneName )

-----------------------------------------------------------------------------------------
-- CREATING VARIABLE FOR THE SCENE
-----------------------------------------------------------------------------------------

-- The local variables for this scene
local bkg
local pauseButton

-- initialize character speed
local scrollXSpeed = 1.5

-- boolean variable that states if the scene is paused or not
local pauseLevel1 = false
local alreadyHitWall = false
local alreadyClickedAnAnswer = false

-- the level1 character
local character1    
local character1Wrong 

-- determine the range for the numbers to add
local MIN_NUM = 1
local MAX_NUM = 10

local NUM_CORRECT_ANSWERS = 8

-- the variables containing the first and second numbers to add for the equation
local firstNumber
local secondNumber

-- the global variables that will hold the answer and the wrong answers
local answer 
local wrongAnswer1
local wrongAnswer2
local wrongAnswer3 

-- the text object that will hold the addition equation
local addEquationTextObject = display.newText( "", display.contentWidth*1/4, display.contentHeight*2/5, nil, 50 )
-- sets the color of the text
addEquationTextObject:setTextColor(155/255, 42/255, 198/255)


-- the text objects that will hold the answer and the wrong answers
local answerTextObject = display.newText("", display.contentWidth*.4, display.contentHeight/2, nil, 50 )
local wrongAnswer1TextObject = display.newText("", display.contentWidth*.3, display.contentHeight/2, nil, 50 )
local wrongAnswer2TextObject = display.newText("", display.contentWidth*.2, display.contentHeight/2, nil, 50 )
local wrongAnswer3TextObject = display.newText("", display.contentWidth*.1, display.contentHeight/2, nil, 50 )

local numberCorrectText = display.newText("", display.contentWidth*4/5, display.contentHeight*6/7, nil, 25)

local livesText = display.newText("", display.contentWidth*4/5, display.contentHeight*8/9, nil, 25) 

-- the text displaying congratulations
local congratulationText = display.newText("Good job!", display.contentWidth/2, display.contentHeight*2/5, nil, 50 )

-- Sets text colour
congratulationText:setTextColor(57/255, 230/255, 0)
congratulationText.isVisible = false

-- Displays text that says correct.
local correct = display.newText("Correct", display.contentWidth/2, display.contentHeight*1/3, nil, 50 )
correct:setTextColor(100/255, 47/255, 210/255)
correct.isVisible = false

-- Displays text that says wrong.
local wrong = display.newText("Wrong", display.contentWidth/2, display.contentHeight*1/3, nil, 50 )
wrong:setTextColor(100/255, 47/255, 210/255)
wrong.isVisible = false 

-- Displays the out of time text
local outOfTimeText = display.newText("Out of Time!", display.contentWidth*2/5, display.contentHeight*1/3, nil, 50)
outOfTimeText:setTextColor(100/255, 47/255, 210/255)
outOfTimeText.isVisible = false

-- Displays the level text of time text
local level1Text = display.newText("Level 1", display.contentWidth*2/12, display.contentHeight*2/12, nil, 50)
level1Text:setTextColor(0, 0, 0)


--create the audio variable for the sound channel
local soundLevel1 = audio.loadSound("Background Music/level1Music.wav")
local level1SoundChannel = nil
local monsterNoise = audio.loadSound("Sound Effects/monsterSound.wav")
local monsterNoiseChannel = nil
local correctSound = audio.loadSound("Sound Effects/CorrectAnswer.mp3")
local correctSoundChannel = nil
local wrongSound = audio.loadSound("Sound Effects/WrongBuzzer.mp3")
local wrongSoundChannel = nil

-----------------------------------------------------------------------------------------
-- FUNCTIONS
-----------------------------------------------------------------------------------------

-- Creating Transition to Lose Screen
function MainMenuTransition( )        
    MakeSceneObjectsInvisible()
    -- this function removes the event listener for the character
    StopCharacter()
    composer.gotoScene( "main_menu", {effect = "zoomInOutFade", time = 1000})
end 

-- Creating Transition to Lose Screen
function LoseScreenTransition( )        
    MakeSceneObjectsInvisible()
    -- this function removes the event listener for the character
    StopCharacter()
    composer.gotoScene( "you_lose", {effect = "zoomInOutFade", time = 1000})
end 



function CheckLives()
-- if they lose all their lives, go to you lose screen
    if (lives == 0) then
        RemoveTextObjectListeners()
        timer.performWithDelay( 1000, LoseScreenTransition )
    -- otherwise, restart the level 1 scene
    elseif (pauseLevel1 == false) then       
        RestartScene()            
    end
end

function HideOutOfTimeText()
    outOfTimeText.isVisible = false
    character1.isVisible = true
    character1Wrong.isVisible = false
    CheckLives()
end

-- Function for when you hit the wall
function HitWall( )

    if (pauseLevel1 == false) then


        -- set the boolean variable to be true
        alreadyHitWall = true

        -- decrease lives by 1
        lives = lives - 1
        livesText.text = "Number of lives = " .. tostring(lives)    

        character1.isVisible = false
        character1Wrong.x = character1.x
        character1Wrong.y = character1.y

        character1Wrong.isVisible = true



        -- freeze the character's movement
        StopCharacter()
        MakeSceneObjectsInvisible()
           
        -- display out of time. This works with below timer delay transitions
        outOfTimeText.isVisible = true
        timer.performWithDelay(500, HideOutOfTimeText)
     

    end
end

function ResetCharacterPosition()
    character1.x = display.contentWidth*1/32
    character1.y = display.contentHeight*5/6
end

function StopCharacter()
    Runtime:removeEventListener("enterFrame", MoveCharacter)
end

-- Creating function that moves the character across the screen
function MoveCharacter()
    if (character1.x < display.contentWidth*15/32) then    
        character1.x = character1.x + scrollXSpeed   
    elseif (character1.x >= display.contentWidth*15/32) then
        --make monster noise
        monsterNoiseChannel = audio.play( monsterNoise, {channel=3, loops=0} )
        -- remove event listener on character
        StopCharacter()
        -- call function to decrease number of lives
        HitWall() 
    else
        print ("***Error.")
    end
end

-- The transition for the pause button
function PauseTransition( )

    pauseLevel1 = true

    -- Pause scene variables
    local options = {
            isModal = true,
            effect = "fromBottom",
            time = 400
    }

    MakeSceneObjectsInvisible()
    StopCharacter()
    level1SoundChannel = audio.stop()
    composer.showOverlay( "pause", options )
end

function ResumeGame()
    pauseLevel1 = false

    MakeSceneObjectsVisible()
    RestartCharacter()
    level1SoundChannel = audio.play( soundLevel1, {channel=6, loops=-1} )
end


function RestartCharacter()

    alreadyHitWall = false
    if (pauseLevel1 == false) then
        MakeSceneObjectsVisible()
        Runtime:addEventListener("enterFrame", MoveCharacter)
    else        
        MakeSceneObjectsInvisible()
    end
end


function RestartScene()

    alreadyClickedAnAnswer = false

    if (pauseLevel1 == false) then
        -- display lives
        livesText.text = "Number of lives = " .. tostring(lives)
        numberCorrectText.text = "Number correct = " .. tostring(numberCorrect)

        -- reset character position and then call function to start moving it again
        ResetCharacterPosition()
        RestartCharacter()    

        MakeSceneObjectsVisible()
        DisplayAddEquation()
        DeternmineAnswers()
        DisplayAnswers()
    end
end

-- Function that restarts the scene when the answer is wrong.
function RestartSceneWrong()

    alreadyClickedAnAnswer = false

    wrong.isVisible = false
    -- decrease the number of lives by 1  
    lives = lives - 1
    livesText.text = "Number of lives = " .. tostring(lives)

    -- freeze the character's movement
    StopCharacter()
    MakeSceneObjectsInvisible()

    -- if the number of lives reaches 0, show the you lose scene
    if (lives == 0) then        
        RemoveTextObjectListeners()
        composer.gotoScene( "you_lose" )
    -- otherwise, restart the scene
    else        
        RestartScene() 
    end
end

function RestartSceneRight()

    alreadyClickedAnAnswer = false

    correct.isVisible = false
    numberCorrect = numberCorrect + 1
    numberCorrectText.text = "Number correct = " .. tostring(numberCorrect)

    -- freeze the character's movement
    StopCharacter()
    MakeSceneObjectsInvisible()

    -- if they answer 8 questions right, go to the next level
    if (numberCorrect == NUM_CORRECT_ANSWERS) then        
        -- Displays congratulations text        
        congratulationText.isVisible = true   
        RemoveTextObjectListeners()  
        timer.performWithDelay(1000, MakeSceneObjectsInvisible)  
        timer.performWithDelay(1000, Level2ScreenTransition)
    -- otherwise, restart the scene
    else
        RestartScene()
    end
end

-- Functions that checks if the buttons have been clicked.
function TouchListenerAnswer(touch)
    -- get the user answer from the text object that was clicked on
    local userAnswer = answerTextObject.text

    if (touch.phase == "ended") and (alreadyClickedAnAnswer == false) then
        
        -- set boolean
        alreadyClickedAnAnswer = true

        if (answer == tonumber(userAnswer)) then
            StopCharacter()  
            correctSoundChannel = audio.play( correctSound )          
            correct.isVisible = true
            timer.performWithDelay( 1000, RestartSceneRight )

        else
            print ("***WRONG")
        end        

    end
end

function TouchListenerWrongAnswer1(touch)
    -- get the user answer from the text object that was clicked on
    local userAnswer = wrongAnswer1TextObject.text

    if (touch.phase == "ended") and (alreadyClickedAnAnswer == false) then

        -- set boolean
        alreadyClickedAnAnswer = true
        
        if (answer == tonumber(userAnswer)) then
            print ("***CORRECT") 
        else
            print ("***WRONG")
            StopCharacter()
            wrong.isVisible = true
            wrongSoundChannel = audio.play( wrongSound )
            timer.performWithDelay( 1000, RestartSceneWrong )            
        end        

    end
end

function TouchListenerWrongAnswer2(touch)
    -- get the user answer from the text object that was clicked on
    local userAnswer = wrongAnswer2TextObject.text

      
        if (touch.phase == "ended") and (alreadyClickedAnAnswer == false) then

            -- set boolean
            alreadyClickedAnAnswer = true

            if (answer == tonumber(userAnswer)) then
                print ("***CORRECT")
            else
                print ("***WRONG")
            StopCharacter()
            wrong.isVisible = true
            wrongSoundChannel = audio.play( wrongSound )
            timer.performWithDelay( 1000, RestartSceneWrong )            
            end        
    
        end
end
    
function TouchListenerWrongAnswer3(touch)
        -- get the user answer from the text object that was clicked on
        local userAnswer = wrongAnswer3TextObject.text        
    
        if (touch.phase == "ended") and (alreadyClickedAnAnswer == false) then

            -- set boolean
            alreadyClickedAnAnswer = true

            if (answer == tonumber(userAnswer)) then
                print ("***CORRECT")
            else
                print ("***WRONG")
                StopCharacter()
                wrong.isVisible = true
                wrongSoundChannel = audio.play( wrongSound )
                timer.performWithDelay( 1000, RestartSceneWrong )            
            end        
    
        end
end

function AddTextObjectListeners()

    answerTextObject:addEventListener("touch", TouchListenerAnswer)
    wrongAnswer1TextObject:addEventListener("touch", TouchListenerWrongAnswer1)
    wrongAnswer2TextObject:addEventListener("touch", TouchListenerWrongAnswer2)
    wrongAnswer3TextObject:addEventListener("touch", TouchListenerWrongAnswer3)

end

function RemoveTextObjectListeners()

    answerTextObject:removeEventListener("touch", TouchListenerAnswer)
    wrongAnswer1TextObject:removeEventListener("touch", TouchListenerWrongAnswer1)
    wrongAnswer2TextObject:removeEventListener("touch", TouchListenerWrongAnswer2)
    wrongAnswer3TextObject:removeEventListener("touch", TouchListenerWrongAnswer3)

end
    
-- The function that displays the equation and determines the answer and the wrong answers
function DisplayAddEquation()
    -- local variables to this function
    local addEquationString

    -- choose the numbers to add randomly
    firstNumber = math.random(MIN_NUM, MAX_NUM)
    secondNumber = math.random(MIN_NUM, MAX_NUM)

    -- create the addition equation to display
    addEquationString = firstNumber .. " + " .. secondNumber .. " = " 

    -- displays text on text object
    addEquationTextObject.text = addEquationString

    
end

function DeternmineAnswers()
    -- determine the answer as well as the wrong answers
    answer = firstNumber + secondNumber
    wrongAnswer1 = answer + math.random(1,4)
    wrongAnswer2 = answer + math.random(5,8)
    wrongAnswer3 = answer - math.random(1,4)
end

-- Function that changes the answers for a new questions and places them randomly
function DisplayAnswers( )

    local answerPosition = math.random(1,4)
    answerTextObject.text = tostring( answer )
    wrongAnswer1TextObject.text = tostring( wrongAnswer1 )
    wrongAnswer2TextObject.text = tostring( wrongAnswer2 )
    wrongAnswer3TextObject.text = tostring( wrongAnswer3 )
    print ("answer********** =" .. answer)

    if (answerPosition == 1) then                
        
        answerTextObject.x = display.contentWidth*.4        
        wrongAnswer1TextObject.x = display.contentWidth*.3
        wrongAnswer2TextObject.x = display.contentWidth*.2 
        wrongAnswer3TextObject.x = display.contentWidth*.1

    elseif (answerPosition == 2) then
       
        
        answerTextObject.x = display.contentWidth*.3        
        wrongAnswer1TextObject.x = display.contentWidth*.2
        wrongAnswer2TextObject.x = display.contentWidth*.1 
        wrongAnswer3TextObject.x = display.contentWidth*.4 

    elseif (answerPosition == 3) then
       
        answerTextObject.x = display.contentWidth*.2        
        wrongAnswer1TextObject.x = display.contentWidth*.1
        wrongAnswer2TextObject.x = display.contentWidth*.4 
        wrongAnswer3TextObject.x = display.contentWidth*.3

    else
        
        answerTextObject.x = display.contentWidth*.1        
        wrongAnswer1TextObject.x = display.contentWidth*.4
        wrongAnswer2TextObject.x = display.contentWidth*.3 
        wrongAnswer3TextObject.x = display.contentWidth*.2
    end
end

-- This function makes all objects on the scene invisible
function MakeSceneObjectsInvisible()
    addEquationTextObject.isVisible = false
    answerTextObject.isVisible = false
    wrongAnswer1TextObject.isVisible = false
    wrongAnswer2TextObject.isVisible = false
    wrongAnswer3TextObject.isVisible = false
    --outOfTimeText.isVisible = false
    character1.isVisible = false
    congratulationText.isVisible = false
end

-- This function makes all objects on the scene visible, except for Correct, Wrong and Out of Time
function MakeSceneObjectsVisible()
    addEquationTextObject.isVisible = true
    answerTextObject.isVisible = true
    wrongAnswer1TextObject.isVisible = true
    wrongAnswer2TextObject.isVisible = true
    wrongAnswer3TextObject.isVisible = true
    livesText.isVisible = true
    numberCorrectText.isVisible = true
    character1.isVisible = true
    outOfTimeText.isVisible = false
    wrong.isVisible = false
    correct.isVisible = false
end

function ResumeGameInstructions()
    PauseTransition()
end

-----------------------------------------------------------------------------------------

function Level2ScreenTransition()
    composer.gotoScene( "you_win", {effect = "zoomInOutFade", time = 1000})
end

-- The function called when the screen doesn't exist
function scene:create( event )

    -- Creating a group that associates objects with the scene
    local sceneGroup = self.view

    -----------------------------------------------------------------------------------------

    -- Insert the background image
    bkg = display.newImageRect("Images/Level 1 Screen.png", display.contentWidth, display.contentHeight)
    bkg.x = display.contentCenterX
    bkg.y = display.contentCenterY
    bkg.width = display.contentWidth
    bkg.height = display.contentHeight

    character1 = display.newImageRect("Images/Level 1 Character.png", 200, 200)
    character1.x = display.contentWidth*1/32
    character1.y = display.contentHeight*5/6
    character1.isVisible = true

    character1Wrong = display.newImageRect("Images/Level 1 Character Wrong.png", 200, 200)
    character1Wrong.x = display.contentWidth*1/32
    character1Wrong.y = display.contentHeight*5/6
    character1Wrong.isVisible = false

    -- Send the background image to the back layer so all other objects can be on top
    bkg:toBack()        

-----------------------------------------------------------------------------------------
-- WIDGETS
-----------------------------------------------------------------------------------------

    -- Create pause button
    pauseButton = widget.newButton( 
    {
        -- Setting Position
        x = display.contentWidth768,
        y = display.contentHeight*15/16,


        -- Setting Visual Properties
        defaultFile = "Images/Unpressed Pause.png",
        overFile = "Images/Pressed Pause.png",

        -- Setting Functional Properties
        onRelease = PauseTransition

    } )

-----------------------------------------------------------------------------------------

    
-----------------------------------------------------------------------------------------

     -- Insert objects into scene group
    sceneGroup:insert( bkg )  
    sceneGroup:insert( pauseButton ) 
    sceneGroup:insert( character1 )
    sceneGroup:insert( character1Wrong )
    sceneGroup:insert( numberCorrectText )
    sceneGroup:insert( livesText )
    sceneGroup:insert( addEquationTextObject )
    sceneGroup:insert( answerTextObject )
    sceneGroup:insert( wrongAnswer1TextObject )
    sceneGroup:insert( wrongAnswer2TextObject )
    sceneGroup:insert( wrongAnswer3TextObject )
    sceneGroup:insert( outOfTimeText )
    sceneGroup:insert( congratulationText )
    sceneGroup:insert( wrong )
    sceneGroup:insert( correct )
    sceneGroup:insert( level1Text )
end

-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------

-- The function called when the scene is issued to appear on screen
function scene:show( event )

    -- Creating a group that associates objects with the scene
    --local sceneGroup = self.view
    local phase = event.phase


    -----------------------------------------------------------------------------------------

    if ( phase == "will" ) then

        -- Called when the scene is still off screen (but is about to come on screen).
    -----------------------------------------------------------------------------------------

    elseif ( phase == "did" ) then

        level1SoundChannel = audio.play( soundLevel1, {channel=6, loops=-1} )
        pauseLevel1 = false
        character1.isVisible = true
        character1Wrong.isVisible = false

        lives = 3
        numberCorrect = 0
        AddTextObjectListeners()        

        -- Restart the scene
        RestartScene()
    end

end

-----------------------------------------------------------------------------------------

-- The function called when the scene is issued to leave the screen
function scene:hide( event )

    -- Creating a group that associates objects with the scene
    local sceneGroup = self.view
    local phase = event.phase

    -----------------------------------------------------------------------------------------

    if ( phase == "will" ) then

        level1SoundChannel = audio.stop (6)

        -- Called when the scene is on screen (but is about to go off screen).
        -- Insert code here to "pause" the scene.
        -- Example: stop timers, stop animation, stop audio, etc.
        StopCharacter()
        RemoveTextObjectListeners()

    -----------------------------------------------------------------------------------------

    elseif ( phase == "did" ) then
        --composer.removeScene( "level1_screen (2)" )
    end

end

-----------------------------------------------------------------------------------------

-- The function called when the scene is issued to be destroyed
function scene:destroy( event )

    -- Creating a group that associates objects with the scene
    local sceneGroup = self.view

    -----------------------------------------------------------------------------------------
    --print ("***called destroy: level1_screen")
    --composer.removeScene( "level1_screen" )
    -- Called prior to the removal of scene's view ("sceneGroup").
    -- Insert code here to clean up the scene.
    -- Example: remove display objects, save state, etc.
end

-----------------------------------------------------------------------------------------
-- EVENT LISTENERS
-----------------------------------------------------------------------------------------

-- Adding Event Listeners for Scene
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- add event listener to move character across screen
--Runtime:addEventListener("enterFrame", MoveCharacter )
-----------------------------------------------------------------------------------------

return scene