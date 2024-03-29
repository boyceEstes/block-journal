# Block Journal 

This is a project meant to help with tracking activities over time in a fun, easily visible way. 
Each log represents some activity and has a corresponding colorful block added to your day. Over the course of your day
you can add as many activity block logs as you want, edit them, remove them, and bask in the colorful productivity

**Development Strategy**
This isn't a complicated project and is built solely by one developer. This is a prototype to test if this is a viable product that is helpful and satisfying to use. 


## Git Branching Strategy
Main branch is where all of the important stuff lives.
Branch for each new feature. If there is something extra experimental, branch from there.
When a feature is complete, merge into the main branch.

The purpose of this strategy is to enable quick and easy hot fixes/sporadic updates to the main branch while working on an overarching feature.

Once unit tests are added, the plan is to use GitHub Actions to automate tests on each merge to main, which will sadly mean Pull Requests will be enforced make updates. 


## Unit Testing
This project was built quickly and has sacrificed some good programming practices like Test Driven Development in favor of getting basic behavior and UI/UX down first. As its gotten more mature and the business logic has gotten more complicated, unit testing has become necessary.

This should make things much easier moving forward. The goal is to have major code coverage for all business logic. Extract logic from the views as much as possible and into `Policy` files if possible. This will make it more ubiquitous and reusable across future UI modules, and mostly safe without being anal about code coverage percentages.


## Module Design
I am beginning to separate the project into its various modules at this stage. If all goes well, this app would be expanded to macOS and/or watchOS. This requires some shared logic between UI. This requires a shared framework to handle the data that will power each UI module, which I am calling the `BJRepository`. 

![Module Design Dependency Graph](module-design.drawio.png)


## App Usage

#### To Get Started
1. Create an Activity/Habit - Enter basic information like name of activity
2. *New*: Add a detail to the activity/habit that you want to track each time you create a log for the activity
3. Tap the Activity that is created to log your first block!


### Context Menus Are Your Friend
If you feel like something is missing(... It probably is, but on the off-chance its not) try holding down UI elements for extra features. Quick and dirty way to get the functionality there until the UI is more fleshed out.

### Statistics
View your habits over time in the statistics view, filter through them and be flabberghasted at the life you've built through blocks. Watch your major statistics like "best streak", "most completions", "avgerage records per day" and more change dyanmically according to you filtered activities!
