/obj/structure/awaymission/mrbones/candle
	name = "Candle"
	desc = "TOO SPOOKY!!!"
	icon = 'icons/awaymissions/mrbones.dmi'
	icon_state = "candle"
	anchored = 1
	density = 1

/obj/structure/awaymission/mrbones/candle/New()
	..()
	SetLuminosity(5,2,2)

/obj/structure/awaymission/mrbones/sign
	name = "SPOOKY CAVE"
	desc = "2SPOOKY 4 U"
	icon = 'icons/awaymissions/cave.dmi'

/obj/effect/away/mrbones/draw
	name = "Draw Bridge"
	desc = "Lavely helps you get past otherwise deadly lava."
	icon = 'icons/awaymissions/mrbones.dmi'
	icon_state = "draw"