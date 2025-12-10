local tbTable = GameMain:GetMod("MagicHelper");
local MagicTuntian = tbTable:GetMagic("Magic_Body_TunTian");  --吞天


--吞天
function MagicTuntian:Init()
end

function MagicTuntian:EnableCheck(npc)
	local temptimes=0
	if npc.PropertyMgr.Practice.LogicStage == 3 then
		temptimes=1
	elseif npc.PropertyMgr.Practice.LogicStage == 6 then
		temptimes=3
	elseif npc.PropertyMgr.Practice.LogicStage == 9 then
		temptimes=3
	elseif npc.PropertyMgr.Practice.LogicStage >= 12 then
		temptimes=4
	end
	temptimes = (temptimes) * 50
	if npc.Needs:GetNeedValue(CS.XiaWorld.g_emNeedType.Practice) > temptimes then
		return true;
	else
		return false;
	end
end

function MagicTuntian:TargetCheck(k, t)	
	return true;
end

function MagicTuntian:MagicEnter(IDs, IsThing)	
	self.TargetID = IDs[0]
	self.target = ThingMgr:FindThingByID(self.TargetID)
end

function MagicTuntian:MagicStep(dt, duration)--返回值  0继续 1成功并结束 -1失败并结束		
	self:SetProgress(duration/self.magic.Param1);
	if duration >= self.magic.Param1 then	
		return 1;	
	end
	return 0;
end

function MagicTuntian:MagicLeave(success)
	if success == false then
		return
	end
	
	-- 检查目标是否存在
	if self.target == nil then
		return
	end
	
	local item_count = 0
	if self.target.Count <= 10 then      --获取物品数目，若数目大于配置上限则只吞噬配置上限个物品
		item_count = self.target.Count
	else
		item_count = 10
	end

	-- 获取吞天路秘体，如果不存在则等级为0
	local partsnum = 0
	local parts = self.bind.PropertyMgr.Practice.BodyPracticeData:GetSuperPartData("SuperPart_TunTian_Core1")
	if parts ~= nil then
		partsnum = parts.Level
	end
	
	local stagelv = self.bind.PropertyMgr.Practice.LogicStage  --获取境界
	local ling = self.target.LingV  --获取灵气值
	local rate = self.target.Rate  --获取品阶

	-- 境界对吞天的影响（产出加成）
	local stageBonus = 0
	if stagelv == 3 then
		stageBonus = 1
	elseif stagelv == 6 then
		stageBonus = 2
	elseif stagelv == 9 then
		stageBonus = 3
	elseif stagelv == 12 then
		stageBonus = 4
	else
		stageBonus = 0
	end

	-- 精元消耗（与EnableCheck中的计算方式保持一致）
	local costTimes = 0
	if stagelv == 3 then
		costTimes = 1
	elseif stagelv == 6 then
		costTimes = 3
	elseif stagelv == 9 then
		costTimes = 3
	elseif stagelv >= 12 then
		costTimes = 4
	end
	local practiceCost = costTimes * 50  -- 实际消耗的精元值

	-- 计算精华获取量
	local count = math.floor(((item_count + ling/1000) * (rate/12) + stageBonus + partsnum) * 
		(1 + self.bind:GetProperty("BodyPractice_EatItemProduceCountAddp")))
	
	-- 确保至少获得1个
	if count < 1 then
		count = 1
	end

	-- 执行操作
	self.target:SubCount(item_count)  -- 扣除物品
	self.bind.Needs:AddNeedValue(CS.XiaWorld.g_emNeedType.Practice, -practiceCost)  -- 扣除精元
	self.bind.PropertyMgr.Practice.BodyPracticeData:AddQuenchingItem("Item_BodyPractice_TianJi", count)  -- 添加天机材料
	
	self.TargetID = nil
	self.target = nil
end

function MagicTuntian:OnGetSaveData()
	return {}
end

function MagicTuntian:OnLoadData(tbData,IDs, IsThing)
	self.TargetID = IDs[0]
	self.target = ThingMgr:FindThingByID(self.TargetID)
end
