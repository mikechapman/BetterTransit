import csv, sqlite3, codecs, os

class UnicodeCsvReader(object):
    """
    A wrapper class to add unicode support to the csv module
    """
    def __init__(self, f, encoding="utf-8", **kwargs):
        self.csv_reader = csv.reader(f, **kwargs)
        self.encoding = encoding

    def __iter__(self):
        return self

    def next(self):
        # read and split the csv row into fields
        row = self.csv_reader.next() 
        # now decode
        return [unicode(cell, self.encoding) for cell in row]

    @property
    def line_num(self):
        return self.csv_reader.line_num


def createTable(curs, table_name, table_columns, filename, source_id):
    """
    Create tables, then popolate them with data from GTFS files.
    """
    primary_keys = ("route_id", "stop_id", "trip_id")
    
    #curs.execute('drop table if exists %s' % table_name)
    curs.execute('create table if not exists %s (%s)' % (table_name, table_columns))
    
    # Get column names
    column_names = []
    for column in table_columns.split(','):
        l = column.strip().split(' ')
        column_names.append(l[0])
    
    # Parse csv file
    #data = csv.reader(open("%s/%s" % (folder, filename)))
    data = UnicodeCsvReader(open("%s/%s" % (folder, filename)))
    header = data.next()
    
    # Remove Byte Order Mark (BOM)
    header[0] = header[0].lstrip(u'\ufeff')
    
    # Remove unused columns from csv data
    new_data = []
    for row in data:
        new_row = [None] * len(column_names)
        for i in range(len(row)):
            if header[i] in column_names:
                idx = column_names.index(header[i])
                if header[i] in primary_keys:
                    new_row[idx] = str(source_id) + '#' + row[i]
                else:
                    new_row[idx] = row[i]
        new_data.append(new_row)
    
    curs.executemany("insert into %s (%s) values (%s)" % (table_name, ','.join(column_names), ','.join(['?']*len(column_names))), new_data)
    
    # # Create a unique index from the primary key
    # if primary_key is not None:
    #     curs.execute('create unique index %s on %s (%s)' % ('idx_'+primary_key, table_name, primary_key))
    

# __main__

# We are combining two sources into one database so we need a source_id.
source_id = 0

# Creat a new database and connect to it
database_name = "HoosBus-GTFS.db"

if os.path.exists(database_name):
    os.remove(database_name)

conn = sqlite3.connect(database_name)
curs = conn.cursor()

for folder in ("google_transit_UVA", "google_transit_Charlottesville"):
    # Creat the routes table
    table_columns = "route_id TEXT, agency_id TEXT, route_short_name TEXT, route_long_name TEXT"
    createTable(curs, 'routes', table_columns, "routes.txt", source_id)
    
    # Create the stops table
    table_columns = "stop_id TEXT, stop_code TEXT, stop_name TEXT, stop_lat REAL, stop_lon REAL"
    createTable(curs, 'stops', table_columns, "stops.txt", source_id)
    
    # Create the trips table
    table_columns = "route_id TEXT, trip_id TEXT, direction_id INTEGER, trip_headsign TEXT"
    createTable(curs, 'trips', table_columns, "trips.txt", source_id)
    
    # Create the stop_times table
    table_columns = "trip_id TEXT, stop_id TEXT, stop_sequence INTEGER"
    createTable(curs, 'stop_times', table_columns, "stop_times.txt", source_id)
    
    # Since all trips in the same route have the same stop sequences, we only need to store one stop sequence per route.
    trips_dict = {}
    
    for row in curs.execute('select * from trips'):
        (route_id, trip_id, direction_id, trip_headsign) = row
        k = (route_id, direction_id)
        if k not in trips_dict:
            trips_dict[k] = (trip_id, trip_headsign)
    
    table_columns = "route_id TEXT, direction_id INTEGER, trip_headsign TEXT, stop_id TEXT, stop_sequence INTEGER"
    #curs.execute('drop table if exists %s' % table_name)
    curs.execute('create table if not exists %s (%s)' % ("distinct_trips", table_columns))
    
    distinct_trips = []
    for k, v in trips_dict.items():
        (route_id, direction_id) = k
        (trip_id, trip_headsign) = v
        for row in curs.execute('select stop_id, stop_sequence from stop_times where trip_id = "%s"'  % trip_id):
            (stop_id, stop_sequence) = row
            distinct_trips.append([route_id, direction_id, trip_headsign, stop_id, stop_sequence])
    
    curs.executemany("insert into distinct_trips (route_id, direction_id, trip_headsign, stop_id, stop_sequence) values (?, ?, ?, ?, ?)", distinct_trips)
    
    # At last we drop the trips and stop_times tables
    curs.execute('drop table if exists %s' % "trips")
    curs.execute('drop table if exists %s' % "stop_times")
    
    # Increment the source_id
    source_id += 1

# Create indexes
curs.execute('create unique index idx_stop_id on stops (stop_id)')
curs.execute('create unique index idx_route_id on routes (route_id)')

# Commit the changes
conn.commit()

# Close the cursor
curs.close()

