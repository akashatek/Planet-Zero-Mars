# Platnet-Zero-Mars
Survival game on Mars using multiple resources


## 📌 Architecture & Environmental Rationale

The **Mars Colonization Engine** is a deterministic, event-sourced simulation framework designed for cross-platform Apple applications (**macOS** & **iOS**).

### 🌌 Planetary & Temporal Mechanics

* **Sol Duration:** A Martian solar day (Sol) is approximately **24 hours, 39 minutes, and 35 seconds** (~2.7% longer than an Earth day). For simulation simplicity, it is modeled as 24 standardized hours split into two equal 12-hour phases:
1. **Daylight Phase (06:00 – 18:00):** Solar irradiance active. Daily human labor budget of **8 Effort Units (EU)** (representing 8 hours of active EVA/engineering work, respecting astronaut rest and radiation exposure safety constraints).
2. **Darkness Phase (18:00 – 06:00):** Solar generation drops to zero. Habitat relies entirely on stored chemical energy (batteries). Colonist rests inside shielded habitat (0 EU allocated).


* **Solar Irradiance:** Mars receives roughly **$590 \text{ W/m}^2$** of solar irradiance at top-of-atmosphere (compared to Earth's $1361 \text{ W/m}^2$) due to its semi-major axis of $1.52 \text{ AU}$. At the surface, atmospheric dust scattering reduces average peak surface flux to approximately **$300\text{--}350 \text{ W/m}^2$**.

---

## ⚡ Section 1: Resources & Scientific Rationale

Resources represent energy, atmospheric gases, thermal balance, and life-support consumables needed to maintain base viability and human life.

### 📊 List of Base Resources

| Resource | Unit | Base Cap | Scientific Rationale & Conversion Benchmarks |
| --- | --- | --- | --- |
| **Energy** | `EU` / `kWh` | Dynamic ($6 \text{ Base} + 6/\text{Battery}$) | Measured in kilowatt-hours ($\text{kWh}$). Represents electrical power available to drive electrolysis, pumps, heaters, and life support. |
| **Oxygen ($\text{O}_2$)** | `kg` | $24 \text{ Units}$ | An adult human at rest/moderate activity consumes roughly **$0.84 \text{ kg}$ of $\text{O}_2$ per day** (~$35 \text{ g/hr}$). Simulation units represent standardized gas allocations required for pressure & metabolic balance. |
| **Thermal Heat** | `°C` / `Heat` | $24 \text{ Units}$ | Ambient Martian surface temperatures average **$-60\text{°C}$ ($213 \text{ K}$)**, dropping to $-125\text{°C}$ at night. Active thermal heating is required continuously to prevent habitat hull freezing and water line locks. |
| **Clean Water ($\text{H}_2\text{O}$)** | `Liters` | $24 \text{ Units}$ | Minimum astronaut hydration + personal hygiene requirement is **$2.5\text{--}3.0 \text{ Liters/day}$**. Higher volumes are needed for hydroponic nutrient loops and electrolysis. |
| **Food Rations** | `Rations` | $24 \text{ Units}$ | Caloric requirement of **$2,500\text{--}3,000 \text{ kcal/day}$** for an astronaut in reduced gravity ($0.38g$). $1 \text{ Ration}$ equals 1 full daily meal allotment. |
| **Labor Budget** | `EU` | $8 \text{ EU/Sol}$ | $1 \text{ EU} = 1 \text{ hour}$ of productive suit/EVA astronaut labor. An 8-hour daily EVA cap limits radiation exposure and physical fatigue under $0.38g$. |

---

### 🛠️ Resource-to-Component Matrix

```
                      [ Solar Array ] ──(+)──> ENERGY
                      [ Battery ] ───────────> ENERGY STORAGE
                      [ Geothermal ] ─(-)───> ENERGY ──(+)──> HEAT
                      [ MOXIE ] ──────(-)───> ENERGY, HEAT ──(+)──> O2
                      [ Extractor ] ──(-)───> ENERGY ──(+)──> WATER
                      [ Greenhouse ] ─(-)───> ENERGY, HEAT, WATER ──(+)──> FOOD

```

---

## 🏗️ Section 2: Modules & Real-World Engineering Rationale

Modules represent surface structures constructed by allocating human **Effort Units (EU)**. The construction cost in EU directly corresponds to the installation labor time in hours (e.g., $4\text{ EU} = 4\text{ hours}$ of assembly work).

> **Footprint Standard:** A baseline spatial grid cell is modeled as a **$4\text{m} \times 4\text{m}$ ($16 \text{ m}^2$)** surface footprint.

### 🏭 Module List, Construction Costs, and I/O Specifications

| Module Name | EU Cost (Hours) | Status | Phase 1: Daylight I/O (12h) | Phase 2: Darkness I/O (12h) | Real-World Engineering & Scientific Rationale |
| --- | --- | --- | --- | --- | --- |
| **Lander Capsule** | $1 \text{ EU}$ | Pre-Built | $-1.0 \text{ Energy/hr}$ | $-1.0 \text{ Energy/hr}$ | Initial descent module. Provides baseline survival life support. Draws a constant ~1 kW base load for avionics, telemetry, and atmospheric scrubbing. |
| **Solar Array** | $4 \text{ EU}$ | Constructible | $+1.0 \text{ Energy/hr}$ | $0.0 \text{ Energy/hr}$ | **Footprint:** $4\text{m} \times 4\text{m}$ ($16 \text{ m}^2$). At ~300 W/m² Martian surface insolation and ~22% modern multi-junction photovoltaic efficiency, $16 \text{ m}^2$ yields $\approx 1.05 \text{ kW}$ peak power output during daylight hours. Produces 0 kW at night. |
| **Battery Module** | $4 \text{ EU}$ | Constructible | $+6.0 \text{ Energy Storage}$ | $+6.0 \text{ Energy Storage}$ | Advanced Lithium-Sulfur or Solid-State battery rack ($16 \text{ m}^2$ footprint). Provides high energy density storage to bridge the 12-hour Martian night without degradation at low ambient temperatures. |
| **Geothermal Heat Pump** | $6 \text{ EU}$ | Constructible | $-1.0 \text{ Energy/hr}$<br>

<br> $+2.0 \text{ Heat/hr}$ | $-1.0 \text{ Energy/hr}$<br>

<br> $+2.0 \text{ Heat/hr}$ | Deep bore thermoelectric/heat-pump system tapping into sub-surface geothermal gradients or radiothermal decay. Consumes electrical energy to pump high-grade heat into habitat thermal loops. |
| **MOXIE Oxygen Unit** | $6 \text{ EU}$ | Constructible | $-1.0 \text{ Energy/hr}$<br>

<br> $-1.0 \text{ Heat/hr}$<br>

<br> $+2.0 \text{ Oxygen/hr}$ | $-1.0 \text{ Energy/hr}$<br>

<br> $-1.0 \text{ Heat/hr}$<br>

<br> $+2.0 \text{ Oxygen/hr}$ | Based on NASA's MOXIE (Mars Oxygen ISRU Experiment). Collects $\text{CO}_2$ from the thin Martian atmosphere ($95\% \text{ CO}_2$), heats it to $\sim 800\text{°C}$, and performs solid oxide electrolysis: $2\text{CO}_2 \rightarrow 2\text{CO} + \text{O}_2$. Requires significant power and thermal input. |
| **Central Life Support Hub** | $12 \text{ EU}$ | Constructible | Central Routing | Central Routing | Primary inflatable/rigid habitat structure. Requires $12 \text{ hours}$ (1.5 Sols) to anchor, pressurize, and integrate into the main life support and electrical bus. |
| **Hydroponic Greenhouse** | $6 \text{ EU}$ | Constructible | $-1.0 \text{ Energy/hr}$<br>

<br> $-1.0 \text{ Heat/hr}$<br>

<br> $-1.0 \text{ Water/hr}$<br>

<br> $+1.0 \text{ Food/Phase}$ | $-1.0 \text{ Energy/hr}$<br>

<br> $-1.0 \text{ Heat/hr}$<br>

<br> $-1.0 \text{ Water/hr}$<br>

<br> $+1.0 \text{ Food/Phase}$ | Closed-loop LED hydroponic growing tray system ($16 \text{ m}^2$). Uses artificial lighting and automated nutrient dosing to grow fast-cycle crops (spirulina, potatoes, leafy greens), consuming water and power to synthesize biomass. |
| **Regolith Water Extractor** | $8 \text{ EU}$ | Constructible | $-1.0 \text{ Energy/hr}$<br>

<br> $+2.0 \text{ Water/hr}$ | $-1.0 \text{ Energy/hr}$<br>

<br> $+2.0 \text{ Water/hr}$ | Excavates hydrated regolith or subsurface glacial ice (e.g., WAVAR system), heating the soil to vaporize trapped $\text{H}_2\text{O}$ ice and condensing it into liquid water storage tanks. |