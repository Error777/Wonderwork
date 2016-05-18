/obj/machinery/telecomms/receiver/preset_left/ariastation
	name = "Receiver"
	freq_listening = list()

/obj/machinery/telecomms/bus/preset_one/ariastation
	name = "Bus"
	autolinkers = list("processor1", "common")
	freq_listening = list()

/obj/machinery/telecomms/processor/preset_one/ariastation
	name = "Processor"

/obj/machinery/telecomms/server/presets/common/ariastation/New()
	..()
	freq_listening = list()

/obj/machinery/telecomms/broadcaster/preset_left/ariastation
	name = "Broadcaster"
