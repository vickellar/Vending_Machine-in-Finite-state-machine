Vending Machine FSM Web Application
Overview
This project implements a coin-operated vending machine as a Finite State Machine (FSM) using Java, JSP, and Tomcat. The machine dispenses a product when exactly $1.00 is deposited, accepting only $1.00, $0.50, $0.20, and $0.10 coins. Invalid coins trigger an error state, requiring a reset.

Features
FSM-based logic: States Q0–Q10 for normal operation, Q10 for final state (item dispensed), Q11 for error state (invalid coin).
Strict coin validation: Only $1.00, $0.50, $0.20, $0.10 accepted.
Error handling: Invalid coins immediately set error state (Q11).
Session persistence: Each user’s FSM state is stored in their session.
Reset functionality: Users can reset the machine to start a new transaction.
Visual FSM diagram: The UI displays the current state and transitions.
FSM State Diagram
Q0 → Q1 → Q2 → ... → Q10
           ↓
          Q11 (error)
Q0–Q10: $0.00 to $1.00 in $0.10 increments
Q10: Final state, item dispensed
Q11: Error state, invalid coin inserted
Usage Instructions
Start Tomcat and deploy the application.
Open the app in your browser (e.g., http://localhost:8080/Vending%20Machine/).
Insert coins using the provided buttons. Only valid coins are accepted.
Observe the FSM diagram and status messages.
If an invalid coin is inserted, the machine enters error state (Q11). Use the reset button to clear.
When $1.00 is reached, the machine dispenses the item and locks until reset.
Code Structure
src/main/java/models/VendingMachine.java: FSM model. Handles state transitions, coin validation, error/final state logic. Fully documented with Javadoc.
src/main/java/controller/VendingMachineServlet.java: Servlet controller. Manages session, processes coin/reset actions, forwards to JSP. Fully documented with Javadoc.
src/main/webapp/index.jsp: Frontend UI. Displays FSM diagram, status, and controls.
src/main/webapp/style.css: Styles for the UI.
Example Flows
Valid Transaction:
Insert $0.50 → Insert $0.20 → Insert $0.20 → Insert $0.10 → Q10 reached, item dispensed.
Invalid Coin:
Insert $0.05 → Q11 error state, must reset.
Reset:
Click reset button → FSM returns to Q0, ready for new transaction.
Documentation
All core classes and methods are documented with Javadoc. See source files for details.
FSM logic and state transitions are described in the comments and README.
Testing
Try all coin combinations, including invalid coins, to verify FSM behavior.
Ensure error and final states lock further input until reset.
License
MIT License (or specify your own)

For questions or improvements, contact me