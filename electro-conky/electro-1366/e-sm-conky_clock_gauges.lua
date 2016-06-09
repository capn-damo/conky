-- Conky Gauges by damo, december 2013  <damo.linux@gmail.com>
-- The gauges are based on Conky Orange 4CPU
-- <http://gnome-look.org/content/show.php/Conky+Orange+4+CPU?content=144319>

require 'cairo'

--                                                                    gauge DATA
-- CPU rings
--
-- Uncomment as necessary for the number of cpu available
gauge = {
{
    name='cpu',                    arg='cpu0',                  max_value=100,
    x=94,                          y=594,
    graph_radius=26,
    graph_thickness=5,
    graph_start_angle=155,
    graph_unit_angle=2.7,          graph_unit_thickness=2.7,
    graph_bg_colour=0xffffff,      graph_bg_alpha=0.1,
    graph_fg_colour=0x6A9BCB,      graph_fg_alpha=0.5,
    hand_fg_colour=0x6A9BCB,       hand_fg_alpha=0.0,
    txt_radius=71,
    txt_weight=0,                  txt_size=12.0,
    txt_fg_colour=0x6A9BCB,        txt_fg_alpha=0,
    graduation_radius=28,
    graduation_thickness=0,        graduation_mark_thickness=1,
    graduation_unit_angle=27,
    graduation_fg_colour=0xFFFFFF, graduation_fg_alpha=0.3,
    caption='',
    caption_weight=1,              caption_size=8.0,
    caption_fg_colour=0xFFFFFF,    caption_fg_alpha=0.3,
},
{
    name='cpu',                    arg='cpu1',                  max_value=100,
    x=94,                          y=594,
    graph_radius=32,
    graph_thickness=5,
    graph_start_angle=155,
    graph_unit_angle=2.7,          graph_unit_thickness=2.7,
    graph_bg_colour=0xffffff,      graph_bg_alpha=0.1,
    graph_fg_colour=0x6A9BCB,      graph_fg_alpha=0.5,
    hand_fg_colour=0x6A9BCB,       hand_fg_alpha=0.0,
    txt_radius=42,
    txt_weight=0,                  txt_size=12.0,
    txt_fg_colour=0x6A9BCB,        txt_fg_alpha=0,
    graduation_radius=28,
    graduation_thickness=0,        graduation_mark_thickness=1,
    graduation_unit_angle=27,
    graduation_fg_colour=0xFFFFFF, graduation_fg_alpha=0.3,
    caption='',
    caption_weight=1,              caption_size=8.0,
    caption_fg_colour=0xFFFFFF,    caption_fg_alpha=0.3,
},
--[[
{
    name='cpu',                    arg='cpu2',                  max_value=100,
    x=160,                          y=100,
    graph_radius=48,
    graph_thickness=5,
    graph_start_angle=0,
    graph_unit_angle=2.7,          graph_unit_thickness=2.7,
    graph_bg_colour=0xffffff,      graph_bg_alpha=0.1,
    graph_fg_colour=0x6A9BCB,      graph_fg_alpha=0.5,
    hand_fg_colour=0x6A9BCB,       hand_fg_alpha=0.0,
    txt_radius=38,
    txt_weight=0,                  txt_size=9.0,
    txt_fg_colour=0x6A9BCB,        txt_fg_alpha=0,
    graduation_radius=28,
    graduation_thickness=0,        graduation_mark_thickness=1,
    graduation_unit_angle=27,
    graduation_fg_colour=0xFFFFFF, graduation_fg_alpha=0.3,
    caption='',
    caption_weight=1,              caption_size=8.0,
    caption_fg_colour=0xFFFFFF,    caption_fg_alpha=0.3,
},
{
    name='cpu',                    arg='cpu3',                  max_value=100,
    x=160,                          y=100,
    graph_radius=42,
    graph_thickness=5,
    graph_start_angle=0,
    graph_unit_angle=2.7,          graph_unit_thickness=2.7,
    graph_bg_colour=0xffffff,      graph_bg_alpha=0.1,
    graph_fg_colour=0x6A9BCB,      graph_fg_alpha=0.5,
    hand_fg_colour=0x6A9BCB,       hand_fg_alpha=0.0,
    txt_radius=15,
    txt_weight=0,                  txt_size=9.0,
    txt_fg_colour=0x6A9BCB,        txt_fg_alpha=0,
    graduation_radius=28,
    graduation_thickness=0,        graduation_mark_thickness=1,
    graduation_unit_angle=27,
    graduation_fg_colour=0xFFFFFF, graduation_fg_alpha=0.3,
    caption='',
    caption_weight=1,              caption_size=8.0,
    caption_fg_colour=0xFFFFFF,    caption_fg_alpha=0.3,
},
{
    name='cpu',                    arg='cpu4',                  max_value=100,
    x=160,                          y=100,
    graph_radius=36,
    graph_thickness=5,
    graph_start_angle=0,
    graph_unit_angle=2.7,          graph_unit_thickness=2.7,
    graph_bg_colour=0xffffff,      graph_bg_alpha=0.1,
    graph_fg_colour=0x6A9BCB,      graph_fg_alpha=0.5,
    hand_fg_colour=0x6A9BCB,       hand_fg_alpha=0.0,
    txt_radius=15,
    txt_weight=0,                  txt_size=9.0,
    txt_fg_colour=0x6A9BCB,        txt_fg_alpha=0,
    graduation_radius=28,
    graduation_thickness=0,        graduation_mark_thickness=1,
    graduation_unit_angle=27,
    graduation_fg_colour=0xFFFFFF, graduation_fg_alpha=0.3,
    caption='',
    caption_weight=1,              caption_size=8.0,
    caption_fg_colour=0xFFFFFF,    caption_fg_alpha=0.3,
},
{
    name='cpu',                    arg='cpu5',                  max_value=100,
    x=160,                          y=100,
    graph_radius=30,
    graph_thickness=5,
    graph_start_angle=0,
    graph_unit_angle=2.7,          graph_unit_thickness=2.7,
    graph_bg_colour=0xffffff,      graph_bg_alpha=0.1,
    graph_fg_colour=0x6A9BCB,      graph_fg_alpha=0.5,
    hand_fg_colour=0x6A9BCB,       hand_fg_alpha=0.0,
    txt_radius=15,
    txt_weight=0,                  txt_size=9.0,
    txt_fg_colour=0x6A9BCB,        txt_fg_alpha=0,
    graduation_radius=28,
    graduation_thickness=0,        graduation_mark_thickness=1,
    graduation_unit_angle=27,
    graduation_fg_colour=0xFFFFFF, graduation_fg_alpha=0.3,
    caption='',
    caption_weight=1,              caption_size=8.0,
    caption_fg_colour=0xFFFFFF,    caption_fg_alpha=0.3,
},
{
    name='cpu',                    arg='cpu6',                  max_value=100,
    x=160,                          y=100,
    graph_radius=24,
    graph_thickness=5,
    graph_start_angle=0,
    graph_unit_angle=2.7,          graph_unit_thickness=2.7,
    graph_bg_colour=0xffffff,      graph_bg_alpha=0.1,
    graph_fg_colour=0x6A9BCB,      graph_fg_alpha=0.5,
    hand_fg_colour=0x6A9BCB,       hand_fg_alpha=0.0,
    txt_radius=15,
    txt_weight=0,                  txt_size=9.0,
    txt_fg_colour=0x6A9BCB,        txt_fg_alpha=0,
    graduation_radius=28,
    graduation_thickness=0,        graduation_mark_thickness=1,
    graduation_unit_angle=27,
    graduation_fg_colour=0xFFFFFF, graduation_fg_alpha=0.3,
    caption='',
    caption_weight=1,              caption_size=8.0,
    caption_fg_colour=0xFFFFFF,    caption_fg_alpha=0.3,
},
{
    name='cpu',                    arg='cpu7',                  max_value=100,
    x=160,                          y=100,
    graph_radius=18,
    graph_thickness=5,
    graph_start_angle=0,
    graph_unit_angle=2.7,          graph_unit_thickness=2.7,
    graph_bg_colour=0xffffff,      graph_bg_alpha=0.1,
    graph_fg_colour=0x6A9BCB,      graph_fg_alpha=0.5,
    hand_fg_colour=0x6A9BCB,       hand_fg_alpha=0.0,
    txt_radius=15,
    txt_weight=0,                  txt_size=9.0,
    txt_fg_colour=0x6A9BCB,        txt_fg_alpha=0,
    graduation_radius=28,
    graduation_thickness=0,        graduation_mark_thickness=1,
    graduation_unit_angle=27,
    graduation_fg_colour=0xFFFFFF, graduation_fg_alpha=0.3,
    caption='',
    caption_weight=1,              caption_size=8.0,
    caption_fg_colour=0xFFFFFF,    caption_fg_alpha=0.3,
},
--]]
-- MEM ring
{
    name='memperc',                arg='',                      max_value=100,
    x=133,                          y=656,
    graph_radius=16,
    graph_thickness=6,
    graph_start_angle=90,
    graph_unit_angle=2.7,          graph_unit_thickness=2.7,
    graph_bg_colour=0xffffff,      graph_bg_alpha=0.1,
    graph_fg_colour=0x6A9BCB,      graph_fg_alpha=0.5,
    hand_fg_colour=0x6A9BCB,       hand_fg_alpha=0.0,
    txt_radius=5,
    txt_weight=0,                  txt_size=10.0,
    txt_fg_colour=0xB6C5D7,        txt_fg_alpha=1.0,
    graduation_radius=28,
    graduation_thickness=0,        graduation_mark_thickness=1,
    graduation_unit_angle=27,
    graduation_fg_colour=0xFFFFFF, graduation_fg_alpha=0.5,
    caption='',
    caption_weight=1,              caption_size=8.0,
    caption_fg_colour=0xFFFFFF,    caption_fg_alpha=0.3,
},
-- DISKS rings
{
    name='fs_used_perc',           arg='/',                     max_value=100,
    x=94,                          y=445,
    graph_radius=30,
    graph_thickness=5,
    graph_start_angle=0,
    graph_unit_angle=2.7,          graph_unit_thickness=2.7,
    graph_bg_colour=0xffffff,      graph_bg_alpha=0.1,
    graph_fg_colour=0x6A9BCB,      graph_fg_alpha=0.5,
    hand_fg_colour=0x6A9BCB,       hand_fg_alpha=0.0,
    txt_radius=15,
    txt_weight=0,                  txt_size=12.0,
    txt_fg_colour=0xB6C5D7,        txt_fg_alpha=1.0,
    graduation_radius=28,
    graduation_thickness=0,        graduation_mark_thickness=1,
    graduation_unit_angle=27,
    graduation_fg_colour=0xFFFFFF, graduation_fg_alpha=0.3,
    caption='/',
    caption_weight=1,              caption_size=12.0,
    caption_fg_colour=0xFFFFFF,    caption_fg_alpha=0.5,
},
{
    name='fs_used_perc',           arg='/mnt/homedata',                max_value=100,
    x=94,                          y=445,
    graph_radius=36,
    graph_thickness=5,
    graph_start_angle=0,
    graph_unit_angle=2.7,          graph_unit_thickness=2.7,
    graph_bg_colour=0xffffff,      graph_bg_alpha=0.1,
    graph_fg_colour=0x6A9BCB,      graph_fg_alpha=0.5,
    hand_fg_colour=0x6A9BCB,       hand_fg_alpha=0.0,
    txt_radius=36,
    txt_weight=0,                  txt_size=12.0,
    txt_fg_colour=0xB6C5D7,        txt_fg_alpha=1.0,
    graduation_radius=28,
    graduation_thickness=0,        graduation_mark_thickness=1,
    graduation_unit_angle=27,
    graduation_fg_colour=0xFFFFFF, graduation_fg_alpha=0.3,
    caption='/data',
    caption_weight=1,              caption_size=12.0,
    caption_fg_colour=0xFFFFFF,    caption_fg_alpha=0.5,
},
{
    name='fs_used_perc',           arg='/mnt/backups',                max_value=100,
    x=94,                          y=445,
    graph_radius=42,
    graph_thickness=5,
    graph_start_angle=0,
    graph_unit_angle=2.7,          graph_unit_thickness=2.7,
    graph_bg_colour=0xffffff,      graph_bg_alpha=0.1,
    graph_fg_colour=0x6A9BCB,      graph_fg_alpha=0.5,
    hand_fg_colour=0x6A9BCB,       hand_fg_alpha=0.0,
    txt_radius=50,
    txt_weight=0,                  txt_size=12.0,
    txt_fg_colour=0xB6C5D7,        txt_fg_alpha=1.0,
    graduation_radius=28,
    graduation_thickness=0,        graduation_mark_thickness=1,
    graduation_unit_angle=27,
    graduation_fg_colour=0xFFFFFF, graduation_fg_alpha=0.3,
    caption='/backups',
    caption_weight=1,              caption_size=12.0,
    caption_fg_colour=0xFFFFFF,    caption_fg_alpha=0.5,
},
-- This is a bit of a cheat: 2 layered bgs, for safe and red sectors, with fg no alpha
-- Overlaid with the temp (green) with fg enabled
--
-- Adjust "max_value" and "graph_start_angle" for the sector to be displayed
--[[
    { -- gpu high temps bg section (red)
    name='nvidia',                arg='temp',                      max_value=27,
    x=221,                          y=300,
    graph_radius=29,
    graph_thickness=10,
    graph_start_angle=313,
    graph_unit_angle=1.7,          graph_unit_thickness=2.7,
    graph_bg_colour=0xff0000,      graph_bg_alpha=0.3,
    graph_fg_colour=0xCE7646,      graph_fg_alpha=0,
    hand_fg_colour=0x6A9BCB,       hand_fg_alpha=0.0,
    txt_radius=15,
    txt_weight=0,                  txt_size=9.0,
    txt_fg_colour=0xCE7646,        txt_fg_alpha=0,
    graduation_radius=28,
    graduation_thickness=8,        graduation_mark_thickness=0,
    graduation_unit_angle=27,
    graduation_fg_colour=0xFFFFFF, graduation_fg_alpha=0.5,
    caption='',
    caption_weight=1,              caption_size=8.0,
    caption_fg_colour=0xFFFFFF,    caption_fg_alpha=0.3,
    },
    
    { -- gpu temp indicator
    name='nvidia',                arg='temp',                      max_value=100,
    x=221,                          y=300,
    graph_radius=29,
    graph_thickness=10,
    graph_start_angle=90,
    graph_unit_angle=2.7,          graph_unit_thickness=2.7,
    graph_bg_colour=0xffffff,      graph_bg_alpha=0.1,
    graph_fg_colour=0x5AC352,      graph_fg_alpha=0.5,
    hand_fg_colour=0x6A9BCB,       hand_fg_alpha=0.0,
    txt_radius=15,
    txt_weight=0,                  txt_size=9.0,
    txt_fg_colour=0xCE7646,        txt_fg_alpha=0,
    graduation_radius=28,
    graduation_thickness=8,        graduation_mark_thickness=0,
    graduation_unit_angle=27,
    graduation_fg_colour=0xFFFFFF, graduation_fg_alpha=0.5,
    caption='',
    caption_weight=1,              caption_size=8.0,
    caption_fg_colour=0xFFFFFF,    caption_fg_alpha=0.3,
    },
--]]
}

