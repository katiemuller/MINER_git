ptf !
### PFLOTRAN Input Deck for DI Dissolution Experiments
    #=========================== simulation ================================
SIMULATION
  SIMULATION_TYPE SUBSURFACE
  PROCESS_MODELS
    SUBSURFACE_TRANSPORT transport
      MODE GIRT
    /
  /
END

SUBSURFACE

EOS WATER
  DENSITY CONSTANT 1000
/

#=========================== numerical methods ================================
NUMERICAL_METHODS TRANSPORT
  NEWTON_SOLVER
    NUMERICAL_JACOBIAN
  /

  LINEAR_SOLVER
    SOLVER DIRECT
  /
END

#=========================== regression =======================================
REGRESSION
  CELL_IDS
    1
  /
END

#=========================== flow mode ========================================
# Uniform velocity (see below). No flow mode specified.

#=========================== useful tranport parameters ==================
SPECIFIED_VELOCITY
  UNIFORM? YES
  DATASET 0.d0 0.d0 0.d0 m/yr
END

#=========================== dataset  ===============================
DBASE_FILENAME /home/mull128/projects/MINER/dissolution_exps/analysis/MINER_Diss_EDTA/output-Diss_EDTA/pflotran_inout/parameter.h5

#=========================== chemistry ========================================
CHEMISTRY
  PRIMARY_SPECIES
    Ni++
    Fe++
    Mn++
    Mg++
    Ca++
    H+
    SiO2(aq)
    CrO4--
    O2(aq)
    NO3-
    K+
    H2Phth-
    HCO3-
    Al+++
  /      
  SECONDARY_SPECIES
    OH-
    Cr+++
    # Buffer Phth
    HPhth--
    Phth---
    # Ca
    CaNO3+
    CaOH+
    # Fe
    Fe+++
    FeOH+
    Fe(OH)3-
    Fe(OH)4--
    Fe(OH)2+
    FeOH++
    FeNO3++
    Fe(OH)4-
    Fe(OH)2(aq)
    Fe(OH)3(aq)
    #K 
    KOH(aq)
    # Mg
    MgCO3(aq)
    # Mn
    MnOH+
    Mn2(OH)3+
    Mn(OH)2(aq)
    Mn(OH)3-
    Mn2OH+++
    Mn(OH)4--
    Mn+++
    MnO4--
    # N
    NO2-
    HNO3(aq)
    NH3(aq)
    # Ni
    Ni(OH)2(aq)
    Ni(OH)3-
    Ni2OH+++
    # Si
    HSiO3-
    H6(H2SiO4)4--
    H4(H2SiO4)4----
    H2SiO4--
  /
  PASSIVE_GAS_SPECIES
    O2(g)
  /
  MINERALS
    Forsterite
    Fayalite
    Ni2SiO4
    Tephroite
    Wollastonite
    Enstatite
    Chrysotile
    Fe(OH)2
    Fe(OH)3
    FeO
    Magnesite
    Clinochlore-14A
  /

  MINERAL_KINETICS
        Forsterite
            PREFACTOR
            RATE_CONSTANT !forsterite_rate_constant      ! mol/cm^2-sec #Acid-Mechanism
            ACTIVATION_ENERGY 67.2d0
            PREFACTOR_SPECIES H+
              ALPHA 0.47d0
            /
            /
            PREFACTOR
            RATE_CONSTANT 8.77e-13 mol/cm^2-sec 
            ACTIVATION_ENERGY 79.0d0
            /
        /
        Fayalite
            PREFACTOR
            RATE_CONSTANT !fayalite_rate_constant       ! mol/cm^2-sec #Acid-Mechanism
            ACTIVATION_ENERGY 94.4d0
            /
            PREFACTOR
            RATE_CONSTANT 1.58e-21 mol/cm^2-sec #Neutral-Mechanism
            ACTIVATION_ENERGY 94.4d0
            /
        /
        Ni2SiO4 #Liebenbergite
            PREFACTOR
            RATE_CONSTANT !Ni2SiO4_rate_constant       ! mol/cm^2-sec #No rates available- Acid-Mechanism using P&K parameters for Forsterite
            ACTIVATION_ENERGY 67.2d0
            PREFACTOR_SPECIES H+
              ALPHA 0.47d0
            /
            /
            PREFACTOR
            RATE_CONSTANT 3.6e-19 mol/cm^2-sec #No rates available- Neutral-Mechanism from Palandri and Kharaka, 2004 for Forsterite
            ACTIVATION_ENERGY 79.0d0
            /
        /    
        Tephroite
            PREFACTOR
            RATE_CONSTANT !tephroite_rate_constant       ! mol/cm^2-sec #Acid-Mechanism using P&K parameters
            ACTIVATION_ENERGY 67.2d0
            PREFACTOR_SPECIES H+
              ALPHA 0.47d0
            /
            /
            PREFACTOR
            RATE_CONSTANT 2.99e-19 mol/cm^2-sec #Neutral-Mechanism using P&K parameters
            ACTIVATION_ENERGY 79.d0
            /
        /     
        Wollastonite
            PREFACTOR
            RATE_CONSTANT !wollastonite_rate_constant       ! mol/cm^2-sec #Acid-Mechanism from Palandri and Kharaka, 2004
            ACTIVATION_ENERGY 54.7d0
            PREFACTOR_SPECIES H+
              ALPHA 0.4d0
            /
            /
            PREFACTOR
            RATE_CONSTANT 1.63e-14 mol/cm^2-sec #Neutral-Mechanism from Palandri and Kharaka, 2004
            ACTIVATION_ENERGY 54.7d0
            /
        /      
        Enstatite
            PREFACTOR
            RATE_CONSTANT !enstatite_rate_constant       ! mol/cm^2-sec #Acid-Mechanism from Palandri and Kharaka, 2004
            ACTIVATION_ENERGY 80.d0
            PREFACTOR_SPECIES H+
              ALPHA 0.6d0
            /
            /
            PREFACTOR
            RATE_CONSTANT 1.91e-17 mol/cm^2-sec #Neutral-Mechanism from Palandri and Kharaka, 2004
            ACTIVATION_ENERGY 80.d0
            /
        /  
        Chrysotile
            PREFACTOR
            RATE_CONSTANT !chrysotile_rate_constant       ! mol/cm^2-sec #Neutral-Mechanism from Palandri and Kharaka, 2004
            ACTIVATION_ENERGY 73.5d0
            /
            PREFACTOR
            RATE_CONSTANT 2.63e-18 mol/cm^2-sec #Base-Mechanism from Palandri and Kharaka, 2004
            ACTIVATION_ENERGY 73.5d0
            PREFACTOR_SPECIES H+
              ALPHA -0.23d0
            /
            /
        /
  /
  DATABASE /home/mull128/projects/MINER/dissolution_exps/data/Database/hanfordv2.dat

  LOG_FORMULATION
  ACTIVITY_COEFFICIENTS OFF
  OUTPUT
    TOTAL
    ALL
    SECONDARY_SPECIES
    pH
  /
