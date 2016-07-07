--[[ 
weather.lua, written by <damo>, July 2016

---------------------------------------------
Use this in a conky with

    lua_load /path/to/weather.lua
    lua_draw_hook_pre conky_main

In the conky, get the weather data from weather.sh with

TEXT
${execi <interval> /path/to/weather.sh [location]}

---------------------------------------------]]

require 'cairo'

-- set default font
--fontface="Dustismo"
fontface="Liberation"

function conky_main()
    if conky_window==nil then return end
    cs=cairo_xlib_surface_create(conky_window.display,
                                        conky_window.drawable,
                                        conky_window.visual,
                                        conky_window.width,
                                        conky_window.height)
    cr=cairo_create(cs)
    
    xW=160      -- x pos wind dial centre
    yW=90       -- y pos wind dial centre
    radiusW=60  -- radiusW wind dial
    xT=30       -- x pos temp bar (top)
    yT=10       -- y pos temp bar (top)
    wT=6        -- width temp bar
    hT=150      -- height temp bar
    xSun=340    -- x pos sun dial centre
    ySun=90     -- y pos sun dial centre
    radiusSun=60-- radius sun dial
    datafile="/path/to/weather-data.txt"  -- textfile to hold lua-weather.sh output
    
    direction,windS,temperature,sunrise,sunset,loc,wx = get_vals() 
    concentric = 0
    
    local updates=conky_parse('${updates}')
    update_num=tonumber(updates)

-- Settings for concentric dials ---------------------------------
--
    concentric = 1  -- <--- "0" for separate widgets
    xSun = 300
    ySun = 100
    radiusSun = 90
    xW = xSun
    yW = ySun
    radiusW = 0.7*radiusSun
--
------------------------------------------------------------------------

    if update_num>1 then
        draw_widgets()
    end

    cairo_destroy(cr)
    cairo_surface_destroy(cs)
    cr=nil
end

--  Choose the widgets to be displayed:
function draw_widgets()
    draw_thermometer(cr,xT,yT,wT,hT)
    draw_wind_rose()
    draw_sun_ring()
end

-- read values from datafile
function get_vals()
    local path = datafile
    local file = io.open( path)
    local array = {}
    local i=0
    
    if (file) then
        -- read all contents of file into array
        for line in file:lines() do
            i=i+1
            array[i]=line
        end
        file:close()

        dir=tostring(array[1]) -- get wind direction, convert to value required
        if ( dir == "null" ) then
            winddir=-math.pi*(tonumber(0))/180
            wind_speed="No wind data"
        else
            winddir=-math.pi*(tonumber(dir))/180
            wind_speed=tostring(array[2])  -- windspeed knots
        end
        temperature=tonumber(array[5])
        sunrise=array[3]
        sunset=array[4]
        location=array[6]
        weather=array[7]

        return winddir,wind_speed,temperature,sunrise,sunset,location,weather
    else
        print("datafile " .. datafile .. " not found")
    end
end

-- convert degree to rad 
function angle_to_position(start_angle, current_angle)
    local pos = start_angle + current_angle
    return pos * math.pi/180
end

function draw_sun_ring()
--    local hours=20
--    local mins=0
    
    local hours=os.date("%H")
    local mins=os.date("%M")
    current_time=(hours .. mins)

    mins_arc = 360/60*mins
    hours_arc = (360/24*hours + mins_arc/24) + 90
    
    start_angle = 90    -- south
    end_angle = 360
    start_arc = 0
    stop_arc = 0

    -- get times and angle position from function sun_rise_set()
    sunrise,sunset,sun_rise,sun_set = sun_rise_set()

    local border_pat=cairo_pattern_create_linear(xSun,ySun-radiusSun*1.25,xSun,ySun+radiusSun*1.25)
    
    cairo_pattern_add_color_stop_rgba(border_pat,0,1,1,0,0.3)
    cairo_pattern_add_color_stop_rgba(border_pat,0.4,0.9,0.9,0.2,0.2)
    cairo_pattern_add_color_stop_rgba(border_pat,0.55,0.9,0.2,0,0.2)
    cairo_pattern_add_color_stop_rgba(border_pat,0.7,0,0.1,1,0.3)
    cairo_set_source(cr,border_pat)
    -- draw ring, starting at south position ( = midnight/00hrs)
    cairo_arc(cr, xSun, ySun, radiusSun, angle_to_position(start_angle, 0), angle_to_position(start_angle, end_angle))
