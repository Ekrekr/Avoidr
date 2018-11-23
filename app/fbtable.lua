-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------



local composer = require( "composer" )
local facebook = require("plugin.facebook.v4")
local json = require("json")


local fbtable = {}



---------------------------------------------------------------------------------
-- Facebook Commands
---------------------------------------------------------------------------------
fbtable.fbCommand = nil		-- forward reference
fbtable.LOGOUT = 1
fbtable.SHOW_FEED_DIALOG = 2
fbtable.SHARE_LINK_DIALOG = 3
fbtable.POST_MSG = 4
fbtable.POST_PHOTO = 5
fbtable.GET_USER_INFO = 6
fbtable.PUBLISH_INSTALL = 7
fbtable.lastStatus = "Not Connected"
fbtable.manToShare = nil

-- Check for an item inside the provided table
-- Based on implementation at: https://www.omnimaga.org/other-computer-languages-help/(lua)-check-if-array-contains-given-value/
function inTable( table, item )
	for k,v in pairs( table ) do
		if v == item then
			return true
		end
	end
	return false
end

-- This function is useful for debugging problems with using FB Connect's web api,
-- e.g. you passed bad parameters to the web api and get a response table back
function FBPrintTable( t, label, level )
	if label then print( label ) end
	level = level or 1

	if t then
		for k,v in pairs( t ) do
			local prefix = ""
			for i=1,level do
				prefix = prefix .. "\t"
			end

			print( prefix .. "[" .. tostring(k) .. "] = " .. tostring(v) )
			if type( v ) == "table" then
				print( prefix .. "{" )
				FBPrintTable( v, nil, level + 1 )
				print( prefix .. "}" )
			end
		end
	end
end

function fbtable:createStatusMessage( message, x, y )
	-- Show text, using default bold font of device (Helvetica on iPhone)
	local textObject = display.newText( message, 0, 0, native.systemFontBold, 24 )
	textObject:setFillColor( 1,1,1 )

	-- A trick to get text to be centered
	local group = display.newGroup()
	group.x = x
	group.y = y
	group:insert( textObject, true )

	-- Insert rounded rect behind textObject
	local r = 10
	local roundedRect = display.newRoundedRect( 0, 0, SCRW/3 + 2*r, textObject.contentHeight + 2*r, r )
	roundedRect:setFillColor( 55/255, 55/255, 55/255, 190/255 )
	group:insert( 1, roundedRect, true )

	group.textObject = textObject
	return group
end

-- Runs the desired facebook command
function fbtable:processFBCommand( )

	-- The following displays a Facebook dialog box for posting to your Facebook Wall
	if fbtable.fbCommand == fbtable.SHOW_FEED_DIALOG then
		-- "feed" is the standard "post status message" dialog
		local response = facebook.showDialog( "feed" )
		FBPrintTable(response)
	end

	-- This displays a Facebook Dialog for posting a link with a photo to your Facebook Wall
	if fbtable.fbCommand == fbtable.SHARE_LINK_DIALOG then
		local response = facebook.showDialog( "link", {
			name = "Facebook v4 Corona plugin on iOS!",
			link = "https://coronalabs.com/blog/2015/09/01/facebook-v4-plugin-ios-beta-improvements-and-new-features/",
			description = "More Facebook awesomeness for Corona!",
			picture = "https://coronalabs.com/wp-content/uploads/2014/11/Corona-Icon.png",
		})
		FBPrintTable(response)
	end

	-- Request the current logged in user's info
	if fbtable.fbCommand == fbtable.GET_USER_INFO then
		local response = facebook.request( "me" )
		FBPrintTable(response)
		-- facebook.request( "me/friends" )		-- Alternate request
	end

	-- This code posts a photo image to your Facebook Wall
	if fbtable.fbCommand == fbtable.POST_PHOTO then
		local attachment = {
			name = "Developing a Facebook Connect app using the Corona SDK!",
			link = "http://www.coronalabs.com/links/forum",
			caption = "Link caption",
			description = "Corona SDK for developing iOS and Android apps with the same code base.",
			picture = "http://www.coronalabs.com/links/demo/Corona90x90.png",
			actions = json.encode( { { name = "Learn More", link = "http://coronalabs.com" } } )
		}
	
		local response = facebook.request( "me/feed", "POST", attachment )		-- posting the photo
		FBPrintTable(response)
	end
	
	-- This code posts a message to your Facebook Wall
	if fbtable.fbCommand == fbtable.POST_MSG then
		local time = os.date("*t")
		local postMsg = {
			message = "Test status, do not like " ..
				os.date("%A, %B %e")  .. ", " .. time.hour .. ":"
				.. time.min .. "." .. time.sec
		}
	
		local response = facebook.request( "me/feed", "POST", postMsg )		-- posting the message
		FBPrintTable(response)
	end
end

