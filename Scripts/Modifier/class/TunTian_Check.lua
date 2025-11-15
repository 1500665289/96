--吞天诀分支秘体检测脚本
local tbTable = GameMain:GetMod("_ModifierScript");
local tbModifier = tbTable:GetModifier("modifier_tuntian_check");

--进入modifier
function tbModifier:Enter(modifier, npc)

end

--modifier step
function tbModifier:Step(modifier, npc, dt)
	
end

--层数更新
function tbModifier:UpdateStack(modifier, npc, add)
	
end

--离开modifier
function tbModifier:Leave(modifier, npc)
	if npc == nil then
		return;
	end

	local parts1 = npc.PropertyMgr.Practice.BodyPracticeData:GetSuperPartData("SuperPart_TunTian_Core1"); --吞天路
	local parts2 = npc.PropertyMgr.Practice.BodyPracticeData:GetSuperPartData("SuperPart_TunTian_Core2");  --衍道行

	if parts1.Level >= 1 then  --根据分支，在不同的境界解锁不同的秘体
		if npc.PropertyMgr.Practice.GongStateLevel == CS.XiaWorld.g_emGongStageLevel.Dan1 then
			npc.PropertyMgr.Practice.BodyPracticeData:UnLockSuperPart("SuperPart_TunTian_Atk2",true);
			npc.PropertyMgr.Practice.BodyPracticeData:UnLockSuperPart("SuperPart_TunTian_Effect1",true);
		elseif npc.PropertyMgr.Practice.GongStateLevel == CS.XiaWorld.g_emGongStageLevel.Dan2 then
			npc.PropertyMgr.Practice.BodyPracticeData:UnLockSuperPart("SuperPart_TunTian_Effect2",true);
			npc.PropertyMgr.Practice.BodyPracticeData:UnLockSuperPart("SuperPart_TunTian_Att1",true);
		elseif npc.PropertyMgr.Practice.GongStateLevel == CS.XiaWorld.g_emGongStageLevel.God then
			npc.PropertyMgr.Practice.BodyPracticeData:UnLockSuperPart("SuperPart_TunTian_Atk3",true);
			npc.PropertyMgr.Practice.BodyPracticeData:UnLockSuperPart("SuperPart_TunTian_Effect4",true);
		end
	elseif parts2.Level >=1 then
		if npc.PropertyMgr.Practice.GongStateLevel == CS.XiaWorld.g_emGongStageLevel.Dan1 then
			npc.PropertyMgr.Practice.BodyPracticeData:UnLockSuperPart("SuperPart_TunTian_Def2",true);
			npc.PropertyMgr.Practice.BodyPracticeData:UnLockSuperPart("SuperPart_TunTian_Effect1",true);
		elseif npc.PropertyMgr.Practice.GongStateLevel == CS.XiaWorld.g_emGongStageLevel.Dan2 then
			npc.PropertyMgr.Practice.BodyPracticeData:UnLockSuperPart("SuperPart_TunTian_Effect3",true);
			npc.PropertyMgr.Practice.BodyPracticeData:UnLockSuperPart("SuperPart_TunTian_Att2",true);
		elseif npc.PropertyMgr.Practice.GongStateLevel == CS.XiaWorld.g_emGongStageLevel.God then
			npc.PropertyMgr.Practice.BodyPracticeData:UnLockSuperPart("SuperPart_TunTian_Def3",true);
			npc.PropertyMgr.Practice.BodyPracticeData:UnLockSuperPart("SuperPart_TunTian_Effect5",true);
		end
	end

end

--获取存档数据
function tbModifier:OnGetSaveData()
	return nil;
end

--载入存档数据
function tbModifier:OnLoadData(modifier, npc, tbData)

end

