import os
import pandas as pd

f = open(os.path.join(r'D:\EDM_LT\GitHub\Carmel\PEST','Pilot_Point_List_For_Regul.csv'), 'r')
f.close()

df = pd.read_csv(os.path.join(r'D:\EDM_LT\GitHub\Carmel\PEST','Pilot_Point_List_For_Regul.csv'))

# Work on layer 1 regularization 
L1_Zn1 = []

# Column Names
# 0)  FID_hru_pa
# 1)  ORIG_FID
# 2)  HRU_ID
# 3)  HRUTYPE_IN
# 4)  HRU_ROW
# 5)  HRU_COL
# 6)  HRU_X
# 7)  HRU_Y
# 8)  X
# 9)  Y
# 10) Unique_ID
# 11) Lay1_Zn
# 12) Lay2_Zn
# 13) Lay3_Zn

zn1 = df.loc[df['Lay1_Zn'] == 1]
zn1 = zn1.sort_values('Unique_ID')

for index, row in zn1.iterrows():
    temp_tab = zn1.copy()
    val = int(row['Unique_ID'])
    temp_tab_m1 = temp_tab.loc[temp_tab['Unique_ID'] > val]
    
    # First, fill a column with all the distances from the current point
    dist = ((row['X'] - temp_tab_m1['X'])**2 + (row['Y'] - temp_tab_m1['Y'])**2)**0.5
    temp_tab_m1['Euc_Dist'] = dist
    
    temp_tab_m2 = temp_tab_m1.sort_values('Euc_Dist')
    
    # Set up a relationship between the 4 closest points to the current point.
    how_many = min(4, len(temp_tab_m2))
    for i in range(how_many):
        tmp = temp_tab_m2.iloc[i]
        if tmp['Unique_ID'] > val:
            L1_Zn1.append((val, tmp['Unique_ID'], tmp['Euc_Dist']))

# Once the for loop completes, write the list to a text file
f = open('pilot_point_relationships_L1_Z1.txt', 'w')
f.write('    ppt1     ppt2         dist\n')
for i in range(len(L1_Zn1)):
    f.write("{0:8d} {1:8d}   {2:10.2f}\n".format(L1_Zn1[i][0], int(L1_Zn1[i][1]), L1_Zn1[i][2]))

f.close()

# ---------------------------------------
# Work on layer 2 regularization, zone 2
L2_Zn2 = []
zn2 = df.loc[df['Lay2_Zn'] == 2]
zn2 = zn2.sort_values('Unique_ID')

for index, row in zn2.iterrows():
    temp_tab = zn2.copy()
    val = int(row['Unique_ID'])
    temp_tab_m1 = temp_tab.loc[temp_tab['Unique_ID'] > val]

    # First, fill a column with all the distances from the current point
    dist = ((row['X'] - temp_tab_m1['X']) ** 2 + (row['Y'] - temp_tab_m1['Y']) ** 2) ** 0.5
    temp_tab_m1['Euc_Dist'] = dist

    temp_tab_m2 = temp_tab_m1.sort_values('Euc_Dist')

    # Set up a relationship between the 4 closest points to the current point.
    how_many = min(4, len(temp_tab_m2))
    for i in range(how_many):
        tmp = temp_tab_m2.iloc[i]
        if tmp['Unique_ID'] > val:
            L2_Zn2.append((val, tmp['Unique_ID'], tmp['Euc_Dist']))

# Once the for loop completes, write the list to a text file
f = open('pilot_point_relationships_L2_Z2.txt', 'w')
f.write('    ppt1     ppt2         dist\n')
for i in range(len(L2_Zn2)):
    f.write("{0:8d} {1:8d}   {2:10.2f}\n".format(L2_Zn2[i][0], int(L2_Zn2[i][1]), L2_Zn2[i][2]))

f.close()


# ---------------------------------------
# Work on layer 2 regularization, zone 3
L2_Zn3 = []
zn3 = df.loc[df['Lay2_Zn'] == 3]
zn3 = zn3.sort_values('Unique_ID')