-- New Facebook Connection listener
function fbtable:listener( event )

	-- Debug Event parameters printout --------------------------------------------------
	-- Prints Events received up to 20 characters. Prints "..." and total count if longer
	print( "Facebook Listener events:" )
	
	local maxStr = 20		-- set maximum string length
	local endStr
	
	for k,v in pairs( event ) do
		local valueString = tostring(v)
		if string.len(valueString) > maxStr then
			endStr = " ... #" .. tostring(string.len(valueString)) .. ")"
		else
			endStr = ")"
		end
		print( "   " .. tostring( k ) .. "(" .. tostring( string.sub(valueString, 1, maxStr ) ) .. endStr )
	end
	-- End of debug Event routine -------------------------------------------------------

    print( "event.name", event.name ) -- "fbconnect"
    print( "event.type:", event.type ) -- type is either "session" or "request" or "dialog"
	print( "isError: " .. tostring( event.isError ) )
	print( "didComplete: " .. tostring( event.didComplete ) )
	print( "response: " .. tostring( event.response ) )
	-----------------------------------------------------------------------------------------
		-- Process the response to the FB command
		-- Note: If the app is already logged in, we will still get a "login" phase
	-----------------------------------------------------------------------------------------

    if ( "session" == event.type ) then
        -- event.phase is one of: "login", "loginFailed", "loginCancelled", "logout"
		fbtable.lastStatus = event.phase
		
		print( "Session Status: " .. event.phase )
		
		if event.phase ~= "login" then
			-- Exit if login error
			return
		else
			-- Run the desired command
			fbtable:processFBCommand()
		end

    elseif ( "request" == event.type ) then
        -- event.response is a JSON object from the FB server
        local response = event.response
        
		if ( not event.isError ) then
	        response = json.decode( event.response )
	        
			print( "Facebook Command: " .. fbtable.fbCommand )

	        if fbtable.fbCommand == fbtable.GET_USER_INFO then
				fbtable.lastStatus = response.name
				FBPrintTable( response, "User Info", 3 )
				print( "name", response.name )
				
			elseif fbtable.fbCommand == fbtable.POST_PHOTO then
				FBPrintTable( response, "photo", 3 )
				fbtable.lastStatus = "Photo Posted"
							
			elseif fbtable.fbCommand == fbtable.POST_MSG then
				FBPrintTable( response, "message", 3 )
				fbtable.lastStatus = "Message Posted"
				
			else
				-- Unknown command response
				print( "Unknown command response" )
				fbtable.lastStatus = "Unknown ?"
			end

        else
        	-- Post Failed
			fbtable.lastStatus = "Post failed"
			FBPrintTable( event.response, "Post Failed Response", 3 )
		end
		
	elseif ( "dialog" == event.type ) then
		-- showDialog response
		print( "dialog response:", event.response )
		fbtable.lastStatus = event.response
    end
end

function fbtable:enforceFacebookLogin()
	if facebook.isActive then
		local accessToken = facebook.getCurrentAccessToken()
		if accessToken == nil then

			print( "Need to log in" )
			facebook.login( listener )

		elseif not inTable( accessToken.grantedPermissions, "publish_actions" ) then

			print( "Logged in, but need permissions" )
			FBPrintTable( accessToken, "Access Token Data" )
			facebook.login( listener, {"publish_actions"} )

		else

			print( "Already logged in with needed permissions" )
			FBPrintTable( accessToken, "Access Token Data" )
			fbtable.lastStatus = "login"
			fbtable:processFBCommand()

		end
	else
		print( "Please wait for facebook to finish initializing before checking the current access token" );
	end
end


-- This code posts a photo image to your Facebook Wall
function fbtable:postPhoto_onRelease( event )
	-- call the login method of the FB session object, passing in a handler
	-- to be called upon successful login.
	fbtable.fbCommand = fbtable.POST_PHOTO
	fbtable:enforceFacebookLogin()
end

-- Request the current logged in user's info
function fbtable:getInfo_onRelease( event )
	-- call the login method of the FB session object, passing in a handler
	-- to be called upon successful login.
	fbtable.fbCommand = fbtable.GET_USER_INFO
	fbtable:enforceFacebookLogin()
end

-- This code posts a message to your Facebook Wall
function fbtable:postMsg_onRelease( event )
	-- call the login method of the FB session object, passing in a handler
	-- to be called upon successful login.
	fbtable.fbCommand = fbtable.POST_MSG
	fbtable:enforceFacebookLogin()
end

-- The following displays a Facebook dialog box for posting to your Facebook Wall
function fbtable:showFeedDialog_onRelease( event )
	-- call the login method of the FB session object, passing in a handler
	-- to be called upon successful login.
	fbtable.fbCommand = fbtable.SHOW_FEED_DIALOG
	fbtable:enforceFacebookLogin()
end

-- This displays a Facebook Dialog for posting a link with a photo to your Facebook Wall
function fbtable:shareLinkDialog_onRelease( event )
	-- call the login method of the FB session object, passing in a handler
	-- to be called upon successful login.
	fbtable.fbCommand = fbtable.SHARE_LINK_DIALOG
	fbtable:enforceFacebookLogin()
end

function fbtable:publishInstall_onRelease( event )
	fbtable.fbCommand = fbtable.PUBLISH_INSTALL
	facebook.publishInstall()
end

function fbtable:logOut_onRelease( event )
	-- call the login method of the FB session object, passing in a handler
	-- to be called upon successful login.
	fbtable.fbCommand = fbtable.LOGOUT
	facebook.logout()
end
---------------------------------------------------------------------------------

return fbtable