--                                                            angle_to_position
-- convert degree to rad and rotate (0 degree is top/north)
--
function angle_to_position(start_angle, current_angle)
    local pos = current_angle + start_angle
    return ( ( pos * (2 * math.pi / 360) ) - (math.pi / 2) )
end

--                                                              draw_gauge_ring
-- displays gauges
--
function draw_gauge_ring(display, data, value)
    local max_value = data['max_value']
    local x, y = data['x'], data['y']
    local graph_radius = data['graph_radius']
    local graph_thickness, graph_unit_thickness = data['graph_thickness'], data['graph_unit_thickness']
    local graph_start_angle = data['graph_start_angle']
    local graph_unit_angle = data['graph_unit_angle']
    local graph_bg_colour, graph_bg_alpha = data['graph_bg_colour'], data['graph_bg_alpha']
    local graph_fg_colour, graph_fg_alpha = data['graph_fg_colour'], data['graph_fg_alpha']
    local hand_fg_colour, hand_fg_alpha = data['hand_fg_colour'], data['hand_fg_alpha']
    local graph_end_angle = (max_value * graph_unit_angle) % 360

    -- background ring
    cairo_arc(display, x, y, graph_radius, angle_to_position(graph_start_angle, 0), angle_to_position(graph_start_angle, graph_end_angle))
    cairo_set_source_rgba(display, rgb_to_r_g_b(graph_bg_colour, graph_bg_alpha))
    cairo_set_line_width(display, graph_thickness)
    cairo_stroke(display)

    -- arc of value
    local val = value % (max_value + 1)
    local start_arc = 0
    local stop_arc = 0
    local i = 1
    while i <= val do
        start_arc = (graph_unit_angle * i) - graph_unit_thickness
        stop_arc = (graph_unit_angle * i)
        cairo_arc(display, x, y, graph_radius, angle_to_position(graph_start_angle, start_arc), angle_to_position(graph_start_angle, stop_arc))
        cairo_set_source_rgba(display, rgb_to_r_g_b(graph_fg_colour, graph_fg_alpha))
        cairo_stroke(display)
        i = i + 1
    end
    local angle = start_arc

    -- hand
    start_arc = (graph_unit_angle * val) - (graph_unit_thickness * 2)
    stop_arc = (graph_unit_angle * val)
    cairo_arc(display, x, y, graph_radius, angle_to_position(graph_start_angle, start_arc), angle_to_position(graph_start_angle, stop_arc))
    cairo_set_source_rgba(display, rgb_to_r_g_b(hand_fg_colour, hand_fg_alpha))
    cairo_stroke(display)

    -- graduations marks
    local graduation_radius = data['graduation_radius']
    local graduation_thickness, graduation_mark_thickness = data['graduation_thickness'], data['graduation_mark_thickness']
    local graduation_unit_angle = data['graduation_unit_angle']
    local graduation_fg_colour, graduation_fg_alpha = data['graduation_fg_colour'], data['graduation_fg_alpha']
    if graduation_radius > 0 and graduation_thickness > 0 and graduation_unit_angle > 0 then
        local nb_graduation = graph_end_angle / graduation_unit_angle
        local i = 0
        while i < nb_graduation do
            cairo_set_line_width(display, graduation_thickness)
            start_arc = (graduation_unit_angle * i) - (graduation_mark_thickness / 2)
            stop_arc = (graduation_unit_angle * i) + (graduation_mark_thickness / 2)
            cairo_arc(display, x, y, graduation_radius, angle_to_position(graph_start_angle, start_arc), angle_to_position(graph_start_angle, stop_arc))
            cairo_set_source_rgba(display,rgb_to_r_g_b(graduation_fg_colour,graduation_fg_alpha))
            cairo_stroke(display)
            cairo_set_line_width(display, graph_thickness)
            i = i + 1
        end
    end

    -- text
    local txt_percent = "%" --add "%" to numbers
        txt_percent = value..txt_percent
    local txt_radius = data['txt_radius']
    local txt_weight, txt_size = data['txt_weight'], data['txt_size']
    local txt_fg_colour, txt_fg_alpha = data['txt_fg_colour'], data['txt_fg_alpha']
    local movex = txt_radius * math.cos(angle_to_position(graph_start_angle, angle))
    local movey = txt_radius * math.sin(angle_to_position(graph_start_angle, angle))
    cairo_select_font_face (display, "Dustismo", CAIRO_FONT_SLANT_NORMAL, txt_weight)
    cairo_set_font_size (display, txt_size)
    cairo_set_source_rgba (display, rgb_to_r_g_b(txt_fg_colour, txt_fg_alpha))
    cairo_move_to (display, x + movex - (txt_size / 2), y + movey + 3)
    cairo_show_text (display, txt_percent)
    cairo_stroke (display)

    -- caption
    local caption = data['caption']
    local caption_weight, caption_size = data['caption_weight'], data['caption_size']
    local caption_fg_colour, caption_fg_alpha = data['caption_fg_colour'], data['caption_fg_alpha']
    local tox = graph_radius * (math.cos((graph_start_angle * 2 * math.pi / 360)-(math.pi/2)))
    local toy = graph_radius * (math.sin((graph_start_angle * 2 * math.pi / 360)-(math.pi/2)))
    cairo_select_font_face (display, "Dustismo", CAIRO_FONT_SLANT_NORMAL, caption_weight);
    cairo_set_font_size (display, caption_size)
    cairo_set_source_rgba (display, rgb_to_r_g_b(caption_fg_colour, caption_fg_alpha))
    cairo_move_to (display, x + tox + 5, y + toy + 1)
    -- bad hack but not enough time !
    if graph_start_angle < 105 then
        cairo_move_to (display, x + tox - 30, y + toy + 1)
    end
    cairo_stroke (display)