for index, row in zn3.iterrows():
    temp_tab = zn3.copy()
    val = int(row['Unique_ID'])
    temp_tab_m1 = temp_tab.loc[temp_tab['Unique_ID'] > val]

    # First, fill a column with all the distances from the current point
    dist = ((row['X'] - temp_tab_m1['X']) ** 2 + (row['Y'] - temp_tab_m1['Y']) ** 2) ** 0.5
    temp_tab_m1['Euc_Dist'] = dist

    temp_tab_m2 = temp_tab_m1.sort_values('Euc_Dist')

    # Set up a relationship between the 4 closest points to the current point.
    how_many = min(4, len(temp_tab_m2))
    for i in range(how_many):
        tmp = temp_tab_m2.iloc[i]
        if tmp['Unique_ID'] > val:
            L2_Zn3.append((val, tmp['Unique_ID'], tmp['Euc_Dist']))

# Once the for loop completes, write the list to a text file
f = open('pilot_point_relationships_L2_Z3.txt', 'w')
f.write('    ppt1     ppt2         dist\n')
for i in range(len(L2_Zn3)):
    f.write("{0:8d} {1:8d}   {2:10.2f}\n".format(L2_Zn3[i][0], int(L2_Zn3[i][1]), L2_Zn3[i][2]))

f.close()

# ---------------------------------------
# Work on layer 2 regularization, zone 4
L2_Zn4 = []
zn4 = df.loc[df['Lay2_Zn'] == 4]
zn4 = zn4.sort_values('Unique_ID')

for index, row in zn4.iterrows():
    temp_tab = zn4.copy()
    val = int(row['Unique_ID'])
    temp_tab_m1 = temp_tab.loc[temp_tab['Unique_ID'] > val]

    # First, fill a column with all the distances from the current point
    dist = ((row['X'] - temp_tab_m1['X']) ** 2 + (row['Y'] - temp_tab_m1['Y']) ** 2) ** 0.5
    temp_tab_m1['Euc_Dist'] = dist

    temp_tab_m2 = temp_tab_m1.sort_values('Euc_Dist')

    # Set up a relationship between the 4 closest points to the current point.
    how_many = min(4, len(temp_tab_m2))
    for i in range(how_many):
        tmp = temp_tab_m2.iloc[i]
        if tmp['Unique_ID'] > val:
            L2_Zn4.append((val, tmp['Unique_ID'], tmp['Euc_Dist']))

# Once the for loop completes, write the list to a text file
f = open('pilot_point_relationships_L2_Z4.txt', 'w')
f.write('    ppt1     ppt2         dist\n')
for i in range(len(L2_Zn4)):
    f.write("{0:8d} {1:8d}   {2:10.2f}\n".format(L2_Zn4[i][0], int(L2_Zn4[i][1]), L2_Zn4[i][2]))

f.close()

# ---------------------------------------
# Work on layer 2 regularization, zone 5
L2_Zn5 = []
zn5 = df.loc[df['Lay2_Zn'] == 5]
zn5 = zn5.sort_values('Unique_ID')

for index, row in zn5.iterrows():
    temp_tab = zn5.copy()
    val = int(row['Unique_ID'])
    temp_tab_m1 = temp_tab.loc[temp_tab['Unique_ID'] > val]

    # First, fill a column with all the distances from the current point
    dist = ((row['X'] - temp_tab_m1['X']) ** 2 + (row['Y'] - temp_tab_m1['Y']) ** 2) ** 0.5
    temp_tab_m1['Euc_Dist'] = dist

    temp_tab_m2 = temp_tab_m1.sort_values('Euc_Dist')

    # Set up a relationship between the 4 closest points to the current point.
    how_many = min(4, len(temp_tab_m2))
    for i in range(how_many):
        tmp = temp_tab_m2.iloc[i]
        if tmp['Unique_ID'] > val:
            L2_Zn5.append((val, tmp['Unique_ID'], tmp['Euc_Dist']))

