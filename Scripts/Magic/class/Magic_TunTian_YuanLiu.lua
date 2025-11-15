
local tbTable = GameMain:GetMod("MagicHelper");
local MagicYuanLiu = tbTable:GetMagic("Magic_Body_TunTian_YuanLiu");  --炁体源流

--炁体源流
--消耗400点精元和100个仙道精华，帮助他人提高炼精化气的程度（每次提升400-600点进度）。
function MagicYuanLiu:Init()
end

function MagicYuanLiu:EnableCheck(npc)
	if npc.Needs:GetNeedValue(CS.XiaWorld.g_emNeedType.Practice) > 400 then
		return true;
	else
		return false;
	end
end

function MagicYuanLiu:TargetCheck(k, t)	
	local temp = t.PropertyMgr.Practice:GetMaxAccumulativeLing()
	if t.PropertyMgr.Practice.AccumulativeLing >= temp then
		self:SetCheckMsg(XT("该目标已经达到鼎炉之限"))
		return false
	end
	if (t.Camp ~= g_emFightCamp.Player) then
		self:SetCheckMsg(XT("不能对敌方角色使用"))
		return false
	end
	return true
end

function MagicYuanLiu:MagicEnter(IDs, IsThing)	
	self.TargetID = IDs[0]
	self.target = ThingMgr:FindThingByID(self.TargetID)
end

function MagicYuanLiu:MagicStep(dt, duration)--返回值  0继续 1成功并结束 -1失败并结束		
	self:SetProgress(duration/self.magic.Param1);
	if duration >= self.magic.Param1 then	
		return 1;	
	end
	return 0;
end

function MagicYuanLiu:MagicLeave(success)

	if success ~= true then
		self.TargetID = nil
		self.target = nil
		return
	end
	
	local aling = self.target.PropertyMgr.Practice.AccumulativeLing   --获取当前炼精化气的灵气
	local rand = world:RandomInt(400,600)
	aling = aling + rand  --获得增加后的灵气
	local maxling = self.target.PropertyMgr.Practice:GetMaxAccumulativeLing()

	if aling >= maxling  then
		self.target.PropertyMgr.Practice.AccumulativeLing = self.target.PropertyMgr.Practice:GetMaxAccumulativeLing()
	else
		self.target.PropertyMgr.Practice.AccumulativeLing = aling
	end

	self.bind.Needs:AddNeedValue(CS.XiaWorld.g_emNeedType.Practice,-400);  --扣除精元消耗
end

function MagicYuanLiu:OnGetSaveData()

end

function MagicYuanLiu:OnLoadData(tbData,IDs, IsThing)

end