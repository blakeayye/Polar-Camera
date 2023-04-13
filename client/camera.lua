local QBCore = exports['qb-core']:GetCoreObject()







RegisterNetEvent('Polar-Sub:Client:W', function()

	local currentCamMode = GetFollowPedCamViewMode()

  
        local cameraOffset = vector3(0.0, 1.0, 0.7) -- adjust this value to change the distance
        local cameraPos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), cameraOffset)

     
        local newCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
        SetCamCoord(newCam, cameraPos.x, cameraPos.y, cameraPos.z)
        SetCamRot(newCam, -10.0, 0.0, GetEntityHeading(PlayerPedId()) - 180.0, 2)
        SetCamFov(newCam, 50.0)

      

      
        SetCamUseShallowDofMode(newCam, true) -- Sets the camera to use shallow dof mode
        SetCamNearDof(newCam, 0.2) -- Sets the camera's near dof to the value set in the config file
        SetCamFarDof(newCam, 5.0) -- Sets the camera's far dof to the value set in the config file
        SetCamDofStrength(newCam, 1) -- Sets the camera's dof strength to the value set in the config file
        SetCamActive(newCam, true) -- Sets the camera to active
        RenderScriptCams(true, false, 0, true, false)
 
    while DoesCamExist(newCam) do -- While the camera exists, do the following:
        SetUseHiDof() -- Sets the camera to use high dof
        Wait(0) -- Waits 0 milliseconds before repeating the loop
    end
end)








local PlayerData = {}
local camera = false
local photo = false
local fov_max = 70.0
local fov_min = 5.0 -- max zoom level (smaller fov is more zoom)
local zoomspeed = 5.0 -- camera zoom speed
local speed_lr = 2.0 -- speed by which the camera pans left-right
local speed_ud = 2.0 -- speed by which the camera pans up-down
local fov = (fov_max+fov_min)*0.5

local cameraprop = nil
local photoprop = nil
local zoomvalue = 1


function LerpVector(start, stop, amt)
    return start + (stop - start) * amt
end

local cam = nil

local camTransitioning = false

RegisterNetEvent('Polar-Sub:Client:S', function()
    local coords = GetEntityCoords(PlayerPedId())

   
    cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
       
    local cameraOffset = vector3(0.0, -6.0, 0.6) -- adjust this value to change the distance
    local cameraPos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), cameraOffset)

 
        camTransitioning = true
        SetCamCoord(cam, cameraPos.x, cameraPos.y, cameraPos.z)
        SetCamRot(cam, -10.0, 0.0, GetEntityHeading(PlayerPedId()), 2)
        SetCamFov(cam, 50.0)
        RenderScriptCams(true, false, 1, true, false)
       
        while camTransitioning do
        Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId())
        local camCoords = GetCamCoord(cam)

        local distance = #(playerCoords - camCoords)
           
        if distance < 0.1 then
        camTransitioning = false
               
        else

        local lPed = PlayerPedId()
        if not IsPedSittingInAnyVehicle(lPed) then
        if IsControlJustPressed(0,241) then
            fov = math.max(fov - zoomspeed, fov_min)
        end
        if IsControlJustPressed(0,242) then
            fov = math.min(fov + zoomspeed, fov_max)
        end
        local current_fov = GetCamFov(cam)
        if math.abs(fov-current_fov) < 0.1 then
            fov = current_fov
        end
        SetCamFov(cam, current_fov + (fov - current_fov)*0.05)
        else
        if IsControlJustPressed(0,17) then
            fov = math.max(fov - zoomspeed, fov_min)
        end
        if IsControlJustPressed(0,16) then
            fov = math.min(fov + zoomspeed, fov_max)
        end
        local current_fov = GetCamFov(cam)
        if math.abs(fov-current_fov) < 0.1 then
            fov = current_fov
        end
        SetCamFov(cam, current_fov + (fov - current_fov)*0.05)
        end

        local rightAxisX = GetDisabledControlNormal(0, 220)
        local rightAxisY = GetDisabledControlNormal(0, 221)
        local rotation = GetCamRot(cam, 2)
        if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
        local new_z = rotation.z + rightAxisX*-1.0*(speed_ud)*(zoomvalue+0.1)
        local new_x = math.max(math.min(20.0, rotation.x + rightAxisY*-1.0*(speed_lr)*(zoomvalue+0.1)), -89.5)
        SetCamRot(cam, new_x, 0.0, new_z, 2)
        end

        local lerpPos = LerpVector(camCoords, vec3(playerCoords.x,playerCoords.y, playerCoords.z+1.0), (0.01 - math.exp(-distance)) * 1.0)
        SetCamCoord(cam, lerpPos.x, lerpPos.y, lerpPos.z)
               
              
            end
        end

end)