--  set width of ring
    cairo_set_line_width(cr,radiusSun*0.06)
    cairo_stroke(cr)
    cairo_pattern_destroy (pat)

    -- draw sun
    -- get position on circumference ( = time from midnight (south), 24hr clock)
    sun_pos=angle_to_position(start_angle,hours_arc)
    local sunx=xSun - (math.sin(-sun_pos)*radiusSun)
    local suny=ySun - (math.cos(-sun_pos)*radiusSun)

    -- set colour & alpha, for day/night
    local r,g,b,a = sun_colour()

    cairo_set_source_rgba (cr,r,g,b,a)
    cairo_arc(cr,sunx,suny,radiusSun*0.09,0,360)
    cairo_fill(cr)
    
    local r,g,b,a = 1,1,0,0.5
    cairo_set_source_rgba (cr,r,g,b,a)
    cairo_set_line_width(cr,2)
    cairo_set_line_cap(cr, CAIRO_LINE_CAP_ROUND)

    -- draw sunrise mark
    local sunrise_x=xSun - (math.sin(-sun_rise)*radiusSun*1.05)
    local sunrise_y=ySun - (math.cos(-sun_rise)*radiusSun*1.05)
    local sunrise_xc=xSun - (math.sin(-sun_rise)*radiusSun*0.95)
    local sunrise_yc=ySun - (math.cos(-sun_rise)*radiusSun*0.95)
    cairo_move_to(cr,sunrise_x,sunrise_y)
    cairo_line_to(cr,sunrise_xc,sunrise_yc)
    cairo_stroke(cr)
    -- draw sunset mark
    local sunset_x=xSun - (math.sin(-sun_set)*radiusSun*1.05)
    local sunset_y=ySun - (math.cos(-sun_set)*radiusSun*1.05)
    local sunset_xc=xSun - (math.sin(-sun_set)*radiusSun*0.95)
    local sunset_yc=ySun - (math.cos(-sun_set)*radiusSun*0.95)
    local r,g,b,a = 1,0,0,0.5
    cairo_set_source_rgba (cr,r,g,b,a)
    cairo_move_to(cr,sunset_x,sunset_y)
    cairo_line_to(cr,sunset_xc,sunset_yc)
    cairo_stroke(cr)
--  print sunrise/sunset text
    sun_text(sunrise_x,sunrise_y,sunset_x,sunset_y)
end

function sun_colour()   -- get dawn/day/evening/night colour (depending on current time)
    -- date/time math needs values from date object
    local r,g,b,a = 1,1,1,1

    t_obj = os.date('*t')   -- get date object
    
    t_now = t_obj
    --t_now.hour = 5    -- for testing
    --t_now.min = 14
    time_now = os.date("%H%M", os.time(t_now)) -- get time now, hours(24),mins

    t_sunrise = t_obj
    t_sunrise.hour = sunupH
    t_sunrise.min = sunupM
    time_sunrise = os.date("%H%M", os.time(t_sunrise))
    
    t_sunrise10 = t_obj
    t_sunrise10.min = sunupM + 10
    time_sunrise10 = os.date("%H%M", os.time(t_sunrise10))

    t_sunset = t_obj
    t_sunset.hour = sundownH
    t_sunset.min = sundownM
    time_sunset = os.date("%H%M", os.time(t_sunset))

    t_sunset10 = t_obj
    t_sunset.hour = sundownH
    t_sunset10.min = sundownM - 10
    time_sunset10 = os.date("%H%M", os.time(t_sunset10))

    if ( time_now >= time_sunrise ) and ( time_now <= time_sunrise10 ) then
--            print("dawn")
        r,g,b,a = 1,0.6,0,0.4 --dawn
    elseif ( time_now > time_sunrise10 ) and ( time_now < time_sunset10 ) then
--            print("day")
        r,g,b,a = 1,1,0,0.4 --day
    elseif ( time_now <= time_sunset ) and ( time_now >= time_sunset10 ) then
--            print("evening")
        r,g,b,a = 1,0.2,0,0.4 --evening
    elseif ( time_now < time_sunrise ) or ( time_now > time_sunset ) then
--            print("night")
        r,g,b,a = 0.5,0.5,0.5,0.4 --night
    end
    
    return r,g,b,a
end

