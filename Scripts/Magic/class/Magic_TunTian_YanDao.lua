
local tbTable = GameMain:GetMod("MagicHelper");
local MagicYandao = tbTable:GetMagic("Magic_Body_YanDao");  --衍道

--衍道
function MagicYandao:Init()
	self.save = {};
	self.save.TunaDT = 0;
end
function MagicYandao:TargetCheck(k, t)
	return true
end
function MagicYandao:EnableCheck(npc)
	if npc.Needs:GetNeedValue(CS.XiaWorld.g_emNeedType.Practice) > 50 then
		return true;
	else
		return false;
	end
end

function MagicYandao:MagicEnter(IDs, IsThing)
	
end

function MagicYandao:MagicStep(dt, duration)--返回值  0继续 1成功并结束 -1失败并结束 duration:已持续时间

	self:SetProgress(duration/self.magic.Param1);--UI上显示的进度
	self.save.TunaDT = self.save.TunaDT + dt;

	local parts = self.bind.PropertyMgr.Practice.BodyPracticeData:GetSuperPartData("SuperPart_TunTian_Core2"); --获取衍道行秘体
	local partsnum = parts.Level;
	local stagelv = self.bind.PropertyMgr.Practice.LogicStage;  --获取境界
	local penalty = self.bind.PropertyMgr.Practice:GetPenalty();  --获取善功值

	if penalty>=0 then
		penalty = 0
	end
	penalty = math.abs(math.max(penalty,-10));

	local count = math.floor((1+penalty+partsnum)*(1+self.bind.PropertyMgr.Practice.BodyPracticeData:TunaOtherEffect()));         --这里是计算精华获取量，跟秘体等级。境界，善功值有关，具体公式需要规划一下
	local times = 30;
	if stagelv == 3 then
		times=30;
	elseif stagelv == 6 then
		times=15;
	elseif stagelv == 9 then
		times=10;
	elseif stagelv >= 12 then
		times=5;
	end

	if self.save.TunaDT >= times then
		self.save.TunaDT = self.save.TunaDT - times;
		self.bind.Needs:AddNeedValue(CS.XiaWorld.g_emNeedType.Practice,-50);  --扣除精元消耗
		self.bind.PropertyMgr.Practice.BodyPracticeData:AddQuenchingItem("Item_BodyPractice_TianJi",count);
	end
	if duration >= self.magic.Param1 then		
		return 1;	
	end
	return 0;
end

function MagicYandao:MagicLeave(success)
end

function MagicYandao:OnGetSaveData()
	return self.save;
end

function MagicYandao:OnLoadData(tbData,IDs, IsThing)	
	self.save = tbData;
end