end

--                                                               go_gauge_rings
-- loads data and displays gauges
--
function go_gauge_rings(display)
    local function load_gauge_rings(display, data)
        local str, value = '', 0
        str = string.format('${%s %s}',data['name'], data['arg'])
        str = conky_parse(str)
        value = tonumber(str)
        draw_gauge_ring(display, data, value)
    end --local
    
    for i in pairs(gauge) do
        load_gauge_rings(display,gauge[i])
    end--for i in pairs
end--function go_gauge_rings

function rgb_to_r_g_b(colour,alpha)
    return ((colour / 0x10000) % 0x100) / 255., ((colour / 0x100) % 0x100) / 255., (colour % 0x100) / 255., alpha
end

function draw_ring(cr,t,pt)
    local w,h=conky_window.width,conky_window.height

    local xc,yc,ring_r,ring_w,sa,ea=pt['x'],pt['y'],pt['radius'],pt['thickness'],pt['start_angle'],pt['end_angle']
    local bgc, bga, fgc, fga=pt['bg_colour'], pt['bg_alpha'], pt['fg_colour'], pt['fg_alpha']

    local angle_0=sa*(2*math.pi/360)-math.pi/2
    local angle_f=ea*(2*math.pi/360)-math.pi/2
    local t_arc=t*(angle_f-angle_0)

    -- Draw background ring
    cairo_arc(cr,xc,yc,ring_r,angle_0,angle_f)
    cairo_set_source_rgba(cr,rgb_to_r_g_b(bgc,bga))
    cairo_set_line_width(cr,ring_w)
    cairo_stroke(cr)

    -- Draw indicator ring
    cairo_arc(cr,xc,yc,ring_r,angle_0,angle_0+t_arc)
    cairo_set_source_rgba(cr,rgb_to_r_g_b(fgc,fga))
    cairo_stroke(cr)
end

function conky_functions()
    if conky_window == nil then 
        return
    end

    local cs = cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, conky_window.width, conky_window.height)
    local display = cairo_create(cs)
    
    local updates = conky_parse('${updates}')
    update_num = tonumber(updates)
    
    if update_num > 5 then
        go_gauge_rings(display)
    end
end
