
local tbTable = GameMain:GetMod("MagicHelper");
local MagicGetLingPlant = tbTable:GetMagic("Magic_Body_TunTian_GetLingPlant");  --六库仙贼

--盗取灵植灵性
function MagicGetLingPlant:Init()
end

function MagicGetLingPlant:EnableCheck(npc)
	return true 
end

function MagicGetLingPlant:TargetCheck(k, t)
	if t.bLingPlant == false then	
		self:SetCheckMsg(XT("该目标不是灵植"))
		return false
	elseif t.bLingPlant then
		return true
	end
	return false
end

function MagicGetLingPlant:MagicEnter(IDs, IsThing)	
	self.TargetID = IDs[0]
	self.target = ThingMgr:FindThingByID(self.TargetID)
end

function MagicGetLingPlant:MagicStep(dt, duration)--返回值  0继续 1成功并结束 -1失败并结束		
	self:SetProgress(duration/self.magic.Param1);
	if duration >= self.magic.Param1 then	
		return 1;	
	end
	return 0;
end

function MagicGetLingPlant:MagicLeave(success)
	if success == false then
		return
	end

	local lingsha = self.target.LingShaValue  --获取当前灵煞值
	if lingsha == 0 then
		return
	end

	if math.abs(lingsha)<=0.1 then
		self.bind.Needs:AddNeedValue(CS.XiaWorld.g_emNeedType.Practice,1);  --根据灵煞值获得精元
	else
		self.bind.Needs:AddNeedValue(CS.XiaWorld.g_emNeedType.Practice,math.abs(lingsha)*10);  --根据灵煞值获得精元
	end
	self.target:AddLingSha(-math.abs(lingsha))  --清空灵植的灵煞

	local rand = world:RandomInt(0,100)
	if rand<=math.abs(lingsha) then
		if lingsha>=0 then
			ThingMgr:AddItemThing(self.bind.Key,"Item_TunTian_lingxing",self.bind.map,1,true)   --获得灵性结晶
		else
			ThingMgr:AddItemThing(self.bind.Key,"Item_TunTian_shaxing",self.bind.map,1,true)   --获得煞性结晶
		end
	end
	self.TargetID = nil
	self.target = nil
end

function MagicGetLingPlant:OnGetSaveData()

end

function MagicGetLingPlant:OnLoadData(tbData,IDs, IsThing)

end