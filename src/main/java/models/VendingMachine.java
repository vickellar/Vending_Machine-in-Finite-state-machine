package models;

/**
 * VendingMachine models a finite state machine (FSM) for a coin-operated vending machine.
 * <p>
 * The machine accepts only $1.00, $0.50, $0.20, and $0.10 coins. Any other coin triggers an error state (Q11).
 * When the total deposited reaches $1.00, the machine enters the final state (Q10), dispenses the item, and locks until reset.
 * The FSM can be reset to its initial state using the {@link #reset()} method.
 * </p>
 * <ul>
 *   <li>States Q0-Q10: Normal operation, increments by $0.10 per state.</li>
 *   <li>State Q10: Final/accepting state, $1.00 deposited, item dispensed.</li>
 *   <li>State Q11: Error state, invalid coin inserted, requires reset.</li>
 * </ul>
 *
 * Serializable for session persistence in web applications.
 */
public class VendingMachine implements java.io.Serializable {
    /** Serialization ID for session persistence. */
    private static final long serialVersionUID = 1L;
    /** Current state in cents. -1 indicates error state (Q11). */
    private int stateCents = 0;
    /** Price of the item in cents ($1.00). */
    private static final int ITEM_PRICE = 100;
    /** True if the machine is in error state (Q11). */
    private boolean isErrorState = false;
    /** True if the machine is in final state (Q10). */
    private boolean isFinalState = false;

    /**
     * Inserts a coin and transitions the FSM accordingly.
     * <ul>
     *   <li>Accepts only 100, 50, 20, or 10 cent coins.</li>
     *   <li>Invalid coins set error state (Q11).</li>
     *   <li>When $1.00 is reached, enters final state (Q10) and dispenses item.</li>
     *   <li>No further coins accepted in error or final state until reset.</li>
     * </ul>
     * @param coinValueCents Coin value in cents.
     * @return Status message for the UI.
     */
    public String insertCoin(int coinValueCents) {
        if (isErrorState) {
            return "Error: Invalid coin previously inserted. Please reset.";
        }
        if (isFinalState) {
            return "Item already dispensed. Please reset.";
        }
        if (coinValueCents != 100 && coinValueCents != 50 && coinValueCents != 20 && coinValueCents != 10) {
            this.stateCents = -1; // Error state Q11
            isErrorState = true;
            return "Invalid coin detected! Machine in error state (Q11). Please reset.";
        }
        this.stateCents += coinValueCents;
        if (this.stateCents >= ITEM_PRICE) {
            isFinalState = true;
            this.stateCents = ITEM_PRICE; // Lock at $1.00 (Q10)
            return "ITEM DISPENSED! (Q10)";
        } else {
            return String.format("Deposited: $%.2f. Need: $%.2f more. (State %s)", 
                                 this.stateCents / 100.0, 
                                 (ITEM_PRICE - this.stateCents) / 100.0, 
                                 getQState());
        }
    }

    /**
     * Resets the FSM to its initial state (Q0), clearing error and final states.
     */
    public void reset() {
        this.stateCents = 0;
        this.isErrorState = false;
        this.isFinalState = false;
    }

    /**
     * Returns a user-friendly status message for the UI based on the current state.
     * @return Status message string.
     */
    public String getStatusMessage() {
        if (isErrorState) {
            return "⚠️ Invalid coin detected. Please reset.";
        }
        if (isFinalState) {
            return "Ready to dispense! (Q10)";
        }
        return String.format("Insert coin. $%.2f remaining.", (ITEM_PRICE - this.stateCents) / 100.0);
    }

    /**
     * Returns the current FSM state as a string.
     * <ul>
     *   <li>Q0-Q10: Normal states</li>
     *   <li>Q10: Final state</li>
     *   <li>Q11: Error state</li>
     * </ul>
     * @return State string (e.g., "Q5", "Q10", "Q11").
     */
    public String getQState() {
        if (isErrorState) return "Q11";
        if (isFinalState) return "Q10";
        return "Q" + Math.min(stateCents / 10, 10);
    }

    /**
     * Gets the current deposited amount in cents.
     * @return Amount in cents (or -1 for error state).
     */
    public int getStateCents() {
        return this.stateCents;
    }

    /**
     * Checks if the machine is in error state (Q11).
     * @return True if error state.
     */
    public boolean isErrorState() {
        return isErrorState;
    }

    /**
     * Checks if the machine is in final state (Q10).
     * @return True if final state.
     */
    public boolean isFinalState() {
        return isFinalState;
    }
}
