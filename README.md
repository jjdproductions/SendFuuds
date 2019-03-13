# SendFuuds

## Table of Contents
1. [Overview](#Overview)
1. [Product Specification](#Product-Specification)
1. [Wireframes](#Wireframes)
1. [Schema](#Schema)
1. [Walkthrough](#Walkthrough)
1. [App Pitch Presentation](#App-Pitch-Presentation)
1. [Authors](#Authors)

## Overview

### App Description
Have you ever had food that you couldn't finish, and just ended up throwing it away? Chances are, you have. 

**JJDProductions** aims to solve this huge problem in the world today with **SendFuuds**.

**SendFuuds** is an application where users can get notified that their food is about to expire and are given an option to share it with friends.

Uses [Parse](https://docs.parseplatform.org/parse-server/guide/) for storing data. 

### App Evaluation
- **Category:** Social Media/Personal use
- **Mobile:** This app would be primarily developed for iOS users and will work similar to apps like [Instagram](https://www.instagram.com/?hl=en).
- **Story:** A user takes a picture of their food, enters the expiration date and a general description, and posts it to their personal list. Days pass and the user gets notified that their food is about to expire, so they need to take action. The user then shares the food publicly to their friends. A friend comments on the user's post, letting the user know that they are interested in their food. The user and the friend discuss and finalize a time and place to meet. Once the friend has gotten the user's food, the user deletes the post. 
- **Market:** Any individual could choose to use this app. We all need to be aware of the food that we waste each day!
- **Habit:** This app could be used more often by people who cook to ensure that the groceries they buy do not expire. 
- **Scope:** We will start by having users around UC Irvine use the application, but we expect that this application can be used by people around the world.

## Product-Specification

### User Stories

**Required Must-have Stories**
- [x] User can log in
- [x] User can sign up
- [x] User stays logged in across restarts.
- [x] User can log out.
- [x] User must enter correct login/sign up credentials
- [x] User can enter the expiration date and description of their food and post it to their personal list of foods.
- [x] User can share their post publicly to the home feed.  
- [x] User can post an image from either their photo gallery or camera. 
- [x] User can search and add friends.
- [x] User can only see their own posts and their friends' posts on the home feed.
- [x] User gets notified when their food is about to expire.
- [x] User can remove their own posts from the personal list.
- [x] User can comment on other user's posts. 
- [x] User gets notified when their food is about to expire.

**Optional Nice-to-have Stories**
- [ ] Users have a fully functional profile page, as opposed to just a personal list of food. 
- [ ] To add a friend, a User should send a friend request to another User, and the other User has to accept that request in order for the two Users to be friends. 
- [ ] User can remove friends. 
- [ ] Once a food is expired, the food should be deleted from the User's personal list and home feed.
- [ ] When a User comments on a post, the creator of the post gets a push notification. 
- [ ] User can privately message other users
- [ ] User can see mutual friends.
- [ ] User can search for specific food in their feed. 

### App Screen Archetypes

 * Login Screen
     * User can login
     * User can create a new account
 * Stream (Home Screen)
     * User can view a feed of their own food and their friends' food.
 * Creation (Post Screen)
     * User can post a new food to their feed, add the expiration date, and a brief description.
 * Search Screen
     * User can search for other users
     * User can add another user
 * Notification Screen
     * User can see recent notifications that they have received.
 * Profile Screen
     * User can see their own posts.
     * Future feature - User has profile image, description, and more information.

### App Navigation Flows

**Tab Navigation**

 * Home Feed
 * Search User
 * Post a Food
 * Notification 

**Flow Navigation**

 * Login Screen
    * Home after logging in or signing up.
 * Stream (Home Screen)
    * Login Screen by clicking the Logout button.
    * Future version might involve navigation to a profile page for a user.
    * Any other screen by clicking one of them on the tab bar.
    * Login screen by clicking logout.
 * Creation (Post Screen)
    * Home after a user posts their food.
    * Any other screen by clicking one of them on the tab bar.
    * Login screen by clicking logout.
 * Search Screen.
    * Any other screen by clicking one of them on the tab bar.
    * Login screen by clicking logout.
 * Notification Screen
    * Any other screen by clicking one of them on the tab bar.
    * Login screen by clicking logout.
    
## Wireframes

**Hand-Drawn:**

<img src='https://i.imgur.com/AXiMMlk.jpg' title='Wireframe Walkthrough' width='' alt='Wireframe Walkthrough' />

**Digital:**
https://www.figma.com/proto/BNQyBUMhIxUdroJeTUbXtPLb/SendFuuds?node-id=0%3A1&scaling=scale-down

<img src='https://i.imgur.com/ZKQlv1m.gif' title='Wireframe Walkthrough' width='' alt='Wireframe Walkthrough' />

## Schema 
### Models

#### User

   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | username      | String   | user's unique username |
   | password        | String | user's password | 
   | createdAt | Date | Date that the user table was created |
   | updatedAt | Date | Date that the user table has been updated |
   
#### userInfo

   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | username      | String   | user's unique username |
   | friends        | array of String | array of user's friends| 
   | createdAt | Date | Date that the user table was created |
   | updatedAt | Date | Date that the user table has been updated |
   
#### Foods

   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | owner      | String   | user's unique username |
   | image        | image file (any is taken) | user's image of their food |
   | description | String | description of user's food |
   | date | Date | the expiration date of the food | 
   | notifyDay | Date | the date that user will get notified |
   | createdAt | Date | Date that the user table was created |
   | updatedAt | Date | Date that the user table has been updated |
  

## Walkthrough

**Walkthrough of the following stories**

- [x] User can log in
- [x] User can sign up
- [x] User stays logged in across restarts.
- [x] User can log out.
- [x] User must enter correct login/sign up credentials
- [x] User can enter the expiration date of their groceries and post it to a home feed.
- [x] User has the option to post an image from their photo gallery or camera. 
- [x] User can search and add friends.
- [x] User can only see his own posts and his friends' posts on the home feed.
- [x] User gets notified when their food is about to expire.

<img src='https://i.imgur.com/Cqf6MJJ.gif' title='Part 1 Walkthrough' width='' alt='Part 1 Walkthrough' />

## App-Pitch-Presentation

**Coming Soon**

## Authors

SendFuuds implemented by **JJDProductions:**

* **Joshua Tavassolikhah** - [JoshTavasso](https://github.com/JoshTavasso)

* **Justin Leong** - [justinleong360](https://github.com/justinleong360)

* **David Yip** - [davidyip50](https://github.com/davidyip50)

### Process of building this application

All authors collaborated together on 1 laptop at a time. Work was always done together and all features were implemented as a team. 
