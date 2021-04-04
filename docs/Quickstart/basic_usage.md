# Quick Start

!!! info
    This is an example of how to save player cash.

First, you need to create a new RDataStore to save data.
``` lua
local RStore = require("path.to.RStore")
local RDataStore = RStore.new("datakey")
```

Next, you probably have a variable or something you want to save.

``` lua
local RStore = require("path.to.RStore")
local CashStore = RStore.new("datakey")
game.Players.PlayerAdded:Connect(function(plr)
	local cash = CashStore:Get(plr, 0) -- **plr** is who you're saving it for, **0** is the default value
end)
```

Obviously, something makes the player earn some cash. In this case, let's make it add 10 cash every time they say "I want cash!"

``` lua
local RStore = require("path.to.RStore")
local CashStore = RStore.new("datakey")
game.Players.PlayerAdded:Connect(function(plr)
	local cash = CashStore:Get(plr, 0) -- **plr** is who you're saving it for, **0** is the default value
	
	plr.Chatted:Connect(function(msg)
		if msg == "I want cash!" then
			CashStore:Increment(plr, 10) -- here, you **increment** since you want to *add* to the current value. otherwise, if you wanted to directly overwrite, you'd use :Set()
		end
	end)
end)
```

??? tip ""
    You can print the value of CashStore:Get(plr) to see it increase.

Great! Now you have a basic understanding of how to use RStore in your Roblox game!
