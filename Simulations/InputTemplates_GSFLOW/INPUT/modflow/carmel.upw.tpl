ptf @
# Carmel starting K values
# ILPFCB    HDRY   NPLPF UPWHDRY
       0  -9999.       0       0 
1 1 1                                                                                     # LAYTYP
2 2 2                                                                                     # LAYAVG
1.0 1.0 1.0                                                                               # CHANI
1 1 1                                                                                     # LAYVKA
0 0 0                                                                                     # LAYWET
OPEN/CLOSE   .\INPUT\modflow\upw_support\Kh_lay_1.txt  @     Kh_lay_1@   (FREE)   -1      # HORIZONTAL HYDRAULIC CONDUCTIVITY FOR LAYER 1  (0.8)
CONSTANT     2.0                                                                          # Ratio of Kh/Kv = VKA VERTICAL HYDRAULIC CONDUCTIVITY FOR LAYER 1
CONSTANT     1.0e-6                                               1.00   (FREE)   -1      # Ss - Layer 1
OPEN/CLOSE   .\INPUT\modflow\upw_support\SY_lay_1.txt             1.00   (FREE)   -1      # SY - Layer 1
OPEN/CLOSE   .\INPUT\modflow\upw_support\Kh_lay_2.txt             1.00   (FREE)   -1      # HORIZONTAL HYDRAULIC CONDUCTIVITY FOR LAYER 2  (5.0e-3)
CONSTANT     3.0                                                                          # Ratio of Kh/Kv = VKA VERTICAL HYDRAULIC CONDUCTIVITY FOR LAYER 2
CONSTANT     1.0e-6                                               1.00   (FREE)   -1      # Ss - Layer 2
OPEN/CLOSE   .\INPUT\modflow\upw_support\SY_lay_2.txt             1.00   (FREE)   -1      # SY - Layer 2
OPEN/CLOSE   .\INPUT\modflow\upw_support\Kh_lay_3.txt             1.00   (FREE)   -1      # HORIZONTAL HYDRAULIC CONDUCTIVITY FOR LAYER 3  (1.0e-3)
CONSTANT     1.0                                                                          # Ratio of Kh/Kv = VKA VERTICAL HYDRAULIC CONDUCTIVITY FOR LAYER 3
CONSTANT     1.0e-6                                                                       # SS - Layer 3
CONSTANT     0.005                                                                        # SY - Layer 3
 