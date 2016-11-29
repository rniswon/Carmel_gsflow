Steady State MPWMD Files for GitHub upload: JL and MH
11.29.2016

STEADY STATE SIMULATION
Meeting 11/21/2016 - RN the requested the following:

1. Average pumping throughout model domain
2. Average diversions
3. Average return flows
4. Average evaporation from Los Padres
5. Average Heads (hobs)
6. Averages for streamflow gages: (a) Long term, (b) July-September


JL/MH Deliverables:

1. Folder: Simulation_20161129_SteadyState
   - Contains well pumping *.tab files
   - Took carmel.nam from GitHub and appended IUNIT and tab files. Saved as Simulation_20161129_SteadyState.nam
     IUNIT starts at 100 and increments upward
   - Created Simulation_20161129_SteadyState.wel using corresponding IUNIT as in .nam file

2.  - *.tab files created for diversions at Los Padres, San Clemente, and Galante. For San Clemente, the ISEG was chosen as the segment right below San Clemente Dam. However, we don't know the segment number for the "pipe to nowhere" - this needs to be modified accordingly.

    - Took Simulation_20161129_SteadyState.nam and appended diversion *.tab IUNIT numbers, starting at 5000 and incrementing upwards.

    - Took Carmel_xsections.sfr from GitHub/MODFLOW/INPUT and appended SEGNUM, NUMVAL, and IUNIT in Dataset8.

    - Evaporation was treated as a diversion for the steady state simulation (per RN).

3.  Return flows are contained in pumping (1) as positive numbers

4.  Evaporation is contained in diversions (2)

5.  Created Simulation_20161129_SteadyState.hob 
    - Uncertain about free format in HOBS item 3 - used same as example provided by RN of 1.0 2 1 

6.  Streamflow_Stations.tiff shows gage locations (for reference).
    Streamflow_1992_2003.xlsx contains month-by-month averages
    Streamflow_Long_Term_Aves.xlsx contains averages for all available data
    Streamflow_July_to_Sep_Aves.xlsx contains averages for July through September.

