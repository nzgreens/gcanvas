import csv
import json

class Resident(object):
    def __init__(self):
        self.id = 0;
        self.title = ''
        self.firstname = ''
        self.middlenames = ''
        self.lastname = ''
        self.occupation = ''
        self.gender = ''

    def __repr__(self):
        return str(self.toMap())
        
    def toMap(self):
        return {
            'id': self.id,
            'title': self.title,
            'firstname': self.firstname,
            'middlenames': self.middlenames,
            'lastname': self.lastname,
            'occupation': self.occupation,
            'gender': self.gender
        }


class Address(object):
    def __init__(self):
        self.street = ''
        self.suburb = ''
        self.city = ''
        self.meshblock = 0
        self.electorate = 0
        self.latitude = 0
        self.longitude = 0
        self.residents = []

    def __repr__(self):
        return str(self.toMap())


    def toMap(self):
        return {
            'street': self.street,
            'suburb': self.suburb,
            'city': self.city,
            'meshblock': self.meshblock,
            'electorate': self.electorate,
            'latitude': self.latitude,
            'longitude': self.longitude,
            'residents': [resident.toMap() for resident in self.residents]
        }

titles = ('mr', 'miss', 'ms', 'mrs', 'dr')

def parseName(name):
    names = name.split()
    title = names[0] if names[0].lower() in titles else ''
    if len(title) > 0:
        del names[0]
    firstname = names[0]
    del names[0]
    lastname = names.pop()
    middlenames = ' '.join(names)
    
    return title, firstname, middlenames, lastname


addresses = dict()

with open('Ikaroa-Rawhiti_65_DoorknockTargets_2013-06-09 11_14_34.csv', newline='') as csvfile:
    ereader = csv.reader(csvfile, delimiter=',')
    firstrow = True
    for row in ereader:
        if firstrow:
            firstrow = False
            continue
        resident = Resident()
        resident.id = int(row[0])
        resident.title, resident.firstname, resident.middlenames, resident.lastname = parseName(row[1])
        resident.occupation = row[4]
        resident.gender = row[5]
        if "%s, %s" % (row[2],row[3]) in addresses.keys():
            addresses["%s, %s" % (row[2],row[3])].residents.append(resident)
        else:
            address = Address()
            address.street = row[2]
            address.city = row[3]
            address.meshblock = int(row[6])
            address.electorate = int(row[11])
            address.latitude = float(row[12])
            address.longitude = float(row[13])
            address.residents.append(resident)
            addresses["%s, %s" % (row[2],row[3])] = address


print (json.dumps([addresses[address].toMap() for address in addresses.keys() if addresses[address].latitude != 0 and addresses[address].longitude != 0]))

