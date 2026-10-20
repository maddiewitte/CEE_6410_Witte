$ontext
Special-Event Park-and-Ride Planning Problem
CEE 6410
Maddie Witte
October 10, 2026

This problem was contributed by Dr. Ran Sun and expanded by Dr. David Rosenberg

Learning objectives.
Students will be able to:
•   Define dimensions, decision variables and an objective function;
•   Formulate demand, capacity, and service-quality constraints;
•   Solve a small linear program;
•   Identify constraints;

Problem Statement
State Department of Transportation guidance for special events emphasizes advance parklotanning for transportation demand, traffic, parking, transit operations, and seating.

Passengers must also be assigned in full bus-loads of 50 passengers per bus.

Additionally, the event planners must rent and bring in grandstands for the attendees. They have 2 potential venders. Each vender has an up-front reservation cost, number of seats per grandstand, and cost to load, ship, and setup a grandstand.

Vendor  Reservation cost ($)    Seats per grandstand    Cost to load, ship, and setup ($ per grandstand)
PurpleRain $1,000                   100                 200
Blue Sky    $1,500                  200                 300

Full details at https://usu.instructure.com/courses/818402/files/100525844?wrap=1

David E Rosenberg
david.rosenberg@usu.edu
$offtext

* 1. DEFINE the SETS
SETS parklot Parking Lots /north, south, west/
     vendor Vendors of grandstands /PurpleRain, BlueSky/;

* 2. DEFINE input data
PARAMETERS
   MaxPassengers(parklot) maximimum number of peoparklote parking lot can handle (Number)
         /north 600,
          south 500,
          west  600/
   Cost(parklot) cost per passenger from parking lot ($ per person)
          /north 4,
          south 5,
          west  7/
   TravelTime(parklot) Travel time from parking lot (minutes)
         /north 20,
          south 12,
          west  8/
   MaxAverageTime Maximum average travel time for all pasengers (minutes) /13/
   Attendees number of attendees /1200/
   ReservationCost(vendor) Cost to reserve grandstands from vendor ($)
        /PurpleRain 1000,
         BlueSky    1500/
   Seats(vendor) Seats per grandstand (number)
        /PurpleRain 100,
         BlueSky    200/
   UnitCost(vendor) Cost per grandstand to load ship and setup ($ per grandstand)
        /PurpleRain 200,
         BlueSky    300/
   MaxGrandstands(vendor) max grandstands needed
         /PurpleRain 12, BlueSky 6/;

* 3. DEFINE the variables
VARIABLES   I(vendor) binary decision to use or not use each vendor (1=yes 0=no)
            G(vendor) number of granstands ordered
            X(parklot) number of buses from parking lots
            TCOST  total capital and operating costs ($);

BINARY VARIABLES I;
INTEGER VARIABLES X,G;

* 4. COMBINE variables and data in equations
*EQUATIONS
EQUATIONS
    ObjectiveFunct  total cost of everything
    MaxCap(parklot) max capacity in each lot
    TotalDemandCap meet total attendee capacity
    GrandSeatsCap meet capacity for grandstand seats
    AvgTravel average travel time from lots
    VendorMax(vendor) relationship between grandstands and vendor
    VendorMin(vendor) min requirment for grandstands if vendor is selected;

ObjectiveFunct..   TCOST =E= SUM(parklot, Cost(parklot) * 50 * X(parklot)) + SUM(vendor, ReservationCost(vendor) * I(vendor)) + SUM(vendor, UnitCost(vendor) * G(vendor));
MaxCap(parklot)..  50 * X(parklot) =L= MaxPassengers(parklot);
TotalDemandCap..   SUM(parklot, 50 * X(parklot)) =G= Attendees;
GrandSeatsCap..    SUM(vendor, Seats(vendor) * G(vendor)) =G= Attendees;
AvgTravel..        SUM(parklot, (TravelTime(parklot) - MaxAverageTime) * X(parklot)) =L= 0;
VendorMax(vendor).. G(vendor) =L= MaxGrandstands(vendor) * I(vendor);
VendorMin(vendor).. G(vendor) =G= I(vendor);

* 5. DEFINE the MODEL from the EQUATIONS
MODEL SpecialEvent /ALL/;

* 6. Solve the Model as a Mixed Integer Program
SOLVE SpecialEvent USING MIP MINIMIZING TCOST;

* 7. Display the decision variable values in the list file
DISPLAY X.L, I.L, G.L, TCOST.L;

* Dump all input data and results to a GAMS gdx file
Execute_Unload "MIP-SpecialEvent.gdx";
* Dump the gdx file to an Excel workbook
Execute "gdx2xls MIP-SpecialEvent.gdx"
