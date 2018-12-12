# capstone_app

This is the iOS app counterpart to our capstone. This app requires 2 iPhones capable of networking, retrieving its compass 
data, as well as running iOS 12.1 or higher. This app has been shown to run on iPhones 6 plus, 7 plus, and X with no issues.

To install on a phone, you will either need an iOS developer's liscence or permission from someone who does to use theirs. This
app is not on the app store as of yet and is not able to be run by any persons in the general public.

If you do install it on an iPhone successfully and are running a version of our server on your own, please change line 106 in 
/Capstone/ViewController.swift from
let url = URL(string: "http://5halfcap.ngrok.io/phone")!
to have whatever url you are using inside the quotes instead.

Launching the app once installed is not unlike anty other app. Once it is running on 2 iPhones simultaneously, have one phone
select Second from the bottom picker. To play music on the browser opened to the web page, hold the play button on the iPhone
with Second selected. This is now the volume controller, where the other is the pitch controller.
