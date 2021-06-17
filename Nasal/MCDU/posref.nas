# McDonnell Douglas MD-11 MCDU
# Copyright (c) 2021 Josh Davidson (Octal450)

var PosRef = {
	new: func(n) {
		var m = {parents: [PosRef]};
		
		m.id = n;
		
		m.Display = {
			arrow: 1,
			
			CFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			C1: "",
			C1S: "",
			C2: "",
			C2S: "",
			C3: "",
			C3S: "",
			C4: "",
			C4S: "",
			C5: "",
			C5S: "",
			C6: "",
			C6S: "",
			
			LFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			L1: "N4038.5/W07346.0",
			L1S: "FMC LAT/LONG (G/I)",
			L2: "N4038.5/W07346.0",
			L2S: "IRS (MIX)",
			L3: "",
			L3S: "",
			L4: "2.00/0.05NM",
			L4S: "RNP ACTUAL",
			L5: "",
			L5S: "",
			L6: "",
			L6S: "",
			
			pageNum: "1/3",
			
			RFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			R1: "",
			R1S: "",
			R2: "",
			R2S: "",
			R3: "",
			R3S: "",
			R4: "",
			R4S: "",
			R5: "INHIBIT*",
			R5S: "GPS NAV",
			R6: "F-PLN INIT>",
			R6S: "RETURN TO",
			
			simple: 1,
			title: "IRS/GNS POS   ",
		};
		
		m.Value = {
			frozen: 0,
		};
		
		m.group = "fmc";
		m.name = "posRef";
		m.nextPage = "irsGnsPos";
		m.scratchpad = "";
		
		return m;
	},
	reset: func() {
		# Placeholder
	},
	tempReset: func() {
		# Placeholder
	},
	loop: func() {
		if (!me.Value.frozen) {
			me.Display.L1S = "FMC LAT/LONG (G/I)";
		} else {
			me.Display.L1S = "POS FROZEN (G/I)";
		}
		
		# todo: GPS ENABLE / INHIBIT
		# G/I MODE: 
		# G WHEN GPS ENABLE + NO IRS
		# I WHEN GPS INHIBIT + IRS
		# NO NAV WHEN NEITHER GPS NOR IRS
		# and this doesn't consider the radio beacons
	},
	softKey: func(k) {
		if (mcdu.unit[me.id].scratchpadState() == 1) {
			if (k == "l1") {
				me.Value.frozen = !me.Value.frozen;
			} elsif (k == "r6") {
				mcdu.unit[me.id].setPage("refindex");
			} else {
				mcdu.unit[me.id].setMessage("NOT ALLOWED");
			}
		} else {
			mcdu.unit[me.id].setMessage("NOT ALLOWED");
		}
	},
};

var IrsGnsPos = {
	new: func(n) {
		var m = {parents: [IrsGnsPos]};
		
		m.id = n;
		
		m.Display = {
			arrow: 1,
			
			CFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			C1: "-",
			C1S: "NAV",
			C2: "-",
			C2S: "NAV",
			C3: "-",
			C3S: "NAV",
			C4: "",
			C4S: "NAV",
			C5: "",
			C5S: "NAV",
			C6: "",
			C6S: "",
			
			LFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			L1: "N4038.5/W07346.0",
			L1S: "IRU 1",
			L2: "N4038.5/W07346.0",
			L2S: "IRU 2",
			L3: "N4038.5/W07346.0",
			L3S: "IRU 3",
			L4: "N4038.5/W07346.0",
			L4S: "GNS 1",
			L5: "N4038.5/W07346.0",
			L5S: "GNS 2",
			L6: "",
			L6S: "",
			
			pageNum: "2/3",
			
			RFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			R1: "000g/00",
			R1S: "",
			R2: "000g/00",
			R2S: "",
			R3: "000g/00",
			R3S: "2 MIN  ",
			R4: "000g/00",
			R4S: "6SV ",
			R5: "000g/00",
			R5S: "5SV ",
			R6: "REF INDEX>",
			R6S: "RETURN TO",
			
			simple: 1,
			title: "IRS/GNS POS   ",
		};
		
		m.group = "fmc";
		m.name = "irsGnsPos";
		m.nextPage = "irsStatus";
		m.scratchpad = "";
		
		return m;
	},
	reset: func() {
		# Placeholder
	},
	tempReset: func() {
		# Placeholder
	},
	loop: func() {
		if (systems.IRS.Iru.aligned[0].getValue()) {
			me.Display.L1 = "N4038.5/W07346.0";
			me.Display.C1S = "NAV";
			me.Display.R1 = "000g/00";
			me.Display.R1S = "";
		} else {
			me.Display.L1 = "  -----/-----";
			me.Display.C1S = "ALIGN";
			me.Display.R1 = "";
			me.Display.R1S = sprintf("%2.0f MIN",systems.IRS.Iru.alignTimeRemainingMinutes[0].getValue());
		}
		
		if (systems.IRS.Iru.aligned[1].getValue()) {
			me.Display.L2 = "N4038.5/W07346.0";
			me.Display.C2S = "NAV";
			me.Display.R2 = "000g/00";
			me.Display.R2S = "";
		} else {
			me.Display.L2 = "  -----/-----";
			me.Display.C2S = "ALIGN";
			me.Display.R2 = "";
			me.Display.R2S = sprintf("%2.0f MIN",systems.IRS.Iru.alignTimeRemainingMinutes[1].getValue());
		}
		
		if (systems.IRS.Iru.aligned[2].getValue()) {
			me.Display.L3 = "N4038.5/W07346.0";
			me.Display.C3S = "NAV";
			me.Display.R3 = "000g/00";
			me.Display.R3S = "";
		} else {
			me.Display.L3 = "  -----/-----";
			me.Display.C3S = "ALIGN";
			me.Display.R3 = "";
			me.Display.R3S = sprintf("%2.0f MIN",systems.IRS.Iru.alignTimeRemainingMinutes[2].getValue());
		}
	},
	softKey: func(k) {
		if (mcdu.unit[me.id].scratchpadState() == 1) {
			if (k == "r6") {
				mcdu.unit[me.id].setPage("refindex");
			} else {
				mcdu.unit[me.id].setMessage("NOT ALLOWED");
			}
		} else {
			mcdu.unit[me.id].setMessage("NOT ALLOWED");
		}
	},
};

