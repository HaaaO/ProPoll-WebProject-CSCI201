<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0-beta/css/materialize.min.css">
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Join Poll</title>
		<script>
	  // Initialize Firebase
	  var socket;
		socket = new WebSocket("ws://localhost:8080/CSCI201_ProPoll_Project/ws");
	  	function sendMessage(){
	  		socket.send("update page");
	  		return true;
	  	}
	  function reader() {
			document.title = "<%=request.getAttribute("name")%>";
			document.getElementById("name").innerHTML = "<%=request.getAttribute("name")%>";
			<% for (int i=0; i<(Integer)session.getAttribute("numquestions"); i++) {%>
		    document.getElementById("q<%=i%>").innerHTML = "<%=request.getAttribute("question"+Integer.toString(i))%>";
		    <% for (int j=0; j<4; j++) { %>
		    	document.getElementById("r<%=(i*10)+j%>").innerHTML = "  "+"<%=request.getAttribute("response"+Integer.toString((i*10)+j))%>";
		    <% } }%>
	  }
	  </script>
	</head>
	<body>
			<!-- NAVBAR -->
		<nav class="blue">
	        <div class="nav-wrapper">
	          <a href="#" class="brand-logo white-text">ProPoll</a>   
	            <ul class="hide-on-med-and-down right">               
	                <li>    
	                   <div class="center row">
	                      <div class="col s12 " >
	                        <div class="row" id="topbarsearch">
	                          <div class="input-field col s6 s12 blue-text" text-align = "center">
	                            <i class="red-text material-icons prefix"></i>
	                            	<input type="text" placeholder="Enter Poll ID" id="autocomplete-input" class="autocomplete red-text" 
	                            		name = "pollID" method = "GET" action = "JoinPollServlet">
	                            </div>
	                          </div>
	                        </div>
	                      </div>          
	                  </li>                     
	                <c:choose>
	                  <c:when test="${loggedOn==null }">
	                <li><a href="login.jsp" class="white-text">Login</a></li>
	                <li><a href="signup.jsp" class="white-text">Sign Up</a></li>
	                </c:when>
	                <c:otherwise>
	                <li><a href="Profile" class="white-text">Profile</a></li>
	                 <li><a href="FrontPage.jsp" class="white-text">Logout</a></li>
	                </c:otherwise>
	                </c:choose>
	            </ul>
	        </div>
	      </nav> 
	      <!-- NAVBAR -->	
	     <div class = "container">
	     	<div class = "row">
	     		<div class = "col s6 offset-s3 z-depth-2" id = "panell">
					<script>
					<% if (request.getParameter("invalid")!=null&&request.getParameter("invalid").equals("true")) { %>
						document.getElementById("error").innerHTML = "Please choose a response for all questions!";
					<% }
					session.setAttribute("pollID", request.getParameter("pollID"));
					session.setAttribute("pollName", request.getParameter("pollName"));
					%>
					</script>
					<h1 id="name"></h1>
					<form method="GET" action="JoinPollResponsesServlet" onsubmit="return sendMessage();">
					<div id="error" style="color:red;"></div>
					<c:forEach var="i" begin="0" end="${numquestions-1}">
						<pre><span id="q${i}"></span><br /></pre>
						<c:forEach var="j" begin="0" end="3"> 
						<label for="response${(i*10)+j}" >
							<input name="question${i}" type="radio" id="response${(i*10)+j}" value="${j}" ${j==0?"checked":"" }> 
							<span id="r${(i*10)+j}"></span>
						</label><br />
						</c:forEach>
				</c:forEach>
				<br />
					<input class="waves-effect waves-light btn" type="submit" id="submit">
					<input type="text" name="pollID" value="${pollID}" style="display:none"/>
					</form>
					<script>reader();</script>
					<br />
				</div>
			</div>
		</div>
	</body>
</html>