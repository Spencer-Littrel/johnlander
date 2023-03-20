pico-8 cartridge // http://www.pico-8.com
version 41
__lua__

function _init()
  game_over=false
  win=false
  g=0.025         -- gravity
  make_background()
  make_ground()
  make_player()
end

function _update()
  if (not game_over) then
    move_player()
    check_land()
  else
    if (btnp(5)) then
      _init()
    end
  end
end

function _draw()
  cls()
  draw_background()
  draw_ground()
  draw_player()

  -- print("dx:"..p.dx,2,2,7)
  -- print("dy:"..p.dy,2,8,7)
  print("make it home",5)

  if (game_over) then
    if (win) then
      print("welcome home",40,40,11)
    else
      print("no way home",40,40,13)
    end
    print("❎ - try again?",34,70,5)
  end
end

function make_player()
  p={}
  p.x=64                  -- position
  p.y=8
  p.dx=0                   -- movement
  p.dy=0
  p.sprite=1
  p.alive=true
  p.thrust=0.075
end

function make_background()
  s={}
  s.rand=rndb(0,127)
end

function draw_player()
  spr(p.sprite,p.x,p.y)
  if (game_over and win) then
    spr(5,p.x,p.y)       -- victory
  elseif (game_over) then
    spr(2,p.x,p.y)         -- death
  end
  if (btn(0)) then
    spr(4,p.x,p.y) -- left facing
  end
  if (btn(1)) then
    spr(3,p.x,p.y)  -- right facing
  end


  if (btn(0) or btn(1) or btn(2)) then
    spr(6,p.x,p.y+6)  -- wind
  end
end

function move_player()
  p.dy+=g                  -- add gravity

  thrust()

  p.x+=p.dx                -- actually move the player
  p.y+=p.dy

  stay_on_screen()
end

function thrust()
  -- add thrust to movement
  if (btn(0)) then
    p.dx-=p.thrust
    -- spr(4,p.x,p.y)
  end

  if (btn(1)) then
    p.dx+=p.thrust
    -- spr(3,p.x,p.y)
  end

  if (btn(2)) then
    p.dy-=p.thrust
    -- spr(6,p.x,p.y+8)
  end

  -- thrust sound
  if (btn(0) or btn(1) or btn(2)) then
    sfx(0)
  end
end

function stay_on_screen()
  if (p.x<0) then          -- left side
    p.x=0
    p.dx=0
  end
  if (p.x>119) then        -- right side
    p.x=119
    p.dx=0
  end
  if (p.y<0) then          -- top side
    p.y=0
    p.dy=0
  end
end

function rndb(low,high)
  return flr(rnd(high-low+1)+low)
end

function draw_background()
  rectfill(0,0,128,128,0) -- background color
  srand(s.rand)
  for i=1,50 do
    pset(rndb(0,127),rndb(0,127),rndb(1,2))
  end
end

function make_ground()
  -- create the ground
  gnd={}
  local top=96             -- highest point
  local btm=120            -- lowest point

  -- set up the landing pad
  pad={}
  pad.width=15
  pad.x=rndb(0,126-pad.width)
  pad.y=rndb(top,btm)
  pad.sprite=16

  -- create ground at pad
  for i=pad.x,pad.x+pad.width do
    gnd[i]=pad.y
  end

  -- create ground right of pad
  for i=pad.x+pad.width+1,127 do
    local h=rndb(gnd[i-1]-3,gnd[i-1]+3)
    gnd[i]=mid(top,h,btm)
  end

  -- create ground left of pad
  for i=pad.x-1,0,-1 do
    local h=rndb(gnd[i+1]-3,gnd[i+1]+3)
    gnd[i]=mid(top,h,btm)
  end
end

function draw_ground()
  for i=0,127 do
    line(i,gnd[i],i,127,1)
  end
  spr(pad.sprite,pad.x,pad.y,2,1)
end

function check_land()
  l_x=flr(p.x)             -- left side of lander
  r_x=flr(p.x+7)           -- right side of lander
  b_y=flr(p.y+5)           -- bottom of lander

  over_pad=l_x>=pad.x and r_x<=pad.x+pad.width
  on_pad=b_y>=pad.y-1
  slow=p.dy<1

  if (over_pad and on_pad and slow) then
    end_game(true)
  elseif (over_pad and on_pad) then
    end_game(false)
  else
    for i=l_x,r_x do
      if (gnd[i]<=b_y) then
        end_game(false)
      end
    end
  end
end

function end_game(won)
  game_over=true
  win=won

  if (win) then
    sfx(1)
  else
    sfx(2)
  end
end

__gfx__
00000000000000000000000000000000000000000000000056677776000000000000000000000000000000000000000000000000000000000000000000000000
00000000000005000000000000000500005000000000050005557765000000000000000000000000000000000000000000000000000000000000000000000000
00700700005555000dd5050000115500005511000055550005675550000000000000000000000000000000000000000000000000000000000000000000000000
000770000057770000d6660000117700007711000c57770c56777665000000000000000000000000000000000000000000000000000000000000000000000000
00077000011111000dd66600001111000011110001c111c005675550000000000000000000000000000000000000000000000000000000000000000000000000
00700700011ccc000d6ddd60011ccc0000ccc110011ccc0000557500000000000000000000000000000000000000000000000000000000000000000000000000
00000000001ccc0006577706100ccc0000ccc001001ccc0005675000000000000000000000000000000000000000000000000000000000000000000000000000
00000000011a0a0000555500000a0a0000a0a000011a0a0000550000000000000000000000000000000000000000000000000000000000000000000000000000
000bbb55b55bb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00bbbbbbbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000bbb55b55bb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000bb55b55bb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000bbbbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
0107000024050286002b60024600286002b600000000c600136000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600
000c0000180701803013070130300e0700e0301a0701a03000000130701a0701a0300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010400003d670356602f65028640226401b6301663013630106200c62009620056200461001610006100000000000000000000000000000000000000000000000000000000000000000000000000000000000000
013000181c555105001f5551a55513500185551a5551c555185001f5551a55500000000001c555000001f5552655500000245551f555000001d5551c5551a5550000000000000000000000000000000000000000
