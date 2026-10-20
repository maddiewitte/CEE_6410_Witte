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
SETS crop /Hay, Grain/
     month /June, July, August/;

* 2. DEFINE input data
PARAMETERS
   c(crop) Objective function coefficients ($ per acre crop)
         /Hay 100,
        Grain 120 /

   b(month) Right hand constraint values (available water per month)
          /June 14000,
           July  18000,
           August  6000/;
  
TABLE A(crop,month) Left hand side constraint coefficients: water per crop per month
                 June      July      August
 Hay             2         1         1
 Grain           1         2         0;


* 3. DEFINE the variables
VARIABLES X(crop) area planted (acres)
          VPROFIT  total profit ($);

* Non-negativity constraints
POSITIVE VARIABLES X;

* 4. COMBINE variables and data in equations
EQUATIONS
   PROFIT Total profit ($) and objective function value
   RES_CONSTRAIN(month) Resource Constraints
   MAX_AREA total amount of area the crops can fill;

PROFIT..                   VPROFIT =E= SUM(crop, c(crop)*X(crop));
RES_CONSTRAIN(month) ..    SUM(crop, A(crop,month)*X(crop)) =L= b(month);
MAX_AREA..                 X(crop) =L= 10000;

* 5. DEFINE the MODEL from the EQUATIONS
MODEL PLANTING /PROFIT, RES_CONSTRAIN, MAX_AREA/;
*Altnerative way to write (include all previously defined equations)
*MODEL MAKING /ALL/;


* 6. SOLVE the MODEL
* Solve the MAKING model using a Linear Programming Solver (see File=>Options=>Solvers)
*     to maximize VPROFIT
SOLVE PLANTING USING LP MAXIMIZING VPROFIT;


* 6. CLick File menu => RUN (F9) or Solve icon and examine solution report in .LST file
