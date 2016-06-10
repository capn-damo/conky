--[[ wrapper script to call lua scripts in electro-1920.conkyrc --]]

package.path = "?.lua"
require 'e-conky_clock_gauges' --for scriptA.lua ".lua" is not required here
require 'e-clock_rings'

function conky_main()
     conky_functions()
     conky_clock_rings()
end
