function RectifyProperties(props)
  if props.plugin_show_debug.Value == false then 
  else
    print("Debugging: Enabled")
  end

  return props
end