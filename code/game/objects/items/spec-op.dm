/obj/structure/candybucket
	name = "Candy Bucket"
	desc = "Has tons of candy for you."
	icon = 'icons/obj/scooterstuff.dmi'
	icon_state = "candy1"
	var/candy = 1
	var/id = 0
	anchored = 1
	density = 1


	attackby(obj/W as obj, mob/user as mob)
		if(istype(W, /obj/item/candybucket))
			var/obj/item/candybucket/Z = W
			user << "You take candy out of the bucket!"
			if(candy)
				switch(id)
					if(1)
						if(Z.id1 == 0)
							Z.id1 = 1
							change()
					if(2)
						if(Z.id2 == 0)
							Z.id2 = 1
							change()
					if(3)
						if(Z.id3 == 0)
							Z.id3 = 1
							change()
					if(4)
						if(Z.id4 == 0)
							Z.id4 = 1
							change()
					if(5)
						if(Z.id5 == 0)
							Z.id5 = 1
							change()
				if(Z.id1 == 1 && Z.id2 == 1 && Z.id3 == 1 && Z.id4 == 1 && Z.id5 == 1)
					user << "You have visited all five places!"
					Z.icon_state = "candy1"
				else
					return

/obj/structure/candybucket/proc/change()
		candy = 0
		icon_state = "candy0"
		var/wait = rand(50,300)
		spawn(wait)
		candy = 1
		icon_state = "candy1"
	//	src.visible_message << "Takes the candy from the bucket."

/obj/item/candybucket
	name = "Candy Bucket"
	desc = "Holds candy."
	icon = 'icons/obj/scooterstuff.dmi'
	icon_state = "candy0"
	var/id1 = 0
	var/id2 = 0
	var/id3 = 0
	var/id4 = 0
	var/id5 = 0

/obj/item/token
	name = "Lucky Corp Point Rewarder"
	desc = "Lucky!"
	icon = 'icons/obj/scooterstuff.dmi'
	icon_state = "token"

/obj/item/chestkey
	name = "old key"
	desc = "It has Epsilon written on it."
	icon = 'icons/obj/scooterstuff.dmi'
	icon_state = "key"
	var/keyid = 0
	var/style = 0 //1 = greed, 2 = gluttony

/obj/item/chestkey/chtonic
	name = "chtonic key"
	icon_state = "key-chtonic"

/obj/item/chestkey/card
	name = "key-card"
	icon_state = "key-card"

/obj/item/chestkey/artifact
	name = "old artifact"
	icon_state = "key-artifact"