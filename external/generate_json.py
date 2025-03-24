

# incoming format
# country
#   city, population
#     street, length
#     etc.
#   end
# end


class Street:
    def __init__(self, name, length):
        self.name = name
        self.length = length

    def make_json(self):
        return "{ \"name\": \"%s\", \"length\": %s }" % (self.name, self.length)

class City:
    def __init__(self, name, population):
        self.name = name
        self.streets = []
        self.population = population

    def add_street(self, street):
        self.streets.append(street)

    def make_json(self):
        out = "{ \"name\": \"" + self.name + "\", "
        out += "\"population\": " + self.population + ","
        out += "\"streets\" : ["
        out += ",".join([s.make_json() for s in self.streets])
        out += "]}"
        return out

class Country:
    def __init__(self, name):
        self.name = name
        self.cities = []

    def add_city(self, city):
        self.cities.append(city)

    def make_json(self):
        out = "{ \"name\": \"" + self.name + "\", "
        out += "\"cities\" : ["
        out += ",".join([c.make_json() for c in self.cities])
        out += "]}"
        return out
        
with open("places.txt", "r") as f:
    lines = f.readlines()
    i = 0
    countries = []
    curr_country = None
    curr_city = None
    while i < len(lines):
        t_type = lines[i].strip().split(" ")[0]
        if t_type == "country":
            curr_country = Country(lines[i].strip()[8:])
        elif t_type == "city":
            # strip off the type and also split
            city = lines[i].strip()[5:].split(", ")
            curr_city = City(city[0], city[1])
        elif t_type == "end_country":
            countries.append(curr_country)
            curr_country = None
        elif t_type == "end_city":
            if curr_country == None:
                raise Error("Cities must belong to countries")
            
            curr_country.add_city(curr_city)
            curr_city = None
        else:
            if curr_city == None:
                raise Error("Streets must belong to cities")
            street = lines[i].strip().split(", ")
            curr_city.add_street(Street(street[0], int(street[1])))

        i += 1
    
    # make json
    json = "["
    for c in countries:
        json += c.make_json() + ", "
    json += "]"
    print(json)
    
