import csv, sqlite3, codecs

class UnicodeCsvReader(object):
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

def createTable(curs, table_name, table_columns, filename):
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
                new_row[idx] = row[i]
        new_data.append(new_row)
    
    curs.executemany("insert into %s (%s) values (%s)" % (table_name, ','.join(column_names), ','.join(['?']*len(column_names))), new_data)


# __main__
for folder in ("google_transit_UVA", "google_transit_Charlottesville"):
    conn = sqlite3.connect("HoosBus-GTFS.db")
    curs = conn.cursor()

    # Creat the routes table
    table_columns = "route_id TEXT, agency_id TEXT, route_short_name TEXT, route_long_name TEXT"
    createTable(curs, 'routes', table_columns, "routes.txt")

    # Create the stops table
    table_columns = "stop_id TEXT, stop_code TEXT, stop_name TEXT, stop_desc TEXT, stop_lat REAL, stop_lon REAL"
    createTable(curs, 'stops', table_columns, "stops.txt")

    # Create the trips table
    table_columns = "route_id TEXT, service_id TEXT, trip_id TEXT, trip_headsign TEXT, trip_short_name TEXT, direction_id INTEGER"
    createTable(curs, 'trips', table_columns, "trips.txt")

    # # Create the stop_times table
    # table_columns = "trip_id TEXT, arrival_time TEXT, departure_time TEXT, stop_id TEXT, stop_sequence TEXT, stop_headsign TEXT"
    # createTable(curs, 'stop_times', table_columns, "stop_times.txt")

    # Commit the changes
    conn.commit()