var IrsStatus = {
	new: func(n) {
		var m = {parents: [IrsStatus]};
		
		m.id = n;
		
		m.Display = {
			arrow: 1,
			
			CFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			C1: "-",
			C1S: "DRIFT RATE   ",
			C2: "-",
			C2S: "",
			C3: "-",
			C3S: "",
			C4: "",
			C4S: "",
			C5: "",
			C5S: "",
			C6: "",
			C6S: "",
			
			LFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.small, FONT.small],
			L1: "IRU1",
			L1S: "",
			L2: "IRU2",
			L2S: "",
			L3: "IRU3",
			L3S: "",
			L4: "",
			L4S: "",
			L5: "IRU1        00",
			L5S: " STATUS CODE",
			L6: "IRU3        00",
			L6S: "IRU2        00",
			
			pageNum: "3/3",
			
			RFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			R1: "-",
			R1S: "GS",
			R2: "-",
			R2S: "",
			R3: "-",
			R3S: "",
			R4: "",
			R4S: "",
			R5: "",
			R5S: "",
			R6: "F-PLN INIT>",
			R6S: "RETURN TO",
			
			simple: 1,
			title: "IRS STATUS   ",
		};
		
		m.group = "fmc";
		m.name = "irsStatus";
		m.nextPage = "posRef";
		m.scratchpad = "";
		
		return m;
	},
	reset: func() {
		# Placeholder
	},
	tempReset: func() {
		# Placeholder
	},
	loop: func() {
		pts.Velocities.groundspeedKtTemp = pts.Velocities.groundspeedKt.getValue();
		if (systems.IRS.Iru.aligned[0].getValue()) {
			me.Display.C1 = "0";
			me.Display.R1 = sprintf("%3.0f",pts.Velocities.groundspeedKtTemp);
		} else {
			me.Display.C1 = "-";
			me.Display.R1 = "-";
		}
		
		if (systems.IRS.Iru.aligned[1].getValue()) {
			me.Display.C2 = "0";
			me.Display.R2 = sprintf("%3.0f",pts.Velocities.groundspeedKtTemp);
		} else {
			me.Display.C2 = "-";
			me.Display.R2 = "-";
		}
	
		if (systems.IRS.Iru.aligned[2].getValue()) {
			me.Display.C3 = "0";
			me.Display.R3 = sprintf("%3.0f",pts.Velocities.groundspeedKtTemp);
		} else {
			me.Display.C3 = "-";
			me.Display.R3 = "-";
		}
	},
	softKey: func(k) {
		if (mcdu.unit[me.id].scratchpadState() == 1) {
			if (k == "r6") {
				mcdu.unit[me.id].setPage("init");
			} else {
				mcdu.unit[me.id].setMessage("NOT ALLOWED");
			}
		} else {
			mcdu.unit[me.id].setMessage("NOT ALLOWED");
		}
	},
};
