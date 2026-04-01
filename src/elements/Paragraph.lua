local Creator = require("../modules/Creator")
local New = Creator.New

local Element = {}

function Element:New(Config)
    local Paragraph = {
        __type = "Paragraph",
        Title = Config.Title or "Note",
        Content = Config.Content or "",
        UIElements = {}
    }
    
    Paragraph.Frame = require("../components/window/Element")({
        Title = Paragraph.Title,
        Desc = Paragraph.Content,
        Parent = Config.Parent,
        Window = Config.Window,
        Hover = false, -- Paragraphs don't need hover effects
        Tab = Config.Tab,
        Index = Config.Index,
        ElementTable = Paragraph,
        ParentConfig = Config,
    })
    
    function Paragraph:SetTitle(text)
        Paragraph.Title = text
        Paragraph.Frame:SetTitle(text)
    end
    
    function Paragraph:SetContent(text)
        Paragraph.Content = text
        Paragraph.Frame:SetDesc(text)
    end
    
    return Paragraph.__type, Paragraph
end

return Element