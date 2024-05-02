// imports
import Map "mo:base/HashMap";
import Hash "mo:base/Hash";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
// String type
import Text "mo:base/Text";

// actor to start smart contract (icp)
actor Assistant {

  // Like class
  type ToDo = {
    description: Text;
    completed: Bool;
  };

  // Data types
  // Text > String
  // Boolean > Bool
  // Nat >> Int

  // Functions in Motoko
  // Same as Go , return (:)
  func natHash(number: Nat) : Hash.Hash {
    // Return line should be last one, it will get 
    // it automatically
    Text.hash(Nat.toText(number))
  };

  // let > immutable
  // var > mutable (Go)
  // const > global

  var todos = Map.HashMap<Nat, ToDo>(0, Nat.equal, natHash);
  var nextId : Nat = 0;

  // func >> private
  // public func >> public
  // public query func > sorgulama
  // public func > update 

  public query func getTodos() : async [ToDo] {
    Iter.toArray(todos.vals());
  };

  public func addToDo(description: Text) : async Nat {
    let id = nextId;
    todos.put(id,
     {description = description; 
    completed = false});
    nextId += 1;
    //return id;
    id
  };

  public func completeTodo(id: Nat) : async () {
    ignore do ? {
      let description = todos.get(id)!.description;
      todos.put(
        id, {description; completed = true}
      );
    }
  };

  // Check & write
  public query func showTodos() : async Text {
    var output: Text = "\n_____TO-DOs_____";
    for (todo: ToDo in todos.vals()) {
      output #= "\n" # todo.description;
      if (todo.completed) { output #= " !"};
    };
    output # "\n"
  };

  // if completed, remove it
  public func clearCompleted() : async () {
    // What's mapFilter structure.. looks like Lambda Expression a bit.. though it seems a function..
    todos := Map.mapFilter<Nat, ToDo, ToDo>(todos, Nat.equal,
     natHash, func(_, todo) {
       if (todo.completed) null else ?todo
     });
  }

};
