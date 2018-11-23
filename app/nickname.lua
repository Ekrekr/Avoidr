-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
json = require("json")

loadsave = require("loadsave")

-- include Corona's "widget" library
local widget = require "widget"

lowerLetters = {"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"," "}

rudeWords = {
	'2g1c',
	'2 girls 1 cup',
	'acrotomophilia',
	'alabamahotpocket',
	'alaskanpipeline',
	'anal',
	'anilingus',
	'anus',
	'apeshit',
	'arsehole',
	'ass',
	'asshole',
	'assmunch',
	'autoerotic',
	'autoerotic',
	'babeland',
	'babybatter',
	'babyjuice',
	'ballgag',
	'ballgravy',
	'ballkicking',
	'balllicking',
	'ballsack',
	'ballsucking',
	'bangbros',
	'bareback',
	'barelylegal',
	'bastard',
	'bastardo',
	'bastinado',
	'bbw',
	'bdsm',
	'beaner',
	'beaners',
	'beavercleaver',
	'beaverlips',
	'bestiality',
	'bigblack',
	'bigbreasts',
	'bigknockers',
	'bigtits',
	'bimbos',
	'birdlock',
	'bitch',
	'bitches',
	'blackcock',
	'blondeaction',
	'blondeonblonde',
	'blowjob',
	'blowjob',
	'blowyourload',
	'bluewaffle',
	'blumpkin',
	'bollocks',
	'bondage',
	'boner',
	'boob',
	'boobs',
	'bootycall',
	'brownshowers',
	'brunetteaction',
	'bukkake',
	'bulldyke',
	'bulletvibe',
	'bullshit',
	'bunghole',
	'bunghole',
	'busty',
	'butt',
	'buttcheeks',
	'butthole',
	'cameltoe',
	'camgirl',
	'camslut',
	'camwhore',
	'carpetmuncher',
	'carpetmuncher',
	'circlejerk',
	'clevelandsteamer',
	'clit',
	'clitoris',
	'cloverclamps',
	'clusterfuck',
	'cock',
	'cocks',
	'coprolagnia',
	'coprophilia',
	'cornhole',
	'coon',
	'coons',
	'creampie',
	'cum',
	'cumming',
	'cunnilingus',
	'cunt',
	'darkie',
	'daterape',
	'deep throat',
	'deepthroat',
	'dendrophilia',
	'dick',
	'dildo',
	'dingleberry',
	'dingleberries',
	'dirtypillows',
	'dirtysanchez',
	'doggiestyle',
	'doggiestyle',
	'doggystyle',
	'doggystyle',
	'dogstyle',
	'dolcett',
	'domination',
	'dominatrix',
	'dommes',
	'donkeypunch',
	'doubledong',
	'doublepenetration',
	'dpaction',
	'dryhump',
	'dvda',
	'eatmyas',
	'ecchi',
	'ejaculation',
	'erotic',
	'erotism',
	'escort',
	'eunuch',
	'faggot',
	'fecal',
	'felch',
	'fellatio',
	'feltch',
	'female squirting',
	'femdom',
	'figging',
	'fingerbang',
	'fingering',
	'fisting',
	'footfetish',
	'footjob',
	'frotting',
	'fuck',
	'fuk',
	'fudge packer',
	'fudgepacker',
	'futanari',
	'gangbang',
	'gaysex',
	'genitals',
	'giantcock',
	'girlon',
	'girlontop',
	'girlsgone wild',
	'goatcx',
	'goatse',
	'god damn',
	'gokkun',
	'golden shower',
	'goodpoop',
	'googirl',
	'goregasm',
	'grope',
	'groupsex',
	'g-spot',
	'guro',
	'handjob',
	'handjob',
	'hardcore',
	'hardcore',
	'hentai',
	'homoerotic',
	'honkey',
	'hooker',
	'hotcarl',
	'hotchick',
	'howtokill',
	'howtomurder',
	'hugefat',
	'humping',
	'incest',
	'intercourse',
	'jackoff',
	'jailbait',
	'jailbait',
	'jellydonut',
	'jerkoff',
	'jigaboo',
	'jiggaboo',
	'jiggerboo',
	'jizz',
	'juggs',
	'kike',
	'kinbaku',
	'kinkster',
	'kinky',
	'knobbing',
	'leatherrestraint',
	'lemonparty',
	'lolita',
	'lovemaking',
	'makemecome',
	'malesquirting',
	'masturbate',
	'menage a trois',
	'milf',
	'missionaryposition',
	'motherfucker',
	'moundofvenus',
	'mrhands',
	'muffdiver',
	'muffdiving',
	'naked',
	'nambla',
	'nawashi',
	'negro',
	'neonazi',
	'nigga',
	'nigger',
	'nignog',
	'nimphomania',
	'nipple',
	'nsfw images',
	'nude',
	'nudity',
	'nympho',
	'nymphomania',
	'octopussy',
	'omorashi',
	'onecuptwogirls',
	'oneguyonejar',
	'orgasm',
	'orgy',
	'paedophile',
	'paki',
	'panties',
	'panty',
	'pedobear',
	'pedophile',
	'pegging',
	'penis',
	'phonesex',
	'pieceofshit',
	'pissing',
	'pisspig',
	'pisspig',
	'playboy',
	'pleasurechest',
	'polesmoker',
	'ponyplay',
	'poof',
	'poon',
	'poontang',
	'punany',
	'poop chute',
	'poopchute',
	'porn',
	'porno',
	'pornography',
	'princealbertpiercing',
	'pthc',
	'pubes',
	'pussy',
	'queaf',
	'queef',
	'quim',
	'raghead',
	'raging boner',
	'rape',
	'raping',
	'rapist',
	'rectum',
	'reverse cowgirl',
	'rimjob',
	'rimming',
	'rosypalm',
	'rustytrombone',
	'sadism',
	'santorum',
	'scat',
	'schlong',
	'scissoring',
	'semen',
	'sex',
	'sexo',
	'sexy',
	'shaved beaver',
	'shaved pussy',
	'shemale',
	'shibari',
	'shit',
	'shitblimp',
	'shitty',
	'shota',
	'shrimping',
	'skeet',
	'slanteye',
	'slut',
	's&m',
	'smut',
	'snatch',
	'snowballing',
	'sodomize',
	'sodomy',
	'spic',
	'splooge',
	'sploogemoose',
	'spooge',
	'spreadlegs',
	'spunk',
	'strap on',
	'strapon',
	'strappado',
	'stripclub',
	'styledoggy',
	'suck',
	'sucks',
	'suicidegirls',
	'sultrywomen',
	'swastika',
	'swinger',
	'taintedlove',
	'tastemy',
	'teabagging',
	'threesome',
	'throating',
	'tiedup',
	'tightwhite',
	'tit',
	'tits',
	'titties',
	'titty',
	'tongue in a',
	'topless',
	'tosser',
	'towelhead',
	'tranny',
	'tribadism',
	'tub girl',
	'tubgirl',
	'tushy',
	'twat',
	'twink',
	'twinkie',
	'twogirlsonecup',
	'undressing',
	'upskirt',
	'urethraplay',
	'urophilia',
	'vagina',
	'venusmound',
	'vibrator',
	'violetwand',
	'vorarephilia',
	'voyeur',
	'vulva',
	'wank',
	'wetback',
	'wetdream',
	'whitepower',
	'wrappingmen',
	'wrinkledstarfish',
	'yaoi',
	'yellowshowers',
	'yiffy',
	'zoophilia',
}

