
local tbTable = GameMain:GetMod("MagicHelper");
local MagicHongLu = tbTable:GetMagic("Magic_Body_TunTian_HongLu");  --天地烘炉

--天地烘炉
function MagicHongLu:Init()
end

function MagicHongLu:EnableCheck(npc)
	local qcount = npc.PropertyMgr.Practice.BodyPracticeData:GetPartQuenchingCount("Heart")
	qcount= qcount+100

	if npc.PropertyMgr.Practice.BodyPracticeData:GetQuenchingItemCount("Item_BodyPractice_XianDaoJingHua")>=qcount then
		return true
	else
		return false
	end
end

function MagicHongLu:TargetCheck(k, t)	
	return true;
end

function MagicHongLu:MagicEnter(IDs, IsThing)	
	self.TargetID = IDs[0]
	self.target = ThingMgr:FindThingByID(self.TargetID)
end

function MagicHongLu:MagicStep(dt, duration)--返回值  0继续 1成功并结束 -1失败并结束		
	self:SetProgress(duration/self.magic.Param1);
	if duration >= self.magic.Param1 then	
		return 1;	
	end
	return 0;
end

function MagicHongLu:MagicLeave(success)

	if success ~= true then
		return
	end
	local qcount = self.bind.PropertyMgr.Practice.BodyPracticeData:GetPartQuenchingCount("Heart")
	self.bind.PropertyMgr.Practice.BodyPracticeData:AddQuenchingItem("Item_BodyPractice_XianDaoJingHua",-qcount);  --扣除仙道精华
	prate = qcount/100
	self.target:SoulCrystalYouPowerUp(0,0.4,2,prate);  --提升物品品阶
	self.TargetID = nil
	self.target = nil	
end

function MagicHongLu:OnGetSaveData()

end

function MagicHongLu:OnLoadData(tbData,IDs, IsThing)

end