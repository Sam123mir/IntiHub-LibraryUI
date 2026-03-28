local content = readfile("c:/Users/samir/OneDrive/Desktop/WindUI/dist/main.lua")
local exec, err = loadstring(content)
if not exec then
    print("SYNTAX ERROR FOUND:")
    print(err)
else
    print("SYNTAX OK")
end
