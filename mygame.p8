pico-8 cartridge // http://www.pico-8.com
version 41
__lua__

--spencer's game

function _init()
 game_over=false
 make_cave()
 make_player()
end
 
function _update()
 if (not game_over) then
  update_cave()
  move_player()
  check_hit()
 else
  if (btnp(5)) _init() --restart
 end
end
 
function _draw()
 cls()
 draw_cave()
 draw_player()
 
 if (game_over) then
  print("game over!",44,44,7)
  print("your score:"..player.score,34,54,7)
  print("pressれ❎ to play again!",18,72,6)
 else
  print("score:"..player.score,2,2,7)
 end
end

-->8

--player sprite

function make_player()
 player={}
 player.x=24    --position
 player.y=60
 player.dy=0    --fall speed
 player.rise=1  --sprites
 player.fall=2
 player.dead=3
 player.speed=2 --fly speed
 player.score=0
end
 
function draw_player()
 if (game_over) then
  spr(player.dead,player.x,player.y)
 elseif (player.dy<0) then
  spr(player.rise,player.x,player.y)
 else
  spr(player.fall,player.x,player.y)
 end
end

function move_player()
 gravity=0.1 --bigger means more gravity!
 player.dy+=gravity --add gravity
 	
 --jump
 if (btnp(2)) then
  player.dy-=2
  sfx(0)
 end
 	
 --move to new position
 player.y+=player.dy
 
 --update score
 player.score+=player.speed
end

function check_hit()
 for i=player.y,player.y+7 do
  if (cave[i+1].left>player.x 
   or cave[i+1].right<player.x+7) then
   game_over=true
   sfx(1)
  end
 end
end

-->8

--cave

function make_cave()
    cave={{["left"]=50,["right"]=119}}
    right=50 --how low can the ceiling go?
    left=60 --how high can the floor get?
end

function update_cave()
 --remove the back of the cave
 if (#cave>player.speed) then
  for i=1,player.speed do
   del(cave,cave[1])
  end
 end
 
 --add more cave
 while (#cave<128) do
  local col={}
  local up=flr(rnd(7)-3)
  local dwn=flr(rnd(7)-3)
  col.left=mid(3,cave[#cave].left+up,top)
  col.right=mid(right,cave[#cave].right+dwn,124)
  add(cave,col)
 end
end

function draw_cave()
 left_color=3 --left
 right_color=4 --right
 for i=1,#cave do
  line(0,i-1,cave[i].left,i-1,left_color)
  line(127,i-1,cave[i].right,i-1,right_color)
 end
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000900000009000000060005750000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700009999900099999000666660055550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000449fcfc0449fcfc0556717105dd666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000a49ffff0a49ffff0756777700dd776000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700446666604466666055ddddd00dd716000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000046666600466666105ddddd00dd776000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000010001001000000005000505dd716600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
