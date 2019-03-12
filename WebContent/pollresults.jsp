<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
   <head>
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0-beta/css/materialize.min.css">
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>${pollData.getName()} Results</title>
	<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
    	<script type="text/javascript">
    
    	var loc = "http://localhost:8080/CSCI201_ProPoll_Project/PollResults?pollName=${pollName}"
 	if (window.location.href.substring(46,57)!="PollResults"){
    		window.location.replace("/CSCI201_ProPoll_Project/PollResults?pollName=${pollName}");
 	}
	// Connecting to the server through web socket
    	var socket;
	function connectToServer() {
		socket = new WebSocket("ws://localhost:8080/CSCI201_ProPoll_Project/ws");
		socket.onopen = function(event) {
			document.getElementById("mychat").innerHTML += "Connected!";
		}
		socket.onmessage = function(event) {
			
			document.getElementById("mychat").innerHTML += event.data + "<br />";
			/*
			 google.charts.load('current', {'packages':['corechart']});

		      // Set a callback to run when the Google Visualization API is loaded.
		      google.charts.setOnLoadCallback(drawChart);

			drawChart(); 
			*/
		  	setTimeout(reload,1000);
		}
		socket.onclose = function(event) {
			document.getElementById("mychat").innerHTML += "Disconnected!";
		}
	}
	
	function reload(){
		location.reload(true);
	}

    
    //Implement web worker to call demo_workers to count the length of time user has enterred the page
    //Meet the multi-threading requirements
    var webWorker;
		
    function startWorker() {
        if(typeof(Worker) !== "undefined") {
            if(typeof(webWorker) == "undefined") {
                webWorker = new Worker("demo_workers.js");
            }
            webWorker.onmessage = function(event) {
                document.getElementById("result").innerHTML = event.data;
            };
        } else {
            document.getElementById("result").innerHTML = "Sorry! No Web Worker support.";
        }
    }
    //Terminate the web worker
    function stopWorker() { 
        webWorker.terminate();
        webWorker = undefined;
    }
    
    startWorker();
		
    // Rendering the charts to visualize the poll results 
    </script>
	<c:forEach var="i" begin="0" end="${pollData.size()-1 }">
	<script>
      // Load the Visualization API and the corechart package.
      google.charts.load('current', {'packages':['corechart']});

      // Set a callback to run when the Google Visualization API is loaded.
      google.charts.setOnLoadCallback(drawChart);

      // Callback that creates and populates a data table,
      // instantiates the pie chart, passes in the data and
      // draws it.
      
      function drawChart() {
    	  resultArray = [];
   
    	resultArray = [];
    		  
    	  
    	var title =   '${pollData.getQuestion(i).toString() }';
 
    	console.log(title);
    	
    	var questionSize = parseInt('${pollData.getQuestion(i).size() }');
    
    	console.log(questionSize);
    	var j;
    	var count = 0;

    	var res1  = '${pollData.getQuestion(i).getResponseString(i)}';
    	var res1Num1 = parseInt('${pollData.getQuestion(i).getResponseCount(0)}');
    	resultArray.push([res1, res1Num1]);
    	var res2  = '${pollData.getQuestion(i).getResponseString(1)}';
    	var res1Num2 = parseInt('${pollData.getQuestion(i).getResponseCount(1)}');
    	resultArray.push([res2, res1Num2]);
    	
    	var res3  = '${pollData.getQuestion(i).getResponseString(2)}';
    	var res1Num3 = parseInt('${pollData.getQuestion(i).getResponseCount(2)}');
    	resultArray.push([res3, res1Num3]);
    	var res4  = '${pollData.getQuestion(i).getResponseString(3)}';
    	var res1Num4 = parseInt('${pollData.getQuestion(i).getResponseCount(3)}');
    	resultArray.push([res4, res1Num4]);
    	
    	
		var data = new google.visualization.DataTable();
        data.addColumn('string', 'ResponseName');
        data.addColumn('number', 'ResponseNumber');
       // final add 
        data.addRows(resultArray);
 
        // Set chart options
        var options = {'title':title,
                       'width':400,
                       'height':300};

        // Instantiate and draw our chart, passing in some options.
        var chart = new google.visualization.PieChart(document.getElementById('chart_div${i}'));
        chart.draw(data, options);
        console.log("drawwwwwwww");
    	
      }
    </script>
    </c:forEach>
	</head>
	<body onload="connectToServer()">
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
	
		<div align = "center">
			<h1> ${pollData.getName() } Results</h1>	
			<h4>Poll ID = ${pollData.getPollID()}</h4>
		</div>

		<div class = "container" padding = "30px">
			<div class = "row">
				<div class="col s16 m4 l2">
					<div id="yourResponses" >
						<c:if test="${loggedOn!=null}" >
							<h5>Your responses</h5>
							<ol>
								<c:if test="${userResponse.size()>0}">
								<c:forEach var="i" begin="0" end="${userResponse.size()-1}">
								<li>
								${userResponse.get(i).toString()} : ${userResponse.get(i).getResponseString(0)}
								</li>
								</c:forEach>
								</c:if>
							</ol>
						</c:if>
					</div>
					</div>
		
		<div class="col s16 m4 l2">
					<div id="yourResponses" >
					<c:if test="${loggedOn.equals(pollData.getCreator())}" >
					<h5> User Responses</h5>
					<c:if test="${pollResponses.size()>0 }">
						<c:forEach var="i" begin ="0" end="${pollResponses.size() -1}">
							${pollResponses.get(i) } <br />
						</c:forEach>
					</c:if>
					</c:if>
				</div>
				</div>
			<div class="col s16 m4 l2">
				<h5> Total Responses</h5>
				<ol>	
					<c:if test="${pollData.size()>0}">
					<c:forEach var="i" begin="0" end = "${pollData.size()-1}">
						<li> ${pollData.getQuestion(i).toString() } </li>
						<ul>
						<c:forEach var="j" begin="0" end="${pollData.getQuestion(i).size()-1 }">
							<li> 
							${pollData.getQuestion(i).getResponseString(j)} : ${pollData.getQuestion(i).getResponseCount(j)}
							</li>
						</c:forEach>
						</ul>
					</c:forEach>
					</c:if>
				</ol>
			</div>
			<div class="col s16 m4 l2">
				<c:forEach var="i" begin="0" end="${pollData.size()-1 }">
	    		<div id="chart_div${i}"></div>
	    		</c:forEach>
	    	</div>
	  	</div>
	    <p>It's been: <output id="result"></output> seconds since the last update</p>
</div>



	<div id="mychat"></div>


	<div id="disqus_thread"></div>
	<noscript>Please enable JavaScript to view the <a href="https://disqus.com/?ref_noscript">comments powered by Disqus.</a></noscript>
	</body>
</html>