function sun_text(xr,yr,xs,ys)
    -- display sunrise time
    --[[    Uncomment to format time text as "NN:NN"
    sunrise1 = string.sub(sunrise,1,2)
    sunrise2 = string.sub(sunrise,3,4)
    sunset1 = string.sub(sunset,1,2)
    sunset2 = string.sub(sunset,3,4)
    
    local sunrise = ( sunrise1 .. ":" .. sunrise2 )
    local sunset = ( sunset1 .. ":" .. sunset2 )
    --]]
    
    local r,g,b,a = 1,1,0,0.5
    cairo_set_source_rgba (cr,r,g,b,a)
    print_text(cr,sunrise,xr-4,yr,4,10)
    print_text(cr,"sunrise",xr-4,yr+8,4,8)
    
    -- display sunset time
    local r,g,b,a = 1,0,0,0.5
    cairo_set_source_rgba (cr,r,g,b,a)
    print_text(cr,sunset,xs,ys+10,0,10)
    print_text(cr,"sunset",xs,ys+18,0,8)
    
--    print("concentric= " .. concentric)
    if ( concentric == 0 ) then
        -- display time
        local current_time = os.date("%H%M")
        local fontface="Dustismo"
        local r,g,b,a = 1,1,1,0.3
        cairo_set_source_rgba (cr,r,g,b,a)
        cairo_select_font_face(cr,fontface,CAIRO_FONT_SLANT_NORMAL,CAIRO_FONT_WEIGHT_BOLD)
        cairo_set_font_size (cr,24)
        local xt,yt = position_text(cr,current_time,xSun,ySun-6,2)
        cairo_move_to (cr,xt,yt)
        cairo_show_text (cr,current_time)
        cairo_stroke (cr)
        
        -- display date
        local cal = os.date("%a %d %b")
        local fontface="Dustismo"
        local r,g,b,a = 1,1,1,0.3
        cairo_set_source_rgba (cr,r,g,b,a)
        cairo_select_font_face(cr,fontface,CAIRO_FONT_SLANT_NORMAL,CAIRO_FONT_WEIGHT_BOLD)
        cairo_set_font_size (cr,12)
        local xt,yt = position_text(cr,cal,xSun,ySun+10,1)
        cairo_move_to (cr,xt,yt)
        cairo_show_text (cr,cal)
        cairo_stroke (cr)
        
    --  print location
        local fontface="Dustismo"
        local r,g,b,a = 1,1,1,0.4
        cairo_set_source_rgba (cr,r,g,b,a)
        cairo_select_font_face(cr,fontface,CAIRO_FONT_SLANT_NORMAL,CAIRO_FONT_WEIGHT_NORMAL)
        cairo_set_font_size (cr,10)
        local xt,yt = position_text(cr,loc,xSun,ySun+25,1)
        cairo_move_to (cr,xt,yt)
        cairo_show_text (cr,loc)
        cairo_stroke (cr)
    else
        print_location_text(xSun,ySun+1.4*radiusSun)
    end

end

function print_location_text(x,y)
   -- display time
    local current_time = os.date("%H%M")
    local fontface="Dustismo"
    local r,g,b,a = 1,1,1,0.3
    cairo_set_source_rgba (cr,r,g,b,a)
    cairo_select_font_face(cr,fontface,CAIRO_FONT_SLANT_NORMAL,CAIRO_FONT_WEIGHT_BOLD)
    cairo_set_font_size (cr,24)
    local xt,yt = position_text(cr,current_time,x,y,2)
    cairo_move_to (cr,xt,yt)
    cairo_show_text (cr,current_time)
    cairo_stroke (cr)
    
    -- display date
    local cal = os.date("%a %d %b")
    local fontface="Dustismo"
    local r,g,b,a = 1,1,1,0.3
    cairo_set_source_rgba (cr,r,g,b,a)
    cairo_select_font_face(cr,fontface,CAIRO_FONT_SLANT_NORMAL,CAIRO_FONT_WEIGHT_BOLD)
    cairo_set_font_size (cr,12)
    local xt,yt = position_text(cr,cal,x,y+10,1)
    cairo_move_to (cr,xt,yt)
    cairo_show_text (cr,cal)
    cairo_stroke (cr)
    
--  print location
    local fontface="Dustismo"
    local r,g,b,a = 1,1,1,0.4
    cairo_set_source_rgba (cr,r,g,b,a)
    cairo_select_font_face(cr,fontface,CAIRO_FONT_SLANT_NORMAL,CAIRO_FONT_WEIGHT_NORMAL)
    cairo_set_font_size (cr,10)
    local xt,yt = position_text(cr,loc,x,y+25,1)
    cairo_move_to (cr,xt,yt)
    cairo_show_text (cr,loc)
    cairo_stroke (cr)
end

