# Yaris API wrapper for Roblox LUAU Exploiting

If you're looking for a Node.js version of this, go [here](https://www.npmlua.com/package/yaris-wrapper).

### Information:
This is a API wrapper for Yaris whitelisting system located [here](https://yaris:rocks/beta/). This is intended to help you use their API endpoint system without you hassling around with messy fetch code. Source code [here](https://github.com/NotRllyRn/YarisWrapper).

### Script compatablity:
this works on most roblox executors. Not guaranteed to work on free exploits. If you any of these: `syn.request`, `http_request`, `request` on your executor, then you're good.

### Disclamer!
I did not make Yaris, this is simply an API wrapper for their service. The Yaris discord server is [here](https://discord.gg/qVBtSYXX72). Please support them!

---
## Table of contents:
- [To get started](#to-get-started-using-loadstring)
    - [Define a new connection](#to-define-a-new-connection)
- [Error handling](#important-error-handling)
- [Using callbacks](#callbacks)
- [List of commands](#list-of-commands-w-examples)
    - [getInfo](#apigetinfo)
    - [addUser](#apiadduser)
    - [removeUser](#apiremoveuser)
    - [getUser](#apigetuser)
    - [editUser](#apiedituser)
    - [whitelistUser](#apiwhitelistuser)
    - [blacklistUser](#apiblacklistuser)
    - [addKey](#apiaddkey)
    - [removeKey](#apiremovekey)
- [Example usage](#example-usage)
---

### to get started using loadstring:
```lua
--// gets the loader.
local Yaris = loadstring(game:HttpGet("https://raw.githubusercontent.com/NotRllyRn/YarisWrapperLUA/main/index.lua"))()
```
### to define a new connection:
```lua
--// defines a new connection to a whitelist.
local yaris = yaris:login("API_KEY") 
```

---

# List of commands w/ examples:
## Important! Error handling.
when an api end point fails for some reason, maybe if you requested removeKey and provided a wrong key, it will always return the Object below, applies to all endpoints.
```lua
{
    success = false,
    error = {
        message = "error_message",
        code = "error_code"
    },
}
```
## Callbacks!
You can use callbacks, by default it will return the information, if there is a callback passed into the function, it will instead return the ouput of the callback
```lua
yaris:getInfo(function(info) --// add a callback for the 1st argument, since it doesn't take in any other arguments
    for info, value in pairs(info) do --// loop through table and print whitelist information
        print(info, value)
    end
end)

yaris:blacklistUser("user_tag", "reason", function(info)  --// callback on the last argument.
    if (info.success) then
        print(info.message) --// successfully blacklisted
    else
        print(info.error.message) --// failed to blacklist
    end
end)
```
### API.getInfo()
* gets whitelist info
```lua
local info = yaris:getInfo(optional_callback)

info = {
    id = "whitelist_id", --// whitelist's id
    owner = "user_id", --// owner of whitelist's id
    name = "whitelist_name", --// the whitelist name
    description = "whitelist_description" --// the whitelist dicription
}
```
### API.addUser()
* adds a user to whitelist using some sort of data (usually hwid)
```lua
local info = yaris:addUser({
    tag = "user_tag",
    data = "user_data",
    expires = "", --// set to never expire
    role = "user_role", --// could be anything
}, optional_callback)

info = { --// adds user successfully
    success = true,
    message = "Successfully added that user to your script."
}
```
### API.removeUser()
* removes a user from whitelist using some sort of data (usually hwid)
```lua
local info = yaris:removeUser({
    tag = "user_tag", --// uses user's tag
    data = "user_data", --// or uses user's hwid
    hashed = false, --// [OPTIONAL] change this accordingly to the data field.
}, optional_callback)

info = { --// removes user successfully
    success = true,
    message = "Successfully removed that user from your script."
}
```
### API.getUser()
* gets a users info w/ their tag
```lua
local info = yaris:getUser("user_tag", optional_callback)

info = { --// successfully retrieved info
    success = true,
    message = "yes",
    additional = {
        tag = "user_tag",
        data = "user_hashed_hwid",
        expires = "", --// sets to never expire
        role = "user_role",
        blacklisted = "false", --// if they are blacklisted or whitelisted
        reason = "" --// for what reason (if blacklisted)
    }
}
```
### API.editUser()
* edits a users data using some sort of data (usually hwid)
```lua
local info = yaris:editUser({
    data = "user_data",     --// unhashed or hashed
    hashed = false,         --// [OPTIONAL] change this accordingling to the data field.
    tag = "new_user_tag",   --// [OPTIONAL]
    expires = "",           --// [OPTIONAL]
    role = "new_user_role", --// [OPTIONAL]
}, optional_callback)

info = { --// successfully edited user.
    success = true,
    message = 'Successfully changed that users tag.'
}
```
### API.whitelistUser()
* whitelists a user using their user id
```lua
local info = yaris:whitelistUser({
    data = "user_data", --// hashed or unhashed
    hashed = false, --// [OPTIONAL] change this accordingling to the data field.
}, optional_callback)

info = { --// successfully whitelised
    success = true,
    message = "Successfully whitelisted that user to your script."
}
```
### API.blacklistUser()
* blacklists a user using their user id w/ a reason (optional)
```lua
local info = yaris:blacklistUser(({
    data = "user_data", --// hashed or unhashed
    reason = "", --// [OPTIONAL]
    hashed = false, --// [OPTIONAL] change this accordingling to the data field.
}, optional_callback)

info = { --// successfully blacklisted
    success = true,
    message = "Successfully blacklisted that user from your script."
}
```
### API.addKey()
* generates a key for your whitelist
```lua
local info = yaris:addKey(optional_callback)

info = { --// successfully generated a key
    success = true,
    message = "Successfully generated a key for your script.",
    additional = { 
        key = "generated_key"
    }
}
```
### API.removeKey()
* generates a key for your whitelist
```lua
local info = yaris:removeKey("key", optional_callback)

info = { --// successfully removed specified key
    success = true,
    message = "Successfully removed that key from your script."
}
```

---

# Example Usage
```lua
local Yaris = loadstring(game:HttpGet("https://raw.githubusercontent.com/NotRllyRn/YarisWrapperLUA/main/index.lua"))()
local yaris = Yaris:login("API_KEY") --// define new connection

local info = yaris:getInfo() --// gets information about your whitelist
print("whitelist id: " .. info.id)

yaris:addUser({ --// adduser endpoint using callback
    tag = "user_tag",
    data = "user_data",
    expires = "", --// never expires if empty
    role = "user_role" --// can be anything
}, function(data)
    if (data && data.success) then
        print(data.message) --// successfully whitelisted
    else
        print(data.error.message, data.error.message.code)
    end
end)

yaris:addkey(function(data) --// adds a key with a callback
	if data.success then
		local key = data.additional.key --// gets the key

		print("Generated key: " .. key)
		local removeKeyData = yaris:removeKey(key) --// removes key without using callback

		if removeKeyData.success then
			print(removeKeyData.message)
		end

		yaris:whitelistUser({ --// whitelists a user with user data (usually hwid) and uses a callback
			data = "user_data",
			hashed = false, --// tells the endpoint wether if the data is hashed or not.
		}, function(data)
			if data.success then
				print(data.message) --// prints the success message
			else
				print(data.error.message, data.error.code)
			end
		end)
	else
		print(data.error.message, data.error.code) --// prints the error
	end
end)
```

Thank you for using yaris-wrapper <3
- 
from [NotRllyRn](https://github.com/NotRllyRn)