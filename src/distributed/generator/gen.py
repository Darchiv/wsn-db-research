import random

import time
from datetime import datetime

import socket
import struct

import math
import collections

# todo
# cluster   - id; gateway_ip;
# node      - id; cluster_id; name;
# Sensor    - id; node_id; sensorType_id
# Measurement - id; sensor_id; time; value;
# sensor type - id, name, unit

cluster_no      = 15
#sensor types
sen_typ         = ["temp1","temp2","temp3", "preasure1", "preasure2", "preasure3", "light", "flow1", "flow2", "hum"]
units           = ["C","C","F","Pa","Pa","Pa","Lux","L/h","L/h","%"]
combined        = []
# nodes per cluster
node_no         = [8, 45]
# Sensors per node
sensor_no       = [1, 5]
# Sensor values
sensor_measurement_no = [0, 50]


data_range      = ["2017-01-01 06:00:00.000000", "2020-04-01 23:00:00.000000"]
cluster_id      = 0
node_id         = 0
sensor_id       = 0
sensor_type_id  = 0
measurement_id  = 0

file_cass = open("cass.csv", "w+")
file_cass2 = open("cass2.csv", "w+")
file_cass3 = open("cass3.csv", "w+")
file_cluster = open("cluster.csv", "w+")
file_node = open("node.csv", "w+")
file_sens_type = open("sType.csv", "w+")
file_sens = open("sens.csv", "w+")
file_measur = open("measure.csv", "w+")


def str_time_prop(start, end, format, prop):
    stime = time.mktime(time.strptime(start, format))
    etime = time.mktime(time.strptime(end, format))
    ptime = stime + prop * (etime - stime)
    return datetime.utcfromtimestamp(ptime).strftime(format)[:-3]+"+0000"

def random_date(start, end):
    return str_time_prop(start, end, '%Y-%m-%d %H:%M:%S.%f', random.random())

def random_ip():
    return socket.inet_ntoa(struct.pack('>I', random.randint(1, 0xffffffff)))

def node_name(node_id):
    return "node_"+str(node_id)

# print(random_date(data_range[0], data_range[1], random.random()))
for i in range(0,len(sen_typ)):
    sensor_type_id = sensor_type_id + 1
    tmp = [sensor_type_id, sen_typ[i], units[i]]
    combined.append(tmp)
    file_sens_type.write(','.join(str(v) for v in tmp)+'\n')

for c in range(1,cluster_no+1):
    cluster_id = cluster_id + 1
    cluster_gateway = random_ip()
    file_cluster.write(','.join(str(v) for v in [cluster_id, cluster_gateway])+'\n')
    nodes_list = []
    cluster_sensor_list = []

    for n in range(1, random.randint(node_no[0],node_no[1])+1):
        node_id = node_id + 1
        file_node.write(','.join(str(v) for v in [node_id,cluster_id, node_name(node_id)])+'\n')
        nodes_list.append(node_name(node_id))

        sensor_list = random.choices(combined, k=random.randint(sensor_no[0],sensor_no[1]))
        for s in sensor_list:
            sensor_id = sensor_id + 1
            sensor_type_id = s[0]
            sensor_name = s[1]
            sensor_unit = s[2]
            file_sens.write(','.join(str(v) for v in [sensor_id, sensor_type_id, node_id])+'\n')
            cluster_sensor_list.append(sensor_name)

            for m in range(0,random.randint(sensor_measurement_no[0],sensor_measurement_no[1])+1):
                measurement_id = measurement_id + 1
                when = random_date(data_range[0], data_range[1])
                val = random.randint(0,255)

                #cluster, datetime, val, unit, sens_type
                cass_str = [cluster_id, when, "'"+node_name(node_id)+"'", "'"+sensor_name+"'", val, "'"+sensor_unit+"'"]
                file_cass.write(','.join(str(v) for v in cass_str)+'\n')

                file_measur.write(','.join(str(v) for v in [measurement_id,sensor_id,when,val])+'\n')

    cass2_str = [cluster_id, "'"+cluster_gateway+"'", "\"['"+"','".join(nodes_list)+"']\""]
    file_cass2.write(','.join(str(v) for v in cass2_str)+'\n')

    c = collections.Counter(cluster_sensor_list)
    for x in c.items():
        sensor_name = x[0]
        senscor_count = x[1]
        file_cass3.write("UPDATE sens_type_by_cluster SET count = count + "+str(senscor_count)+" WHERE cluster = "+str(cluster_id)+" AND sens_type = '"+sensor_name+"' AND unit='"+units[sen_typ.index(sensor_name)]+"';\n")



file_cass.close()
file_cass2.close()
file_cass3.close()
file_cluster.close()
file_node.close()
file_sens_type.close()
file_sens.close()
file_measur.close()