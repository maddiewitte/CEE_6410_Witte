$ontext
Maddie Witte
maddie.witte@usu.edu
October 2, 2026
CEE 6410 ENGR Systems Analysis

HW 2 PROBLEM:
A field will be planted with hay and grain and watered using excess from an aqueduct.

                     Monthly water demand (ac-ft)
                     June             July           August           Return ($/acre)
Hay                  2                1              1                100
Grain                1                2              0                120

Determine the optimal water allocation plan.


THE SOLUTION:
Uses General Algebraic Modeling System to Solve this Linear Program. Below:

$offtext

* 1. DEFINE the SETS
SETS crop crops growing /Hay, Grain/
     month resources /June, July, August/;

* 2. DEFINE input data
PARAMETERS
   c(crop) Objective function coefficients ($ per plant)
         /Hay 100,
         Grain 120/
   b(month) Right hand constraint values (per resource)
          /June 14000,
           July  18000,
           August 6000 /
   MaxArea the maximum area the crops can cover (acres)
         /1000/;

TABLE A(crop,month) Left hand side constraint coefficients
                 June   July  August     
 Hay             2      1     1         
 Grain           1      2     0;     

* 3. DEFINE the variables
VARIABLES X(crop) plants planted (acres)
          VPROFIT  total profit ($)
          Y(month)  value of water used (ac-ft)
          VREDCOST total reduced cost ($)
          Z max area constraint (acres);

* Non-negativity constraints
POSITIVE VARIABLES X, Y, Z;

* 4. COMBINE variables and data in equations
EQUATIONS
   PROFIT_PRIMAL Total profit ($) and objective function value
   RES_CONS_PRIMAL(month) Resource constraints
   REDCOST_DUAL Reduced Cost ($) associated with using resources
   RES_CONS_DUAL(crop) Profit levels
   CROP_AREA max area of the crops;

*Primal Equations
PROFIT_PRIMAL..                 VPROFIT =E= SUM(crop,c(crop)*X(crop));
RES_CONS_PRIMAL(month) ..    SUM(crop,A(crop,month)*X(crop)) =L= b(month);
CROP_AREA..                   SUM(crop,X(crop)) =L= MaxArea;

*Dual Equations
REDCOST_DUAL..                 VREDCOST =E= SUM(month,b(month)*Y(month))+MaxArea*Z;
RES_CONS_DUAL(crop)..          sum(month,A(crop,month)*Y(month)) +Z =G= c(crop);


* 5. DEFINE the MODELS
*PRIMAL model
MODEL CROP_PRIMAL /PROFIT_PRIMAL, RES_CONS_PRIMAL, CROP_AREA/;
*Set the options file to print out range of basis information
CROP_PRIMAL.optfile = 1;

*DUAL model
MODEL CROP_DUAL /REDCOST_DUAL, RES_CONS_DUAL/;

* 6. SOLVE the MODELS
* Solve the PLANTING PRIMAL model using a Linear Programming Solver (see File=>Options=>Solvers)
*     to maximize VPROFIT
SOLVE CROP_PRIMAL USING LP MAXIMIZING VPROFIT;

* Solve the PLANTING DUAL model using a Linear Programming Solver (see File=>Options=>Solvers)
*     to maximize VPROFIT
SOLVE CROP_DUAL USING LP MINIMIZING VREDCOST;
*Order does not matter!

* 6. CLick File menu => RUN (F9) or Solve icon and examine solution report in .LST file

* 7 . Dump all data and results to GAMS proprietary file storage .gdx and to Excel
Execute_Unload "Ex2-1Dual.gdx";
* Dump the gdx file to an Excel workbook
Execute "gdx2xls Ex2-1Dual.gdx"
* To open the GDX file in the GAMS IDE, select File => Open.
* In the Open window, set Filetype to .gdx and select the file.
