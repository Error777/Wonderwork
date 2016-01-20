/obj/item/weapon/vending_charge
	name = "Vending Charge"
	icon = 'icons/obj/vending_restock.dmi'
	icon_state = "generic-charge"
	item_state = "charge_unit"
	var/charge_type = "Generic"
	var/list/charges = 0	//how many restocking "charges" the refill has for standard/contraband/coin products

/obj/item/weapon/vending_charge/New(amt = -1)
	..()
	name = "\improper [charge_type] charge unit"
	if(isnum(amt) && amt > -1)
		charges = amt

/obj/item/weapon/vending_charge/examine(mob/user)
	..()
	if(charges)
		user << "It can [charges] charges."
	else
		user << "It's empty!"


/obj/item/weapon/vending_charge/generic
	charge_type = "Generic"
	charges = 10

/obj/item/weapon/vending_charge/medical
	charge_type = "Medical"
	icon_state = "medical-charge"
	charges = 20

/obj/item/weapon/vending_charge/chemistry
	charge_type = "Chemistry"
	icon_state = "chemistry-charge"
	charges = 20

/obj/item/weapon/vending_charge/genetics
	charge_type = "Genetics"
	icon_state = "genetics-charge"
	charges = 6

/obj/item/weapon/vending_charge/toxins
	charge_type = "Toxins"
	icon_state = "toxins-charge"
	charges = 6

/obj/item/weapon/vending_charge/robotics
	charge_type = "Robotics"
	icon_state = "robotics-charge"
	charges = 20

/obj/item/weapon/vending_charge/bar
	charge_type = "Bar"
	icon_state = "bar-charge"
	charges = 60

/obj/item/weapon/vending_charge/kitchen
	charge_type = "Kitchen"
	icon_state = "kitchen-charge"
	charges = 6

/obj/item/weapon/vending_charge/engineering
	charge_type = "Engineering"
	icon_state = "engineering-charge"
	charges = 20

/obj/item/weapon/vending_charge/security
	charge_type = "Security"
	icon_state = "security-charge"
	charges = 6

/obj/item/weapon/vending_charge/coffee
	charge_type = "Coffee"
	icon_state = "coffee-charge"
	charges = 20

/obj/item/weapon/vending_charge/snack
	charge_type = "Snack"
	icon_state = "snack-charge"
	charges = 20

/obj/item/weapon/vending_charge/cart
	charge_type = "Cart"
	icon_state = "cart-charge"
	charges = 10

/obj/item/weapon/vending_charge/cigarette
	charge_type = "Cigarette"
	icon_state = "cigarette-charge"
	charges = 38

/obj/item/weapon/vending_charge/hydroponics
	charge_type = "Hydroponics"
	icon_state = "hydroponics-charge"
	charges = 60

/obj/item/weapon/vending_charge/soda
	charge_type = "Soda"
	icon_state = "soda-charge"
	charges = 30

/obj/item/weapon/vending_charge/clothes
	charge_type = "Ñlothes"
	icon_state = "clothes-charge"
	charges = 48

/obj/item/weapon/vending_charge/liquid
	charge_type = "LiquidRation"
	icon_state = "liquidfood-charge"
	charges = 8