# Once the for loop completes, write the list to a text file
f = open('pilot_point_relationships_L2_Z5.txt', 'w')
f.write('    ppt1     ppt2         dist\n')
for i in range(len(L2_Zn5)):
    f.write("{0:8d} {1:8d}   {2:10.2f}\n".format(L2_Zn5[i][0], int(L2_Zn5[i][1]), L2_Zn5[i][2]))

f.close()

# ---------------------------------------
# Work on layer 2 regularization, zone 6
L2_Zn6 = []
zn6 = df.loc[df['Lay2_Zn'] == 6]
zn6 = zn6.sort_values('Unique_ID')

for index, row in zn6.iterrows():
    temp_tab = zn6.copy()
    val = int(row['Unique_ID'])
    temp_tab_m1 = temp_tab.loc[temp_tab['Unique_ID'] > val]

    # First, fill a column with all the distances from the current point
    dist = ((row['X'] - temp_tab_m1['X']) ** 2 + (row['Y'] - temp_tab_m1['Y']) ** 2) ** 0.5
    temp_tab_m1['Euc_Dist'] = dist

    temp_tab_m2 = temp_tab_m1.sort_values('Euc_Dist')

    # Set up a relationship between the 4 closest points to the current point.
    how_many = min(4, len(temp_tab_m2))
    for i in range(how_many):
        tmp = temp_tab_m2.iloc[i]
        if tmp['Unique_ID'] > val:
            L2_Zn6.append((val, tmp['Unique_ID'], tmp['Euc_Dist']))

# Once the for loop completes, write the list to a text file
f = open('pilot_point_relationships_L2_Z6.txt', 'w')
f.write('    ppt1     ppt2         dist\n')
for i in range(len(L2_Zn6)):
    f.write("{0:8d} {1:8d}   {2:10.2f}\n".format(L2_Zn6[i][0], int(L2_Zn6[i][1]), L2_Zn6[i][2]))

f.close()

# ---------------------------------------
# Work on layer 2 regularization, zone 7
L2_Zn7 = []
zn7 = df.loc[df['Lay2_Zn'] == 7]
zn7 = zn7.sort_values('Unique_ID')

for index, row in zn7.iterrows():
    temp_tab = zn7.copy()
    val = int(row['Unique_ID'])
    temp_tab_m1 = temp_tab.loc[temp_tab['Unique_ID'] > val]

    # First, fill a column with all the distances from the current point
    dist = ((row['X'] - temp_tab_m1['X']) ** 2 + (row['Y'] - temp_tab_m1['Y']) ** 2) ** 0.5
    temp_tab_m1['Euc_Dist'] = dist

    temp_tab_m2 = temp_tab_m1.sort_values('Euc_Dist')

    # Set up a relationship between the 4 closest points to the current point.
    how_many = min(4, len(temp_tab_m2))
    for i in range(how_many):
        tmp = temp_tab_m2.iloc[i]
        if tmp['Unique_ID'] > val:
            L2_Zn7.append((val, tmp['Unique_ID'], tmp['Euc_Dist']))

# Once the for loop completes, write the list to a text file
f = open('pilot_point_relationships_L2_Z7.txt', 'w')
f.write('    ppt1     ppt2         dist\n')
for i in range(len(L2_Zn7)):
    f.write("{0:8d} {1:8d}   {2:10.2f}\n".format(L2_Zn7[i][0], int(L2_Zn7[i][1]), L2_Zn7[i][2]))

f.close()


# ---------------------------------------
# Work on layer 2 regularization, zone 8
L2_Zn8 = []
zn8 = df.loc[df['Lay2_Zn'] == 8]
zn8 = zn8.sort_values('Unique_ID')

for index, row in zn8.iterrows():
    temp_tab = zn8.copy()
    val = int(row['Unique_ID'])
    temp_tab_m1 = temp_tab.loc[temp_tab['Unique_ID'] > val]

    # First, fill a column with all the distances from the current point
    dist = ((row['X'] - temp_tab_m1['X']) ** 2 + (row['Y'] - temp_tab_m1['Y']) ** 2) ** 0.5
    temp_tab_m1['Euc_Dist'] = dist

    temp_tab_m2 = temp_tab_m1.sort_values('Euc_Dist')

    # Set up a relationship between the 4 closest points to the current point.
    how_many = min(4, len(temp_tab_m2))
    for i in range(how_many):
        tmp = temp_tab_m2.iloc[i]
        if tmp['Unique_ID'] > val:
            L2_Zn8.append((val, tmp['Unique_ID'], tmp['Euc_Dist']))

