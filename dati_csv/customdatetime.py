from datetime import datetime
import csv

with open('procedures.csv', newline='') as infile, open('dati_csv_cleaned/procedures_cleaned.csv', 'w', newline='') as outfile:
    reader = csv.DictReader(infile)
    fieldnames = reader.fieldnames
    writer = csv.DictWriter(outfile, fieldnames=fieldnames)
    writer.writeheader()

    for row in reader:
        if row['START']:
            dt = datetime.fromisoformat(row['START'].replace('Z', '+00:00'))
            row['START'] = dt.strftime('%Y-%m-%d %H:%M:%S')
        if row['STOP']:
            dt = datetime.fromisoformat(row['STOP'].replace('Z', '+00:00'))
            row['STOP'] = dt.strftime('%Y-%m-%d %H:%M:%S')
        # if row['LASTBILLEDDATE1']:
        #     dt = datetime.fromisoformat(row['LASTBILLEDDATE1'].replace('Z', '+00:00'))
        #     row['LASTBILLEDDATE1'] = dt.strftime('%Y-%m-%d %H:%M:%S')
        # if row['LASTBILLEDDATE2']:
        #     dt = datetime.fromisoformat(row['LASTBILLEDDATE2'].replace('Z', '+00:00'))
        #     row['LASTBILLEDDATE2'] = dt.strftime('%Y-%m-%d %H:%M:%S')
        # if row['LASTBILLEDDATEP']:
        #     dt = datetime.fromisoformat(row['LASTBILLEDDATEP'].replace('Z', '+00:00'))
        #     row['LASTBILLEDDATEP'] = dt.strftime('%Y-%m-%d %H:%M:%S')
        writer.writerow(row)