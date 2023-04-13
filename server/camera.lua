local QBCore = exports['qb-core']:GetCoreObject()
-- Register the command that will toggle the motion blur effect
QBCore.Commands.Add("camera", "makes cam", {}, false, function(source, args)
   TriggerClientEvent('Polar-Sub:Client:W', source)
end)




QBCore.Commands.Add("smooth", "makes cam go slow", {}, false, function(source, args)
   TriggerClientEvent('Polar-Sub:Client:S', source)
end)