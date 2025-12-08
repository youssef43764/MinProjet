#!/bin/bash
mongo --host mongodb --eval '
db = db.getSiblingDB("projetdb");
db.restaurants.deleteMany({});
db.restaurants.insertMany([
  {name:"Le Tunisien", city:"Tunis", rating:4.2},
  {name:"La Mer", city:"Sousse", rating:4.5},
  {name:"Chez Ali", city:"Sfax", rating:4.0}
]);
print("Seed done");
'
