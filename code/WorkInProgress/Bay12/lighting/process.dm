// SCHECK macros
// This references src directly to work around a weird bug with try/catch
#define SCHECK_EVERY(this_many_calls) if(++src.calls_since_last_scheck >= this_many_calls) sleepCheck()
#define SCHECK SCHECK_EVERY(50)

/datum/controller/process
	// How many SCHECKs have been skipped (to limit btime calls)
	var/tmp/calls_since_last_scheck = 0

// Do not call this directly - use SHECK or SCHECK_EVERY
/datum/controller/process/proc/sleepCheck(var/tickId = 0)
	calls_since_last_scheck = 0
	if (killed)
		// The kill proc is the only place where killed is set.
		// The kill proc should have deleted this datum, and all sleeping procs that are
		// owned by it.
		CRASH("A killed process is still running somehow...")
	if (hung)
		// This will only really help if the doWork proc ends up in an infinite loop.
		handleHung()
		CRASH("Process [name] hung and was restarted.")

	if (main.getCurrentTickElapsedTime() > main.timeAllowance)
		sleep(world.tick_lag)
		cpu_defer_count++
		last_slept = TimeOfHour
	else
		var/timeofhour = TimeOfHour
		// If timeofhour has rolled over, then we need to adjust.
		if (timeofhour < last_slept)
			last_slept -= 36000

		if (timeofhour > last_slept + sleep_interval)
			// If we haven't slept in sleep_interval deciseconds, sleep to allow other work to proceed.
			sleep(0)
			last_slept = TimeOfHour