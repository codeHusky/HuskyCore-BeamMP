function vehicleSpawnHandler(pid,vid,vd) 
	if vid == 0 then
		RemoveVehicle(pid,1)
	else
		RemoveVehicle(pid,0)
	end
	SendChatMessage(pid,"Your old vehicle was cleaned up for your convenience.")
	SendChatMessage(-1, GetPlayerName(pid) .. " just spawned a new vehicle.")
end

function playerJoin(pid)
	SendChatMessage(pid,"Welcome, ".. GetPlayerName(pid).."! This server features HuskyCore! You do not need to remove your car to switch cars, just simply spawn a new one in and the old one will be removed!")
end

function onInit()
	print("HuskyCore v1.0 is starting")
	RegisterEvent("onVehicleSpawn","vehicleSpawnHandler")
	print("HuskyCore has started")
	SendChatMessage(-1,"This server features HuskyCore! This means you can simply spawn a new vehicle to remove your old one (instead of having to remove your old car manually)!")
end