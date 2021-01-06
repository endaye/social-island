---@module BagUIMgr
---@copyright Lilith Games, Avatar Team
---@author Yen Yuan
local BagUIMgr, this = ModuleUtil.New("BagUIMgr", ClientBase)

---初始化函数
function BagUIMgr:Init()
    print("BagUIMgr: Init")
    this:NodeDef()
    this:DataInit()
    this:SlotCreate()
    this:EventBind()
end

function BagUIMgr:NodeDef()
    this.gui = localPlayer.Local.BagGui.BagPnl
    this.slotList = {}

    --* Button------------
    this.useBtn = this.gui.UseBtn
    this.nextBtn = this.gui.NextBtn
    this.prevBtn = this.gui.PrevBtn
    this.backBtn = this.gui.BackBtn

    --* Text--------------
    this.nameTxt = this.gui.NameTxt
    this.descTxt = this.gui.DescTxt
    this.pageTxt = this.gui.pageTxt
end

function BagUIMgr:DataInit()
    this.slotItem = {}
    this.pageSize = 10 -- 可配置
    this.pageIndex = 1 -- 页面序号
    this.maxPage = nil -- 最大页数
    this.selectIndex = nil
    --* 背包物品显示参数
    this.rowNum = 10
    this.colNum = 5
end

--单元格生成
local slot
function BagUIMgr:SlotCreate()
    for i = 1, this.rowNum * this.colNum do
        --this.rowNum * this.colNum do
        slot = world:CreateInstance("SlotImg", "SlotImg", this.gui.SlotPnl)

        slot.AnchorsX =
            Vector2((math.fmod(i, this.rowNum) - 1) * (1 / this.rowNum), math.fmod(i, this.rowNum) * (1 / this.rowNum))
        slot.AnchorsY =
            Vector2(
            1.1 - (math.modf(i / this.rowNum) + 1) * 1 / this.colNum,
            1.1 - (math.modf(i / this.rowNum) + 1) * 1 / this.colNum
        )
        table.insert(this.slotList, slot)
        -- TODO: 调整位置
        -- 绑定事件
        slot.SelectBtn.OnClick:Connect(
            function()
                this:SelectItem(i)
            end
        )
    end
end

function BagUIMgr:EventBind()
    this.useBtn.OnClick:Connect(
        function()
            this:ClickUseBtn(this.selectIndex)
        end
    )
    this.nextBtn.OnClick:Connect(
        function()
            this:ClickChangePage(this.pageIndex + 1)
        end
    )
    this.prevBtn.OnClick:Connect(
        function()
            this:ClickPrePage(this.pageIndex - 1)
        end
    )
    this.backBtn.OnClick:Connect(
        function()
            this:HideBagUI()
        end
    )
end

function BagUIMgr:ShowBagUI()
    this:ClearSelect()
    this.gui:SetActive(true)
end

function BagUIMgr:HideBagUI()
    this.gui:SetActive(false)
end

function BagUIMgr:ShowItemByIndex(_index, _itemId)
    -- TODO: 更换图片
    this.slotList[_index].Image = nil
    this.slotItem[_index] = _itemId
    this.slotList[_index]:SetActive(_itemId and true or false)
end

function BagUIMgr:ClickUseBtn(_index)
    if not this.selectIndex then
        return
    end
    -- TODO: 使用物品

    -- 清除选择
    this:ClearSelect()
    -- 重新读取物品信息
end

---选中物品
function BagUIMgr:SelectItem(_index)
    this:ClearSelect()
    --this.selectIndex = _index
    -- TODO: 进行名字和描述的更换,并高亮该物品
    print(_index)
end

function BagUIMgr:ChangeSelectOffset(_pageIndex)
end

function BagUIMgr:ClearSelect()
    if this.selectIndex then
        this.selectIndex = nil
        --清除描述，清除高亮
        this.nameTxt.Text = " "
        this.descTxt.Text = " "
        this.useBtn:SetActive(false)
    end
end

function BagUIMgr:ClickChangePage(_pageIndex)
    this:ClearSelect()
    -- TODO: 显示当前页面物品

    --页面数字显示
    this.pageTxt = tostring(math.floor(_pageIndex))
    --如果第一页则不显示上一页按钮
    if _pageIndex == 1 then
        this.prevBtn:SetActive(false)
    end
    --如果最后一页不显示下一页按钮
    if _pageIndex == this.maxPage then
        this.nextBtn:SetActive(false)
    end
    --其他情况打开全部按钮
    if _pageIndex ~= 1 or _pageIndex ~= this.maxPage then
        this.prevBtn:SetActive(true)
        this.nextBtn:SetActive(true)
    end
end

---更新最大页面数
function BagUIMgr:GetMaxPageNum(_itemNum)
    this.maxPage = math.ceil(_itemNum / this.pageSize)
end

return BagUIMgr
