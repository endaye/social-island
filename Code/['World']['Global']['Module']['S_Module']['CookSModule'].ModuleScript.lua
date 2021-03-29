---@module CookS
---@copyright Lilith Games, Avatar Team
---@author Yen Yuan
local CookS, this = ModuleUtil.New("CookS", ServerBase)

---初始化函数
function CookS:Init()
    this:DataInit()
end

function CookS:DataInit()
    this.foodNum = #world.FoodLocation:GetChildren()
    this.potFree = true
    this.curFoodNum = 0
    this.foodList = {}
    for i = 1, this.foodNum do
        this.foodList[i] = nil
    end
end

function CookS:FoodOnDeskEventHandler(_foodId, _player)
    if this.curFoodNum >= this.foodNum then
        return
    end
    this.curFoodNum = this.curFoodNum + 1
    this:PutFood(_foodId, _player)
    NetUtil.Broadcast("SycnDeskFoodNumEvent", this.curFoodNum, this.foodNum)
end

--桌上放菜
function CookS:PutFood(_foodId, _player)
    for i = 1, this.foodNum do
        if this.foodList[i] == nil then
            this.foodList[i] = {
                foodId = _foodId,
                cook = _player.UserId,
                index = i,
                cookName = _player.Name
            }
            -- 摆上食物
            -- TODO:需要读表中的model创建
            local model =
                world:CreateInstance(
                Config.CookMenu[_foodId].Model,
                "Food",
                world.FoodLocation["Location" .. i],
                world.FoodLocation["Location" .. i].Position
            )
            model.OnCollisionBegin:Connect(
                function(_hitObject)
                    if _hitObject and _hitObject.Avatar and _hitObject.Avatar.ClassName=='PlayerAvatarInstance' then
                        NetUtil.Fire_C(
                            "SetSelectFoodEvent",
                            _hitObject,
                            _foodId,
                            this.foodList[i].cookName,
                            _player.UserId
                        )
                        NetUtil.Fire_C("OpenDynamicEvent", _hitObject, "Interact", 27)
                    end
                end
            )
            model.OnCollisionEnd:Connect(
                function(_hitObject)
                    if _hitObject and _hitObject.Avatar and _hitObject.Avatar.ClassName=='PlayerAvatarInstance' then
                        NetUtil.Fire_C("ChangeMiniGameUIEvent", _hitObject)
                    end
                end
            )
            return
        end
    end
end

function CookS:OnPlayerJoinEventHandler(_player)
    NetUtil.Fire_C("SycnDeskFoodNumEvent", _player, this.curFoodNum, this.foodNum)
end

function CookS:FoodRewardEventHandler(_playerId, _cookId, _coin)
    print(_playerId, _cookId)
    local rewardPlayer, cook = world:GetPlayerByUserId(_playerId), world:GetPlayerByUserId(_cookId)
    if rewardPlayer and cook then
        NetUtil.Fire_C("InsertInfoEvent", cook, rewardPlayer.Name .. "打赏了你" .. _coin, 2, false)
        NetUtil.Fire_C("UpdateCoinEvent", cook, _coin)
    end
end

return CookS
