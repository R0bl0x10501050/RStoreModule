# Documentation

## RStore [CLASS]
### RStore.new(...)
#### Description:
* Creates a new RDataStore for you to use
#### Parameters:
* Datakey - A unique key for storing data in that specific RDataStore
#### Returns:
* RDataStore [CLASS]
## RDataStore [CLASS]
### RDataStore:Get(...)
#### Description:
* Gets the specified obj's value from the cache
#### Parameters:
* Obj - A unique key (can be an Instance, string, integer, etc.)
* DefaultValue - Default value to be cached if there is no saved value in the cache or DataStore API
#### Returns:
* Cached result
### RDataStore:Set(...)
#### Description:
* Sets the specified obj's value to the specified data in the cache
#### Parameters:
* Obj - A unique key (can be an Instance, string, integer, etc.)
* Data - Data to cache in RDataStore
#### Returns:
* Cached result
### RDataStore:Increment(...)
#### Description:
* Increments the specified obj's value by the specified amount in the cache
#### Parameters:
* Obj - A unique key (can be an Instance, string, integer, etc.)
* Amount - Amount to increase the current value by
#### Returns:
* Cached result
### RDataStore:OnUpdate(...)
#### Description:
* Executes callback when the RDataStore is updated
!!! tip "NewValue"
    When the callback is executed, it provides a variable, "newValue". It'd be a good idea to take advantage of that!
#### Parameters:
* Callback - A function to execute every time the RDataStore is updated; callback includes `newValue` as a function parameter
#### Returns:
* nil
### RDataStore:Save(...)
#### Description:
* Saves the specified obj's value to the Roblox Datastore API
!!! success "Auto-Save"
    When a player leaves or game:BindToClse() is fired, :Save() is automatically called.
#### Parameters:
* Obj - A unique key (can be an Instance, string, integer, etc.)
#### Returns:
* Cached result
### RDataStore:SaveAll()
#### Description:
* Calls :Save() on all objs in each RDataStore
!!! warning "Warning"
    :SaveAll() can cause DataStore lag and it is not recommended that this method is used.
