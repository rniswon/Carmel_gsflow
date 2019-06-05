import numpy as np
import os

arr = np.ones((328, 406))
arr_Kh1 = arr * 0.8
arr_Kv1 = arr * 0.4
arr_Kh2 = arr * 5e-3
arr_Kv2 = arr * 5e-3
arr_Kh3 = arr * 1e-4
arr_Kv3 = arr * 1e-4

f = open('Kh_lay_1.txt','w')
np.savetxt(f, arr_Kh1, fmt='%15.8e')
f.close()

f = open('Kv_lay_1.txt','w')
np.savetxt(f, arr_Kv1, fmt='%15.8e')
f.close()

f = open('Kh_lay_2.txt','w')
np.savetxt(f, arr_Kh2, fmt='%15.8e')
f.close()

f = open('Kv_lay_2.txt','w')
np.savetxt(f, arr_Kv2, fmt='%15.8e')
f.close()

f = open('Kh_lay_3.txt','w')
np.savetxt(f, arr_Kh3, fmt='%15.8e')
f.close()

f = open('Kv_lay_3.txt','w')
np.savetxt(f, arr_Kv3, fmt='%15.8e')
f.close()

