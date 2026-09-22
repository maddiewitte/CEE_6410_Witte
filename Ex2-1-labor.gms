$ontext
CEE 6410 - Engineering Systems Analysis
Example 2.1 from Bishop Et Al Text (https://digitalcommons.usu.edu/ecstatic_all/76/)
Modifies Example to add a labor constraint

THE PROBLEM:

A cr manufacturer makes coups and vans. The data are as follows:

Yearly Resource
Inputs or Profit        Car Make        Resource
Availability
                     Coups               Minivans
Metal                1,000 lbs/car       2,000 lbs/car      4,000,000 lbs/year
Circuit Boards       4 boards/car        3 boards/car       12,000 boards/year
Labor                5 days/car          2.5 days/car       17,500 days/year
Profit/car          $6,000 /car         $7,000 /car

                Determine the optimal manufacturing plan.

THE SOLUTION:
Uses General Algebraic Modeling System to Solve this Linear Program

Maddie Witte
maddie.witte@usu.edu
September 21, 2026
$offtext

* 1. DEFINE the SETS
SETS car cars making /Coup, Minivan/
     res resources /Metal, Circuit_Boards, Labor/;

* 2. DEFINE input data
PARAMETERS
   c(car) Objective function coefficients ($ per car)
         /Coup 6000,
        Minivan 7000 /

   b(res) Right hand constraint values (per resource)
          /Metal 4000000,
           Circuit_Boards  12000,
           Labor  17500/;

TABLE A(car,res) Left hand side constraint coefficients
                 Metal     Circuit_Boards   Labor
 Coup            1000      4                5
 Minivan         2000      3                2.5;


* 3. DEFINE the variables
VARIABLES X(car) cars produced (Number)
          VPROFIT  total profit ($);

* Non-negativity constraints
POSITIVE VARIABLES X;

* 4. COMBINE variables and data in equations
EQUATIONS
   PROFIT Total profit ($) and objective function value
   RES_CONSTRAIN(res) Resource Constraints;

PROFIT..                 VPROFIT =E= SUM(car, c(car)*X(car));
RES_CONSTRAIN(res) ..    SUM(car, A(car,res)*X(car)) =L= b(res);


* 5. DEFINE the MODEL from the EQUATIONS
MODEL MAKING /PROFIT, RES_CONSTRAIN/;
*Altnerative way to write (include all previously defined equations)
*MODEL MAKING /ALL/;


* 6. SOLVE the MODEL
* Solve the MAKING model using a Linear Programming Solver (see File=>Options=>Solvers)
*     to maximize VPROFIT
SOLVE MAKING USING LP MAXIMIZING VPROFIT;


* 6. CLick File menu => RUN (F9) or Solve icon and examine solution report in .LST file
