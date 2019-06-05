ptf @
# Carmel Simulation -- GSFLOW
# NUZTOP IUZFOPT IRUNFLG IETFLG IUZFCB1 IUZFCB2 NTRAIL NSETS NUZGAGES SURFDEP
OPTIONS
 SPECIFYTHTI
 SPECIFYSURFK
 SEEPSURFK
END
       2       1       1      1       0      0       7    80        0     3.0
OPEN/CLOSE .\input\modflow\uzf_support\iuzfbnd.txt                1 (free)    6     # UZFBND
OPEN/CLOSE .\input\modflow\uzf_support\irunbnd.txt                1 (free)    6     # IRUNBND 
OPEN/CLOSE .\input\modflow\uzf_support\vks.txt      @     vks_mult@ (free)    0     # VKS         # Transient for Martis is 4.0           
OPEN/CLOSE .\input\modflow\uzf_support\surfk.txt    @    srfk_mult@ (free)    0     # SURFK       # 0.1*VKS           
CONSTANT   4.0                                                                      # BROOKS/COREY EPSILON (EPS)
CONSTANT   0.35                                                                     # SATURATED WATER CONTENT (THTS)
OPEN/CLOSE .\input\modflow\uzf_support\thti.txt                1 (free)       6     # INITIAL WATER CONTENT (THTI)
1                                                                                   # NUZF1
OPEN/CLOSE .\INPUT\modflow\uzf_support\finf_1.txt   @         finf@ (free)    0     # INFILTRATION AT TOP OF LAYER 1 (FINF) STRESS PERIOD 1
1                                                                                   # NUZF2
OPEN/CLOSE .\INPUT\modflow\uzf_support\pET.txt      @          pET@ (free)    0     # PET FOR STRESS PERIOD 1   # orig is 0.003556020
1                                                                                   # NUZF3
OPEN/CLOSE .\INPUT\modflow\uzf_support\extdp_1.txt  @        extdp@ (free)    0     # EXTDP FOR STRESS PERIOD 1
1                                                                                   # NUZF4
CONSTANT   0.35                                                                     # EXTWC FOR STRESS PERIOD 1
-1
-1
-1
-1
-1
-1
-1
-1


CONSTANT   0.01                                                                     # SATURATED WATER CONTENT (THTR)
