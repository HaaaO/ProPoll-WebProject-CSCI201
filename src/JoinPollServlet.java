

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class JoinPollServlet
 */
@WebServlet("/JoinPollServlet")
public class JoinPollServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public JoinPollServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String pollName = request.getParameter("pollName");
		String next = "";
		String username = (String) request.getSession().getAttribute("loggedOn");
		Poll poll = null;
		int pollID = 0;
		if (request.getParameter("pollName")==null) {
			 pollID = Integer.parseInt((String)request.getParameter("pollID"));
			
			 poll = ProPollServer.getPollInfo(pollID);
			pollName = poll.getName();
			if(username!=null&&ProPollServer.checkForResponse(pollID,username)) {
				next="/PollResults?pollName="+pollName;
			}
			else {
				next="/JoinPoll.jsp?pollName="+poll.getName();
				if (request.getParameter("invalid")!=null&&request.getParameter("invalid").equals("true")){
					next += "&invalid=true";
				}
	
			}
		}
		else {
			next="/JoinPoll.jsp?pollName="+pollName;
			poll = ProPollServer.getPollData(pollName, username);
			pollID = poll.getPollID();
			
		}
		request.setAttribute("pollID", pollID);
		request.getSession().setAttribute("pollID", pollID);
		request.setAttribute("name", pollName);
		for (int i=0; i<poll.size(); i++) {
			request.setAttribute("question"+Integer.toString(i), poll.getQuestion(i));
			for (int j=0; j< poll.getQuestion(i).size(); j++) {
				request.setAttribute("response"+Integer.toString((i*10)+j), poll.getQuestion(i).getResponseString(j));
			}
		}
		request.getSession().setAttribute("numquestions", poll.getQuestions().size());
		
		RequestDispatcher dispatch = getServletContext().getRequestDispatcher(next);
		dispatch.forward(request, response);
	}

}
