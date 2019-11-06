--
-- For more information on config.lua see the Project Configuration Guide at:
-- https://docs.coronalabs.com/guide/basics/configSettings
--

application =
{
	content =
	{
		width = 320 * (display.pixelHeight/display.pixelWidth>1.5 and 1 or 1.5/(display.pixelHeight/display.pixelWidth)),
		height = 480 * (display.pixelHeight/display.pixelWidth<1.5 and 1 or (display.pixelHeight/display.pixelWidth)/1.5), 
		scale = "letterbox",
		fps = 60,
		
		imageSuffix =
		{
			["@2x"] = 1.5,
			["@4x"] = 3.0,
		},
	},
}
