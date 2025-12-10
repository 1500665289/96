local tbTable = GameMain:GetMod("MagicHelper");
local MagicTuntian = tbTable:GetMagic("Magic_Body_TunTian");  --吞天

--吞天魔法：吞噬物品获得淬体精华
function MagicTuntian:Init()
    self.TargetID = nil
    self.target = nil
end

-- 启用检查：判断是否可以使用吞天魔法
function MagicTuntian:EnableCheck(npc)
    -- 增加空值检查
    if not npc or not npc.PropertyMgr or not npc.PropertyMgr.Practice or not npc.Needs then
        return false
    end
    
    local temptimes = 0
    local stage = npc.PropertyMgr.Practice.LogicStage or 0
    
    -- 统一计算逻辑，与MagicLeave保持一致
    if stage >= 12 then
        temptimes = 4
    elseif stage >= 9 then
        temptimes = 3
    elseif stage >= 6 then
        temptimes = 2
    elseif stage >= 3 then
        temptimes = 1
    end
    
    -- 计算精元消耗
    temptimes = temptimes * 50
    
    -- 检查精元是否足够
    local practiceValue = npc.Needs:GetNeedValue(CS.XiaWorld.g_emNeedType.Practice) or 0
    return practiceValue > temptimes
end

-- 目标检查：验证目标是否有效
function MagicTuntian:TargetCheck(k, t)    
    if not t then
        return false
    end
    
    -- 这里可以添加更多目标检查逻辑
    -- 例如：检查目标是否是物品、是否可以吞噬等
    return true
end

-- 魔法开始：初始化目标
function MagicTuntian:MagicEnter(IDs, IsThing)    
    if not IDs or #IDs == 0 then
        return
    end
    
    self.TargetID = IDs[1]  -- Lua数组索引从1开始
    self.target = ThingMgr:FindThingByID(self.TargetID)
    
    -- 验证目标存在且有效
    if not self.target or not self.target.Count or self.target.Count <= 0 then
        self.TargetID = nil
        self.target = nil
    end
end

-- 魔法执行：处理进度
function MagicTuntian:MagicStep(dt, duration)
    -- 参数检查
    if not self.magic or not self.magic.Param1 or self.magic.Param1 <= 0 then
        return -1  -- 失败
    end
    
    -- 目标检查
    if not self.target or not self.target.Count or self.target.Count <= 0 then
        return -1  -- 目标失效
    end
    
    -- 设置进度
    self:SetProgress(duration / self.magic.Param1)
    
    -- 检查是否完成
    if duration >= self.magic.Param1 then    
        return 1
    end
    
    return 0
end

-- 魔法结束：执行吞噬操作
function MagicTuntian:MagicLeave(success)
    if not success then
        self.TargetID = nil
        self.target = nil
        return
    end
    
    -- 安全检查
    if not self.bind or not self.target or not self.target.Count or self.target.Count <= 0 then
        self.TargetID = nil
        self.target = nil
        return
    end
    
    local item_count = 0
    
    -- 计算吞噬数量（最多10个）
    if self.target.Count <= 10 then
        item_count = self.target.Count
    else
        item_count = 10
    end

    -- 获取各种属性（增加空值检查和默认值）
    local partsnum = 0
    local stagelv = 0
    local ling = 0
    local rate = 0
    local bonusRate = 0
    
    -- 获取秘体等级
    if self.bind.PropertyMgr and self.bind.PropertyMgr.Practice and 
       self.bind.PropertyMgr.Practice.BodyPracticeData then
        local parts = self.bind.PropertyMgr.Practice.BodyPracticeData:GetSuperPartData("SuperPart_TunTian_Core1")
        if parts then
            partsnum = parts.Level or 0
        end
    end
    
    -- 获取境界
    if self.bind.PropertyMgr and self.bind.PropertyMgr.Practice then
        stagelv = self.bind.PropertyMgr.Practice.LogicStage or 0
    end
    
    -- 获取物品属性
    ling = self.target.LingV or 0
    rate = self.target.Rate or 0
    
    -- 获取吞噬加成属性
    if self.bind.GetProperty then
        bonusRate = self.bind:GetProperty("BodyPractice_EatItemProduceCountAddp") or 0
    end
    
    -- 根据境界计算加成倍数
    local times = 0
    if stagelv >= 12 then
        times = 4
    elseif stagelv >= 9 then
        times = 3
    elseif stagelv >= 6 then
        times = 2
    elseif stagelv >= 3 then
        times = 1
    end
    
    -- 计算获得的精华数量
    -- 公式: ((物品数量 + 灵气/1000) * (品阶/12) + 境界加成 + 秘体等级) * (1 + 吞噬加成)
    local count = math.floor(((item_count + ling / 1000) * (rate / 12) + times + partsnum) * (1 + bonusRate))
    
    -- 执行吞噬操作
    local success = pcall(function()
        self.target:SubCount(item_count)
        
        -- 计算精元消耗
        local practiceCost = times * 50
        
        -- 扣除精元
        if self.bind.Needs then
            self.bind.Needs:AddNeedValue(CS.XiaWorld.g_emNeedType.Practice, -practiceCost)
        end
        
        -- 添加淬体精华
        if self.bind.PropertyMgr and self.bind.PropertyMgr.Practice and 
           self.bind.PropertyMgr.Practice.BodyPracticeData then
            self.bind.PropertyMgr.Practice.BodyPracticeData:AddQuenchingItem("Item_BodyPractice_TianJi", count)
        end
    end)
    
    if not success then
        -- 吞噬失败，记录日志（如果有日志系统）
    end
    
    -- 清理
    self.TargetID = nil
    self.target = nil
end

-- 保存数据
function MagicTuntian:OnGetSaveData()
    return {
        TargetID = self.TargetID
    }
end

-- 加载数据
function MagicTuntian:OnLoadData(tbData, IDs, IsThing)
    if tbData and tbData.TargetID then
        self.TargetID = tbData.TargetID
        self.target = ThingMgr:FindThingByID(self.TargetID)
    end
end
