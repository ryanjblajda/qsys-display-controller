ButtonHeight = 50
ButtonWidth = 150

LabelHeight = 25
LabelWidth = 150

ProgressGaugeHeight = 15
ProgressGaugeWidth = 150

ConfigurationKnobHeight = 25
ConfigurationKnobWidth = 150

IndicatorLEDHeight = 25
IndicatorLEDWidth = 25

Colors = { Blue = { 0, 0, 255}, Red = { 255, 0, 0 }, White = { 0, 0, 0 }, Yellow = { 0, 255, 255 }}

function GetVerticalStartPosition(margin, start, height)
  return margin + start + height
end

function GetHorizontalStartPosition(margin, start, width)
  return margin + start + width
end

function GeneratePageMainControlLayout(layout, graphics)
  local objectMargin = 5
  local currentVerticalPosition = objectMargin
  local currentHorizontalPosition = objectMargin

  layout["power_btn 1"] = { Size = { ButtonWidth, ButtonHeight }, Position = { currentHorizontalPosition, currentVerticalPosition }, Legend = "Power On", FontSize = 22}
  local currentHorizontalPosition = GetHorizontalStartPosition(objectMargin, currentHorizontalPosition, ButtonWidth)
  layout["power_btn 2"] = { Size = { ButtonWidth, ButtonHeight }, Position = { currentHorizontalPosition, currentVerticalPosition }, Legend = "Power Off", FontSize = 22}
  local currentVerticalPosition = GetVerticalStartPosition(objectMargin, currentVerticalPosition, ButtonHeight)
  layout["power_toggle"] = { Size = { ButtonWidth, ButtonHeight }, Position = { objectMargin + (ButtonWidth / 2), currentVerticalPosition }, Legend = "Power Toggle", FontSize = 22 }
  local currentVerticalPosition = GetVerticalStartPosition(objectMargin, ButtonHeight * 2, currentVerticalPosition)
  layout["screen_btn 1"] = { Size = { ButtonWidth, ButtonHeight }, Position = { objectMargin + (ButtonWidth / 2), currentVerticalPosition }, Legend = "Screen Up", FontSize = 22}
  local currentVerticalPosition = GetVerticalStartPosition(objectMargin, ButtonHeight, currentVerticalPosition)
  layout["screen_btn 2"] = { Size = { ButtonWidth, ButtonHeight }, Position = { objectMargin + (ButtonWidth / 2), currentVerticalPosition }, Legend = "Screen Stop", FontSize = 22 }
  local currentVerticalPosition = GetVerticalStartPosition(objectMargin, ButtonHeight, currentVerticalPosition)
  layout["screen_btn 3"] = { Size = { ButtonWidth, ButtonHeight }, Position = { objectMargin + (ButtonWidth / 2), currentVerticalPosition }, Legend = "Screen Down", FontSize = 22}

  return layout, graphics
end

function GeneratePageConfigurationControlLayout(layout, graphics)
  local objectMargin = 5
  local currentVerticalPosition = objectMargin
  local currentHorizontalPosition = objectMargin

  table.insert(graphics, { Type = "Label", Size = { LabelWidth, LabelHeight }, Position = { currentHorizontalPosition, currentVerticalPosition }, Text = "Warmup Time", HTextAlign = "Center", FontSize = 18 })
  local currentHorizontalPosition = GetHorizontalStartPosition(objectMargin, currentHorizontalPosition, LabelWidth)
  table.insert(graphics, { Type = "Label", Size = { LabelWidth, LabelHeight }, Position = { currentHorizontalPosition, currentVerticalPosition }, Text = "Cooldown Time", HTextAlign = "Center", FontSize = 18 })
  local currentVerticalPosition = GetVerticalStartPosition(objectMargin, currentVerticalPosition, LabelHeight)
  layout["warmup_time"] = { Size = { ConfigurationKnobWidth, ConfigurationKnobHeight }, Position = { objectMargin, currentVerticalPosition}, FontSize = 18, Color = Colors.Red, TextColor = Colors.White }
  local currentHorizontalPosition = GetHorizontalStartPosition(objectMargin, objectMargin, ConfigurationKnobWidth)
  layout["cooldown_time"] = { Size = { ConfigurationKnobWidth, ConfigurationKnobHeight }, Position = { currentHorizontalPosition, currentVerticalPosition}, FontSize = 18, Color = Colors.Blue, TextColor = Colors.White }

  local currentVerticalPosition = GetVerticalStartPosition(objectMargin * 2, currentVerticalPosition, ConfigurationKnobHeight)
  table.insert(graphics, { Type = "Label", Size = { LabelWidth, LabelHeight }, Position = { objectMargin + (LabelWidth / 2), currentVerticalPosition }, Text = "Screen Travel Time", HTextAlign = "Center", FontSize = 16 })
  local currentVerticalPosition = GetVerticalStartPosition(objectMargin, currentVerticalPosition, LabelHeight)
  layout["screen_travel_time"] = { Size = { ConfigurationKnobWidth, ConfigurationKnobHeight }, Position = { objectMargin + (LabelWidth / 2), currentVerticalPosition}, FontSize = 18, TextColor = Colors.White }

  local currentVerticalPosition = GetVerticalStartPosition(objectMargin * 2, currentVerticalPosition, ConfigurationKnobHeight)
  table.insert(graphics, { Type = "Label", Size = { LabelWidth, LabelHeight }, Position = { objectMargin + (LabelWidth / 2), currentVerticalPosition }, Text = "Relay Pulse Time", HTextAlign = "Center", FontSize = 16 })
  local currentVerticalPosition = GetVerticalStartPosition(objectMargin, currentVerticalPosition, LabelHeight)
  layout["screen_relay_pulse_time"] = { Size = { ConfigurationKnobWidth, ConfigurationKnobHeight }, Position = { objectMargin + (LabelWidth / 2), currentVerticalPosition}, FontSize = 18, TextColor = Colors.White }

  return layout, graphics
