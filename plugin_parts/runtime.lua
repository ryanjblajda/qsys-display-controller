-----------------------
--------------FUNCTIONS
-----------------------

--------------UTILITY

function PulseOutput(obj)
  obj.Boolean = true
  Timer.CallAfter(function()
    obj.Boolean = false
  end, ScreenRelayPulseTime)
end

function SetButtonsDisabledState(btns, state, ignore)
  for index, object in ipairs(btns) do
    if index ~= ignore then
      object.IsDisabled = state
    end
  end
end

function SetScreenButtonsDisabledState(state, ignore)
  SetButtonsDisabledState(Controls.screen_btn, state, ignore)
end

function SetDisplayButtonsDisabledState(state)
  SetButtonsDisabledState(Controls.power_btn, state)
  Controls.power_toggle.IsDisabled = state
end

function SetAllItemsBoolean(ctrls, bool)
  for index, object in ipairs(ctrls) do
    object.Boolean = bool
  end
end

function SetEventHandler(array, handler)
  for index, object in pairs(array) do
    object.EventHandler = function(obj)
      handler(index, object)
    end
  end
end

function SetInterlocked(array, object)
  for index, obj in pairs(array) do
    object.Boolean = object == obj
  end
end

function CheckScreenState()
  print('CheckScreenState: Assumed State: '..AssumedScreenState)
  if DisplayPowerState then
    if AssumedScreenState == 'up' then
      print('CheckScreenState: send screen down -> projector is on')
      ScreenDown()
    elseif AssumedScreenState == 'discrete' then
      print('CheckScreenState: dont interact -> discrete action requested')
    end
  else
    if AssumedScreenState == 'down' then
      print('CheckScreenState: send screen up -> projector is off')
      ScreenUp()
    elseif AssumedScreenState == 'discrete' then
      print('CheckScreenState: dont interact -> discrete action requested')
    end
  end
end

--------------TICK

function GenerateTickInterval(time)
  local tick_interval = time / 100
  return tick_interval
end

function OnTickTimerExpired(timer)
  if timer == DisplayBusyTickTimer then 
    Controls.display_progress.Position = Controls.display_progress.Position + 0.01
  elseif timer == ScreenTravelingTickTimer then 
    Controls.screen_progress.Position = Controls.screen_progress.Position + 0.01
  end
end

--------------SCREEN

function ScreenUp(discrete)
  if not ScreenTravelingTimer:IsRunning() then
    AssumedScreenState = 'up'
    if discrete ~= nil then
      if discrete == true then
        AssumedScreenState = 'discrete'
      end
    end

    PulseOutput(ScreenUpRelay)
    ScreenTravelingTimer:Start(ScreenTravelTime)
    ScreenTravelingTickTimer:Start(GenerateTickInterval(ScreenTravelTime))
    Controls.screen_progress.Value = 0
    Controls.screen_busy.Boolean = true
    print("ScreenUp: Timer Started")
    SetScreenButtonsDisabledState(true, 2)
  else
    print("ScreenUp: Screen Traveling, Please Wait...")
  end
end

function ScreenDown(discrete)
  if not ScreenTravelingTimer:IsRunning() then
    AssumedScreenState = 'down'
    if discrete ~= nil then
      if discrete == true then
        AssumedScreenState = 'discrete'
      end
    end
    
    PulseOutput(ScreenDownRelay)
    ScreenTravelingTimer:Start(ScreenTravelTime)
    ScreenTravelingTickTimer:Start(GenerateTickInterval(ScreenTravelTime))
    Controls.screen_busy.Boolean = true
    Controls.screen_progress.Value = 0
    print("ScreenDown: Timer Started")
    SetScreenButtonsDisabledState(true, 2)
  else
    print("ScreenDown: Screen Traveling, Please Wait...")
  end
end

function ScreenStop()
  print("ScreenStop: Called")
  PulseOutput(ScreenUpRelay)
  PulseOutput(ScreenDownRelay)
  ScreenTravelingTimer:Stop()
  ScreenTravelingTickTimer:Stop()
  Controls.screen_busy.Boolean = false
  Controls.screen_progress.Value = 0
  SetScreenButtonsDisabledState(false, 2)
end

--------------DISPLAY

function DisplayToggle()
  print("DisplayToggle: Called")
  if(DisplayPowerState) then
    DisplayOff()
  else
    DisplayOn() 
  end
end

function DisplayOn()
  ScreenDown()
  Controls['power_btn'][1].Boolean = true
  Controls['power_btn'][2].Boolean = false
  if not DisplayBusyTimer:IsRunning() then
    print("DisplayOn: Attempt Power On")
    PulseOutput(DisplayPowerOn)
    DisplayBusyTimer:Start(DisplayWarmupTime)
    DisplayBusyTickTimer:Start(GenerateTickInterval(DisplayWarmupTime))
    Controls.display_busy.Boolean = true
    Controls.display_progress.Value = 0
    SetDisplayButtonsDisabledState(true)
  else
    print("DisplayOn: Display Busy, Please Wait...")
  end
