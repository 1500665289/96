local tbTable = GameMain:GetMod("MagicHelper");
local MagicJingYuan = tbTable:GetMagic("Magic_Body_TunTian_JingYuan");  

--精元衍道
--消耗自身精元演化大道，使自身周围的土地变为灵土。（每格土地消耗50精元）

local cost = 50;

function MagicJingYuan:Init()
end

function MagicJingYuan:EnableCheck(npc)
	if npc.Needs:GetNeedValue(CS.XiaWorld.g_emNeedType.Practice) > cost then
		return true;
	else
		return false;
	end
end

function MagicJingYuan:TargetCheck(k, t)	
	return true
end

function MagicJingYuan:MagicEnter(IDs, IsThing)	
	self.curIndex = 0;
	self.jump = 0;
	self.bind:EnterFlying();
	self.grids = IDs;
end

function MagicJingYuan:MagicStep(dt, duration)--返回值  0继续 1成功并结束 -1失败并结束		
	self:SetProgress(self.curIndex/self.grids.Count);--UI上显示的进度

	self.jump = self.jump + dt;	
	if self.jump >= 0.4 then
		local key = self.grids[self.curIndex];
		if self:CreateMine(key) then
			self.bind.Needs:AddNeedValue(CS.XiaWorld.g_emNeedType.Practice,-cost);  --扣除精元
			self.jump = 0;	
		end
		self.curIndex = self.curIndex + 1;	
		if self.curIndex >= self.grids.Count or self.bind.Needs:GetNeedValue(CS.XiaWorld.g_emNeedType.Practice) < cost  then
			return 1;
		end	
	end
	return 0;

end

function MagicJingYuan:CreateMine(key)   --修改目标土地为灵土
	self.bind.map.Terrain:FullTerrain(key, self.magic.sParam1 ,true);
	if self.magic.Param1 ~= nil and self.magic.Param1 > 0 then
		world:PlayEffect(self.magic.Param1, key, 5);
	end
	return true;
end


function MagicJingYuan:MagicLeave(success)
	self.bind:LeaveFlying();
end

function MagicJingYuan:OnGetSaveData()
end

function MagicJingYuan:OnLoadData(tbData,IDs, IsThing)

end