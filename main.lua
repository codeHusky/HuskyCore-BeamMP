admins = {"150463430430687233"}
votes = {}
votingOn = -1
votesRequired = -1
blacklist = {"658763493075451904"}
time = 0
function vehicleSpawnHandler(pid,vid,vd) 
	players[pid] = GetPlayerName(pid)
	if has_value(blacklist,GetPlayerDiscordID(pid)) then
		SendChatMessage(-1,"No. (Blocked " .. GetPlayerName(pid) .. " car spawn)")
		return -1
	end
	print("Handling vehicle spawn by " .. pid .. " of " .. vid)
	--[[if has_value(admins, GetPlayerDiscordID(pid)) then 
		SendChatMessage(pid,"Hello Moto")
		return 
	end]]
	if vid == 0 then
		RemoveVehicle(pid,1)
	else
		RemoveVehicle(pid,0)
	end
	SendChatMessage(pid,"Your old vehicle was cleaned up for your convenience.")
	SendChatMessage(-1, GetPlayerName(pid) .. " just spawned a new vehicle.")
end
players = {}
function playerJoin(pid) 
	players[pid] = GetPlayerName(pid)
	SendChatMessage(-1,GetPlayerName(pid).." joined")
	SendChatMessage(pid,"On this server, you do not need to remove your car to switch cars, just simply spawn a new one in and the old one will be removed!")
		SendChatMessage(pid,"If a player is being disruptive, just /votekick them! For example, /votekick Josh")
	postCurrent()
end

function playerLeave(pid)
	SendChatMessage(-1, players[pid].." left")
	players[pid] = nil
	postCurrent()
end
function updateVotes() 
	votesRequired = round(#players/2)
end
function round(n)
    return n % 1 >= 0.5 and math.ceil(n) or math.floor(n)
end

function checkVotes()
	if votesRequired <= #votes then
		SendChatMessage(-1,GetPlayerName(votingOn) .. " has been kicked via vote! ("..votesRequired .. "/" .. #votes)
		DropPlayer(votingOn,"You were votekicked!")
		votingOn=-1
		votes={}
		votesRequired = -1
	end
end

function endVoting()
	time = time + 1
	if time >= 30 then
		updateVotes()
		checkVotes()
		if votingOn > -1 then
			SendChatMessage(-1,GetPlayerName(votingOn) .. " will not be kicked! Vote failed. ("..votesRequired .. "/" .. #votes ..")")
			votingOn=-1
			votes = {}
			votesRequired = -1
		end
		StopThread()
	end
end

function chatMessage(pid, name, message)
	players[pid] = GetPlayerName(pid)
	print(name .. " ("..GetPlayerDiscordID(pid).."):" .. message)
	amsg = string.lower(message)
	parts = split(amsg," ")
	if parts[1] == "/votekick" then
		if votingOn == -1 then
			who = string.lower(string.sub(message,12))
			for vkpid, vkname in ipairs(players) do
		        lowname = string.lower(vkname)
		        if string.find(lowname, who) or lowname == who then
		        	votingOn = vkpid
		        	votes = {pid}
		        	updateVotes()
		        	SendChatMessage(-1,name .. " is voting to kick " .. vkname .." (1/"..votesRequired..") Type /yes to vote to kick this player. This vote will go for 30 seconds.")
		        	if votingOn > -1 then
		        		CreateThread("endVoting",1)
		        	end
		        	return -1
		        end
		    end 
		    SendChatMessage(pid,"A player with the name ".. who .." was not found.")
		else
			SendChatMessage(pid,"A votekick is currently in progess. Please wait.")
		end
		return -1 
	elseif parts[1] == "/yes" then
		if votingOn > -1 then
			if has_value(votes,pid) then
				SendChatMessage(pid,"You already voted.")
			else
				table.insert(votes,pid)
				updateVotes()
				SendChatMessage(-1,name .. " voted yes to kick " .. GetPlayerName(votingOn) .." (".. #votes.."/".. votesRequired..")")
			end
			checkVotes()
		else
			SendChatMessage(pid,"There is no votekick in progress.")
		end
		return -1
	elseif parts[1] == "/kick" then
		who = string.lower(string.sub(message,12))
	end
end
function postCurrent()
	for i=0,50,1 do
		t = GetPlayerName(i)
		if t ~= nil then
			players[i] = t 
		end
	end
	print("Current Players")
	for pid, name in ipairs(players) do
        print("  "..GetPlayerDiscordID(pid).." -> "..name)
    end
end
function onInit()
	print("HuskyCore v1.1 is starting")
	RegisterEvent("onVehicleSpawn","vehicleSpawnHandler")
	RegisterEvent("onPlayerJoin","playerJoin")
	RegisterEvent("onPlayerDisconnect","playerLeave")
	RegisterEvent("onChatMessage","chatMessage")
	print("HuskyCore has started")
	--CreateThread("postCurrent",1)
	postCurrent()
	--SendChatMessage(-1,"This server  features HuskyCore! This means you can simply spawn a new vehicle to remove your old one (instead of having to remove your old car manually)!")
end


function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

function split (inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={}
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                table.insert(t, str)
        end
        return t
end