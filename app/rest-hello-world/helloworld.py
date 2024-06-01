from flask import Flask, request
from flask_restful import Resource, Api

app = Flask(__name__)
api = Api(app)

class Greeting (Resource):
  def get(self):
    print("Serving request")
    return {"message": "Hello World"}

api.add_resource(Greeting, '/') # Route_1

if __name__ == '__main__':
  print("Starting container")
  app.run('0.0.0.0','80')