--[[ wrapper script to call lua scripts in electro-1366.conkyrc --]]

package.path = "?.lua"
require 'e-sm-conky_clock_gauges' --for scriptA.lua ".lua" is not required here
require 'e-sm-clock_rings'

function conky_main()
     conky_functions()
     conky_clock_rings()
end
