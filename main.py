import json
# import requests
from flask import Flask

app = Flask(__name__)
app.config["DEBUG"] = True

data = ""


@app.before_first_request
def getNames():
    print("Called!")
    # Load the json file
    global data
    with open("./members.json", 'r') as file:
        data = json.load(file)


@app.route('/', methods=['GET'])
def home():
    return json.dumps(data)


@app.route('/api/names', methods=['GET'])
def names():
    plist = []
    for person in data:
        print(person['name'])
        plist.append(person['name'])
    p = set(plist)
    final = {"Name": list(p)}
    return json.dumps(final)


@app.route('/api/name/<int:id>', methods=['GET'])
def name(id=id):
    for person in data:
        if person['id'] == id:
            print(f"Person: {person}")
            return json.dumps(person)
        else:
            print("No such record found!")


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8080)
