Brief Regimen Notation
=======================

Use a structured, short notation as a canonical DSL to describe a regimen.  The notation should be fully useful on it's face, and instantly recognizable.

In general:

    [ regimen meta information ]

    Course [ name or number ]:
    [ drugs with base dose, route and days, one per line ]
    [ cycle length ] x [ number of cycles ]

For a full description of each section, see below.

Here is an example.  From http://chemoregimen.com/Lymphoma-c-44-55.html, BEACOPP might be expressed as:

    Name: BEACOPP
    NCI-Code: C11638

    Course: BEACOPP
    Bleomycin 10.0 IU/m^2 iv d8
    Etoposide 100.0 mg/m^2 iv d1-3
    Doxorubicin 25.0 mg/m^2 iv d1
    Cyclophosphamide 650.0 mg/m^2 iv d1
    Vincristine 1.4 mg/m^2 iv d8
    Procarbazine 100.0 mg/m^2 po qd d1-7
    Prednisone 40.0 mg/m^2 po qd d1-7
    Q21d x 4 cycles

    Course: Course 2
    Etoposide 100.0 mg/m^2 iv d1-3
    Q21d


Sections
--------

Meta data occurs once per regimen specification. A regimen can have one or more course.  The courses many have one or more drug and one cycle length.

### Meta Data

The first section is the meta-data for the regimen.  It's optional, but useful.  The items should be in a key-value list.  This is where the name, NCI code and other information could be placed.

### Course

    Course: [string or number identifying course]

### Drugs
    
    [ drug name ] [base dose] [base dose unit] [route] [route info]? [time info]? [days] [in cycles]?

    Bleomycin 10.0 IU/m^2 iv d8-10
    Bleomycin 10.0 IU/m^2 iv push 30-60 mins d8-10 in cycles 2-4

### Cycle Length
    
    Q[length] [num-cycles] cycles?

Length can be [0-9]*d or [0-9]*w.  Number of cycles is optional.

Examples:

    Q21d              : 21 day cycle length
    Q4w               : 4 week cycle length
    Q14d x 4 cycles   : 4 cycles of 14 days each in length


AST
---


Regimen Object
--------------


    @regimen.meta.name
    @regimen.meta.nci-code


    @regimen.courses.first.drugs
    @regimen.courses.first.drugs.first.base_dose
    @regimen.courses.first.drugs.first.base_dose_with_unit

    @regimen.courses.first.treatment_plan --

      {
        :d1 => [
            { :drug => 'drug 1',
              :base_dose => '10.0',
              :base_dose_unit => 'mg/m^2',
              ..etc..
            },
            { .. }
          ],
        :d5 => [

        ]
      }


License
-------

Copyright (C) 2012 Vermonster LLC
http://www.opensource.org/licenses/MIT
