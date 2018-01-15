#--------------------------------
# Name:         hed_to_raster_20140825.py
# Purpose:      Convert groundwater *.HED output file to IMG rasters
# Author:       Charles Morton
# Created       2014-08-25
# Copyright:    (c) DRI
# Python:       2.6
#--------------------------------

import datetime as dt
import logging
import os
import re
##import struct
from StringIO import StringIO
import sys

import numpy as np

import arcpy
from arcpy import env
from arcpy.sa import *

################################################################################

def hed_to_raster(workspace):
    try:
        #### Input parameters
        hed_name = 'Carmel.hed'
        hed_input_nodata = '-999.0'
        hed_output_nodata = '-999.0'
        elev_name = 'dem_adj_debug.txt'
        max_layers = 3
        save_temp_ascii_file = True

        output_spatref = None
        ##output_spatref = arcpy.SpatialReference("NAD 1983 UTM Zone 11N")
        ##output_spatref = arcpy.SpatialReference("WGS 1984 UTM Zone 11N")
        ##output_spatref = arcpy.SpatialReference("32610")
 
        #### Build file paths
        hed_path = os.path.join(workspace, hed_name)
        elev_ascii = os.path.join(workspace, elev_name)

        #### Check that file paths are valid
        if not os.path.isfile(hed_path):
            logging.error("\nERROR: The HED file does not exist")
            raise SystemExit()
        elif not os.path.isfile(elev_ascii):
            logging.error("\nERROR: The ELEVATION file does not exist")
            raise SystemExit()
        
        #### Set ArcGIS environment variables
        arcpy.CheckOutExtension("Spatial")
        env.workspace = workspace
        env.overwriteOutput = True
        env.pyramid = "NONE"
        ##env.rasterStatistics = "NONE"
        env.extent = "MINOF"

        #### Read elevation file to get header block
        logging.info('\nGetting header block from elevation file')
        with open(elev_ascii) as elev_f:
            elev_list = elev_f.readlines()
        elev_header = elev_list[:6]
        elev_cols = int(re.sub("\D", "", elev_header[0]))
        elev_rows = int(re.sub("\D", "", elev_header[1]))

        #### Print the header
        for elev_line in elev_header:
            logging.info('  {0}'.format(elev_line.strip()))

        #### Read HED file
        logging.info('\nReading HED output file')
        with open(hed_path) as hed_f:
            hed_list = hed_f.readlines()

        #### Get HED header rows by looking for HEAD # # (Rows/Cols)
        hed_header_re = re.compile(
            'HEAD\s*({0})\s*({1})'.format(elev_cols, elev_rows))
        hed_breaks = [n for n, hed_line in enumerate(hed_list)
                      if hed_header_re.search(hed_line)]
        #### Add one more "break" at end of file
        hed_breaks.append(len(hed_list))
        #### Get HED header rows based on number of rows & len(hed_list)
        ##hed_breaks = range(0, len(hed_list)-elev_rows, elev_rows)
        logging.debug('  HED header lines indices: {0}'.format(hed_breaks))

        #### Updated HED nodata value
        hed_header = elev_header[:]
        hed_header[5] = 'NODATA_VALUE {0}\n'.format(hed_output_nodata)

        #### Convert elevation ASCII to raster
        elev_raster = os.path.join(
            workspace, '{0}.img'.format(os.path.splitext(elev_name)[0]))
        arcpy.ASCIIToRaster_conversion(
            elev_ascii, elev_raster, "FLOAT")
        elev_obj = Raster(elev_raster)

        #### Break HED layers based on rows 
        logging.info('\nBuilding output rasters')
        for n, head_i in enumerate(hed_breaks[:-1]):
            if n >= max_layers:
                break
            logging.info('  Layer: {0}'.format(n+1))
            head_list = hed_list[head_i:hed_breaks[n+1]]
            print head_list[0]

            #### Flatten data then read into numpy array
            head_str = ''.join([item.rstrip('\n') for item in head_list[1:]])
            head_data = np.genfromtxt(
                StringIO(head_str), dtype="|S9", autostrip=True)
            head_data = head_data.reshape((elev_rows, elev_cols))

            #### Change nodata value
            head_data[head_data == hed_input_nodata] = hed_output_nodata

            #### Write each layer to ascii file
            head_ascii = os.path.join(workspace, 'head_{0}_ascii.asc'.format(n+1))
            with open(head_ascii, 'w') as head_f:
                #### Write elev header block
                for header_line in hed_header:
                    head_f.write(header_line)
                #### Write grid data, skip first line of grid data (header line)
                for data_line in head_data:
                    head_f.write(' '.join([
                        '{0:>9s}'.format(item) for item in data_line]) + '\n')
            head_f.close()

            #### Save head ascii to raster
            head_raster = os.path.join(workspace, 'head_{0}.img'.format(n+1))
            arcpy.ASCIIToRaster_conversion(
                head_ascii, head_raster, "FLOAT")
            if output_spatref is not None:
                arcpy.DefineProjection_management(head_raster, output_spatref)

            #### Remove temporary ascii files
            if not save_temp_ascii_file:
                os.remove(head_ascii)

            #### Calculate and save depth to groundwater (dtg) raster
            dtg_raster = os.path.join(workspace, 'dtg_{0}.img'.format(n+1))
            dtg_obj = elev_obj - Raster(head_raster)
            dtg_obj.save(dtg_raster)
            del dtg_obj, dtg_raster

            ##break
        del elev_obj

    except:
        logging.exception("Unhandled Exception Error\n\n")
        raw_input("Press ENTER to close")
        
    finally:
        pass

################################################################################
if __name__ == '__main__':
    workspace = os.getcwd()
    
    #### Create Basic Logger
    logging.basicConfig(level=logging.DEBUG, format='%(message)s')

    #### Run Information    
    logging.info("\n%s" % ("#"*80))
    logging.info("%-20s %s" % ("Run Time Stamp:", dt.datetime.now().isoformat(' ')))
    logging.info("%-20s %s" % ("Current Directory:", workspace))
    logging.info("%-20s %s" % ("Script:", os.path.basename(sys.argv[0])))

    hed_to_raster(workspace)
