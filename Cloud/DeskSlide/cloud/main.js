
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});

Parse.Cloud.afterSave("Document", function(request) {
	query = new Parse.Query("Document");
	query.get(request.object.id, {
		success: function(doc) {
			var message;
			if (doc.get("type") == 'text') {
					message = doc.get("text").substr(0, 100);
			} else {
					message = "image post";
			}
			var query = new Parse.Query(Parse.Installation);
			query.equalTo('owner', Parse.User.current());
			Parse.Push.send({
				where: query,
				data: {
					alert: message,
					o: doc.id
			   	}
			},
		   	{
				success: function() {
					// Push was successful
				},
				error: function(error) {
					// Handle error
					console.error("Push an error " + error.code + " : " + error.message);
				}
			});
		},
		error: function(error) {
			console.error("Got an error " + error.code + " : " + error.message);
		}
	});
});