function sun_rise_set()
    sunupH = string.sub(sunrise,1,2)
    sunupM = string.sub(sunrise,3,4)
    sundownH = string.sub(sunset,1,2)
    sundownM = string.sub(sunset,3,4)

    minSR_arc = 360/60*sunupM
    hourSR_arc = (360/24*sunupH + minSR_arc/24) + 90
    pos_SR = angle_to_position(start_angle,hourSR_arc)

    minSS_arc = 360/60*sundownM
    hourSS_arc = (360/24*sundownH + minSS_arc/24) + 90
    pos_SS = angle_to_position(start_angle,hourSS_arc)

    return sunrise,sunset,pos_SR,pos_SS
end

function draw_thermometer(cr,x,y,wT,hT)
    local alpha=0.5
    HT = y+hT
    pat = cairo_pattern_create_linear (x,y,wT,HT)
    cairo_pattern_add_color_stop_rgba (pat, 1,   0,  0, 1, alpha)
    cairo_pattern_add_color_stop_rgba (pat, 0.4, 1,0.8, 0, alpha)
    cairo_pattern_add_color_stop_rgba (pat, 0.3, 1,0.3, 0, alpha)
    cairo_pattern_add_color_stop_rgba (pat, 0, 1,0, 0, alpha)

    cairo_rectangle (cr, x,y,wT,HT)
    cairo_set_source (cr, pat)
    cairo_fill (cr)
    cairo_pattern_destroy (pat)

    draw_temperature(cr,x,y,hT,temperature)
end

function draw_temperature(cr,x,y,hT,Tdegrees)
    local range=hT/100
    local zero = y + range*60
    local T = Tdegrees*range
    t = tostring(Tdegrees)
    t = ( t .. "°C" )
    cairo_set_source_rgba (cr,1,1,1,0.5)
    cairo_set_line_width(cr,1)

    for i = 0,100,10 do -- draw 10 degree marks
        local l = 3
        local xT = x-1
        if ( i == 60 ) then -- longer mark for freezing point
            xT = x-6
            l = -12
        end
        cairo_move_to (cr,xT,y)
        cairo_rel_line_to (cr,-l,0)
        cairo_stroke (cr)
        y = y + range*10
    end

    cairo_set_source_rgba (cr,1,1,1,0.5)
    cairo_set_line_width(cr,3)
    cairo_set_line_cap(cr, CAIRO_LINE_CAP_ROUND)
    cairo_move_to(cr,x-1,zero-T)    -- temperature indicator
    cairo_rel_line_to(cr,10,0)

    -- temperature text
    print_text(cr,t,x+28,zero-T,1,10)
    -- zero degrees text
    print_text(cr,"0",x-12,zero,1,12)
end

function draw_wind_rose()
    draw_marks(cr,xW,yW,radiusW)
    draw_WindArrow(cr,xW,yW,50,direction,radiusW-8)
    draw_NESW(cr,xW,yW,radiusW,10)
    
--  print windspeed
    local fontface="Dustismo"
    local r,g,b,a = 1,1,1,0.4
    cairo_set_source_rgba (cr,r,g,b,a)
    cairo_select_font_face(cr,fontface,CAIRO_FONT_SLANT_NORMAL,CAIRO_FONT_WEIGHT_BOLD)
    cairo_set_font_size (cr,16)
    local xt,yt = position_text(cr,windS,xW,yW,2)
    cairo_move_to (cr,xt,yt)
    cairo_show_text (cr,windS)
    cairo_stroke (cr)

--  print weather conditions
    local fontface="Dustismo"
    local r,g,b,a = 1,1,1,0.4
    cairo_set_source_rgba (cr,r,g,b,a)
    cairo_select_font_face(cr,fontface,CAIRO_FONT_SLANT_NORMAL,CAIRO_FONT_WEIGHT_NORMAL)
    cairo_set_font_size (cr,10)
    local xt,yt = position_text(cr,wx,xW,yW+10,1)
    cairo_move_to (cr,xt,yt)
    cairo_show_text (cr,wx)
    cairo_stroke (cr)
end

