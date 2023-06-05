# Cygnus SDK

The Cygnus SDK is a comprehensive tool designed specifically for the Internet Computer, offering convenient canister management with auto top-up and withdrawal functionality. This SDK package consists of two essential files:

## Cygnus SDK Files in Motoko

1. [Cygnus.mo](https://github.com/CygnusIC/SDK/blob/main/motoko/Cygnus.mo "Cygnus.mo"): This file contains various types necessary for smooth integration. It also includes access control validation, ensuring that only whitelisted principlaIDs and Cygnus Canister have permission to access these methods.

2. [Main.mo](https://github.com/CygnusIC/SDK/blob/main/motoko/Actor.mo "Actor.mo"): This file includes two crucial methods that should be copied into the main actor of your canister.

## Integration Steps

Integrating the Cygnus SDK into your canister involves the following steps:

1. Import Dependencies in the Actor file:

   Make sure to include the following dependencies in your main actor file if you haven't already done so:

   ```motoko
   import Principal "mo:base/Principal";
   import Cycles "mo:base/ExperimentalCycles";
   ```

   Import the Cygnus dependency file into your main actor file:

   ```motoko
   import Cygnus "Cygnus";
   ```

2. Add Principal ID to the array of whitelistedPrincipalIds in the Cygnus.mo file.
   Only whitelisted PrincipalID can register new canisters using the Cygnus front tool or Candid.
   To add a Principal ID, follow these steps: 1. Open the Cygnus.mo file. 2. Locate the whitelistedPrincipalIds array. 3. Add the desired Principal IDs as elements of the array.
   Example:

   ```motoko
      let whitelistedPrincipalIds : [ Text ] = [
         "evwewe-w2wib-fjqum2-5cqnb-56v7f-xptd4-thtkc-vevew-riuws-5wug4-001",
         "evwewe-w2wib-fjqum2-5cqnb-56v7f-xptd4-thtkc-vevew-riuws-5wug4-002",
       ];
   ```

3. Import the Two Restrictive Methods:
   The following methods are restricted and can only be accessed by the Cygnus backend canister and whitelisted PrincipalIDs.

   - fetchCanisterStatus method: Use this method to retrive the status of your canister.-

     The auxPrincipalId parameter is used when a user is registering a canister through Candid. Only whitelisted PrincipalIDs can make an Candid call to register a new canister.

     ```motoko
     public shared (msg) func fetchCanisterStatus(auxPrincipalId : ?Principal) : async Cygnus.CanisterStatus {
         let cygnusClass = Cygnus.Cygnus();
         cygnusClass.validateUser(msg.caller, auxPrincipalId);
         await cygnusClass.getStatus(Principal.fromActor(Main));
     };
     ```

#### Note: Please replace "Main" with the name of your specific actor in the above line.

- (Optional) approveCycleWithdrawal Method: This method enables the withdrawal of cycles from your canister. Its implementation is optional, but not using this method will result in the inability to withdraw cycles from your canister.-
  ```motoko
        public shared (msg) func approveCycleWithdrawal(withdrawAmount : Nat) : async () {
            let cygnusClass = Cygnus.Cygnus();
            cygnusClass.validateUser(msg.caller, null);
            let sendablelimit : Nat = Cycles.balance();
            let sendableCycles = if (withdrawAmount <= sendablelimit) withdrawAmount
              else sendablelimit;
            Cycles.add(sendableCycles);
            await cygnusClass.CygnusCanitser.acceptWithdrwalCyclesFromOtherCanitsers();
        };
  ```

## Please refer to the [Example](https://github.com/CygnusIC/SDK/tree/master/motoko/example "Example") folder for reference.Make sure to add your own Principal IDs to the `whitelistedPrincipalIds` array in the Cygnus.mo file.
