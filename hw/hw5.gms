$onText
Maddie Witte
USU CEE 6410
Homework 5
October 19, 2026

Problem Statement

Two water sources are being considered for a farm: a gravity diversion from reservoir (with 2 possible sizes) or
a pump from a lower river diversion. Base flow in the river adds 2 acft per day under the reservoir and above the
pumping site. The high dam has a capacity of 700 acft and the low dam's is 300 acft with costs of $10,000 per
year for the high dam and $6,000 per year for the low dam. The pump has a capacity of 2.2 acft per day and a yearly
cost of $8,000 and an operational cost of $20 per acft pumped to the farm.

The return for the farmland is $300 per acre irrigated. The yearly water supply from the river and irrigation
demand are in the table below; the year is broken up into two 6 mo long seasons.

Seasonal Flow and demand
season (t)      River Inflow (Q) (acft)      Irrigation Demand (acft/acre)
1               600                          1.0
2               200                          3.0

Maximize profits from the system.

$offText

Sets
    watersource /lowdam, highdam, riverpump/
    season /season1, season2/
    farmland /area/;

Parameters
    WaterSupply(season)         amount of water supplied to the reservoir via the river (acft)
        /season1 600, season2 200/
    IrrigationDemand(season)      the amount of water req by the farmland (acft per acre)
        /season1 1.0, season2 3.0/
    MaxCapacity(watersource)    yearly capactiy of each water source in acft (2.2 acft per day * 365 days per year = 803 acft)
        /highdam 700, lowdam 300, riverpump 803/
    InitialCost(watersource)    inital cost of each water collection method ($)
        /highdam 10000, lowdam 6000, riverpump 8000/
    OperatingCost(watersource)  cost to run the dam or pump per acft of water ($)
        /highdam 0, lowdam 0, riverpump 20/
    Return(farmland)            return per year per acre of farm ($)
        /area 300/
;

Positive Variables
    X(watersource, season)  amount of water pulled from said watersource (ac-ft continuous)
    A(farmland)     total area of farmland to be irrigated (ac continous)
    S(season)       storage in reservoir between season (acft)
    Spill(season)   amount of water sent over the spllway (acft)
;
Variables
    TCOST           total operating costs ($ continuous)
;

Binary Variables
    I(watersource)  whether or not to use the water source (binary)
;

Equations
    ObjectiveFunct         sum of all operating costs and returns
    WaterDemand(season)    how much water needed to irrigate
    SourceUse(watersource, season) where the water is going from the reservoir
    PumpCapacity(season)   max amount of water the pump can deliver
    PumpWaterAvailability(season)   how much water the pump has available to pump
    StorageS1              water balance for season 1
    StorageS2              water balance for season 2
    DamCapacity(season)    how much water each dam can store
    SpillLimit(season)     how much water the dam needs to spill to the river
    HighorLowDam           which dam (high or low) will be built
;

ObjectiveFunct.. TCOST =E= Sum(farmland, Return(farmland) * A(farmland)) -
                       Sum(watersource, InitialCost(watersource) * I(watersource) + OperatingCost(watersource) *
                       Sum(season, X(watersource, season)));
WaterDemand(season)..  Sum(watersource, X(watersource, season)) =G= Sum(farmland, IrrigationDemand(season) * A(farmland));
SourceUse(watersource, season).. X(watersource, season) =L= MaxCapacity(watersource) * I(watersource);
PumpCapacity(season).. X('riverpump', season) =L= 2.2 * 182.5 * I('riverpump');
PumpWaterAvailability(season).. X('riverpump', season) =L= 2 * 182.5 + Spill(season);
StorageS1..            S('season1') =E= WaterSupply('season1') - X('lowdam','season1') - X('highdam','season1') - Spill('season1');
StorageS2..            S('season2') =E=S('season1') + WaterSupply('season2') - X('lowdam','season2') - X('highdam','season2') - Spill('season2');
DamCapacity(season)..  S(season) =L= MaxCapacity('lowdam') * I('lowdam') + MaxCapacity('highdam') * I('highdam');
SpillLimit(season)..   Spill(season) =L= WaterSupply(season) + S(season) - ;
HighorLowDam..         I('lowdam') + I('highdam') =L= 1;

Model HW5Reservoir /ALL/;

* solve the Model as a Mixed Integer Program
Solve HW5Reservoir using MIP Maximizing TCOST;

* display the decision variable values in the list file
Display X.L, I.L, A.L, S.L, Spill.L, TCOST.L;

* send input data and results to a GAMS gdx file
Execute_Unload "HW5Reservoir.gdx";
* send the gdx file to excel
Execute "gdx2xls HW5Reservoir.gdx"