function draw_WindArrow(cr,x, y, length, bearing,radiusW)
    -- startpoint x, startpoint y, length of side, compass bearing
    local head_ratio = 1.05 -- ratio of side to overall length
    local head_angle = 0.02 -- proportion 0 - 0.5 (straight, at right angle to direction)
    
    local x1=x- (math.sin(bearing)*radiusW)
    local y1=y- (math.cos(bearing)*radiusW)
    --arrow body
    local angle = bearing
    local x0 = x1 + (math.sin(angle) * length)
    local y0 = y1 + (math.cos(angle) * length)
    local xtext = x1 + (math.sin(angle) * 0.25*length)
    local ytext = y1 + (math.cos(angle) * 0.25*length)

    --arrow head left
    angle = bearing - (head_angle * math.pi)
    x2 = x0 - (math.sin(angle) * length * head_ratio)
    y2 = y0 - (math.cos(angle) * length * head_ratio)

    --arrow head right
    angle = bearing + (head_angle * math.pi)
    x3 = x0 - (math.sin(angle) * length * head_ratio)
    y3 = y0 - (math.cos(angle) * length * head_ratio)
    
    start_x=(x0+x2+x3)/3
    start_y=(y0+y2+y3)/3
    
    cairo_set_source_rgba (cr,1,1,1,0.5)
    cairo_move_to (cr,start_x,start_y)
    cairo_line_to (cr,x2,y2)
    cairo_line_to (cr,x1,y1) 
    cairo_line_to (cr,x3,y3) 
    cairo_close_path (cr)
    cairo_fill(cr)
    cairo_stroke (cr)
    
    return true
end

--  display compass points
function draw_NESW(cr,x,y,rt,font_size)
    local compass={0,90,180,270}
    local cpoints={"N","E","S","W"}
    radiusW=rt+12
    
    for i = 1,4,1 do
        compass_point=-math.pi*(tonumber(compass[i]))/180
        local x1=x - (math.sin(compass_point)*radiusW)
        local y1=y - (math.cos(compass_point)*radiusW)
        local t = cpoints[i]
        print_text(cr,t,x1,y1,1,font_size)
    end
end

--  draw compass rose graduations
function draw_marks(cr,x,y,r)
    local angle=0
    local inner=r-2
    local outer=r+2

    local r,g,b,a=1,1,1,0.5
    cairo_set_source_rgba (cr,r,g,b,a)
    cairo_set_line_width(cr, 1)

    for i = 0,36,1 do   -- draw small ticks, every 10 deg
        compass_arc=(-2*math.pi/360)*angle
        local x0 = x - (math.sin(compass_arc) * inner)
        local y0 = y - (math.cos(compass_arc) * inner)
        local endx = x - (math.sin(compass_arc) * outer)
        local endy = y - (math.cos(compass_arc) * outer)
        
        if ( (i/3) - math.floor(i/3) ~= 0 ) then -- don't draw every third tick
            cairo_move_to (cr,x0,y0)
            cairo_line_to(cr,endx,endy)
            cairo_stroke(cr)
        end
        angle=angle+10
    end
    
    angle=0 -- re-set angle
    
    for i = 0,12,1 do       -- draw large ticks, every 30 deg
        compass_arc=(-2*math.pi/360)*angle
        x0 = x - (math.sin(compass_arc) * (inner-5))
        y0 = y - (math.cos(compass_arc) * (inner-5))
        endx = x - (math.sin(compass_arc) * outer)
        endy = y - (math.cos(compass_arc) * outer)
        
        cairo_move_to (cr,x0,y0)
        cairo_line_to(cr,endx,endy)
        cairo_stroke(cr)
        angle=angle+30
    end
end

function print_text(cr,t,xT,yT,posT,font_size)
--  align text, using text area extents
    -- posT:        0 = none
    --              1 = align both
    --              2 = horizontal
    --              3 = vertical
    --              4 = left
    cairo_set_font_size (cr,font_size)
    if ( posT == 0 ) then
        xt = xT
        yt = yT
    else
        xt,yt = position_text(cr,t,xT,yT,posT)
    end
    cairo_move_to (cr,xt,yt)
    cairo_show_text (cr,t)
    cairo_stroke (cr)
end

function position_text(cr,t,text_x,text_y,pos)
    -- adjust text position
    -- get text area (x_bearing,y_bearing,width,height,x_advance,y_advance)
    te=cairo_text_extents_t:create()
    cairo_text_extents(cr,t,te)
    xtext = text_x
    ytext = text_y
    
    if ( pos == 1 ) then    -- centre text
        xtext = text_x - te.width/2
        ytext = text_y + te.height/2
    elseif ( pos == 2 ) then    -- horizontal align
        xtext = text_x - te.width/2
    elseif ( pos == 3 ) then    -- vertical align
        ytext = text_y + te.height/2
    elseif ( pos == 4 ) then    -- set right edge of text to pos
        xtext = text_x - te.width
    end

    return xtext,ytext
end
