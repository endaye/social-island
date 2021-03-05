---@module GuiGuitar
---@copyright Lilith Games, Avatar Team
---@author Yen Yuan
local GuiGuitar, this = ModuleUtil.New("GuiGuitar", ClientBase)

local function SortBackFret(_backFret)
    table.sort(
        _backFret,
        function(p1, p2)
            return p1 > p2
        end
    )
end

---初始化函数
function GuiGuitar:Init()
    this:DataInit()
    this:NodeDef()
    this:EventBind()
    this:StringInit()
end

function GuiGuitar:DataInit()
    this.stringAudio = {}
    this.stringPitch = {}
end

function GuiGuitar:NodeDef()
    this.gui = localPlayer.Local.GuitarGui
    this.fret = this.gui.FretPanel:GetChildren()
    this.string = this.gui.StringPanel:GetChildren()
end

function GuiGuitar:StringInit()
    for i = 1, 6 do
        local data = {
            pitchFret = 0,
            backFret = {}
        }
        table.insert(this.stringPitch, data)
    end
end

function GuiGuitar:EventBind()
    for k, v in ipairs(this.string) do
        v.OnEnter:Connect(
            function()
                this:PlayString(k)
            end
        )
    end
    for k, v in ipairs(this.fret) do
        for m, n in ipairs(v:GetChildren()) do
            n.OnDown:Connect(
                function()
                    this:PressFret(m, k)
                end
            )
            n.OnUp:Connect(
                function()
                    this:RealseFret(m, k)
                end
            )
        end
    end
end

function GuiGuitar:PlayString(_string)
    -- TODO: 播放对应弦的音效
    NetUtil.Fire_C(
        "PlayEffectEvent",
        localPlayer,
        Config.GuitarPitch[_string].Pitch[this.stringPitch[_string].pitchFret],
        localPlayer.Position
    )
end

--- 按弦
function GuiGuitar:PressFret(_string, _fret)
    if _fret == this.stringPitch[_string].pitchFret then
        return
    end
    if _fret > this.stringPitch[_string].pitchFret then
        table.insert(this.stringPitch[_string].backFret, this.stringPitch[_string].pitchFret)
        this.stringPitch[_string].pitchFret = _fret
    else
        table.insert(this.stringPitch[_string].backFret, _fret)
    end
    SortBackFret(this.stringPitch[_string].backFret)
    --! test
    print(
        "正按着的弦：" ..
            _string ..
                "，正按着的品：" ..
                    this.stringPitch[_string].pitchFret .. " " .. table.dump(this.stringPitch[_string].backFret)
    )
end

--- 松弦
function GuiGuitar:RealseFret(_string, _fret)
    if this.stringPitch[_string].pitchFret == _fret then
        --TODO： 停止音效
        this.stringPitch[_string].pitchFret = this.stringPitch[_string].backFret[1]
        table.remove(this.stringPitch[_string].backFret, 1)
    else
        for k, v in pairs(this.stringPitch[_string].backFret) do
            if v == _fret then
                table.remove(this.stringPitch[_string].backFret, k)
            end
        end
    end
    --! test
    print(
        "正按着的弦：" ..
            _string ..
                "，正按着的品：" ..
                    this.stringPitch[_string].pitchFret .. " " .. table.dump(this.stringPitch[_string].backFret)
    )
end

return GuiGuitar
