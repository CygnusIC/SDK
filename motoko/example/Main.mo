import Principal "mo:base/Principal";
import Cycles "mo:base/ExperimentalCycles";
import Cygnus "../Cygnus";

actor Main {

    public shared (msg) func fetchCanisterStatus(auxPrincipalId : ?Principal) : async Cygnus.CanisterStatus {
        let cygnusClass = Cygnus.Cygnus();
        cygnusClass.validateUser(msg.caller, auxPrincipalId);
        await cygnusClass.getStatus(Principal.fromActor(Main));
    };

    public shared (msg) func approveCycleWithdrawal(withdrawAmount : Nat) : async () {
        let cygnusClass = Cygnus.Cygnus();
        cygnusClass.validateUser(msg.caller, null);
        let sendablelimit : Nat = Cycles.balance();
        let sendableCycles = if (withdrawAmount <= sendablelimit) withdrawAmount else sendablelimit;
        Cycles.add(sendableCycles);
        await cygnusClass.CygnusCanitser.acceptWithdrwalCyclesFromOtherCanitsers();
    };

};