end

function GeneratePageStatusControlLayout(layout, graphics)
  local objectMargin = 5
  local currentVerticalPosition = objectMargin
  local currentHorizontalPosition = objectMargin

  table.insert(graphics, { Type = "Label", Size = { LabelWidth, LabelHeight }, Position = { currentHorizontalPosition, currentVerticalPosition }, Text = "On Pulse", HTextAlign = "Center", FontSize = 18 })
  local currentHorizontalPosition = GetHorizontalStartPosition(objectMargin, currentHorizontalPosition, LabelWidth)
  table.insert(graphics, { Type = "Label", Size = { LabelWidth, LabelHeight }, Position = { currentHorizontalPosition, currentVerticalPosition }, Text = "Off Pulse", HTextAlign = "Center", FontSize = 18 })
  local currentVerticalPosition = GetVerticalStartPosition(objectMargin, currentVerticalPosition, LabelHeight)

  layout["power_os 1"] = { Size = { IndicatorLEDWidth, IndicatorLEDHeight }, Position = { objectMargin + (LabelWidth / 2) - (IndicatorLEDWidth / 2), currentVerticalPosition}, FontSize = 18, Color = Colors.Red, TextColor = Colors.White, PrettyName = "Display~Power~On" }
  layout["power_os 2"] = { Size = { IndicatorLEDWidth, IndicatorLEDHeight }, Position = { objectMargin * 2 + (LabelWidth / 2) + LabelWidth - (IndicatorLEDWidth / 2), currentVerticalPosition}, FontSize = 18, Color = Colors.Blue, TextColor = Colors.White, PrettyName = "Display~Power~Off" }

  local currentVerticalPosition = GetVerticalStartPosition(objectMargin, currentVerticalPosition, IndicatorLEDHeight)
  
  table.insert(graphics, { Type = "Label", Size = { LabelWidth, LabelHeight }, Position = { objectMargin, currentVerticalPosition }, Text = "Up Relay", HTextAlign = "Center", FontSize = 18 })
  local currentHorizontalPosition = GetHorizontalStartPosition(objectMargin, objectMargin, LabelWidth)
  table.insert(graphics, { Type = "Label", Size = { LabelWidth, LabelHeight }, Position = { currentHorizontalPosition, currentVerticalPosition }, Text = "Down Relay", HTextAlign = "Center", FontSize = 18 })
  local currentVerticalPosition = GetVerticalStartPosition(objectMargin, currentVerticalPosition, LabelHeight)

  layout["screen_os 1"] = { Size = { IndicatorLEDWidth, IndicatorLEDHeight }, Position = { objectMargin + (LabelWidth / 2) - (IndicatorLEDWidth / 2), currentVerticalPosition}, FontSize = 18, Color = Colors.Yellow, PrettyName = "Screen~Relay~Up"}
  layout["screen_os 2"] = { Size = { IndicatorLEDWidth, IndicatorLEDHeight }, Position = { objectMargin * 2 + (LabelWidth / 2) + LabelWidth - (IndicatorLEDWidth / 2), currentVerticalPosition}, FontSize = 18, Color = Colors.Yellow, PrettyName = "Screen~Relay~Down" }

  local currentVerticalPosition = GetVerticalStartPosition(objectMargin, currentVerticalPosition, LabelHeight)
  table.insert(graphics, { Type = "Label", Size = { LabelWidth, LabelHeight }, Position = { objectMargin, currentVerticalPosition }, Text = "Display Progress", HTextAlign = "Center", FontSize = 18 })
  local currentHorizontalPosition = GetHorizontalStartPosition(objectMargin, objectMargin, LabelWidth)
  table.insert(graphics, { Type = "Label", Size = { LabelWidth, LabelHeight }, Position = { currentHorizontalPosition, currentVerticalPosition }, Text = "Screen Progress", HTextAlign = "Center", FontSize = 18 })
  
  local currentVerticalPosition = GetVerticalStartPosition(objectMargin, currentVerticalPosition, LabelHeight)
  layout["display_progress"] = { Size = { ProgressGaugeWidth, ProgressGaugeHeight }, Position = { objectMargin, currentVerticalPosition}, FontSize = 18, Color = Colors.White, Style = "Meter", PrettyName = "Display~Busy~Progress" }
  local currentHorizontalPosition = GetHorizontalStartPosition(objectMargin, objectMargin, ProgressGaugeWidth)
  layout["screen_progress"] = { Size = { ProgressGaugeWidth, ProgressGaugeHeight }, Position = { currentHorizontalPosition, currentVerticalPosition}, FontSize = 18, Color = Colors.Yellow, Style = "Meter", PrettyName = "Screen~Busy~Progress" }

  local currentVerticalPosition = GetVerticalStartPosition(objectMargin, currentVerticalPosition, ProgressGaugeHeight)
  table.insert(graphics, { Type = "Label", Size = { LabelWidth, LabelHeight }, Position = { objectMargin, currentVerticalPosition }, Text = "Display Busy", HTextAlign = "Center", FontSize = 18 })
  local currentHorizontalPosition = GetHorizontalStartPosition(objectMargin, objectMargin, LabelWidth)
  table.insert(graphics, { Type = "Label", Size = { LabelWidth, LabelHeight }, Position = { currentHorizontalPosition, currentVerticalPosition }, Text = "Screen Busy", HTextAlign = "Center", FontSize = 18 })
  local currentVerticalPosition = GetVerticalStartPosition(objectMargin, currentVerticalPosition, LabelHeight)
  layout["display_busy"] = { Size = { IndicatorLEDWidth, IndicatorLEDHeight }, Position = { objectMargin + (LabelWidth / 2) - (IndicatorLEDWidth / 2), currentVerticalPosition}, FontSize = 18, Color = Colors.Red, PrettyName = "Display~Busy~Active"  }
  layout["screen_busy"] = { Size = { IndicatorLEDWidth, IndicatorLEDHeight }, Position = { objectMargin * 2 + (LabelWidth / 2) + LabelWidth - (IndicatorLEDWidth / 2), currentVerticalPosition}, FontSize = 18, Color = Colors.Yellow, PrettyName = "Screen~Busy~Active"  }
  
  local currentVerticalPosition = GetVerticalStartPosition(objectMargin, currentVerticalPosition, LabelHeight)
  table.insert(graphics, { Type = "Label", Size = { LabelWidth, LabelHeight }, Position = { objectMargin + (LabelWidth) - (LabelWidth / 2), currentVerticalPosition }, Text = "Display Power", HTextAlign = "Center", FontSize = 18 })
  local currentVerticalPosition = GetVerticalStartPosition(objectMargin, currentVerticalPosition, LabelHeight)
  layout["power_status"] = { Size = { IndicatorLEDWidth, IndicatorLEDHeight }, Position = { objectMargin + (LabelWidth) - (IndicatorLEDWidth / 2), currentVerticalPosition}, FontSize = 18, Color = Colors.Red, PrettyName = "Display~Power~Feedback"  }

  return layout, graphics
end

function GetControlLayout(props)
  local layout = {}
  local graphics = {}

  local CurrentPage = PageNames[props["page_index"].Value]

  layout["system_off"] = { Style = "None", PrettyName = "System~Power Off" }

  if CurrentPage == "Controls" then
    layout, graphics = GeneratePageMainControlLayout(layout, graphics)
  elseif CurrentPage == "Configuration" then
    layout, graphics = GeneratePageConfigurationControlLayout(layout, graphics)
  elseif CurrentPage == "Status" then
    layout, graphics = GeneratePageStatusControlLayout(layout, graphics)
  end
  
  return layout, graphics
end