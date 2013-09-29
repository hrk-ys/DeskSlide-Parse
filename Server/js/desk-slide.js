// An example Parse.js Backbone application based on the todo app by
// [Jérôme Gravel-Niquet](http://jgn.me/). This demo uses Parse to persist
// the todo items and provide user authentication and sessions.

$(function() {

  Parse.$ = jQuery;

  // Initialize Parse with your Parse application javascript keys
  Parse.initialize("pFG9MpdcFCveSEsE7sD3gHQPa1UeH2ikIOeg2vFS",
                   "w7Whf1MwhH608Cl5t3wcQ8lrZiVbKfSIDrpODNN7");

  var Document = Parse.Object.extend("Document");

  $(".logout").bind("click", function(){
	Parse.User.logOut();
	location.href="/login.html";
  });

  $("#login").bind("click", function(){
    Parse.User.logIn($("#username").val(), $("#password").val(), {
      success: function(user) {
	    location.href="/index.html";
      },
      error: function(user, error) {
        alert("Error: " + error.code + " " + error.message);
      }
    });
	
  });

  $("#regist-document").bind("click", function(){
     var text = $("#text-document").val();
	 console.log( text );

    if (text.length == 0) {
		return;
	}

	var doc = new Document;
	doc.set("type", "text");
	doc.set("text", text);
	doc.save(null, {
		success: function(doc) {
		  $("#document").prepend(
        	'<div class="col-lg-3"><h2>' + doc.get('type') +
			'</h2><p>' + doc.get('text') + '</p></div>'
		  );
		},
		error: function(doc, error) {
			alert('Failed to create new object, with error code: ' + error.description);

		},
	});

  });

  if ($("#document").size() > 0) {
    console.log("document download");
    var query = new Parse.Query(Document);
	query.descending("createdAt");
    query.find({
      success: function(results) {
        for (var i = 0; i < results.length; i++) { 
          var object = results[i];
          console.log(object.id
				  + ' - ' + object.get('type')
				  + ' - ' + object.get('text')
				  );
		  $("#document").append(
        	'<div class="col-lg-3"><h2>' + object.get('type') +
			'</h2><p>' + object.get('text') + '</p></div>'
		  );

        }
      },
      error: function(error) {
       alert("Error: " + error.code + " " + error.message);
      }
    });
	
  }
});
