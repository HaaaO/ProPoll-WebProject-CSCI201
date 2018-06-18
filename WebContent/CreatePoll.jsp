<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0-beta/css/materialize.min.css">
		 <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
		<link rel="stylesheet" href="login.css">
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Create Poll</title>
	</head>
	<body>
		<!-- NAVBAR -->
		<nav class="blue">
	        <div class="nav-wrapper">
	          <a href="FrontPage.jsp" class="brand-logo white-text">ProPoll</a>   
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
	
		<% if (request.getParameter("new")!=null&&request.getParameter("new").equals("true")){ //have some kind of request parameter which specifies whether or not the poll is new instead of checking for null
			session.setAttribute("numquestions", "1");
		} %>
		<script>
		  function check() {
		      if (document.getElementById("public").checked) {
		    	  document.getElementById("allowedlabel").style.display = 'none';
		          document.getElementById("allowedusers").style.display = 'none';
		      } else {
		    	  document.getElementById("allowedlabel").style.display = 'block';
		          document.getElementById("allowedusers").style.display = 'block';
		      }
		  }
		  
		  function writer() {
				//add error checking?
				
				//redirect whereever
				document.location.href = "CreatePoll.jsp";
	  		}
		  
		  </script>
		  
		  <!-- FORM START -->
		  <div class = "container">
		  	<div class = "row">
		  		<div class="col s6 offset-s3 z-depth-2" id="panell">
					<form action="CreatePollServlet" method="POST">
					<div id="error" style="color:red;"></div>
					<% if (request.getParameter("name")!=null) {%>
						Name: <input id="name" name="name" type="text" value="<%=request.getParameter("name")%>">
					<% } else { %>
						Name: <input id="name" name="name" type="text">
					<% } %>
					
						<% for (int i=0; i<Integer.parseInt((String)session.getAttribute("numquestions")); i++) {
							if (request.getParameter("question"+i)==null){%>
							<pre>Question <%=i+1%>: <input name="question<%=i%>" id="question<%=i%>" class="question" type="text"><br /></pre>
							<% } else { %>
							<pre>Question <%=i+1%>: <input name="question<%=i%>" id="question<%=i%>" class="question" type="text" value="<%=request.getParameter("question"+Integer.toString(i))%>"><br /></pre>
							<% }
							for (int j=0; j<4; j++) {
							 if (request.getParameter("response"+Integer.toString((i*10)+j))==null){ %>
							 <pre>	Option <%=j+1%>: <input name="response<%=(i*10)+j%>" id="response<%=(i*10)+j%>" class="answer" type="text"><br /></pre>
							 <% } else {%>
							 <pre>	Option <%=j+1%>: <input name="response<%=(i*10)+j%>" id="response<%=(i*10)+j%>" class="answer" type="text" value="<%=request.getParameter("response"+Integer.toString((i*10)+j))%>"><br /></pre>
						<% } } }%>
						<%
							session.setAttribute("numquestions", Integer.toString(Integer.parseInt((String)session.getAttribute("numquestions"))+1));
						%>
						
					     <label>
					        <input  type="radio" onclick="check()" name="polltype" id="public" value="public"  checked/>
					        <span>Public</span>
					     </label>
					     <label>
					        <input  type="radio" onclick="check()" name="polltype" id="private" value="private" />
					        <span>Private</span>
					     </label>
					      
					      <br>
					      
					      <div id="allowedlabel"><br />Allowed users:<br /></div>
						<% if (request.getParameter("allowedusers")!=null) { %>
						<textarea id="allowedusers" name="allowedusers" rows="10" cols="80"><%=request.getParameter("allowedusers")%></textarea>
						<% } else { %>
						<textarea id="allowedusers" name="allowedusers" rows="10" cols="80" style="display:none;"></textarea>
						<% } %>
					      <br>
					      <button type="button" class="waves-effect waves-light btn"  id="addquestion" onclick="writer()" >Add Question</button>
						<script>check();</script>
						<br /> <br />
						<button type="submit" class="btn waves-effect waves-light" id="submit" >Submit<i class="material-icons right">send</i></button>
						<script>
						<% if (request.getParameter("invalid")!=null&&request.getParameter("invalid").equals("true")) { %>
							document.getElementById("error").innerHTML = "Please fill in the name and at least one question!";
						<% } %>
						</script>
					</form>
					<br />
				
					
				</div>
			</div>
		</div>
		<!-- FORM END -->
	</body>
</html>