# Once the for loop completes, write the list to a text file
f = open('pilot_point_relationships_L2_Z8.txt', 'w')
f.write('    ppt1     ppt2         dist\n')
for i in range(len(L2_Zn8)):
    f.write("{0:8d} {1:8d}   {2:10.2f}\n".format(L2_Zn8[i][0], int(L2_Zn8[i][1]), L2_Zn8[i][2]))

f.close()

# ---------------------------------------
# Work on layer 2 regularization, zone 9
L2_Zn9 = []
zn9 = df.loc[df['Lay2_Zn'] == 9]
zn9 = zn9.sort_values('Unique_ID')

for index, row in zn9.iterrows():
    temp_tab = zn9.copy()
    val = int(row['Unique_ID'])
    temp_tab_m1 = temp_tab.loc[temp_tab['Unique_ID'] > val]

    # First, fill a column with all the distances from the current point
    dist = ((row['X'] - temp_tab_m1['X']) ** 2 + (row['Y'] - temp_tab_m1['Y']) ** 2) ** 0.5
    temp_tab_m1['Euc_Dist'] = dist

    temp_tab_m2 = temp_tab_m1.sort_values('Euc_Dist')

    # Set up a relationship between the 4 closest points to the current point.
    how_many = min(4, len(temp_tab_m2))
    for i in range(how_many):
        tmp = temp_tab_m2.iloc[i]
        if tmp['Unique_ID'] > val:
            L2_Zn9.append((val, tmp['Unique_ID'], tmp['Euc_Dist']))

# Once the for loop completes, write the list to a text file
f = open('pilot_point_relationships_L2_Z9.txt', 'w')
f.write('    ppt1     ppt2         dist\n')
for i in range(len(L2_Zn9)):
    f.write("{0:8d} {1:8d}   {2:10.2f}\n".format(L2_Zn9[i][0], int(L2_Zn9[i][1]), L2_Zn9[i][2]))

f.close()

# ---------------------------------------
# Work on layer 3 regularization, zone 10
L3_Zn10 = []
zn10 = df.loc[df['Lay3_Zn'] == 10]
zn10 = zn10.sort_values('Unique_ID')

for index, row in zn10.iterrows():
    temp_tab = zn10.copy()
    val = int(row['Unique_ID'])
    temp_tab_m1 = temp_tab.loc[temp_tab['Unique_ID'] > val]

    # First, fill a column with all the distances from the current point
    dist = ((row['X'] - temp_tab_m1['X']) ** 2 + (row['Y'] - temp_tab_m1['Y']) ** 2) ** 0.5
    temp_tab_m1['Euc_Dist'] = dist

    temp_tab_m2 = temp_tab_m1.sort_values('Euc_Dist')

    # Set up a relationship between the 4 closest points to the current point.
    how_many = min(4, len(temp_tab_m2))
    for i in range(how_many):
        tmp = temp_tab_m2.iloc[i]
        if tmp['Unique_ID'] > val:
            L3_Zn10.append((val, tmp['Unique_ID'], tmp['Euc_Dist']))

# Once the for loop completes, write the list to a text file
f = open('pilot_point_relationships_L3_Z10.txt', 'w')
f.write('    ppt1     ppt2         dist\n')
for i in range(len(L3_Zn10)):
    f.write("{0:8d} {1:8d}   {2:10.2f}\n".format(L3_Zn10[i][0], int(L3_Zn10[i][1]), L3_Zn10[i][2]))

f.close()

