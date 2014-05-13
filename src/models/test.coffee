module.exports =
  schema :
    id : Number
    name : String
    address : String
  indexes : [
    {
      id : 1
      name : 1
    }
    {
      id : 1
      address : 1
    }
  ]