highScore = 0
highScoreMP = 0
userID = nil

usernameText = ""

goToMenuTriggered = false

foundData = loadsave.loadTable("savedata.json")

if foundData == nil then
	print("no file found")
else
	if foundData["highScore"] > 0 then
		foundData = nil
	else
		userID = foundData["userID"]
		audio.setVolume(foundData["gameVolume"])
		highScoreMP = foundData["highScoreMP"]
		print("File found and loaded")
	end
end

local function createNewSaveFile(nickname, device, userID)
	foundData = {
		nickname = nickname,
		highScore = 0,
		highScoreMP = 0,
		device = device,
		gameVolume = 1.0,
		userID = userID
	}
	foundData["nickname"] = nickname
	loadsave.saveTable(foundData, "savedata.json")
end

-- createNewSaveFile("skimp", "GT-I9300")

function deleteUser()
	local function RetrieveUserData( event )
	    if ( event.isError ) then
	    	print("Network error!")
	    else
	        local response = json.decode(event.response)
	        -- printTable(response)
	    end
	end     

	-- Create a table to hold our headers we'll be passing to 
	-- backendless. This is how Backendless 
	local headers = {}
	headers["application-id"] = "5146253E-BB38-8315-FFB0-E54AC75C3B00"
	headers["secret-key"] = "0ED284EE-37F3-3085-FF81-4D5E60025A00"
	headers["Content-Type"] = "application/json"
	headers["application-type"] = "REST"
	 
	local tempTable = {}
	local jsonData = json.encode(tempTable)

	local params = {}
	params.headers = headers
	params.body = jsonData

	network.request("https://api.backendless.com/v1/data/nicknames/"..userID, "DELETE", RetrieveUserData, params)

