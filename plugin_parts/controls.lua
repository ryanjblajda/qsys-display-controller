function GetControls(props)
  local ctrls = {}
  
  local controls = 
  {
    {
      Name = "power_btn",
      ControlType = "Button",
      ButtonType = "Momentary",
      Count = 2
    },
    {
      Name = "power_toggle",
      ButtonType = "Momentary",
      ControlType = "Button"
    },
    {
      Name = "screen_btn",
      ButtonType = "Momentary",
      ControlType = "Button",
      Count = 3
    },
    {
      Name = "power_os",
      ControlType = "Indicator",
      Count = 2,
      PinStyle = "Output",
  
    },
    {
      Name = "power_status",
      ControlType = "Indicator",
      Count = 1,
      PinStyle = "Input",
    },
    {
      Name = "screen_os",
      ControlType = "Indicator",
      Count = 2,
      PinStyle = "Output",
    },
    {
      Name = "screen_busy",
      ControlType = "Indicator",
      UserPin = true,
      PinStyle = "Output"
    },
    {
      Name = "display_busy",
      ControlType = "Indicator",
      UserPin = true,
      PinStyle = "Output"
    },
    {
      Name = "display_progress",
      ControlType = "Knob",
      ControlUnit = "Position",
      DefaultValue = 0,
      UserPin = true,
      PinStyle = "Output"
    },
    {
      Name = "screen_progress",
      ControlType = "Knob",
      ControlUnit = "Position",
      DefaultValue = 0,
      UserPin = true,
      PinStyle = "Output"
    },
    {
      Name = "warmup_time",
      ControlType = "Knob",
      ControlUnit = "Float",
      Max = 60,
      Min = 1,
      DefaultValue = 10,
      Count = 1
    },
    {
      Name = "cooldown_time",
      ControlType = "Knob",
      ControlUnit = "Float",
      Max = 60,
      Min = 1,
      DefaultValue = 5,
      Count = 1
    },
    {
      Name = "screen_travel_time",
      ControlType = "Knob",
      ControlUnit = "Float",
      Max = 60,
      Min = 1,
      DefaultValue = 15,
      Count = 1
    },
    {
      Name = "screen_relay_pulse_time",
      ControlType = "Knob",
      ControlUnit = "Float",
      Max = 1,
      Min = 0.25,
      DefaultValue = .5,
      Count = 1
    },
    {
      Name = "system_off",
      ControlType = "Indicator",
      PinStyle = "Input",
    },
  }

  for _, control in pairs(controls) do
    table.insert(ctrls, control)
  end

  return ctrls
end