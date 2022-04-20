local httpService = game:GetService("HttpService")
local base = {
    setKey = function(self, key)
        if not self.apiKey then
            self.apiKey = key
        end
    end,
    setInfo = function(self, info)
        if not self.information then
            self.information = info
        end
    end,
    Info = function(self)
        return self.information
    end,
    handleCallback = function(self, info, callback)
        return (callback and (type(callback) == "function") and callback(info)) or info
    end,
}

function ExploitCheck(name, ...)
	local found
	for _, v in ipairs({ ... }) do
		if v then
			found = v
			break
		end
	end
	if found then
		base[name] = found
	else
		error("Unsupported exploit function: " .. name, 1)
	end
end

ExploitCheck("httpRequest", syn and syn.request, http_request, request)
ExploitCheck("JSONDecode", function(...)
	return httpService:JSONDecode(...)
end)
ExploitCheck("JSONEncode", function(...)
	return httpService:JSONEncode(...)
end)
base["apiFetch"] = function(self, endpoint, data)
	local endpoint = endpoint and tostring(endpoint)
	local data = data and (type(data) == "table") and data or {}
	if not endpoint then
		return {
			success = false,
			error = {
				message = "Invalid endpoint",
				code = "invalid_endpoint",
			},
		}
	end

	local post = {
		Url = "https://api.yaris.rocks/v1/" .. endpoint,
		Method = "POST",
		Headers = {
			["Content-Type"] = "application/json",
			["yaris-authentication"] = self.apiKey,
		},
		Body = self.JSONEncode(data),
	}

	local success, response = pcall(function()
		return self.JSONDecode(self.httpRequest(post).Body)
	end)

	if success then
		if response.success or response.information then
			return response.information
		else
			return {
				success = false,
				error = response.error,
			}
		end
	else
		return {
			success = false,
			error = {
				message = "Failed request",
				code = "failed_request",
			},
		}
	end
end

setrawmetatable(base, {
	__newindex = function() end,
})

local endpoints = {
	getInfo = function(self, callback)
		while not self:Info() do
			wait()
		end

		return self:handleCallback(self:Info(), callback)
	end,
	addUser = function(self, data, callback)
		local info = self:apiFetch("adduser", data)
		return self:handleCallback(info, callback)
	end,
	removeUser = function(self, data, callback)
		local info = self:apiFetch("removeuser", data)
		return self:handleCallback(info, callback)
	end,
	getUser = function(self, tag, callback)
		local info = self:apiFetch("getuser", { tag = tag })
		return self:handleCallback(info, callback)
	end,
	editUser = function(self, data, callback)
		local info = self:apiFetch("edituser", data)
		return self:handleCallback(info, callback)
	end,
	whitelistUser = function(self, data, callback)
		local info = self:apiFetch("whitelistuser", data)
		return self:handleCallback(info, callback)
	end,
	blacklistUser = function(self, data, callback)
		local info = self:apiFetch("blacklistuser", data)
		return self:handleCallback(info, callback)
	end,
	addkey = function(self, callback)
		local info = self:apiFetch("addkey")
		return self:handleCallback(info, callback)
	end,
	removeKey = function(self, key, callback)
		local info = self:apiFetch("removekey", { key = key })
		return self:handleCallback(info, callback)
	end,
}

local endpointIndex = {}

setrawmetatable(endpointIndex, {
	__newindex = function() end,
	__index = base,
})
setrawmetatable(endpoints, {
	__newindex = function() end,
	__index = endpointIndex,
})

local topLevel = {
	login = function(self, api_key, callback)
		local new = {}
		setrawmetatable(new, {
			__index = endpoints,
		})

		new:setKey(api_key)
		coroutine.resume(coroutine.create(function()
			local data = new:apiFetch("info")
			if not data.error then
				new:setInfo(data)
			else
				error("[Yaris-Wrapper] Failed to initiate, ERROR: " .. data.error.message .. ", CODE: " .. data.error.code, 1)
			end
		end))

		return new
	end,
}

setrawmetatable(topLevel, {
	__newindex = function() end,
})

return topLevel