end

function requestNewUser(nickname)
	local returnResponse = false

	if type(nickname) ~= "string" then
	    networkReturn = "invalid"
		return "invalid input type"
	end

	if string.len(nickname) < 3 or string.len(nickname) > 12 then
		userEntry.text = "   nickname must be \n    3 - 12 letters"
		return "nickname incorrect length"
	end

	for j = 1, #nickname do
		local c = nickname:sub(j,j):lower()
		if checkInTable(lowerLetters, c) == false then
		    networkReturn = "invalid char"
			return "invalid char"
		end
	end

	testingName = nickname:gsub(" ", ""):lower()

	if checkInTable(rudeWords, testingName) then
	    networkReturn = "too rude"
		return "too rude"
	end

	-- Create a table to hold our headers we'll be passing to 
	-- backendless. This is how Backendless 
	local headers = {}
	headers["application-id"] = "5146253E-BB38-8315-FFB0-E54AC75C3B00"
	headers["secret-key"] = "0ED284EE-37F3-3085-FF81-4D5E60025A00"
	headers["Content-Type"] = "application/json"
	headers["application-type"] = "REST"
	 
	-- This is a "yes" press
	-- OK, well write to the file and update it with the user's name
	-- Create a table to put our data into
	local tempTable = {}
	-- Populate our table with some data...you'll need to change the usernames
	-- if you plan on testing it multiple times, of course. Check on your backendless
	-- dashboard and find the user table:
	 
	tempTable.nickname = nickname
	tempTable.devicetype = system.getInfo("model")
	 
	-- Encode the table into the expectes JSON...
	local jsonData = json.encode(tempTable)
	-- Debug output for your console window...
	print("JSON is "..jsonData)
	-- Event handler for our network.request webcall
	local function RetrieveUserData( event )
	    if ( event.isError ) then
	        networkReturn = "network error"
	    else
	        local response = json.decode(event.response)
	        -- printTable(response)
	        if response["created"] ~= nil then -- If creation successful
	        	networkReturn = "created"
	        	userID = response["objectId"]
	        else
	        	networkReturn = "duplicate"
	        end
	    end
	end     
	 
	-- Now, we'll combine both our headers and the body into the single table "params"
	-- and send this off to Backendless! 
	local params = {}
	params.headers = headers
	params.body = jsonData
	 
	-- To create a user using the JSON encoded info we defined above in the 'params' table
	network.request( "https://api.backendless.com/v1/data/nicknames", "POST", RetrieveUserData, params)

	return returnResponse
end

function updateHighscore(inpScore)
	-- print("Updating high score")
	local function RetrieveUserData( event )
	    if ( event.isError ) then
	       print("Network error!")
	    else
	        local response = json.decode(event.response)
	  --       if response["nickname"] ~= nil then -- If creation successful
	  --       	welcomeText.text = "Our newest user: " .. response["nickname"] .. "\nwelcome!"
	  --       else
	  --       	welcomeText.text = "network error"
	  --       end
			-- welcomeText.alpha = 1
			-- printTable(response)
	    end
	end     

	-- Create a table to hold our headers we'll be passing to 
	-- backendless. This is how Backendless 
	local headers = {}
	headers["application-id"] = "5146253E-BB38-8315-FFB0-E54AC75C3B00"
	headers["secret-key"] = "0ED284EE-37F3-3085-FF81-4D5E60025A00"
	headers["Content-Type"] = "application/json"
	headers["application-type"] = "REST"
	 
	local tempTable = {}
	tempTable["highscore"] = inpScore
	local jsonData = json.encode(tempTable)

	local params = {}
	params.headers = headers
	params.body = jsonData

	network.request("https://api.backendless.com/v1/data/nicknames/" .. userID, "PUT", RetrieveUserData, params)
end

local function aliasTextListener( event )

    if ( event.phase == "began" ) then
        -- User begins editing "defaultField"
        if event.text ~= nil then
	    	usernameText = event.text
	    end

    elseif ( event.phase == "ended" or event.phase == "submitted" ) then
        -- Output resulting text from "defaultField"
        if event.text ~= nil then
	    	usernameText = event.text
	    	requestNewUser(usernameText)
	    end

    elseif ( event.phase == "editing" ) then
        if event.text ~= nil then
	    	usernameText = event.text
	    end
    end