end

function DisplayOff()
  ScreenUp()
  Controls['power_btn'][1].Boolean = false
  Controls['power_btn'][2].Boolean = true
  if not DisplayBusyTimer:IsRunning() then
    print("DisplayOff: Attempt Power Off")
    PulseOutput(DisplayPowerOff)
    DisplayBusyTimer:Start(DisplayCooldownTime)
    DisplayBusyTickTimer:Start(GenerateTickInterval(DisplayCooldownTime))
    Controls.display_busy.Boolean = true
    Controls.display_progress.Value = 0
    SetDisplayButtonsDisabledState(true)
  else
    print("DisplayOff: Display Busy, Please Wait...")
  end
end

--------------HANDLERS

function OnDisplayPowerToggle(obj)
  DisplayToggle()
  obj.Boolean = DisplayPowerState
end

function OnSystemPowerOff(obj)
  print("OnSystemPowerOff: Called")
  if obj.Boolean then
    DisplayOff()
  end
end

function OnDisplayPowerChanged(obj)
  DisplayPowerState = obj.Boolean
  Controls.power_toggle.Boolean = DisplayPowerState
  
  --update button power fb
  if DisplayPowerState then
    print('OnDisplayPowerChanged: Display Is On')
    Controls.power_btn[1].Boolean = true
    Controls.power_btn[2].Boolean = false
  else
    print('OnDisplayPowerChanged: Display Is Off')
    Controls.power_btn[1].Boolean = false
    Controls.power_btn[2].Boolean = true
  end
end

function OnPowerButton(index, object)
  SetInterlocked(Controls.power_btn, object)
  DisplayActions[index]()
end

function OnScreenButton(index, object)
  ScreenActions[index]()
end

function OnScreenTravelingTimerExpired()
  print("OnScreenTravelingTimerExpired: Timer Expired")
  ScreenTravelingTimer:Stop()
  ScreenTravelingTickTimer:Stop()
  Controls.screen_busy.Boolean = false
  SetScreenButtonsDisabledState(false)
end

function OnDisplayBusyTimerExpired()
  print("OnDisplayBusyTimerExpired: Timer Expired")
  DisplayBusyTimer:Stop()
  DisplayBusyTickTimer:Stop()
  Controls.display_busy.Boolean = false
  SetDisplayButtonsDisabledState(false)
  OnDisplayPowerChanged(Controls.power_status)
end
--------------INIT

function Initialize()
  print(string.format("Plugin: %s | Initialize...", GetPrettyName()))

  ScreenActions =   { [1] = ScreenUp,   [2] = ScreenStop, [3] = ScreenDown }

  ScreenTravelingTimer = Timer.New()
  ScreenTravelingTickTimer = Timer.New()
  ScreenTravelTime = Controls['screen_travel_time'].Value

  AssumedScreenState = nil

  ScreenUpRelay = Controls['screen_os'][1]
  ScreenDownRelay = Controls['screen_os'][2]
  ScreenRelayPulseTime = Controls['screen_relay_pulse_time'].Value
  ----------
  ----------
  DisplayActions =  { [1] = DisplayOn,  [2] = DisplayOff }

  DisplayBusyTimer = Timer.New()
  DisplayBusyTickTimer = Timer.New()

  DisplayPowerState = false

  DisplayPowerOn = Controls['power_os'][1]
  DisplayPowerOff = Controls['power_os'][2]

  DisplayPowerState = Controls['power_status'].Boolean
  DisplayWarmupTime = Controls['warmup_time'].Value 
  DisplayCooldownTime = Controls['cooldown_time'].Value

  SetEventHandler(Controls.power_btn, OnPowerButton)
  SetEventHandler(Controls.screen_btn, OnScreenButton)

  Controls.power_toggle.EventHandler = OnDisplayPowerToggle

  Controls.warmup_time.EventHandler = function(obj) DisplayWarmupTime = obj.Value end

  Controls.cooldown_time.EventHandler = function(obj) DisplayCooldownTime = obj.Value end

  Controls.screen_travel_time.EventHandler = function(obj) ScreenTravelTime = obj.Value end

  Controls.screen_relay_pulse_time.EventHandler = function(obj) ScreenRelayPulseTime = obj.Value end

  Controls.power_status.EventHandler = OnDisplayPowerChanged

  Controls.system_off.EventHandler = OnSystemPowerOff
    
  SetAllItemsBoolean(Controls['power_btn'], false)
    
  SetScreenButtonsDisabledState(false)
  SetDisplayButtonsDisabledState(false)
  
  ScreenTravelingTimer.EventHandler = OnScreenTravelingTimerExpired
  ScreenTravelingTickTimer.EventHandler = OnTickTimerExpired
  DisplayBusyTimer.EventHandler = OnDisplayBusyTimerExpired
  DisplayBusyTickTimer.EventHandler = OnTickTimerExpired

  OnDisplayPowerChanged(Controls['power_status'])
end

-----------------------
----------------INIT
-----------------------

Initialize()