# Write all regularization relationships
# --------------------------------------
f = open('pilot_point_relationships_all.txt', 'w')
ct = 1
for i in range(len(L1_Zn1)):
    wt = 500.**2/float(L1_Zn1[i][2])**2
    f.write("{0:8d} 1.0 * log(pp_{1}_l1) - 1.0 * log(pp_{2}_l1) = 0.00   {3:10.6f}   regul_l1_zn1\n".format(ct, L1_Zn1[i][0], int(L1_Zn1[i][1]), wt))
    ct += 1

for i in range(len(L2_Zn2)):
    wt = 500**2/float(L2_Zn2[i][2])**2
    f.write("{0:8d} 1.0 * log(pp_{1}_l2) - 1.0 * log(pp_{2}_l2) = 0.00   {3:10.6f}   regul_l2_zn2\n".format(ct, L2_Zn2[i][0], int(L2_Zn2[i][1]), wt))
    ct += 1

for i in range(len(L2_Zn3)):
    wt = 500**2/float(L2_Zn3[i][2])**2
    f.write("{0:8d} 1.0 * log(pp_{1}_l2) - 1.0 * log(pp_{2}_l2) = 0.00   {3:10.6f}   regul_l2_zn3\n".format(ct, L2_Zn3[i][0], int(L2_Zn3[i][1]), wt))
    ct += 1

for i in range(len(L2_Zn4)):
    wt = 500**2/float(L2_Zn4[i][2])**2
    f.write("{0:8d} 1.0 * log(pp_{1}_l2) - 1.0 * log(pp_{2}_l2) = 0.00   {3:10.6f}   regul_l2_zn4\n".format(ct, L2_Zn4[i][0], int(L2_Zn4[i][1]), wt))
    ct += 1

for i in range(len(L2_Zn5)):
    wt = 500**2/float(L2_Zn5[i][2])**2
    f.write("{0:8d} 1.0 * log(pp_{1}_l2) - 1.0 * log(pp_{2}_l2) = 0.00   {3:10.6f}   regul_l2_zn5\n".format(ct, L2_Zn5[i][0], int(L2_Zn5[i][1]), wt))
    ct += 1

for i in range(len(L2_Zn6)):
    wt = 500**2/float(L2_Zn6[i][2])**2
    f.write("{0:8d} 1.0 * log(pp_{1}_l2) - 1.0 * log(pp_{2}_l2) = 0.00   {3:10.6f}   regul_l2_zn6\n".format(ct, L2_Zn6[i][0], int(L2_Zn6[i][1]), wt))
    ct += 1

for i in range(len(L2_Zn7)):
    wt = 500**2/float(L2_Zn7[i][2])**2
    f.write("{0:8d} 1.0 * log(pp_{1}_l2) - 1.0 * log(pp_{2}_l2) = 0.00   {3:10.6f}   regul_l2_zn7\n".format(ct, L2_Zn7[i][0], int(L2_Zn7[i][1]), wt))
    ct += 1

for i in range(len(L2_Zn8)):
    wt = 500**2/float(L2_Zn8[i][2])**2
    f.write("{0:8d} 1.0 * log(pp_{1}_l2) - 1.0 * log(pp_{2}_l2) = 0.00   {3:10.6f}   regul_l2_zn8\n".format(ct, L2_Zn8[i][0], int(L2_Zn8[i][1]), wt))
    ct += 1

for i in range(len(L2_Zn9)):
    wt = 500**2/float(L2_Zn9[i][2])**2
    f.write("{0:8d} 1.0 * log(pp_{1}_l2) - 1.0 * log(pp_{2}_l2) = 0.00   {3:10.6f}   regul_l2_zn9\n".format(ct, L2_Zn9[i][0], int(L2_Zn9[i][1]), wt))
    ct += 1

for i in range(len(L3_Zn10)):
    wt = 500**2/float(L3_Zn10[i][2])**2
    f.write("{0:8d} 1.0 * log(pp_{1}_l3) - 1.0 * log(pp_{2}_l3) = 0.00   {3:10.6f}   regul_l3_z10\n".format(ct, L3_Zn10[i][0], int(L3_Zn10[i][1]), wt))
    ct += 1

f.close()
