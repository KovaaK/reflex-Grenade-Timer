require "base/internal/ui/reflexcore"
 
local counter = 0
local counter2 = 0
local counter3 = 0
local canFire = true
 
GrenadeTimer = {};
registerWidget("GrenadeTimer");


uBG = Color(255,255,255,128);
uGradientStart = Color(255,255,255,255);
uGradientEnd = Color(255,0,0,255);

	
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function SetSettings()
    consolePerformCommand("ui_set_widget_anchor GrenadeTimer 0 0");
    consolePerformCommand("ui_set_widget_offset GrenadeTimer 0 240");
    consolePerformCommand("ui_set_widget_scale GrenadeTimer 0.4");
end
SetSettings(); 

local function drawGrenadeArc(cnt) -- show the position of the grenade on the circle
		nvgBeginPath();
		nvgStrokeWidth(20);
		local strokeLength = 0.1
		nvgArc(0,0,120,cnt * math.pi+math.pi*1.5,(cnt+strokeLength) * math.pi+math.pi*1.5,2);
		nvgStrokeLinearGradient(0,-80,0,80,uGradientStart,uGradientEnd);
		nvgStroke();
end

local function drawOuterCircle() -- show the outer circle and line
		nvgBeginPath();
		nvgRect(0, -130, 5, 130)
		nvgFillColor(uBG); 
		nvgFill();

		nvgBeginPath();
		nvgStrokeWidth(5);
		nvgArc(0,0,130,0,math.pi*2,2);
		nvgStrokeColor(uBG)
		nvgStroke();
end

function GrenadeTimer:initialize()
	-- load data stored in engine
	self.userData = loadUserData();
	-- ensure it has what we need
	CheckSetDefaultValue(self, "userData", "table", {});
	CheckSetDefaultValue(self.userData, "raceOnly", "boolean", false);
	CheckSetDefaultValue(self.userData, "alwaysCircle", "boolean", true);
	
end 

function GrenadeTimer:drawOptions(x, y)
	local user = self.userData;
	user.raceOnly = uiCheckBox(user.raceOnly, "Enabled in Race Mode only", x, y);
	y = y + 30;
	
	user.alwaysCircle = uiCheckBox(user.alwaysCircle, "Always show, even when not firing grenades", x, y);
	y = y + 30;

	saveUserData(user);
end


function GrenadeTimer:draw()
 
    local raceOnly = self.userData.raceOnly
    local alwaysCircle = self.userData.alwaysCircle
	if raceOnly and not isRaceMode() then return end;
	if not shouldShowHUD() then return end;
 
	local player = getPlayer();
	if not player then return end;
 
	if player.buttons.attack and player.weaponIndexSelected == 4 and canFire then
		canFire = false
		if counter <= 0 then
			counter = 2 -- fuse time
		elseif counter2 <= 0 then
			counter2 = 2
		else
			counter3 = 2
		end
	end

	if counter < 1.2 and counter2 < 1.2 and counter3 < 1.2 then canFire = true end

	if alwaysCircle or counter > 0 or counter2 > 0 or counter3 > 0 then
		drawOuterCircle();
	end
	
	if counter > 0 then 
		drawGrenadeArc(counter) 
		counter = counter - deltaTime
	end
	if counter2 > 0 then 
		drawGrenadeArc(counter2) 
		counter2 = counter2 - deltaTime
	end
	if counter3 > 0 then 
		drawGrenadeArc(counter3) 
		counter3 = counter3 - deltaTime
	end
		
end

