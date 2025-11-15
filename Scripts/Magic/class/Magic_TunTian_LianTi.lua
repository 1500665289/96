
local tbTable = GameMain:GetMod("MagicHelper");
local MagicLianTi = tbTable:GetMagic("Magic_Body_TunTian_LianTi");  

--炼体重生
--以天地烘炉熔炼己身，借助自身庞大的精气（5000点精元），滴血重生，并提升神识，根骨，魅力，悟性和机缘各3成。重生时，自身修为越高，炼体程度越高，天谴也越低！

function MagicLianTi:Init()
end

function MagicLianTi:EnableCheck(npc)
	return true;
end

function MagicLianTi:TargetCheck(k, t)	
	return true
end

function MagicLianTi:MagicEnter(IDs, IsThing)	
	CS.WorldLuaHelper():ShowMsgBox("使用该神通后，将重生为无修为的凡人！\n再次点击神通即可取消","炼体重生")
	CS.XiaWorld.MainManager.Instance:Pause(false);
end

function MagicLianTi:MagicStep(dt, duration)--返回值  0继续 1成功并结束 -1失败并结束		
	self:SetProgress(duration/self.magic.Param1);
	if duration >= self.magic.Param1 then	
		return 1;	
	end
	return 0;
end

function MagicLianTi:MagicLeave(success)

	if success then
		TongLingMgr:ZaoHuaSuTi(self.bind.ID)
		--self.bind:AddModifier("Modifier_Magic_TunTian_Reborn")
	end
end


function MagicLianTi:OnGetSaveData()

end

function MagicLianTi:OnLoadData(tbData,IDs, IsThing)

end