END

GRID
  TYPE STRUCTURED
  NXYZ 1 1 1
  BOUNDS
    0.d0 0.d0 0.d0
    5.5d-2 5.5d-2 5.5d-2
  /
END

    #=========================== fluid properties =================================
FLUID_PROPERTY
  DIFFUSION_COEFFICIENT 1.d-9
END

    #=========================== material properties ==============================
MATERIAL_PROPERTY soil1
  ID 1
  POROSITY 0.09d0
  TORTUOSITY 1.d0
  ROCK_DENSITY 1490.d0 #kg/m3
END

    #=========================== output options ===================================
OUTPUT
TIMES hr 0.0 2.0 4.0 \ 
 6.0 8.0 24.0 
  PERIODIC_OBSERVATION TIMESTEP 1
END

TIME
  FINAL_TIME 24.d0 hr             
  INITIAL_TIMESTEP_SIZE 1.d0 s
  MAXIMUM_TIMESTEP_SIZE 5.d0 hr
END

            #=========================== regions ==========================================
REGION all
  COORDINATES
    -1.d20 -1.d20 -1.d20
    1.d20 1.d20 1.d20
  /
END

REGION pt
  COORDINATE 0.027d0 0.027d0 0.027d0
END

#=========================== constraints ======================================
CONSTRAINT initial
  CONCENTRATIONS
    Ni++ 1e-20 T
    Fe++ 1e-20 T
    Mn++ 1e-20 T
    Mg++ 1.104907475828019e-05 T
    Ca++ 8.676277070858284e-06 T    
    H+ 4 P
    SiO2(aq) 1e-2 T
    CrO4-- 1e-20 T
    O2(aq) 1e-4 T
    NO3- 0.0001 T
    H2Phth- 0.05 T
    K+ 0.05 T
    HCO3- 1e-20 T
    Al+++ 1e-20 T
  / 
  MINERALS
    Forsterite 0.83791 1
    Fayalite 0.075251 1
    Ni2SiO4 0.003652 1
    Tephroite 0.000913 1
    Wollastonite 0.001156 1
    Enstatite 0.063452 1
    Chrysotile 0.02 1
  /
END

INITIAL_CONDITION
  TRANSPORT_CONDITION initial
  REGION all
END

OBSERVATION
  REGION pt
END

TRANSPORT_CONDITION initial
  TYPE ZERO_GRADIENT
  CONSTRAINT_LIST
    0.d0 initial
  /
END

STRATA
  REGION all
  MATERIAL soil1
END

END_SUBSURFACE