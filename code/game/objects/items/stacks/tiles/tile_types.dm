/* Diffrent misc types of tiles
 * Contains:
 *		Grass
 *		Wood
 *		Carpet
 *		Gold
 *		Plasma
 *		Silver
 *		Bananium
 *		Uranium
 *		Diamond
 */

/*
 * Grass
 */
/obj/item/stack/tile/grass
	name = "grass tiles"
	singular_name = "grass floor tile"
	desc = "A patch of grass like they often use on golf courses"
	icon_state = "tile_grass"
	w_class = 3.0
	force = 1.0
	throwforce = 1.0
	throw_speed = 5
	throw_range = 20
	flags = FPRINT | TABLEPASS | CONDUCT
	max_amount = 60
	origin_tech = "biotech=1"

/*
 * Wood
 */
/obj/item/stack/tile/wood
	name = "wood floor tiles"
	singular_name = "wood floor tile"
	desc = "an easy to fit wood floor tile"
	icon_state = "tile-wood"
	w_class = 3.0
	force = 1.0
	throwforce = 1.0
	throw_speed = 5
	throw_range = 20
	flags = FPRINT | TABLEPASS | CONDUCT
	max_amount = 60

/*
 * Carpets
 */
/obj/item/stack/tile/carpet
	name = "carpet"
	singular_name = "carpet"
	desc = "A piece of carpet. It is the same size as a floor tile"
	icon_state = "tile-carpet"
	w_class = 3.0
	force = 1.0
	throwforce = 1.0
	throw_speed = 5
	throw_range = 20
	flags = FPRINT | TABLEPASS | CONDUCT
	max_amount = 60

/obj/item/stack/tile/gold
	name = "gold floor tiles"
	singular_name = "gold floor tile"
	desc = "A tile made out of gold, the swag seems strong here."
	icon_state = "tile_gold"
	w_class = 3.0
	force = 1.0
	throwforce = 1.0
	throw_speed = 5
	throw_range = 20
	flags = FPRINT | TABLEPASS | CONDUCT
	max_amount = 60

/obj/item/stack/tile/plasma
	name = "plasma floor tiles"
	singular_name = "plasma floor tile"
	desc = "A tile made out of highly flammable plasma. This can only end well."
	icon_state = "tile_plasma"
	w_class = 3.0
	force = 1.0
	throwforce = 1.0
	throw_speed = 5
	throw_range = 20
	flags = FPRINT | TABLEPASS | CONDUCT
	max_amount = 60
	origin_tech = "plasmatech=1"

/obj/item/stack/tile/silver
	name = "silver floor tiles"
	singular_name = "silver floor tile"
	desc = "A tile made out of silver, the light shining from it is blinding."
	icon_state = "tile_silver"
	w_class = 3.0
	force = 1.0
	throwforce = 1.0
	throw_speed = 5
	throw_range = 20
	flags = FPRINT | TABLEPASS | CONDUCT
	max_amount = 60

/obj/item/stack/tile/bananium
	name = "bananium floor tiles"
	singular_name = "bananium floor tile"
	desc = "A tile made out of bananium, HOOOOOOOOONK!"
	icon_state = "tile_bananium"
	w_class = 3.0
	force = 1.0
	throwforce = 1.0
	throw_speed = 5
	throw_range = 20
	flags = FPRINT | TABLEPASS | CONDUCT
	max_amount = 60

/obj/item/stack/tile/uranium
	name = "gold floor tiles"
	singular_name = "gold floor tile"
	desc = "A tile made out of uranium. You feel a bit woozy."
	icon_state = "tile-space"
	w_class = 3.0
	force = 1.0
	throwforce = 1.0
	throw_speed = 5
	throw_range = 20
	flags = FPRINT | TABLEPASS | CONDUCT
	max_amount = 60

/obj/item/stack/tile/diamond
	name = "gold floor tiles"
	singular_name = "gold floor tile"
	desc = "A tile made out of diamond. Wow, just, wow."
	icon_state = "tile-space"
	w_class = 3.0
	force = 1.0
	throwforce = 1.0
	throw_speed = 5
	throw_range = 20
	flags = FPRINT | TABLEPASS | CONDUCT
	max_amount = 60
	origin_tech = "materials=2"

/*
 * Fake Space
 */
/obj/item/stack/tile/fakespace
	name = "astral carpet"
	singular_name = "astral carpet"
	desc = "A piece of carpet with a convincing star pattern."
	icon_state = "tile-space"
	w_class = 3.0
	force = 1.0
	throwforce = 1.0
	throw_speed = 5
	throw_range = 20
	flags = FPRINT | TABLEPASS | CONDUCT
	max_amount = 60