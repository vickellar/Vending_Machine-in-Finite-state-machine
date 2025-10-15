
package controller;

import java.io.IOException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.VendingMachine;

/**
 *
 * @author Vickeller.01
 */
@WebServlet(name = "vending", urlPatterns = {"/vending"})

/**
 * VendingMachineServlet handles HTTP requests for the vending machine FSM web application.
 * <p>
 * Manages the VendingMachine FSM object in the user's session, processes coin insertion and reset actions,
 * and coordinates state transitions and error handling. Forwards results to the JSP frontend for display.
 * </p>
 * <ul>
 *   <li>POST: Handles coin insertion and reset actions.</li>
 *   <li>GET: Initializes the FSM for first-time visits.</li>
 * </ul>
 */

public class VendingMachineServlet extends HttpServlet {

    /** Serialization ID for servlet. */
    private static final long serialVersionUID = 1L;

    /**
     * Handles POST requests for coin insertion and reset actions.
     * <ul>
     *   <li>Retrieves or initializes the VendingMachine FSM from the session.</li>
     *   <li>If "reset" is received, resets the FSM.</li>
     *   <li>Otherwise, parses coin value and calls {@link VendingMachine#insertCoin(int)}.</li>
     *   <li>Sets the resulting message for display in the JSP.</li>
     *   <li>Forwards to index.jsp for UI update.</li>
     * </ul>
     * @param request HTTP request containing coin or reset action.
     * @param response HTTP response.
     * @throws jakarta.servlet.ServletException
     * @throws IOException
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws jakarta.servlet.ServletException, IOException {
        // 1. Get the session (FSM persistence)
        HttpSession session = request.getSession();
        VendingMachine vm = (VendingMachine) session.getAttribute("vendingMachine");
        if (vm == null) {
            vm = new VendingMachine();
            session.setAttribute("vendingMachine", vm);
        }

        // 2. Get coin input from the HTML form
        String coinStr = request.getParameter("coin");
        String message = null;
        if ("reset".equals(coinStr)) {
            vm.reset();
            message = "Welcome! Insert a coin.";
        } else {
            int coinCents = 0;
            try {
                double coinDouble = Double.parseDouble(coinStr);
                coinCents = (int) Math.round(coinDouble * 100);
            } catch (NumberFormatException e) {
                coinCents = -1; // Treat as invalid coin
            }
            message = vm.insertCoin(coinCents);
        }
        session.setAttribute("vendingMachine", vm);
        request.setAttribute("message", message);

        // 5. Forward back to the JSP (View) to display the updated state
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }

    /**
     * Handles GET requests to initialize the FSM for first-time visits.
     * <ul>
     *   <li>Initializes the VendingMachine FSM in the session if not present.</li>
     *   <li>Forwards to index.jsp for UI display.</li>
     * </ul>
     * @param request HTTP request.
     * @param response HTTP response.
     * @throws jakarta.servlet.ServletException
     * @throws IOException
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws jakarta.servlet.ServletException, IOException {
        // Initial setup for the first visit
        HttpSession session = request.getSession();
        if (session.getAttribute("vendingMachine") == null) {
            session.setAttribute("vendingMachine", new VendingMachine());
        }
        // Load the initial view
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
}