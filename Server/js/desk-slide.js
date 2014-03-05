// An example Parse.js Backbone application based on the todo app by
// [Jérôme Gravel-Niquet](http://jgn.me/). This demo uses Parse to persist
// the todo items and provide user authentication and sessions.

$(function() {

  Parse.$ = jQuery;

  // Initialize Parse with your Parse application javascript keys
  Parse.initialize("",
                   "");

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
	
	return false;
  });

  $(".doc-delete").bind("click", function(){
    var doc = new Document;
	doc.id = objectId;
	doc.destroy({
		success: function(myObject) {
		},
		error: function(myObject, error) {
		}
	});
  });

  $("#regist-document").bind("click", function(){
     var text = $("#text-document").val();
	 console.log( text );

    if (text.length > 0) {

		var doc = new Document;
		doc.set("type", "text");
		doc.set("text", text);
        doc.set("notice", "1");
		doc.setACL(new Parse.ACL(Parse.User.current()));
		doc.save(null, {
			success: function(doc) {
			  $("#document").prepend(
	        	'<div class="col-md-3"><h2>' + doc.get('type') +
				'</h2><p class="doc-text">' + $('<div />').text(doc.get('text')).html() + '</p></div>'
			  );
     		  $("#text-document").val("");
			  mixpanel.track( "create doc", { "docType": "image" } );
			  mixpanel.people.increment("doc count");
			},
			error: function(doc, error) {
				alert('Failed to create new object, with error code: ' + error.description);
	
			},
		});
	} else {
		var fileUploadControl = $("#profilePhotoFileUpload")[0];
		if (fileUploadControl.files.length == 0) {
			return;
		}

		var file = fileUploadControl.files[0];
  		var parseFile = new Parse.File(file.name, file);
		parseFile.save().then(function() {
			var doc = new Document;
			doc.set("type", "file");
			doc.set("file", parseFile);
            doc.set("notice", "1");
		    doc.setACL(new Parse.ACL(Parse.User.current()));
			doc.save(null, {
				success: function(doc) {
				  $("#document").prepend(
		        	'<div class="col-md-3"><h2>' + doc.get('type') +
					'</h2><img class="doc-image" src="' + doc.get('file').url() + '"></div>'
				  );
				  mixpanel.track( "create doc", { "docType": "image" } );
			      mixpanel.people.increment("doc count");
				},
				error: function(doc, error) {
					alert('Failed to create new object, with error code: ' + error.description);
		
				},
			});
		},
	   	function(error) {
				alert('Failed to file upload, with error code: ' + error.description);
		});
	}

  });


  if ($("#document").size() > 0) {
    var currentUser = Parse.User.current();
	if (! currentUser) {
        console.log("document download");
	    location.href="/login.html";
        return;
	}
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
		  if (object.get("type") == "text") {
			  $("#document").append(
   		     	'<div class="col-md-3"><h2>' + object.get('type') + '</h2>'
			   	+ '<p class="doc-text">' +  $('<div />').text(object.get('text')).html() + '</p>'
				/*
				+ '<div class="doc-delete">'
				+ '<a>'
			   	+ '<span class="glyphicon glyphicon-trash"></span>'
				+ '</a>'
				+ '</div>'
				*/
				+ '</div>'
			  );
		  } else {
			  $("#document").append(
		       	'<div class="col-md-3"><h2>' + object.get('type') + '</h2>'
			   	+ '<div><img class="doc-image" src="' + object.get('file').url() + '"></div>'
				/*
				+ '<div class="doc-delete" data-id="' +  object.id + '">'
				+ '<a>'
			   	+ '<span class="glyphicon glyphicon-trash"></span>'
				+ '</a>'
				+ '</div>'
				*/
				+ '</div>'
			  );
		  }

        }
      },
      error: function(error) {
       alert("Error: " + error.code + " " + error.message);
      }
    });
	
	mixpanel.identify( currentUser.get("username") );
    mixpanel.people.set({ "username": currentUser.get("username") });
	mixpanel.track( "download doc" );
  }
});



