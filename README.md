# FunnyHeadlines iOS
This app was created by myself along with one other person as part of a class project. 
## The Idea
News headlines are depressing. Let's make them less depressing by translating them into funny accents, like how yoda or a pirate or Shakespeare would say it. Is this idea lacking good taste? Probably. But it sure was fun to make.
## Technologies Used
Unfortunately, all my screenshots of this project have been sucked into an interdimensional vortex, and I no longer have an Apple computer to run the code on (I have converted to Android). However, the code is all still there. Anyway, here's how we made it happen:
* NewsAPI - Used to pull the latests headlines from the top news organizations. The user could choose from a list of options, from sources specializing in general news, business news, entertainment news, or sports news.
* Fun Translations API - After the news headlines were pulled from the previous API, there were packaged up and sent to this API, which translated the text sent to it in funny ways. There were lots of "personas" to choose from, and the user was presented with a list of the most interesting one to pick from.
* Swift - The language used to write the app. The app consisted of a configuration screen for choosing the new source and translation, and a main screen which had a list view off all the received headlines in the chosen translation. Tapping on a headline would link to the news story in a web browser.

