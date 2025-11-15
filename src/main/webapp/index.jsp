<%-- 
    Document   : index
    Created on : 15 Oct 2025, 00:14:58
    Author     : Vickeller.01
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="models.VendingMachine" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tomcat Vending Machine FSM</title>
    <link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>
    <% 
        // Retrieve the VendingMachine object from the session
        VendingMachine vm = (VendingMachine) session.getAttribute("vendingMachine");
        if (vm == null) {
            vm = new VendingMachine();
            session.setAttribute("vendingMachine", vm);
        }
        
        // Retrieve the status message set by the Servlet
        String message = (String) request.getAttribute("message");
        if (message == null) {
            message = "Welcome! Insert a coin.";
        }
        
        int stateCents = vm.getStateCents();
        double deposited = stateCents / 100.0;
        double remaining = Math.max(0, 100 - stateCents) / 100.0;
        
        // Calculate Q state index (Q0 = 0-9 cents, Q1 = 10-19 cents, etc.)
        // Q11 is error state (stateCents = -1 indicates error)
        boolean isErrorState = stateCents < 0;
        boolean isFinalState = stateCents >= 100;
        int stateIndex = isErrorState ? 11 : Math.min(stateCents / 10, 10);
        String currentQState = "Q" + stateIndex;
        String internalState = vm.getQState(); // CENTS_X format
    %>

    <div class="container">
        <div class="vending-machine">
            <div class="machine-header">
                <h1>$1.00 Energy Drink Machine</h1>
                <div class="brand-logo">VEND-O-MATIC</div>
            </div>

            <!-- Added FSM State Diagram -->
            <div class="fsm-diagram">
                <h2 class="section-title">Finite State Machine</h2>
                <div class="state-container">
                    <% 
                    for (int i = 0; i <= 11; i++) { 
                        String stateClass = "state-node";
                        if (i == stateIndex) {
                            stateClass += " active";
                            if (i == 10) stateClass += " final-state"; // Q10 is accepting state
                            if (i == 11) stateClass += " error-state"; // Q11 is error state
                        } else if (i == 10) {
                            stateClass += " final-state-inactive"; // Show Q10 as special even when inactive
                        } else if (i == 11) {
                            stateClass += " error-state-inactive"; // Show Q11 as error even when inactive
                        }
                        
                        String stateLabel = "Q" + i;
                        String stateAmount = i == 11 ? "ERR" : "$" + String.format("%.2f", i * 0.10);
                    %>
                        <div class="<%= stateClass %>" data-state="<%= stateLabel %>">
                            <div class="state-label"><%= stateLabel %></div>
                            <div class="state-amount"><%= stateAmount %></div>
                        </div>
                        <% if (i < 11) { %>
                            <div class="state-arrow <%= (i < stateIndex) ? "active" : "" %>">→</div>
                        <% } %>
                    <% } %>
                </div>
                <div class="state-legend">
                    <span class="legend-item"><span class="legend-dot normal"></span>Normal</span>
                    <span class="legend-item"><span class="legend-dot final"></span>Final (Q10)</span>
                    <span class="legend-item"><span class="legend-dot error"></span>Error (Q11)</span>
                </div>
            </div>

            <div class="display-panel">
                <div class="display-screen">
                    <div class="status-message"><%= message %></div>
                    <div class="fsm-state">
                        <span class="label">Current State:</span>
                        <span class="state-value <%= isErrorState ? "error" : (isFinalState ? "final" : "") %>"><%= currentQState %></span>
                    </div>
                    <!-- Added deposited and remaining amount display -->
                    <div class="amount-info">
                        <% if (!isErrorState) { %>
                        <div class="amount-row">
                            <span class="amount-label">Deposited:</span>
                            <span class="amount-value deposited">$<%= String.format("%.2f", deposited) %></span>
                        </div>
                        <% if (stateIndex < 10) { %>
                        <div class="amount-row">
                            <span class="amount-label">Remaining:</span>
                            <span class="amount-value remaining">$<%= String.format("%.2f", remaining) %></span>
                        </div>
                        <% } %>
                        <% } else { %>
                        <div class="amount-row error-message">
                            <span class="amount-label">⚠️ Invalid coin detected</span>
                        </div>
                        <% } %>
                    </div>
                </div>
            </div>

            <!--  <div class="product-section">
                <h2 class="section-title">Available Products</h2>
                <div class="product-grid">
                    <div class="product-item">
                        <div class="product-icon">🥤</div>
                        <div class="product-name">Soda</div>
                        <div class="product-price">$1.00</div>
                    </div>
                    <div class="product-item">
                        <div class="product-icon">💧</div>
                        <div class="product-name">Water</div>
                        <div class="product-price">$1.00</div>
                    </div>
                </div>
            </div>-->

            <form action="vending" method="POST" class="coin-section">
                <h2 class="section-title">Insert Coin</h2>
                <div class="coin-buttons">
                    <button type="submit" name="coin" value="1.00" class="coin-btn coin-dollar">
                        <span class="coin-value">$1.00</span>
                    </button>
                    <button type="submit" name="coin" value="0.50" class="coin-btn coin-half">
                        <span class="coin-value">$0.50</span>
                    </button>
                    <button type="submit" name="coin" value="0.20" class="coin-btn coin-quarter">
                        <span class="coin-value">$0.20</span>
                    </button>
                    <button type="submit" name="coin" value="0.10" class="coin-btn coin-dime">
                        <span class="coin-value">$0.10</span>
                    </button>
                    <button type="submit" name="coin" value="0.05" class="invalid-coin-btn">
                        <span class="coin-value">$0.05</span>
                           <span class="invalid-note">Invalid Coin</span>
                    </button>
                    
                </div>
                
                <div class="reset-container">
                    <button type="submit" name="coin" value="reset" class="reset-btn">
                        🔄 Reset Machine
                    </button>
                </div>
            </form>

            <div class="dispenser-section">
                <div class="change-tray">
                    <div class="tray-icon">📦</div>
                    <div class="tray-label">Change / Product Exit</div>
                </div>
            </div>
        </div>
    </div>

    <!-- Added JavaScript for animations -->
    <script>
        // Animate state transitions on page load
        document.addEventListener('DOMContentLoaded', function() {
            const activeState = document.querySelector('.state-node.active');
            if (activeState) {
                if (activeState.classList.contains('final-state')) {
                    activeState.classList.add('pulse-final');
                } else if (activeState.classList.contains('error-state')) {
                    activeState.classList.add('pulse-error');
                } else {
                    activeState.classList.add('pulse');
                }
                
                setTimeout(() => {
                    activeState.classList.remove('pulse', 'pulse-final', 'pulse-error');
                }, 1500);
            }

            // Add coin button click animations
            const coinButtons = document.querySelectorAll('.coin-btn');
            coinButtons.forEach(button => {
                button.addEventListener('click', function(e) {
                    this.classList.add('coin-insert');
                    setTimeout(() => {
                        this.classList.remove('coin-insert');
                    }, 300);
                });
            });

            // Add reset button click animation
            const resetButton = document.querySelector('.reset-btn');
            if (resetButton) {
                resetButton.addEventListener('click', function(e) {
                    this.classList.add('reset-insert');
                    setTimeout(() => {
                        this.classList.remove('reset-insert');
                    }, 300);
                });
            }
        });
    </script>
</body>
</html>
