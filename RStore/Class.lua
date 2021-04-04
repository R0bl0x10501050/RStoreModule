local ClassModule = {}
setmetatable(ClassModule, ClassModule)

ClassModule.__call = function(self, data) --> Create a new class
	
	if not data.__isClass then --> Brand-new Class
		assert(data.__init__, "No init function was given.")
		assert(not data.new, "'new' is a restricted keyword.")
		assert(not data.__super__, '__super__ is restricted.')
			
		local Class = { __isClass = true } --> For extending other classes.
		Class.__index = Class
		
		for n,d in pairs(data) do
			Class[n] = d
		end
		
		Class.new = function(...)
			local child = {}
			setmetatable(child, Class)
			Class.__init__(child, ...)
			return child
		end
		
		return Class
	else
		return function(truedata) --> Sub class
			
			assert(truedata.__init__, "No init function was given.")
			assert(not truedata.new, "'new' is a restricted keyword.")
			assert(not truedata.__super__, '__super__ is restricted.')
			
			local Class = { __Class__ = true }
			Class.__index = Class
			
			for n,o in pairs(data) do
				if n == "__init__" then
					Class.__super__ = o
				elseif n ~= "new" and n:sub(1,2) ~= "__" then
					Class[n] = o
				end
			end
							
			for n,o in pairs(truedata) do
				Class[n] = o
			end
									
			Class.new = function(...)
				local child = {}
				setmetatable(child, Class)
				Class.__init__(child, ...)
				return child
			end
			
			return Class
			
		end
	end
	
end

return ClassModule
