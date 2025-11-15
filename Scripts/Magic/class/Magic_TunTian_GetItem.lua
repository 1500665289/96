local tbTable = GameMain:GetMod("MagicHelper");
local MagicTuntianItem = tbTable:GetMagic("Magic_Body_Item");  --气血熔炼

--炼化吞天晶体
function MagicTuntianItem:Init()
end

function MagicTuntianItem:EnableCheck(npc)
	if npc.PropertyMgr.Practice.BodyPracticeData:GetQuenchingItemCount("Item_BodyPractice_TianJi")>=10 then
		return true
	else
		return false
	end
end

function MagicTuntianItem:TargetCheck(k, t)	
	return true;
end

function MagicTuntianItem:MagicEnter(IDs, IsThing)	

end

function MagicTuntianItem:MagicStep(dt, duration)--返回值  0继续 1成功并结束 -1失败并结束		
	self:SetProgress(duration/self.magic.Param1);
	if duration >= self.magic.Param1 then	
		return 1;	
	end
	return 0;
end

function MagicTuntianItem:MagicLeave(success)
	if success then
		ThingMgr:AddItemThing(self.bind.Key,"Item_TunTian_jingjin",self.bind.map,1,true)  --掉落天机精晶
		return
	end
end

function MagicTuntianItem:OnGetSaveData()

end

function MagicTuntianItem:OnLoadData(tbData,IDs, IsThing)

end