end

local function nicknameTick(event)
	if networkReturn == "created" then
		print("Creating new user and save file")
		if userTextField then userTextField:removeEventListener( "userInput", aliasTextListener ) display.remove(userTextField) userTextField = nil end
		if userEnterBtn then display.remove(userEnterBtn) userEnterBtn = nil end
		userTick.alpha = 1
		createNewSaveFile(usernameText, system.getInfo("model"), userID)
		networkReturn = ""
		local tempFunc = function() composer.gotoScene("mainmenu") end
		timer.performWithDelay(1000, tempFunc)

	elseif networkReturn == "duplicate" then
		print("@@@ NAME IS DUPLICATE")
	    userEntry.text = "Nickname already taken"
	    networkReturn = ""

	elseif networkReturn == "network error" then
		print("NETWORK ERROR")
		userEntry.text = "Connection Error"
		networkReturn = ""

	elseif networkReturn == "too rude" then
		print("NAME TOO RUDE")
		userEntry.text = "Nickname too rude :("
		networkReturn = ""

	elseif networkReturn == "invalid char" then
		print("INVALID CHAR USED")
		userEntry.text = "Invalid character used"
		networkReturn = ""
	end
end

function scene:create( event )
	-- Happens when the scene is first created, and never again (scene:show is also called, so buttons that need to be deleted should be put there)
	local sceneGroup = self.view

end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	if phase == "will" then

		if foundData ~= nil then
			composer.gotoScene("mainmenu")
		else

			-- Called when the scene is still off screen and is about to move on screen
			userBox = display.newImageRect( "artwork/menu items/username box.bmp", SCRW, SCRH )
			userBox.anchorX, userBox.anchorY = 0, 0
			userBox.x, userBox.y = SCRORIX, SCRORIY
			sceneGroup:insert(userBox)

			userEntry = display.newText("Enter Nickname", SCRORIX + SCRW*1/2, SCRORIY + SCRH*3/10 + toSCRH(160/2), native.systemFontBold, 40)
			userEntry.anchorX, userEntry.anchorY = 0.5, 0.5
			userEntry:setFillColor(0, 0, 0)
			sceneGroup:insert(userEntry)

			userTextField = native.newTextField(SCRORIX + SCRW/2, SCRORIY + SCRH*5/10, SCRW*2/3, SCRH/10)
			userTextField.anchorX, userTextField.anchorY = 0.5, 0.5
			userTextField:addEventListener( "userInput", aliasTextListener )
			sceneGroup:insert(userTextField)

			userEnterBtn = widget.newButton(
				{
			        width = toSCRW(200, 0.5),
			        height = toSCRW(100, 0.5),
			        shape = "rect",
			        label = "Enter",
			        fontSize = 24,
			        fillColor =  { default={1, 0.3, 0.3}, over={0, 0, 0} },
			        labelColor =  { default={1,1,1}, over={1, 1, 1} },
					onRelease = function()
						print(requestNewUser(usernameText))
						native.setKeyboardFocus( nil )
					end
				}
			)
			userEnterBtn.anchorX, userEnterBtn.anchorY = 0.5, 0.5
			userEnterBtn.x, userEnterBtn.y = SCRORIX + SCRW/2, SCRORIY + SCRH*6/10
			sceneGroup:insert(userEnterBtn)

			userTick = display.newImageRect( "artwork/menu items/green tick.png", SCRW/5, SCRW/5)
			userTick.anchorX, userTick.anchorY = 0.5, 0.5
			userTick.x, userTick.y = SCRORIX + SCRW/2, SCRORIY + SCRH/2
			userTick.alpha = 0
			sceneGroup:insert(userTick)

			Runtime:addEventListener( "enterFrame", nicknameTick )
		end


	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
	end	
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
		Runtime:removeEventListener( "enterFrame", nicknameTick )

		audio.play(menuTransition)

	elseif phase == "did" then

		-- Called when the scene is now off screen
		if userBox then display.remove(userBox) userBox = nil end
		if userEntry then display.remove(userEntry) userEntry = nil end
		if userTextField then display.remove(userTextField) userTextField = nil end
		if userEnterBtn then display.remove(userEnterBtn) userEnterBtn = nil end
		if userTick then display.remove(userTick) userTick = nil end
	end	
end

function scene:destroy( event )
	local sceneGroup = self.view
	
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
end

-- Listener setup


-----------------------------------------------------------------------------------------

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene